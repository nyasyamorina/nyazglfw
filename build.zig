const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const dynamic = b.option(bool, "dynamic", "dynamic link to glfw library") orelse false;

    const options = b.addOptions();
    options.addOption(bool, "dynamic", dynamic);

    _ = b.addModule("glfw", .{
        .root_source_file = b.path("src/lib.zig"),
        .optimize = optimize,
        .target = target,
        .imports = &.{
            .{ .name = "build_options", .module = options.createModule() },
        },
    });
}
