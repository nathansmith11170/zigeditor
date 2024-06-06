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
    exe.linkSystemLibrary2("glfw", .{ .preferred_link_mode = .dynamic });
    exe.linkSystemLibrary2("freetype", .{ .preferred_link_mode = .dynamic });

    b.installArtifact(exe);
}
