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

    var state = try zlua.State(void).init(
        lua_alloc.allocator(),
        .{
            .lib = zlua.StdLib.all(),
        },
    );
    defer state.deinit();

    zlua.util.printStack(state.lstate());

    {
        var f = try std.fs.cwd().openFile("./test.lua", .{ .mode = .read_only });
        defer f.close();
        try state.load(f.reader(), allocator, null);
    }

    zlua.util.printStack(state.lstate());

    const r = try state.callFn(.{
        @as(f64, 10),
        @as(f64, 2),
    }, f64, .{ .name = .{ .global = "Mul" } });
    log.info("Got out {d}", .{r});
}
