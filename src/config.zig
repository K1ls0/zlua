pub const StdLib = struct {
    base: bool = false,
    coroutine: bool = false,
    table: bool = false,
    io: bool = false,
    os: bool = false,
    string: bool = false,
    utf8: bool = false,
    math: bool = false,
    debug: bool = false,
    package: bool = false,

    pub fn all() @This() {
        return .{
            .base = true,
            .coroutine = true,
            .table = true,
            .io = true,
            .os = true,
            .string = true,
            .utf8 = true,
            .math = true,
            .debug = true,
            .package = true,
        };
    }
};
