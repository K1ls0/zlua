const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "zlua",
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(lib);

    // Add lua files
    {
        lib.linkLibC();
        lib.addIncludePath(b.path(lib_files_dir));
        inline for (c_files) |cfile| {
            lib.addCSourceFile(.{
                .file = b.path(lib_files_dir ++ cfile),
                .flags = &.{},
            });
        }
    }

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

    const lib_unit_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
    test_step.dependOn(&run_lib_unit_tests.step);
}
const lib_files_dir = "./libs/lua/lua-5.4.6/src/";

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
