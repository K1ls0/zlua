const std = @import("std");
const builtin = @import("builtin");
const log = std.log;
const zlua = @import("zlua");

const FILENAME: []const u8 = "./test.lua";

const PCli = struct {
    filename: []const u8,

    pub fn parse() PCli {
        const max_positionals = 1;

        var filename: ?[]const u8 = null;

        var positional_idx: usize = 0;
        var state = State.normal;
        var it = std.process.args();
        _ = it.skip();
        while (it.next()) |arg| {
            switch (state) {
                .normal => {
                    if (stateFromStr(arg)) |nstate| {
                        switch (nstate) {
                            .help => printHelpAndExit("", .{}, .{ .exit = 0 }),
                            else => state = nstate,
                        }
                        continue;
                    } else {
                        switch (positional_idx) {
                            0 => filename = arg,
                            else => printHelpAndExit("expected {} arguments at most, but got at least {}", .{ max_positionals, positional_idx + 1 }, .{}),
                        }
                        positional_idx += 1;
                    }
                },
                .help => unreachable,
            }
            state = .normal;
        }

        return PCli{
            .filename = filename orelse printHelpAndExit("No filename given", .{}, .{}),
        };
    }

    const State = enum {
        normal,
        help,
    };

    fn stateFromStr(s: []const u8) ?State {
        const eql = struct {
            pub inline fn eql(a: []const u8, b: []const u8) bool {
                return std.mem.eql(u8, a, b);
            }
        }.eql;

        if (eql("-h", s) or eql("--help", s)) return State.help;

        return null;
    }

    fn printHelpAndExit(comptime fmt: []const u8, args: anytype, opts: struct {
        exit: u8 = 1,
    }) noreturn {
        const print = std.debug.print;
        if (fmt.len != 0) {
            print(fmt ++ "\n\n", args);
        }

        print(
            \\ Small test program for lua programming in Zig
            \\
            \\ Usage: zlua [options] <lua file>
            \\
            \\ OPTIONS:
            \\ -h, --help           print this and exit
            \\
        , .{});
        std.process.exit(opts.exit);
    }
};

const DefaultAllocator = struct {
    const DbgA = std.heap.DebugAllocator(.{ .safety = true });
    dbg_alloc: if (useDebugAlloc()) DbgA else void = if (useDebugAlloc()) .init else {},

    pub const init: DefaultAllocator = .{};

    pub fn deinit(self: *DefaultAllocator) void {
        if (comptime useDebugAlloc()) {
            std.debug.assert(self.dbg_alloc.deinit() == .ok);
        }
    }

    pub fn allocator(self: *DefaultAllocator) std.mem.Allocator {
        return if (comptime useDebugAlloc()) self.dbg_alloc.allocator() else std.heap.smp_allocator;
    }

    fn useDebugAlloc() bool {
        return builtin.mode == .Debug or builtin.mode == .ReleaseSafe;
    }
};

//var debug_allocator: std.heap.DebugAllocator(.{ .safety = true }) = .init;
//
//const allocator = if (builtin.mode == .Debug or builtin.mode == .ReleaseSafe) debug_allocator.allocator() else std.heap.smp_allocator;
//
//fn deinitAllocator() void {
//    if (comptime builtin.mode == .Debug or builtin.mode == .ReleaseSafe) {
//        std.debug.assert(debug_allocator.deinit() == .ok);
//    }
//}

pub fn main() !void {
    var default_allocator = DefaultAllocator.init;
    defer default_allocator.deinit();
    const allocator = default_allocator.allocator();

    const args = PCli.parse();

    std.log.info("filename: {s}", .{args.filename});

    var state = try zlua.State().init(
        allocator,
        .{
            .lib = zlua.StdLib.all,
        },
    );
    defer state.deinit();

    {
        var f = try std.fs.cwd().openFile(args.filename, .{ .mode = .read_only });
        defer f.close();
        try state.load(allocator, f.reader(), null);
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
