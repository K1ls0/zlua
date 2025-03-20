const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Lua c dependency
    const luac_dep = b.dependency("luac", .{
        .target = target,
        .optimize = optimize,
    });

    const luac_mod = b.addModule("luac", .{
        .link_libc = true,
        .target = target,
        .optimize = optimize,
    });
    //const luac_lib = b.addStaticLibrary(.{
    //    .name = "luac",
    //    .target = target,
    //    .optimize = optimize,
    //});
    luac_mod.addCSourceFiles(.{
        .root = luac_dep.path("src"),
        .files = c_files,
    });
    luac_mod.addIncludePath(luac_dep.path(""));

    const luac_lib = b.addStaticLibrary(.{
        .name = "lua",
        .root_module = luac_mod,
    });

    // zlua library
    const zlua_mod = b.addModule("zlua", .{
        .target = target,
        .optimize = optimize,
        .root_source_file = b.path("src/root.zig"),
    });
    zlua_mod.linkLibrary(luac_lib);

    const lib = b.addStaticLibrary(.{
        .name = "zlua",
        .root_module = zlua_mod,
    });
    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{
        .root_module = zlua_mod,
    });
    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);

    // Executable
    const exe_mod = b.addModule("zig_lua_test", .{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_mod.addImport("zlua", zlua_mod);

    const exe = b.addExecutable(.{
        .name = "zig_lua_test",
        .root_module = exe_mod,
    });
    exe.step.dependOn(&lib.step);
<<<<<<< main

=======
    exe.root_module.addImport("zlua", lib.root_module);
>>>>>>> Upgrade build to 0.14.0
    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);

    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
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
