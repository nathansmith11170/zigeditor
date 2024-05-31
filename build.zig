const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const winexe = b.addExecutable(.{
        .name = "zigeditor-windows",
        .root_source_file = .{
            .src_path = .{
                .owner = b,
                .sub_path = "src/win-zigeditor.zig",
            },
        },
        .target = target,
        .optimize = optimize,
    });
    winexe.subsystem = .Windows;
    winexe.linkSystemLibrary("user32");
    winexe.linkSystemLibrary("gdi32");

    const xorgexe = b.addExecutable(.{
        .name = "zigeditor-xlinux",
        .root_source_file = .{
            .src_path = .{
                .owner = b,
                .sub_path = "src/linux-zigeditor.zig",
            },
        },
        .target = target,
        .optimize = optimize,
    });

    const windows_exe = b.addInstallArtifact(winexe, .{});
    const windows_step = b.step("windows", "Build the windows application");
    windows_step.dependOn(&windows_exe.step);

    const linux_exe = b.addInstallArtifact(xorgexe, .{});
    const linux_step = b.step("linux", "Build the linux application");
    linux_step.dependOn(&linux_exe.step);
}
