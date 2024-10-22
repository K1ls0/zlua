const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Lua c dependency
    const luac_dep = b.dependency("luac", .{
        .target = target,
        .optimize = optimize,
    });
    const luac_lib = b.addStaticLibrary(.{
        .name = "luac",
        .target = target,
        .optimize = optimize,
    });
    luac_lib.addCSourceFiles(.{
        .root = luac_dep.path("src"),
        .files = c_files,
    });
    luac_lib.root_module.addIncludePath(luac_dep.path(""));
    luac_lib.linkLibC();

    b.installArtifact(luac_lib);

    // zlua library
    const lib = b.addStaticLibrary(.{
        .name = "zlua",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibrary(luac_lib);
    b.installArtifact(lib);

    _ = b.addModule("zlua", .{
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path("src/root.zig"),
    });

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // Executable
    const exe = b.addExecutable(.{
        .name = "zig_lua",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe.step.dependOn(&lib.step);
    exe.root_module.addImport("zlua", &lib.root_module);
    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    test_step.dependOn(&run_exe_unit_tests.step);
}

const c_files: []const []const u8 = &.{
    "ldo.c",
    "lcode.c",
    "ltm.c",
    "lmathlib.c",
    "lobject.c",
    "lapi.c",
    "llex.c",
    "lfunc.c",
    "lctype.c",
    "lparser.c",
    "lzio.c",
    "lutf8lib.c",
    "ldump.c",
    "lmem.c",
    "lcorolib.c",
    "lstring.c",
    //"luac.c",
    "liolib.c",
    "linit.c",
    "lundump.c",
    //"lua.c",
    "loadlib.c",
    "lvm.c",
    "lbaselib.c",
    "loslib.c",
    "ltable.c",
    "lstrlib.c",
    "ldebug.c",
    "ldblib.c",
    "lgc.c",
    "ltablib.c",
    "lstate.c",
    "lopcodes.c",
    "lauxlib.c",
};
