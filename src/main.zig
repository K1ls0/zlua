const std = @import("std");
const builtin = @import("builtin");
const log = std.log;
const zlua = @import("zlua");

const FILENAME: []const u8 = "./test.lua";

var debug_allocator: std.heap.DebugAllocator(.{ .safety = true }) = .init;

const allocator = if (builtin.mode == .Debug or builtin.mode == .ReleaseSafe) debug_allocator.allocator() else std.heap.smp_allocator;

fn deinitAllocator() void {
    if (comptime builtin.mode == .Debug or builtin.mode == .ReleaseSafe) {
        std.debug.assert(debug_allocator.deinit() == .ok);
    }
}

pub const Error = error{
    LoadCode,
    Exec,
};

pub fn main() !void {
    defer deinitAllocator();

    var state = try zlua.State().init(
        allocator,
        .{
            .lib = zlua.StdLib.all(),
        },
    );
    defer state.deinit();

    {
        var f = try std.fs.cwd().openFile("./test.lua", .{ .mode = .read_only });
        defer f.close();
        try state.load(f.reader(), allocator, null);
    }

    log.info("code eval", .{});
    try state.callFn(null, .{}, void);

    try state.registerFn("Mul2", mul2);

    log.info("Mul func", .{});
    const r = try state.callFn("Mul", .{
        @as(f64, 10),
        @as(f64, 2),
    }, f64);
    log.info("Got out {d}", .{r});

    log.info("Mul2 func", .{});
    const r2 = try state.callFn("Mul2", .{
        @as(f64, 10),
        @as(f64, 2),
    }, f64);
    log.info("Got out {d}", .{r2});

    try state.callFn("Main", .{}, void);
}

fn mul2(a: f64, b: f64) f64 {
    return a * b;
}
