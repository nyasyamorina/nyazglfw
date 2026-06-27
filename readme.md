# nyazglfw

A modern GLFW zig wrapper for Zig, with the option of runtime static or dynamic linking.

[中文版读我](./readme.zh-cn.md)

- Zig version: see `minimum_zig_version` in [`build.zig.zon`](./build.zig.zon)

- GLFW version: 3.4.0

---

## Example

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

## Getting start

### Add Dependency

- Run following command in your project:

```shell
zig fetch --save https://github.com/nyasyamorina/nyazglfw/archive/refs/heads/main.tar.gz
```

- If you encounter network problems, you can manually download the package and extract it into `<your project folder>/zig-pkg`, then add the following content to your `build.zig.zon`:

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

### Runtime Static Linking GLFW

Add the following in your `build.zig`:

```zig
pub fn build(b: *std.Build) void {
    const exe = // your executable compile

    const nyazglfw = b.dependency("nyazglfw", .{ .dynamic = false });
    exe.root_module.addImport("glfw", nyazglfw.module("glfw"));
    exe.root_module.linkSystemLibrary("glfw3", .{});
}
```

Then you can use it everywhere:

```zig
const glfw = @import("glfw);

pub fn main() !void {
    if (!glfw.init()) return error.GlfwInitFailed;
    defer glfw.terminate();
}
```

### Runtime Dynamic Linking GLFW

Add the following in your `build.zig`:

```zig
pub fn build(b: *std.Build) void {
    const exe = // your executable compile

    const nyazglfw = b.dependency("nyazglfw", .{ .dynamic = true });
    exe.root_module.addImport("glfw", nyazglfw.module("glfw"));
}
```

Before using the package, you need to load the dynamic link library using `load`, and unload it using `unload` when exiting.

```zig
const glfw = @import("glfw);

pub fn main() !void {
    try glfw.load("libglfw.so");
    defer glfw.unload();

    if (!glfw.init()) return error.GlfwInitFailed;
    defer glfw.terminate();
}
```

`load` is implemented using `std.DynLib`. For platform where `std.DynLib` cannot be used (such as Windows), `loadEx` and `unloadEx` are also provided:

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

## GLFW Library

This project is a wrapper of the GLFW api, which dose not contain the implementation of GLFW. You can compile [the source of GLFW](https://github.com/glfw/glfw), or download [the pre-compiled file](https://github.com/glfw/glfw/releases) to obtain the GLFW library. And Linux user can install `glfw3` package from `pacman`, `apt` or other package manager.

Windows and MACOS user need to copy the dynamic library file (.dll or .dylib) into zig output directory (./zig-out/bin), or use `b.installBinFile(...)` in `build.zig` to automatically copy the file.

Also consider using [tiawl/glfw.zig](https://github.com/tiawl/glfw.zig) to include the compilation of GLFW into your project.
