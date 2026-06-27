# nyazglfw

一个现代化的 GLFW zig 包装器，并且可以选择运行时的静态链接或动态链接。

[English readme](./readme.md)

- Zig 版本：见 [`build.zig.zon`](./build.zig.zon) 的 `minimum_zig_version`

- GLFW 版本：3.4.0

---

## 例子

```zig
const glfw = @import("glfw");

pub fn main() !void {
    // GLFW initialization hinting
    glfw.InitHint.set.platform(.any);

    if (!glfw.init()) return error.GlfwInitFailed;
    defer glfw.terminate();

    // window creation hiting
    glfw.Window.Hint.set.defaults();
    glfw.Window.Hint.set.clientApi(.no_api);
    glfw.Window.Hint.set.resizable(false);

    const window = glfw.Window.create(.{ .width = 800, .height = 600 }, "nyazglfw", null, null).?;
    defer window.destroy();

    // member method
    const framebuffer_size = window.getFramebufferSize();
    std.debug.print("framebuffer size: {d}x{d}\n", .{framebuffer_size.width, framebuffer_size.height});

    // get window attribute
    const bit_depths = glfw.Window.Attribute.get.bitDepths(window);
    std.debug.print("bit depths: {any}\n", .{bit_depths});

    // ... and the another way to get window attribute
    const msaa_samples = window.getAttrib(.samples);
    std.debug.print("msaa sample count: {d}\n", .{msaa_samples});

    // set window attribute
    window.setAttrib(.floating, true); // `glfw.Window.Attribute.set.<attrib>(...)` also exist

    // main loop
    while (!window.shouldClose()) {
        glfw.pollEvents();
        // rendering...
        window.swapBuffers();
    }
}
```

---

## 开始使用

### 添加依赖

- 在你的项目里运行以下命令：

```shell
zig fetch --save https://github.com/nyasyamorina/nyazglfw/archive/refs/heads/main.tar.gz
```

- 如果遇到网络问题，可以手动下载包并解压到 `<你的项目文件夹>/zig-pkg` 里，然后在你的 `build.zig.zon` 添加以下内容：

```zig
{
    // other stuff
    .dependencies = .{
        // other stuff
        .nyazglfw = .{
            .url = "https://github.com/nyasyamorina/nyazglfw/archive/refs/heads/main.tar.gz",
            .hash = "<dependency hash>"
        },
    },
}
```

### 运行时静态链接 GLFW

在你的 `build.zig` 里添加以下内容：

```zig
pub fn build(b: *std.Build) void {
    const exe = // your executable compile

    const nyazglfw = b.dependency("nyazglfw", .{ .dynamic = false });
    exe.root_module.addImport("glfw", nyazglfw.module("glfw"));
    exe.root_module.linkSystemLibrary("glfw3", .{});
}
```

然后就可以到处使用：

```zig
const glfw = @import("glfw);

pub fn main() !void {
    if (!glfw.init()) return error.GlfwInitFailed;
    defer glfw.terminate();
}
```

### 运行时动态链接 GLFW

在你的 `build.zig` 里添加以下内容：

```zig
pub fn build(b: *std.Build) void {
    const exe = // your executable compile

    const nyazglfw = b.dependency("nyazglfw", .{ .dynamic = true });
    exe.root_module.addImport("glfw", nyazglfw.module("glfw"));
}
```

在使用前需要使用 `load` 加载动态链接库，并在退出时需要使用 `unload` 释放库：

```zig
const glfw = @import("glfw);

pub fn main() !void {
    try glfw.load("libglfw.so");
    defer glfw.unload();

    if (!glfw.init()) return error.GlfwInitFailed;
    defer glfw.terminate();
}
```

`load` 是使用 `std.DynLib` 实现的，对于无法使用 `std.DynLib` 的环境（比如 Windows），这里还提供了 `loadEx` 和 `unloadEx`：

```zig
const glfw = @import("glfw);

pub fn main() !void {
    const your_dyn_lib_loader = // ...
    const your_dyn_lib_load_fn = // see also `glfw.api.warpper.lookupFn`

    try glfw.loadEx(@ptrCast(&your_dyn_lib_loader), your_dyn_lib_load_fn);
    defer glfw.unloadEx();

    if (!glfw.init()) return error.GlfwInitFailed;
    defer glfw.terminate();
}
```

---

## GLFW 库

这个项目是 GLFW api 的包装，其中不包含 GLFW 的实现。你可以通过编译 [GLFW 的源码](https://github.com/glfw/glfw)，或下载[已经编译好的文件](https://github.com/glfw/glfw/releases)来获得 GLFW 库。另外 Linux 用户可以通过 `pacman` 或 `apt` 等安装 glfw3 包。

并且 Windows 和 MACOS 用户需要把对应的 GLFW 动态库文件 (.dll 或 .dylib) 复制到 zig 输出目录里 (./zig-out/bin)，或者可以在 `build.zig` 里使用 `b.installBinFile(...)` 使得在编译时自动复制文件。

也可以考虑使用 [tiawl/glfw.zig](https://github.com/tiawl/glfw.zig) 把编译 GLFW 放进你的项目里。
