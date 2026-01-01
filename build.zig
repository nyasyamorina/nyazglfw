const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const nyazglfw = b.addModule("glfw", .{
        .root_source_file = b.path("src/lib.zig"),
        .optimize = optimize,
        .target = target,
    });


    const lib_check = b.addLibrary(.{
        .name = "nyazglfw-check",
        .root_module = nyazglfw,
    });
    const check = b.step("check", "");
    check.dependOn(&lib_check.step);
}
