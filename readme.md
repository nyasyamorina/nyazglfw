# nyazglfw

A modern GLFW wrapper for Zig

[中文版读我](./readme.zh-cn.md)

- Zig version: 0.15.2

- GLFW version: 3.4.0

---

## Example

```zig
const glfw = @import("glfw");

pub fn main() void {
    // GLFW initialization hinting
    glfw.InitHint.set.platform(.any);

    _ = glfw.init();
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

- Run following command in your project:

```shell
zig fetch --save https://github.com/nyasyamorina/nyazglfw/archive/refs/heads/main.tar.gz
```

- or edit your `build.zig.zon`:

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

Then add the following in your `build.zig`:

```zig
pub fn build(b: *std.Build) void {
    const exe = // your executable compile

    const nyazglfw = b.dependency("nyazglfw", .{});
    exe.root_module.addImport("glfw", nyazglfw.module("glfw"));
}
```

---

## GLFW Library

This project is a wrapper of the GLFW api, which dose not contain the implementation of GLFW. You can compile [the source of GLFW](https://github.com/glfw/glfw), or download [the pre-compiled file](https://github.com/glfw/glfw/releases) to obtain the GLFW library. And Linux user can install `glfw3` package from `pacman`, `apt` or other package manager.

Once obtain the GLFW library/package, add the following in your `build.zig`:

```zig
exe.root_module.linkSystemLibrary("glfw3", .{});
```

Windows and MACOS user need to copy the dynamic library file (.dll or .dylib) into zig output directory (./zig-out/bin), or use `b.installBinFile(...)` in `build.zig` to automatically copy the file.

Also consider using [tiawl/glfw.zig](https://github.com/tiawl/glfw.zig) to include the compilation of GLFW into your project.
