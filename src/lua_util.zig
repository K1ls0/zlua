const std = @import("std");
const log = std.log;
pub const c = @import("luac.zig");

//const __builtin_expect = std.zig.c_builtins.__builtin_expect;

//extern var stdin: [*c]FILE;
//extern var stdout: [*c]FILE;
//extern var stderr: [*c]FILE;
//
//extern fn fflush(__stream: [*c]FILE) c_int;
//extern fn snprintf(__s: [*c]u8, __maxlen: c_ulong, __format: [*c]const u8, ...) c_int;
//extern fn fwrite(__ptr: ?*const anyopaque, __size: c_ulong, __n: c_ulong, __s: [*c]FILE) c_ulong;
//extern fn fprintf(__stream: [*c]FILE, __format: [*c]const u8, ...) c_int;

//const _IO_lock_t = anyopaque;
//const struct__IO_marker = opaque {};
//const struct__IO_codecvt = opaque {};
//const struct__IO_wide_data = opaque {};
//const FILE = extern struct {
//    _flags: c_int = std.mem.zeroes(c_int),
//    _IO_read_ptr: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_read_end: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_read_base: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_write_base: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_write_ptr: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_write_end: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_buf_base: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_buf_end: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_save_base: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_backup_base: [*c]u8 = std.mem.zeroes([*c]u8),
//    _IO_save_end: [*c]u8 = std.mem.zeroes([*c]u8),
//    _markers: ?*struct__IO_marker = std.mem.zeroes(?*struct__IO_marker),
//    _chain: [*c]FILE = std.mem.zeroes([*c]FILE),
//    _fileno: c_int = std.mem.zeroes(c_int),
//    _flags2: c_int = std.mem.zeroes(c_int),
//    _old_offset: c_long = std.mem.zeroes(c_long),
//    _cur_column: c_ushort = std.mem.zeroes(c_ushort),
//    _vtable_offset: i8 = std.mem.zeroes(i8),
//    _shortbuf: [1]u8 = std.mem.zeroes([1]u8),
//    _lock: ?*_IO_lock_t = std.mem.zeroes(?*_IO_lock_t),
//    _offset: c_long = std.mem.zeroes(c_long),
//    _codecvt: ?*struct__IO_codecvt = std.mem.zeroes(?*struct__IO_codecvt),
//    _wide_data: ?*struct__IO_wide_data = std.mem.zeroes(?*struct__IO_wide_data),
//    _freeres_list: [*c]FILE = std.mem.zeroes([*c]FILE),
//    _freeres_buf: ?*anyopaque = std.mem.zeroes(?*anyopaque),
//    __pad5: usize = std.mem.zeroes(usize),
//    _mode: c_int = std.mem.zeroes(c_int),
//    _unused2: [20]u8 = std.mem.zeroes([20]u8),
//};

pub const lua_Hook = ?*const fn (?*c.lua_State, [*c]c.lua_Debug) callconv(.c) void;
pub const lua_ident: [*c]const u8 = @extern([*c]const u8, .{
    .name = "lua_ident",
});

const BufferInitArgs = extern union {
    n: c.lua_Number,
    u: f64,
    s: ?*anyopaque,
    i: c.lua_Integer,
    l: c_long,
    b: [1024]u8,
};
pub const luaL_Buffer = extern struct {
    b: [*c]u8 = std.mem.zeroes([*c]u8),
    size: usize = std.mem.zeroes(usize),
    n: usize = std.mem.zeroes(usize),
    L: ?*c.lua_State = std.mem.zeroes(?*c.lua_State),
    init: BufferInitArgs = std.mem.zeroes(BufferInitArgs),
};
pub const luaL_Reg = extern struct {
    name: [*c]const u8 = std.mem.zeroes([*c]const u8),
    func: c.lua_CFunction = std.mem.zeroes(c.lua_CFunction),
};
//pub const luaL_Stream = extern struct {
//    f: [*c]FILE = std.mem.zeroes([*c]FILE),
//    closef: c.lua_CFunction = std.mem.zeroes(c.lua_CFunction),
//};
pub const LUAI_IS32INT = (std.math.maxInt(c_uint) >> 30) >= 3;
pub const LUA_INT_INT = 1;
pub const LUA_INT_LONG = 2;
pub const LUA_INT_LONGLONG = 3;
pub const LUA_FLOAT_FLOAT = 1;
pub const LUA_FLOAT_DOUBLE = 2;
pub const LUA_FLOAT_LONGDOUBLE = 3;
pub const LUA_INT_DEFAULT = LUA_INT_LONGLONG;
pub const LUA_FLOAT_DEFAULT = LUA_FLOAT_DOUBLE;
pub const LUA_32BITS = 0;
pub const LUA_C89_NUMBERS = 0;
pub const LUA_INT_TYPE = LUA_INT_DEFAULT;
pub const LUA_FLOAT_TYPE = LUA_FLOAT_DEFAULT;
pub const LUA_PATH_SEP = ";";
pub const LUA_PATH_MARK = "?";
pub const LUA_EXEC_DIR = "!";
pub const LUA_ROOT = "/usr/local/";
pub const LUA_DIRSEP = "/";
pub const LUAI_DDEF = "";
//pub inline fn lua_number2str(s: [*c]u8, sz: c_ulong, n: anytype) c_int {
//    return snprintf(s, sz, LUA_NUMBER_FMT, LUAI_UACNUMBER(n));
//}
pub const LUA_NUMBER = f64;
pub const LUAI_UACNUMBER = f64;
pub const LUA_NUMBER_FRMLEN = "";
pub const LUA_NUMBER_FMT = "%.14g";
pub const LUA_INTEGER_FMT = "%" ++ LUA_INTEGER_FRMLEN ++ "d";
pub const LUAI_UACINT = LUA_INTEGER;
//pub inline fn lua_integer2str(s: [*c]u8, sz: c_ulong, n: anytype) c_int {
//    return snprintf(s, sz, LUA_INTEGER_FMT, LUAI_UACINT(n));
//}
pub const LUA_UNSIGNED = c_uint ++ LUAI_UACINT;
pub const LUA_INTEGER = c_longlong;
pub const LUA_INTEGER_FRMLEN = "ll";
pub const LUA_MAXINTEGER = std.math.maxInt(c_longlong);
pub const LUA_MININTEGER = std.math.minInt(c_longlong);
pub const LUA_MAXUNSIGNED = std.math.maxInt(c_ulonglong);
pub const LUA_KCONTEXT = c_long;

pub const LUAI_MAXSTACK = std.zig.c_translation.promoteIntLiteral(c_int, 1000000, .decimal);
pub const LUA_EXTRASPACE = std.zig.c_translation.sizeof(?*anyopaque);
pub const LUA_IDSIZE = 60;
pub const LUAL_BUFFERSIZE = std.zig.c_translation.cast(c_int, (16 * std.zig.c_translation.sizeof(?*anyopaque)) * std.zig.c_translation.sizeof(c.lua_Number));
pub const LUA_MULTRET = -1;
pub const LUA_REGISTRYINDEX = -LUAI_MAXSTACK - 1000;
pub inline fn lua_upvalueindex(i: c_int) c_int {
    return LUA_REGISTRYINDEX - i;
}
//pub const LuaType = enum(i8) {
//    none = c.LUA_TNONE,
//    nil = c.LUA_TNIL,
//    boolean = c.LUA_TBOOLEAN,
//    lightuserdata = c.LUA_TLIGHTUSERDATA,
//    number = c.LUA_TNUMBER,
//    string = c.LUA_TSTRING,
//    table = c.LUA_TTABLE,
//    function = c.LUA_TFUNCTION,
//    userdata = c.LUA_TUSERDATA,
//    thread = c.LUA_TTHREAD,
//};

pub const LuaOp = enum(u8) {
    add = c.LUA_OPADD,
    sub = c.LUA_OPSUB,
    mul = c.LUA_OPMUL,
    mod = c.LUA_OPMOD,
    pow = c.LUA_OPPOW,
    div = c.LUA_OPDIV,
    idiv = c.LUA_OPIDIV,
    band = c.LUA_OPBAND,
    bor = c.LUA_OPBOR,
    bxor = c.LUA_OPBXOR,
    shl = c.LUA_OPSHL,
    shr = c.LUA_OPSHR,
    unm = c.LUA_OPUNM,
    bnot = c.LUA_OPBNOT,
};

pub const LuaOpRel = enum(u8) {
    eq = c.LUA_OPEQ,
    lt = c.LUA_OPLT,
    le = c.LUA_OPLE,
};
pub inline fn lua_call(L: ?*c.lua_State, n: c_int, r: c_int) void {
    return c.lua_callk(L, n, r, 0, null);
}
pub inline fn lua_pcall(L: ?*c.lua_State, nargs: c_int, nresults: c_int, errfunc: c_int) c_int {
    return c.lua_pcallk(L, nargs, nresults, errfunc, 0, null);
}
pub inline fn lua_yield(L: ?*c.lua_State, n: c_int) c_int {
    return c.lua_yieldk(L, n, 0, null);
}
pub const LUA_GCSTOP = 0;
pub const LUA_GCRESTART = 1;
pub const LUA_GCCOLLECT = 2;
pub const LUA_GCCOUNT = 3;
pub const LUA_GCCOUNTB = 4;
pub const LUA_GCSTEP = 5;
pub const LUA_GCSETPAUSE = 6;
pub const LUA_GCSETSTEPMUL = 7;
pub const LUA_GCISRUNNING = 9;
pub const LUA_GCGEN = 10;
pub const LUA_GCINC = 11;
pub inline fn lua_getextraspace(L: ?*c.lua_State) ?*anyopaque {
    return std.zig.c_translation.cast(?*anyopaque, std.zig.c_translation.cast([*c]u8, L) - LUA_EXTRASPACE);
}
pub inline fn lua_tonumber(L: ?*c.lua_State, i: c_int) c.lua_Integer {
    return c.lua_tonumberx(L, i, null);
}
pub inline fn lua_tointeger(L: ?*c.lua_State, i: c_int) c.lua_Integer {
    return c.lua_tointegerx(L, i, null);
}
pub inline fn lua_newtable(L: ?*c.lua_State) void {
    return c.lua_createtable(L, 0, 0);
}
pub inline fn lua_pushcfunction(L: *c.lua_State, f: c.lua_CFunction) void {
    return c.lua_pushcclosure(L, f, 0);
}
pub inline fn lua_isfunction(L: ?*c.lua_State, n: c_int) bool {
    return c.lua_type(L, n) == c.LUA_TFUNCTION;
}
pub inline fn lua_istable(L: ?*c.lua_State, n: c_int) bool {
    return c.lua_type(L, n) == c.LUA_TTABLE;
}
pub inline fn lua_islightuserdata(L: ?*c.lua_State, n: c_int) bool {
    return c.lua_type(L, n) == c.LUA_TLIGHTUSERDATA;
}
pub inline fn lua_isnil(L: ?*c.lua_State, n: c_int) bool {
    return c.lua_type(L, n) == c.LUA_TNIL;
}
pub inline fn lua_isboolean(L: ?*c.lua_State, n: c_int) bool {
    return c.lua_type(L, n) == c.LUA_TBOOLEAN;
}
pub inline fn lua_isthread(L: ?*c.lua_State, n: c_int) bool {
    return c.lua_type(L, n) == c.LUA_TTHREAD;
}
pub inline fn lua_isnone(L: ?*c.lua_State, n: c_int) bool {
    return c.lua_type(L, n) == c.LUA_TNONE;
}
pub inline fn lua_isnoneornil(L: ?*c.lua_State, n: c_int) bool {
    return c.lua_type(L, n) <= 0;
}
pub inline fn lua_pushliteral(L: ?*c.lua_State, s: [*c]const u8) [*c]const u8 {
    return c.lua_pushstring(L, s);
}
pub inline fn lua_pushglobaltable(L: ?*c.lua_State) anyopaque {
    return std.zig.c_translation.cast(anyopaque, c.lua_rawgeti(L, LUA_REGISTRYINDEX, c.LUA_RIDX_GLOBALS));
}
pub inline fn lua_tostring(L: ?*c.lua_State, i: c_int) @TypeOf(c.lua_tolstring(L, i, null)) {
    return c.lua_tolstring(L, i, null);
}
pub inline fn lua_insert(L: ?*c.lua_State, idx: c_int) @TypeOf(c.lua_rotate(L, idx, 1)) {
    return c.lua_rotate(L, idx, 1);
}
pub inline fn lua_remove(L: ?*c.lua_State, idx: c_int) void {
    _ = c.lua_rotate(L, idx, -1);
    return pop(L, 1);
}
pub inline fn lua_replace(L: ?*c.lua_State, idx: c_int) void {
    _ = c.lua_copy(L, -1, idx);
    return pop(L, 1);
}
pub const LUA_NUMTAGS = c.LUA_NUMTYPES;
pub const LUA_HOOKCALL = 0;
pub const LUA_HOOKRET = 1;
pub const LUA_HOOKLINE = 2;
pub const LUA_HOOKCOUNT = 3;
pub const LUA_HOOKTAILCALL = 4;
pub const LUA_MASKCALL = 1 << LUA_HOOKCALL;
pub const LUA_MASKRET = 1 << LUA_HOOKRET;
pub const LUA_MASKLINE = 1 << LUA_HOOKLINE;
pub const LUA_MASKCOUNT = 1 << LUA_HOOKCOUNT;
pub const LUA_GNAME = "_G";
pub const LUA_LOADED_TABLE = "_LOADED";
pub const LUA_PRELOAD_TABLE = "_PRELOAD";
pub const LUAL_NUMSIZES = (std.zig.c_translation.sizeof(c.lua_Integer) * 16) + std.zig.c_translation.sizeof(c.lua_Number);
pub const LUA_NOREF = -2;
pub const LUA_REFNIL = -1;

pub inline fn luaL_loadfile(L: ?*c.lua_State, f: [*c]const u8) @TypeOf(c.luaL_loadfilex(L, f, null)) {
    return c.luaL_loadfilex(L, f, null);
}
pub inline fn luaL_checkstring(L: ?*c.lua_State, n: c_int) [*c]const u8 {
    return c.luaL_checklstring(L, n, null);
}
pub inline fn luaL_optstring(L: ?*c.lua_State, n: c_int, d: [*c]const u8) [*c]const u8 {
    return c.luaL_optlstring(L, n, d, null);
}
pub inline fn luaL_typename(L: ?*c.lua_State, i: c_int) [*c]const u8 {
    return c.lua_typename(L, c.lua_type(L, i));
}
pub inline fn luaL_dofile(L: ?*c.lua_State, @"fn": c_int) bool {
    return (luaL_loadfile(L, @"fn") != 0) or (lua_pcall(L, 0, LUA_MULTRET, 0) != 0);
}
pub inline fn luaL_dostring(L: ?*c.lua_State, s: [*c]const u8) bool {
    return (c.luaL_loadstring(L, s) != 0) or (lua_pcall(L, 0, LUA_MULTRET, 0) != 0);
}
pub inline fn luaL_getmetatable(L: ?*c.lua_State, n: [*c]const u8) c_int {
    return c.lua_getfield(L, LUA_REGISTRYINDEX, n);
}
pub inline fn luaL_opt(comptime T: type, L: ?*c.lua_State, f: fn (?*c.lua_State, anytype) T, n: c_int, d: T) T {
    return if (lua_isnoneornil(L, n)) d else f(L, n);
}
pub inline fn luaL_loadbuffer(
    L: ?*c.lua_State,
    s: [*c]const u8,
    sz: usize,
    n: [*c]const u8,
) c_int {
    return c.luaL_loadbufferx(L, s, sz, n, null);
}
pub inline fn luaL_intop(op: anytype, v1: anytype, v2: anytype) c.lua_Integer {
    return std.zig.c_translation.cast(
        c.lua_Integer,
        std.zig.c_translation.cast(c.lua_Unsigned, (v1 ++ op)(c.lua_Unsigned)(v2)),
    );
}
pub inline fn luaL_pushfail(L: *?c.lua_State) @TypeOf(c.lua_pushnil(L)) {
    _ = &L;
    return c.lua_pushnil(L);
}
pub const lua_assert = std.debug.assert;

pub inline fn luaL_bufflen(bf: anytype) @TypeOf(bf.*.n) {
    return bf.*.n;
}
pub inline fn luaL_buffaddr(bf: anytype) @TypeOf(bf.*.b) {
    return bf.*.b;
}
pub inline fn luaL_prepbuffer(B: anytype) @TypeOf(c.luaL_prepbuffsize(B, LUAL_BUFFERSIZE)) {
    return c.luaL_prepbuffsize(B, LUAL_BUFFERSIZE);
}

pub inline fn lua_newuserdata(L: *c.lua_State, s: usize) ?*anyopaque {
    return c.lua_newuserdatauv(L, s, 1);
}
pub inline fn getGlobal(s: *c.lua_State, name: [:0]const u8) LuaError!void {
    if (c.lua_getglobal(s, name.ptr) != c.LUA_OK) {
        return LuaError.UnknownFunction;
    }
}
//pub inline fn registerFn(s: *c.lua_State, n: [:0]const u8, f: c.lua_CFunction) void {
//    _ = lua_pushcfunction(s, f);
//    return c.lua_setglobal(s, n);
//}
pub inline fn pop(L: *c.lua_State, n: c_int) void {
    return c.lua_settop(L, -n - 1);
}
//pub inline fn pushNil(s: *c.lua_State) void {
//    c.lua_pushnil(s);
//}
//pub inline fn pushNumber(s: *c.lua_State, n: c.lua_Number) void {
//    c.lua_pushnumber(s, n);
//}
//pub inline fn pushInteger(s: *c.lua_State, n: c.lua_Integer) void {
//    c.lua_pushinteger(s, n);
//}
//pub inline fn pushString(s: *c.lua_State, str: []const u8) void {
//    _ = c.lua_pushlstring(s, str.ptr, str.len);
//}
//pub inline fn pushBool(s: *c.lua_State, b: bool) void {
//    c.lua_pushboolean(s, @intFromBool(b));
//}

pub inline fn pushUserdata(s: *c.lua_State, d: anytype) LuaError!void {
    const ptr = c.lua_newuserdatauv(s, @sizeOf(@TypeOf(d)), 1) orelse return LuaError.UDCreation;
    @memcpy(@as(*@TypeOf(d), ptr), &d);
}
pub inline fn pushLightUserdata(s: *c.lua_State, ptr: anytype) void {
    const ptr_ti = @typeInfo(@TypeOf(ptr));
    if (ptr_ti != .pointer) @compileError("Light userdata has to be a pointer");
    switch (ptr_ti.pointer.size) {
        .Slice => @compileError("Light userdata has to be a raw pointer"),
        .c, .one, .many => {},
    }
    if (ptr_ti.Pointer.is_const) @compileError("Light userdata has to be a non-const-pointer");
    c.lua_pushlightuserdata(s, @ptrCast(ptr));
}

//pub fn toNumber(s: *c.lua_State, idx: c_int) LuaError!c.lua_Number {
//    var is_num: c_int = 0;
//    const r = c.lua_tonumberx(s, idx, &is_num);
//
//    if (is_num == 0) return LuaError.Conversion;
//
//    return r;
//}

//pub fn toInteger(s: *c.lua_State, idx: c_int) LuaError!c.lua_Integer {
//    var is_num: c_int = 0;
//    const r = c.lua_tointegerx(s, idx, &is_num);
//    if (is_num == 0) return LuaError.Conversion;
//    return r;
//}

//pub fn toString(s: *c.lua_State, idx: c_int) LuaError![:0]const u8 {
//    var len: usize = 0;
//    const r: ?[*:0]const u8 = @ptrCast(c.lua_tolstring(s, idx, &len));
//    if (r) |rstr| {
//        return rstr[0..len :0];
//    } else {
//        return LuaError.Conversion;
//    }
//}

//pub inline fn toBool(s: *c.lua_State, idx: c_int) bool {
//    return c.lua_toboolean(s, idx) != 0;
//}

//pub inline fn toPointer(s: *c.lua_State, comptime T: type, idx: c_int) LuaError!*const T {
//    return @ptrCast(@alignCast(c.lua_topointer(s, idx) orelse {
//        return LuaError.PointerNull;
//    }));
//}

pub inline fn toUserdata(s: *c.lua_State, comptime T: type, idx: c_int) LuaError!*T {
    const ptr = c.lua_touserdata(s, idx) orelse LuaError.NoUserdata;
    return @ptrCast(@alignCast(ptr));
}
//pub extern fn lua_tothread(L: ?*lua_State, idx: c_int) ?*lua_State;

//pub fn pushValue(s: *c.lua_State, v: anytype) LuaError!void {
//    const ti = @typeInfo(@TypeOf(v));
//
//    switch (ti) {
//        inline .void => {},
//        inline .null => pushNil(s),
//        inline .bool => pushBool(s, v),
//        inline .int => {
//            if (v > std.math.maxInt(@TypeOf(v)) or
//                v < std.math.minInt(@TypeOf(v)))
//            {
//                return LuaError.Conversion;
//            }
//            pushInteger(s, @intCast(v));
//        },
//        inline .float => pushNumber(s, @floatCast(v)),
//        inline .array, .@"struct", .optional, .@"enum", .@"union" => std.debug.panic("Unsupported Type for values", .{}),
//        inline .pointer => |ptr_ti| {
//            switch (ptr_ti.size) {
//                inline .slice => {
//                    const child_ti = @typeInfo(ptr_ti.child);
//                    if (child_ti == .int and
//                        child_ti.int.bits == 8 and
//                        child_ti.int.signedness == .unsigned)
//                    {
//                        try pushString(s, v);
//                    } else {
//                        pushLightUserdata(s, v);
//                    }
//                    return;
//                },
//                else => pushLightUserdata(s, v),
//            }
//        },
//        else => @compileError("Unsupported type " ++ @typeName(@TypeOf(v))),
//    }
//}

//pub fn toValue(s: *c.lua_State, comptime T: type, idx: c_int) LuaError!T {
//    const ti = @typeInfo(T);
//
//    switch (ti) {
//        inline .void => return {},
//        inline .null => return null,
//        inline .bool => return toBool(s, idx),
//        inline .int => return toInteger(s, idx),
//        inline .float => return toNumber(s, idx),
//        inline .array => std.debug.panic("Arrays are currently unsupported", .{}),
//        inline .@"struct" => std.debug.panic("Structs are currently unsupported", .{}),
//        inline .optional => std.debug.panic("Optionals are currently unsupported", .{}),
//        inline .@"enum" => std.debug.panic("Enums are currently unsupported", .{}),
//        inline .@"union" => std.debug.panic("Unions are currently unsupported", .{}),
//        inline .pointer => |ptr_ti| {
//            comptime if (!ptr_ti.is_const) @compileError("Pointer has to be constant");
//            switch (ptr_ti.size) {
//                inline .Slice => {
//                    const child_ti = @typeInfo(ptr_ti.child);
//                    if (child_ti == .Int and
//                        child_ti.Int.bits == 8 and
//                        child_ti.Int.signedness == .unsigned)
//                    {
//                        return try toString(s, idx);
//                    } else {
//                        return toPointer(s, ptr_ti.child, idx);
//                    }
//                },
//                else => return toPointer(s, ptr_ti.child, idx),
//            }
//        },
//        else => @compileError("Unsupported type " ++ @typeName(T)),
//    }
//}

pub const LuaError = error{
    StateInit,
    CodeSyntax,
    CodeMem,
    CodeRuntime,
    UnknownFunction,
    Conversion,
    Lookup,
    UnknownFunctionName,
    NotExecutable,
    UnexpectedType,
    PointerNull,
    UDCreation,
    NoUserdata,
} || RunLuaError || ConversionError;

pub const RunLuaError = error{
    Run,
    Syntax,
    Mem,
    Err,
};

pub const ConversionError = error{
    ToNil,
    ToBool,
    ToNumber,
    ToInteger,
    ToString,
    ToTable,
    ToFunction,
    Conversion,
};

pub const EResult = enum {
    ok,
    yield,
};
pub fn toResult(e: c_int) RunLuaError!EResult {
    switch (e) {
        c.LUA_OK => return .ok,
        c.LUA_YIELD => return .yield,
        c.LUA_ERRRUN => return error.Run,
        c.LUA_ERRSYNTAX => return error.Syntax,
        c.LUA_ERRMEM => return error.Mem,
        c.LUA_ERRERR => return error.Err,
        else => unreachable,
    }
}

pub fn errToCode(e: RunLuaError) c_int {
    return switch (e) {
        error.Run => return c.LUA_ERRRUN,
        error.Syntax => return c.LUA_ERRSYNTAX,
        error.Mem => return c.LUA_ERRMEM,
        error.Err => return c.LUA_ERRERR,
        else => return 10,
    };
}

pub fn printStack(lua: *c.lua_State) void {
    const top = c.lua_gettop(lua);
    if (top == 0) log.info("Stack empty", .{});
    log.info("stack:", .{});

    for (1..@intCast(top + 2)) |i| {
        const lua_type = c.lua_type(lua, @intCast(i));
        const tyname = std.mem.sliceTo(c.lua_typename(lua, lua_type), 0);
        switch (lua_type) {
            c.LUA_TBOOLEAN => {
                log.info("\t[{d: >3}] boolean -> {}", .{
                    i,
                    toValue(lua, @intCast(i), LuaType.Bool),
                });
            },
            c.LUA_TNUMBER => {
                log.info("\t[{d: >3}] number -> {}", .{
                    i,
                    toValue(lua, @intCast(i), LuaType.Number),
                });
            },
            c.LUA_TSTRING => {
                log.info("\t[{d: >3}] number -> '{s}'", .{
                    i,
                    toValue(lua, @intCast(i), LuaType.String)[0],
                });
            },
            else => {
                log.info("\t[{d: >3}] {s}", .{
                    i,
                    tyname,
                });
            },
        }
    }
}

pub const LuaTag = enum(c_int) {
    none = -1,
    nil = 0,
    boolean = 1,
    lightuserdata = 2,
    number = 3,
    string = 4,
    table = 5,
    function = 6,
    userdata = 7,
    thread = 8,
    _,

    pub fn fromCode(code: c_int) LuaTag {
        return @enumFromInt(code);
    }

    pub fn toString(self: LuaTag) [:0]const u8 {
        return std.enums.tagName(LuaTag, self) orelse "unknown";
    }
};

pub const LuaType = struct {
    pub const Nil = void;
    pub const Bool = bool;
    pub const Number = c.lua_Number;
    pub const Int = c.lua_Integer;
    pub const String = struct { [:0]const u8 };

    pub const Function = struct { stack_offs: c_int };
    pub const CFunction = struct { stack_offs: c_int };

    pub const UserData = struct { []const u8 };
    pub const LightUserData = struct { *anyopaque };
    pub const Thread = struct { stack_ref: c_int };

    pub fn isValidLuaType(comptime T: type) bool {
        return switch (T) {
            inline Nil,
            Bool,
            Number,
            Int,
            String,
            Table,
            Function,
            CFunction,
            LightUserData,
            UserData,
            => true,
            inline else => @compileError("Unsupported type" ++ @typeName(T)),
        };
    }

    pub fn luaTFromType(comptime T: type) c_int {
        return switch (T) {
            inline Nil => c.LUA_TNIL,
            inline Bool => c.LUA_TBOOLEAN,
            inline Number => c.LUA_TNUMBER,
            inline Int => c.LUA_TNUMBER,
            inline String => c.LUA_TSTRING,

            inline Function => c.LUA_TFUNCTION,
            inline CFunction => c.LUA_TFUNCTION,

            inline UserData => c.LUA_TUSERDATA,
            inline LightUserData => c.LUA_TLIGHTUSERDATA,
            inline Thread => c.LUA_TTHREAD,
            inline Table => c.LUA_TTABLE,
        };
    }

    pub const Table = struct {
        stack_offs: c_int,

        pub fn get(
            self: Table,
            lua: *c.lua_State,
            name: [:0]const u8,
            comptime V: type,
        ) ConversionError!V {
            const lua_field_type = c.lua_getfield(lua, self.stack_offs, name.ptr);
            if (lua_field_type != LuaType.luaTFromType(V)) {
                return error.Conversion;
            }
            return try toValue(lua, -1, V);
        }
    };
};

pub fn call(lua: *c.lua_State, name: ?[:0]const u8, args: anytype, comptime RetT: type) LuaError!RetT {
    if (name) |n| {
        switch (LuaTag.fromCode(c.lua_getglobal(lua, n.ptr))) {
            .thread, .function => {},
            else => |t| {
                log.err("Non-Executable type '{s}'", .{t.toString()});
                return LuaError.NotExecutable;
            },
        }
    }

    const r_ti = @typeInfo(RetT);

    const params_count = args.len;
    const retval_count = if (comptime r_ti == .@"struct" and !LuaType.isValidLuaType(RetT))
        r_ti.@"struct".fields.len
    else
        1;

    inline for (args) |carg| pushValue(lua, carg);
    switch (try toResult(c.lua_pcallk(lua, params_count, retval_count, 0, 0, null))) {
        .ok => {},
        .yield => {},
    }

    if (RetT == void) return {};

    if (comptime r_ti == .@"struct" and !LuaType.isValidLuaType(RetT)) {
        var ret: RetT = undefined;
        // TODO: Reverse?
        inline for (r_ti.@"struct".fields) |field| {
            @field(ret, field.name) = try popValue(lua, @TypeOf(@field(ret, field.name)));
        }
        return ret;
    } else {
        return try popValue(lua, RetT);
    }
}
//const params_count = args_ti.@"struct".fields.len;

pub fn pushValue(lua: *c.lua_State, v: anytype) void {
    switch (@TypeOf(v)) {
        inline LuaType.Nil => c.lua_pushnil(lua, v),
        inline LuaType.Bool => c.lua_pushboolean(lua, v),
        inline LuaType.Number => c.lua_pushnumber(lua, v),
        inline LuaType.Int => c.lua_pushinteger(lua, v),
        inline LuaType.String => _ = c.lua_pushlstring(lua, v[0].ptr, v[0].len),
        inline LuaType.Table => @compileError("Currently unsupported"),
        inline LuaType.Function => @compileError("Currently unsupported"),
        inline else => @compileError("Unsupported type" ++ @typeName(@TypeOf(v))),
    }
}

/// Get a value from the stack (growing up, top of the stack is '-1').
pub fn toValue(lua: *c.lua_State, stack_offset: c_int, comptime T: type) ConversionError!T {
    switch (T) {
        inline LuaType.Nil => {
            if (!lua_isnil(lua, stack_offset)) {
                log.err("Value from stack is not nil (was {s})", .{
                    luaL_typename(lua, stack_offset),
                });
                return error.ToNil;
            }
            return .{};
        },
        inline LuaType.Bool => {
            if (!lua_isboolean(lua, stack_offset)) {
                log.err("Value from stack is not a boolean (was {s})", .{
                    luaL_typename(lua, stack_offset),
                });
                return error.ToBool;
            }
            return c.lua_toboolean(lua, stack_offset) != 0;
        },
        inline LuaType.Number => {
            if (!(c.lua_isnumber(lua, stack_offset) != 0)) {
                log.err("Value from stack is not a number (was {s})", .{
                    luaL_typename(lua, stack_offset),
                });
                return error.ToNumber;
            }
            return c.lua_tonumberx(lua, stack_offset, null);
        },
        inline LuaType.Int => {
            if (!(c.lua_isinteger(lua, stack_offset) != 0)) {
                log.err("Value from stack is not an integer (was {s})", .{
                    luaL_typename(lua, stack_offset),
                });
                return error.ToInteger;
            }
            return c.lua_tointegerx(lua, stack_offset, null);
        },
        inline LuaType.String => {
            if (!(c.lua_isstring(lua, stack_offset) != 0)) {
                log.err("Value from stack is not a string (was {s})", .{
                    luaL_typename(lua, stack_offset),
                });
                return error.ToString;
            }
            var str_len: usize = 0;
            const str_ptr = c.lua_tolstring(lua, stack_offset, &str_len) orelse @panic("String is null");
            return LuaType.String{@ptrCast(str_ptr[0..str_len])};
        },
        inline LuaType.UserData => {
            @panic("TODO");
        },
        inline LuaType.LightUserData => {
            @panic("TODO");
        },
        inline LuaType.Table => {
            if (!lua_istable(lua, stack_offset)) {
                log.err("Value from stack is not a table (was {s})", .{
                    luaL_typename(lua, stack_offset),
                });
                return error.ToTable;
            }
            return LuaType.Table{ .stack_offs = stack_offset };
        },
        inline LuaType.Function => {
            if (!lua_isfunction(lua, stack_offset)) {
                log.err("Value from stack is not a function (was {s})", .{
                    luaL_typename(lua, stack_offset),
                });
                return error.ToFunction;
            }
            return LuaType.Function{ .stack_offs = stack_offset };
        },
        inline else => @compileError("Unsupported type" ++ @typeName(T)),
    }
}

pub fn popValue(lua: *c.lua_State, comptime T: type) ConversionError!T {
    pop(lua, 1);
    return try toValue(lua, 0, T);
}

pub fn registerFn(lua: *c.lua_State, comptime name: ?[:0]const u8, func: anytype) LuaError!void {
    const fn_info = @typeInfo(@TypeOf(func)).@"fn";
    const params = fn_info.params;
    const RetT = fn_info.return_type.?;

    const ArgsStore = ArgsStruct(@TypeOf(func));

    const C = struct {
        pub fn callFunc(l_opt: ?*c.lua_State) callconv(.c) c_int {
            const l = l_opt.?;

            var args_call: ArgsStore = undefined;
            inline for (params, 0..) |param, i| {
                const AT = param.type.?;
                args_call[i] = toValue(l, @intCast(i + 1), AT) catch |e| {
                    log.err("Error while getting value of type " ++ @typeName(AT) ++ ": {}", .{e});
                    return 0;
                };
            }

            const ret: RetT = @call(.auto, func, args_call);

            if (comptime RetT != void) {
                if (comptime @typeInfo(RetT) == .@"struct" and !LuaType.isValidLuaType(RetT)) {
                    inline for (ret) |item| {
                        pushValue(l, item);
                    }
                    return @typeInfo(RetT).@"struct".fields.len;
                } else {
                    pushValue(l, ret);
                    return 1;
                }
            } else return 0;
        }
    };

    c.lua_pushcclosure(lua, &C.callFunc, 0);

    if (name) |n| c.lua_setglobal(lua, n.ptr);
}

fn ArgsStruct(comptime Fn: type) type {
    const fn_info = @typeInfo(Fn).@"fn";
    const args = fn_info.params;

    comptime var ti = std.builtin.Type.Struct{
        .layout = .auto,
        .is_tuple = true,
        .backing_integer = null,
        .fields = &.{},
        .decls = &.{},
    };

    comptime for (args, 0..) |arg, i| {
        const FieldType = arg.type orelse unreachable;
        ti.fields = ti.fields ++ &[_]std.builtin.Type.StructField{
            std.builtin.Type.StructField{
                .name = std.fmt.comptimePrint("{}", .{i}),
                .type = FieldType,
                .alignment = @alignOf(FieldType),
                .default_value_ptr = null,
                .is_comptime = false,
            },
        };
    };

    return @Type(std.builtin.Type{ .@"struct" = ti });
}

//inline fn isMultiReturn(comptime Fn: type) bool {
//    const RetT = @typeInfo(Fn).@"fn".return_type.?;
//    return @typeInfo(RetT) == .@"struct" and @typeInfo(RetT).@"struct".is_tuple;
//}

//fn RetStruct(comptime Fn: type) type {
//    const RetT = @typeInfo(Fn).@"fn".return_type.?;
//    return if (isMultiReturn(Fn)) return RetT else return struct { RetT };
//}
