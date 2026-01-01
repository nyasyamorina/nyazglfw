# nyazglfw

一个现代化的 GLFW zig 包装器。

[English readme](./readme.md)

- Zig 版本：0.15.2

- GLFW 版本：3.4.0

---

## 例子

```zig
const glfw = @import("glfw");

pub fn main() void {
    _ = glfw.init();
    defer glfw.terminate();

    // `hint` will be improved in near future
    glfw.Window.hint(@intFromEnum(glfw.Window.Hint.client_api), @intFromEnum(glfw.ClientApi.no_api));
    glfw.Window.hint(@intFromEnum(glfw.Window.Hint.resizable), @intFromBool(false));
    const window = glfw.Window.create(.{ .width = 800, .height = 600 }, "HelloWGPU", null, null).?;
    defer window.destroy();

    const framebuffer_size = window.getFramebufferSize();
    std.debug.print("framebuffer size: {d}x{d}\n", .{framebuffer_size.width, framebuffer_size.height});

    while (!window.shouldClose()) {
        glfw.pollEvents();
        // rendering...
        window.swapBuffers();
    }
}
```

---

## 开始使用

- 在你的项目里运行以下命令：

```shell
zig fetch --save https://github.com/nyasyamorina/nyazglfw/archive/refs/heads/main.tar.gz
```

- 或者编辑你的 `build.zig.zon`:

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

然后在你的 `build.zig` 里添加以下内容：

```zig
pub fn build(b: *std.Build) void {
    const exe = // your executable compile

    const nyazglfw = b.dependency("nyazglfw", .{});
    exe.root_module.addImport("glfw", nyazglfw.module("glfw"));
}
```

---

## GLFW 库

这个项目是 GLFW api 的包装，其中不包含 GLFW 的实现。你可以通过编译 [GLFW 的源码](https://github.com/glfw/glfw)，或下载[已经编译好的文件](https://github.com/glfw/glfw/releases)来获得 GLFW 库。另外 Linux 用户可以通过 `pacman` 或 `apt` 等安装 glfw3 包。

获取了 GLFW 库/包后在你的 `build.zig` 里添加以下内容：

```zig
exe.root_module.linkSystemLibrary("glfw3", .{});
```

并且 Windows 和 MACOS 用户需要把对应的 GLFW 动态库文件 (.dll 或 .dylib) 复制到 zig 输出目录里 (./zig-out/bin)，或者可以在 `build.zig` 里使用 `b.installBinFile(...)` 使得在编译时自动复制文件。

也可以考虑使用 [tiawl/glfw.zig](https://github.com/tiawl/glfw.zig) 把编译 GLFW 放进你的项目里。
