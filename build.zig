const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const exe = b.addExecutable(.{
        .name = "zigeditor",
        .root_source_file = .{
            .src_path = .{
                .owner = b,
                .sub_path = "src/zigeditor.zig",
            },
        },
        .target = target,
        .optimize = optimize,
    });

    // Use mach-glfw
    const glfw_dep = b.dependency("mach_glfw", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("mach-glfw", glfw_dep.module("mach-glfw"));

    // Use mach-freetype
    const mach_freetype_dep = b.dependency("mach_freetype", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("mach-freetype", mach_freetype_dep.module("mach-freetype"));
    exe.root_module.addImport("mach-harfbuzz", mach_freetype_dep.module("mach-harfbuzz"));

    b.installArtifact(exe);
}
