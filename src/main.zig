const std = @import("std");
const log = std.log;
const zlua = @import("zlua");

const FILENAME: []const u8 = "./test.lua";

pub const Error = error{
    LoadCode,
    Exec,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{ .safety = true }){};
    defer std.debug.assert(gpa.deinit() == .ok);
    const allocator = gpa.allocator();

    var lua_alloc = std.heap.GeneralPurposeAllocator(.{ .safety = false }){};
    defer std.debug.assert(lua_alloc.deinit() == .ok);

    var state = try zlua.State().init(
        lua_alloc.allocator(),
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
