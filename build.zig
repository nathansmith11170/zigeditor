const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zigeditor-windows",
        .root_source_file = .{ .path = "src/win-zigeditor.zig" },
        .target = b.standardTargetOptions(.{
            .default_target = .{
                .os_tag = .windows,
                .abi = .msvc,
                .cpu_arch = .x86_64,
                .ofmt = .coff,
            },
        }),
        .optimize = optimize,
    });
    exe.subsystem = .Windows;
    exe.linkSystemLibrary("user32");
    exe.linkSystemLibrary("gdi32");

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
