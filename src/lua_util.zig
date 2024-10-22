const std = @import("std");
const log = std.log;
pub const c = @import("lua_c.zig");

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
};

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

pub const lua_Hook = ?*const fn (?*c.lua_State, [*c]c.lua_Debug) callconv(.C) void;
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
pub const LuaType = enum(i8) {
    none = c.LUA_TNONE,
    nil = c.LUA_TNIL,
    boolean = c.LUA_TBOOLEAN,
    lightuserdata = c.LUA_TLIGHTUSERDATA,
    number = c.LUA_TNUMBER,
    string = c.LUA_TSTRING,
    table = c.LUA_TTABLE,
    function = c.LUA_TFUNCTION,
    userdata = c.LUA_TUSERDATA,
    thread = c.LUA_TTHREAD,
};

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
pub inline fn lua_getuservalue(L: ?*c.lua_State, idx: c_int) c_int {
    return c.lua_getiuservalue(L, idx, 1);
}
pub inline fn lua_setuservalue(L: ?*c.lua_State, idx: c_int) c_int {
    return c.lua_setiuservalue(L, idx, 1);
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
pub inline fn registerFn(s: *c.lua_State, n: [:0]const u8, f: c.lua_CFunction) void {
    _ = lua_pushcfunction(s, f);
    return c.lua_setglobal(s, n);
}
pub inline fn pop(L: *c.lua_State, n: c_int) void {
    return c.lua_settop(L, -n - 1);
}
pub inline fn pushNil(s: *c.lua_State) void {
    c.lua_pushnil(s);
}
pub inline fn pushNumber(s: *c.lua_State, n: c.lua_Number) void {
    c.lua_pushnumber(s, n);
}
pub inline fn pushInteger(s: *c.lua_State, n: c.lua_Integer) void {
    c.lua_pushinteger(s, n);
}
pub inline fn pushString(s: *c.lua_State, str: []const u8) void {
    _ = c.lua_pushlstring(s, str.ptr, str.len);
}
pub inline fn pushBool(s: *c.lua_State, b: bool) void {
    c.lua_pushboolean(s, @intFromBool(b));
}

pub inline fn pushUserdata(s: *c.lua_State, d: anytype) LuaError!void {
    const ptr = c.lua_newuserdatauv(s, @sizeOf(@TypeOf(d)), 1) orelse return LuaError.UDCreation;
    @memcpy(@as(*@TypeOf(d), ptr), &d);
}
pub inline fn pushLightUserdata(s: *c.lua_State, ptr: anytype) void {
    const ptr_ti = @typeInfo(@TypeOf(ptr));
    if (ptr_ti != .Pointer) @compileError("Light userdata has to be a pointer");
    switch (ptr_ti.Pointer.size) {
        .Slice => @compileError("Light userdata has to be an actual pointer"),
        .C, .One, .Many => {},
    }
    if (ptr_ti.Pointer.is_const) @compileError("Light userdata has to be a nont-const-pointer");
    c.lua_pushlightuserdata(s, @ptrCast(ptr));
}

pub fn toNumber(s: *c.lua_State, idx: c_int) LuaError!c.lua_Number {
    var is_num: c_int = 0;
    const r = c.lua_tonumberx(s, idx, &is_num);

    if (is_num == 0) return LuaError.Conversion;

    return r;
}

pub fn toInteger(s: *c.lua_State, idx: c_int) LuaError!c.lua_Integer {
    var is_num: c_int = 0;
    const r = c.lua_tointegerx(s, idx, &is_num);
    if (is_num == 0) return LuaError.Conversion;
    return r;
}

pub fn toString(s: *c.lua_State, idx: c_int) LuaError![:0]const u8 {
    var len: usize = 0;
    const r: ?[*:0]const u8 = @ptrCast(c.lua_tolstring(s, idx, &len));
    if (r) |rstr| {
        return rstr[0..len :0];
    } else {
        return LuaError.Conversion;
    }
}

pub inline fn toBool(s: *c.lua_State, idx: c_int) bool {
    return c.lua_toboolean(s, idx) != 0;
}

pub inline fn toPointer(s: *c.lua_State, comptime T: type, idx: c_int) LuaError!*const T {
    return @ptrCast(@alignCast(c.lua_topointer(s, idx) orelse {
        return LuaError.PointerNull;
    }));
}
pub inline fn toUserdata(s: *c.lua_State, comptime T: type, idx: c_int) LuaError!*T {
    const ptr = c.lua_touserdata(s, idx) orelse LuaError.NoUserdata;
    return @ptrCast(@alignCast(ptr));
}
//pub extern fn lua_tothread(L: ?*lua_State, idx: c_int) ?*lua_State;

pub fn printStack(s: *c.lua_State) void {
    const top = c.lua_gettop(s);
    if (top == 0) log.info("Stack empty", .{});
    log.info("stack:", .{});
    for (1..@intCast(top + 2)) |i| {
        const tyname = std.mem.sliceTo(c.lua_typename(s, c.lua_type(s, @intCast(i))), 0);
        log.info("\t[{d: >3}] {s} -> {s}", .{
            i,
            tyname,
            toValue(s, []const u8, @intCast(i)) catch "<>",
        });
    }
}
pub fn pushValue(s: *c.lua_State, v: anytype) LuaError!void {
    const ti = @typeInfo(@TypeOf(v));

    switch (ti) {
        inline .void => {},
        inline .null => pushNil(s),
        inline .bool => pushBool(s, v),
        inline .int => {
            if (v > std.math.maxInt(@TypeOf(v)) or
                v < std.math.minInt(@TypeOf(v)))
            {
                return LuaError.Conversion;
            }
            pushInteger(s, @intCast(v));
        },
        inline .float => pushNumber(s, @floatCast(v)),
        inline .array, .@"struct", .optional, .@"enum", .@"union" => std.debug.panic("Unsupported Type for values", .{}),
        inline .pointer => |ptr_ti| {
            switch (ptr_ti.size) {
                inline .Slice => {
                    const child_ti = @typeInfo(ptr_ti.child);
                    if (child_ti == .Int and
                        child_ti.Int.bits == 8 and
                        child_ti.Int.signedness == .unsigned)
                    {
                        try pushString(s, v);
                    } else {
                        pushLightUserdata(s, v);
                    }
                    return;
                },
                else => pushLightUserdata(s, v),
            }
        },
        else => @compileError("Unsupported type " ++ @typeName(@TypeOf(v))),
    }
}

pub fn toValue(s: *c.lua_State, comptime T: type, idx: c_int) LuaError!T {
    const ti = @typeInfo(T);

    switch (ti) {
        inline .void => return,
        inline .null => return null,
        inline .bool => return toBool(s, idx),
        inline .int => return toInteger(s, idx),
        inline .float => return toNumber(s, idx),
        inline .array => std.debug.panic("Arrays are currently unsupported", .{}),
        inline .@"struct" => std.debug.panic("Structs are currently unsupported", .{}),
        inline .optional => std.debug.panic("Optionals are currently unsupported", .{}),
        inline .@"enum" => std.debug.panic("Enums are currently unsupported", .{}),
        inline .@"union" => std.debug.panic("Unions are currently unsupported", .{}),
        inline .pointer => |ptr_ti| {
            comptime if (!ptr_ti.is_const) @compileError("Pointer has to be constant");
            switch (ptr_ti.size) {
                inline .Slice => {
                    const child_ti = @typeInfo(ptr_ti.child);
                    if (child_ti == .Int and
                        child_ti.Int.bits == 8 and
                        child_ti.Int.signedness == .unsigned)
                    {
                        return try toString(s, idx);
                    } else {
                        return toPointer(s, ptr_ti.child, idx);
                    }
                },
                else => return toPointer(s, ptr_ti.child, idx),
            }
        },
        else => @compileError("Unsupported type " ++ @typeName(T)),
    }
}
