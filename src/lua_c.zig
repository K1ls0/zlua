const std = @import("std");

//pub usingnamespace @import("lua.zig");
//pub usingnamespace @import("lauxlib.zig");
//pub usingnamespace @import("lualib.zig");

pub extern fn lua_newstate(f: lua_Alloc, ud: ?*anyopaque) ?*lua_State;
pub extern fn lua_close(L: ?*lua_State) void;
pub extern fn lua_newthread(L: ?*lua_State) ?*lua_State;
pub extern fn lua_closethread(L: ?*lua_State, from: ?*lua_State) c_int;
pub extern fn lua_resetthread(L: ?*lua_State) c_int;
pub extern fn lua_atpanic(L: ?*lua_State, panicf: lua_CFunction) lua_CFunction;
pub extern fn lua_version(L: ?*lua_State) lua_Number;
pub extern fn lua_absindex(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_gettop(L: ?*lua_State) c_int;
pub extern fn lua_settop(L: ?*lua_State, idx: c_int) void;
pub extern fn lua_pushvalue(L: ?*lua_State, idx: c_int) void;
pub extern fn lua_rotate(L: ?*lua_State, idx: c_int, n: c_int) void;
pub extern fn lua_copy(L: ?*lua_State, fromidx: c_int, toidx: c_int) void;
pub extern fn lua_checkstack(L: ?*lua_State, n: c_int) c_int;
pub extern fn lua_xmove(from: ?*lua_State, to: ?*lua_State, n: c_int) void;
pub extern fn lua_isnumber(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_isstring(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_iscfunction(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_isinteger(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_isuserdata(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_type(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_typename(L: ?*lua_State, tp: c_int) [*c]const u8;
pub extern fn lua_tonumberx(L: ?*lua_State, idx: c_int, isnum: [*c]c_int) lua_Number;
pub extern fn lua_tointegerx(L: ?*lua_State, idx: c_int, isnum: [*c]c_int) lua_Integer;
pub extern fn lua_toboolean(s: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_tolstring(L: ?*lua_State, idx: c_int, len: [*c]usize) [*c]const u8;
pub extern fn lua_rawlen(L: ?*lua_State, idx: c_int) lua_Unsigned;
pub extern fn lua_tocfunction(L: ?*lua_State, idx: c_int) lua_CFunction;
pub extern fn lua_touserdata(L: ?*lua_State, idx: c_int) ?*anyopaque;
pub extern fn lua_tothread(L: ?*lua_State, idx: c_int) ?*lua_State;
pub extern fn lua_topointer(L: ?*lua_State, idx: c_int) ?*const anyopaque;
pub extern fn lua_arith(L: ?*lua_State, op: c_int) void;
pub extern fn lua_rawequal(L: ?*lua_State, idx1: c_int, idx2: c_int) c_int;
pub extern fn lua_compare(L: ?*lua_State, idx1: c_int, idx2: c_int, op: c_int) c_int;
pub extern fn lua_pushnil(L: ?*lua_State) void;
pub extern fn lua_pushnumber(L: ?*lua_State, n: lua_Number) void;
pub extern fn lua_pushinteger(L: ?*lua_State, n: lua_Integer) void;
pub extern fn lua_pushlstring(L: ?*lua_State, s: [*c]const u8, len: usize) [*c]const u8;
pub extern fn lua_pushstring(L: ?*lua_State, s: [*c]const u8) [*c]const u8;
pub extern fn lua_pushvfstring(L: ?*lua_State, fmt: [*c]const u8, argp: [*c]PushVFStringArgs) [*c]const u8;
pub extern fn lua_pushfstring(L: ?*lua_State, fmt: [*c]const u8, ...) [*c]const u8;
pub extern fn lua_pushcclosure(L: ?*lua_State, @"fn": lua_CFunction, n: c_int) void;
pub extern fn lua_pushboolean(L: ?*lua_State, b: c_int) void;
pub extern fn lua_pushlightuserdata(L: ?*lua_State, p: ?*anyopaque) void;
pub extern fn lua_pushthread(L: ?*lua_State) c_int;
pub extern fn lua_getglobal(L: ?*lua_State, name: [*c]const u8) c_int;
pub extern fn lua_gettable(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_getfield(L: ?*lua_State, idx: c_int, k: [*c]const u8) c_int;
pub extern fn lua_geti(L: ?*lua_State, idx: c_int, n: lua_Integer) c_int;
pub extern fn lua_rawget(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_rawgeti(L: ?*lua_State, idx: c_int, n: lua_Integer) c_int;
pub extern fn lua_rawgetp(L: ?*lua_State, idx: c_int, p: ?*const anyopaque) c_int;
pub extern fn lua_createtable(L: ?*lua_State, narr: c_int, nrec: c_int) void;
pub extern fn lua_newuserdatauv(L: ?*lua_State, sz: usize, nuvalue: c_int) ?*anyopaque;
pub extern fn lua_getmetatable(L: ?*lua_State, objindex: c_int) c_int;
pub extern fn lua_getiuservalue(L: ?*lua_State, idx: c_int, n: c_int) c_int;
pub extern fn lua_setglobal(L: ?*lua_State, name: [*c]const u8) void;
pub extern fn lua_settable(L: ?*lua_State, idx: c_int) void;
pub extern fn lua_setfield(L: ?*lua_State, idx: c_int, k: [*c]const u8) void;
pub extern fn lua_seti(L: ?*lua_State, idx: c_int, n: lua_Integer) void;
pub extern fn lua_rawset(L: ?*lua_State, idx: c_int) void;
pub extern fn lua_rawseti(L: ?*lua_State, idx: c_int, n: lua_Integer) void;
pub extern fn lua_rawsetp(L: ?*lua_State, idx: c_int, p: ?*const anyopaque) void;
pub extern fn lua_setmetatable(L: ?*lua_State, objindex: c_int) c_int;
pub extern fn lua_setiuservalue(L: ?*lua_State, idx: c_int, n: c_int) c_int;
pub extern fn lua_callk(L: ?*lua_State, nargs: c_int, nresults: c_int, ctx: lua_KContext, k: lua_KFunction) void;
pub extern fn lua_pcallk(L: ?*lua_State, nargs: c_int, nresults: c_int, errfunc: c_int, ctx: lua_KContext, k: lua_KFunction) c_int;
pub extern fn lua_load(L: ?*lua_State, reader: lua_Reader, dt: ?*anyopaque, chunkname: [*c]const u8, mode: [*c]const u8) c_int;
pub extern fn lua_dump(L: ?*lua_State, writer: lua_Writer, data: ?*anyopaque, strip: c_int) c_int;
pub extern fn lua_yieldk(L: ?*lua_State, nresults: c_int, ctx: lua_KContext, k: lua_KFunction) c_int;
pub extern fn lua_resume(L: ?*lua_State, from: ?*lua_State, narg: c_int, nres: [*c]c_int) c_int;
pub extern fn lua_status(L: ?*lua_State) c_int;
pub extern fn lua_isyieldable(L: ?*lua_State) c_int;
pub extern fn lua_setwarnf(L: ?*lua_State, f: lua_WarnFunction, ud: ?*anyopaque) void;
pub extern fn lua_warning(L: ?*lua_State, msg: [*c]const u8, tocont: c_int) void;
pub extern fn lua_gc(L: ?*lua_State, what: c_int, ...) c_int;
pub extern fn lua_error(L: ?*lua_State) c_int;
pub extern fn lua_next(L: ?*lua_State, idx: c_int) c_int;
pub extern fn lua_concat(L: ?*lua_State, n: c_int) void;
pub extern fn lua_len(L: ?*lua_State, idx: c_int) void;
pub extern fn lua_stringtonumber(L: ?*lua_State, s: [*c]const u8) usize;
pub extern fn lua_getallocf(L: ?*lua_State, ud: [*c]?*anyopaque) lua_Alloc;
pub extern fn lua_setallocf(L: ?*lua_State, f: lua_Alloc, ud: ?*anyopaque) void;
pub extern fn lua_toclose(L: ?*lua_State, idx: c_int) void;
pub extern fn lua_closeslot(L: ?*lua_State, idx: c_int) void;
pub extern fn lua_getstack(L: ?*lua_State, level: c_int, ar: [*c]lua_Debug) c_int;
pub extern fn lua_getinfo(L: ?*lua_State, what: [*c]const u8, ar: [*c]lua_Debug) c_int;
pub extern fn lua_getlocal(L: ?*lua_State, ar: [*c]const lua_Debug, n: c_int) [*c]const u8;
pub extern fn lua_setlocal(L: ?*lua_State, ar: [*c]const lua_Debug, n: c_int) [*c]const u8;
pub extern fn lua_getupvalue(L: ?*lua_State, funcindex: c_int, n: c_int) [*c]const u8;
pub extern fn lua_setupvalue(L: ?*lua_State, funcindex: c_int, n: c_int) [*c]const u8;
pub extern fn lua_upvalueid(L: ?*lua_State, fidx: c_int, n: c_int) ?*anyopaque;
pub extern fn lua_upvaluejoin(L: ?*lua_State, fidx1: c_int, n1: c_int, fidx2: c_int, n2: c_int) void;
pub extern fn lua_sethook(L: ?*lua_State, func: lua_Hook, mask: c_int, count: c_int) void;
pub extern fn lua_gethook(L: ?*lua_State) lua_Hook;
pub extern fn lua_gethookmask(L: ?*lua_State) c_int;
pub extern fn lua_gethookcount(L: ?*lua_State) c_int;
pub extern fn lua_setcstacklimit(L: ?*lua_State, limit: c_uint) c_int;

//pub extern fn luaL_checkversion_(L: ?*lua_State, ver: lua_Number, sz: usize) void;
//pub extern fn luaL_getmetafield(L: ?*lua_State, obj: c_int, e: [*c]const u8) c_int;
//pub extern fn luaL_callmeta(L: ?*lua_State, obj: c_int, e: [*c]const u8) c_int;
//pub extern fn luaL_tolstring(L: ?*lua_State, idx: c_int, len: [*c]usize) [*c]const u8;
//pub extern fn luaL_argerror(L: ?*lua_State, arg: c_int, extramsg: [*c]const u8) c_int;
//pub extern fn luaL_typeerror(L: ?*lua_State, arg: c_int, tname: [*c]const u8) c_int;
pub extern fn luaL_checklstring(L: ?*lua_State, arg: c_int, l: [*c]usize) [*c]const u8;
pub extern fn luaL_optlstring(L: ?*lua_State, arg: c_int, def: [*c]const u8, l: [*c]usize) [*c]const u8;
pub extern fn luaL_checknumber(L: ?*lua_State, arg: c_int) lua_Number;
pub extern fn luaL_optnumber(L: ?*lua_State, arg: c_int, def: lua_Number) lua_Number;
pub extern fn luaL_checkinteger(L: ?*lua_State, arg: c_int) lua_Integer;
pub extern fn luaL_optinteger(L: ?*lua_State, arg: c_int, def: lua_Integer) lua_Integer;
pub extern fn luaL_checkstack(L: ?*lua_State, sz: c_int, msg: [*c]const u8) void;
pub extern fn luaL_checktype(L: ?*lua_State, arg: c_int, t: c_int) void;
pub extern fn luaL_checkany(L: ?*lua_State, arg: c_int) void;
pub extern fn luaL_newmetatable(L: ?*lua_State, tname: [*c]const u8) c_int;
pub extern fn luaL_setmetatable(L: ?*lua_State, tname: [*c]const u8) void;
pub extern fn luaL_testudata(L: ?*lua_State, ud: c_int, tname: [*c]const u8) ?*anyopaque;
pub extern fn luaL_checkudata(L: ?*lua_State, ud: c_int, tname: [*c]const u8) ?*anyopaque;
pub extern fn luaL_where(L: ?*lua_State, lvl: c_int) void;
pub extern fn luaL_error(L: ?*lua_State, fmt: [*c]const u8, ...) c_int;
//pub extern fn luaL_checkoption(L: ?*lua_State, arg: c_int, def: [*c]const u8, lst: [*c]const [*c]const u8) c_int;
//pub extern fn luaL_fileresult(L: ?*lua_State, stat: c_int, fname: [*c]const u8) c_int;
//pub extern fn luaL_execresult(L: ?*lua_State, stat: c_int) c_int;
//pub extern fn luaL_ref(L: ?*lua_State, t: c_int) c_int;
//pub extern fn luaL_unref(L: ?*lua_State, t: c_int, ref: c_int) void;
//pub extern fn luaL_loadfilex(L: ?*lua_State, filename: [*c]const u8, mode: [*c]const u8) c_int;
//pub extern fn luaL_loadbufferx(L: ?*lua_State, buff: [*c]const u8, sz: usize, name: [*c]const u8, mode: [*c]const u8) c_int;
//pub extern fn luaL_loadstring(L: ?*lua_State, s: [*c]const u8) c_int;
//pub extern fn luaL_newstate() ?*lua_State;
//pub extern fn luaL_len(L: ?*lua_State, idx: c_int) lua_Integer;
//pub extern fn luaL_addgsub(b: [*c]luaL_Buffer, s: [*c]const u8, p: [*c]const u8, r: [*c]const u8) void;
//pub extern fn luaL_gsub(L: ?*lua_State, s: [*c]const u8, p: [*c]const u8, r: [*c]const u8) [*c]const u8;
//pub extern fn luaL_setfuncs(L: ?*lua_State, l: [*c]const luaL_Reg, nup: c_int) void;
//pub extern fn luaL_getsubtable(L: ?*lua_State, idx: c_int, fname: [*c]const u8) c_int;
//pub extern fn luaL_traceback(L: ?*lua_State, L1: ?*lua_State, msg: [*c]const u8, level: c_int) void;
//pub extern fn luaL_requiref(L: ?*lua_State, modname: [*c]const u8, openf: lua_CFunction, glb: c_int) void;
//pub extern fn luaL_buffinit(L: ?*lua_State, B: [*c]luaL_Buffer) void;
//pub extern fn luaL_prepbuffsize(B: [*c]luaL_Buffer, sz: usize) [*c]u8;
//pub extern fn luaL_addlstring(B: [*c]luaL_Buffer, s: [*c]const u8, l: usize) void;
//pub extern fn luaL_addstring(B: [*c]luaL_Buffer, s: [*c]const u8) void;
//pub extern fn luaL_addvalue(B: [*c]luaL_Buffer) void;
//pub extern fn luaL_pushresult(B: [*c]luaL_Buffer) void;
//pub extern fn luaL_pushresultsize(B: [*c]luaL_Buffer, sz: usize) void;
//pub extern fn luaL_buffinitsize(L: ?*lua_State, B: [*c]luaL_Buffer, sz: usize) [*c]u8;

pub extern fn luaopen_base(L: ?*lua_State) c_int;
pub extern fn luaopen_coroutine(L: ?*lua_State) c_int;
pub extern fn luaopen_table(L: ?*lua_State) c_int;
pub extern fn luaopen_io(L: ?*lua_State) c_int;
pub extern fn luaopen_os(L: ?*lua_State) c_int;
pub extern fn luaopen_string(L: ?*lua_State) c_int;
pub extern fn luaopen_utf8(L: ?*lua_State) c_int;
pub extern fn luaopen_math(L: ?*lua_State) c_int;
pub extern fn luaopen_debug(L: ?*lua_State) c_int;
pub extern fn luaopen_package(L: ?*lua_State) c_int;
pub extern fn luaL_openlibs(L: ?*lua_State) void;

pub const PushVFStringArgs = extern struct {
    gp_offset: c_uint = std.mem.zeroes(c_uint),
    fp_offset: c_uint = std.mem.zeroes(c_uint),
    overflow_arg_area: ?*anyopaque = std.mem.zeroes(?*anyopaque),
    reg_save_area: ?*anyopaque = std.mem.zeroes(?*anyopaque),
};
pub const CallInfo3 = opaque {};
pub const lua_Debug = extern struct {
    event: c_int = std.mem.zeroes(c_int),
    name: [*c]const u8 = std.mem.zeroes([*c]const u8),
    namewhat: [*c]const u8 = std.mem.zeroes([*c]const u8),
    what: [*c]const u8 = std.mem.zeroes([*c]const u8),
    source: [*c]const u8 = std.mem.zeroes([*c]const u8),
    srclen: usize = std.mem.zeroes(usize),
    currentline: c_int = std.mem.zeroes(c_int),
    linedefined: c_int = std.mem.zeroes(c_int),
    lastlinedefined: c_int = std.mem.zeroes(c_int),
    nups: u8 = std.mem.zeroes(u8),
    nparams: u8 = std.mem.zeroes(u8),
    isvararg: u8 = std.mem.zeroes(u8),
    istailcall: u8 = std.mem.zeroes(u8),
    ftransfer: c_ushort = std.mem.zeroes(c_ushort),
    ntransfer: c_ushort = std.mem.zeroes(c_ushort),
    short_src: [60]u8 = std.mem.zeroes([60]u8),
    i_ci: ?*CallInfo3 = std.mem.zeroes(?*CallInfo3),
};

pub const lua_State = opaque {};
pub const lua_Number = f64;
pub const lua_Integer = c_longlong;
pub const lua_Unsigned = c_ulonglong;
pub const lua_KContext = isize;
pub const lua_CFunction = ?*const fn (?*lua_State) callconv(.C) c_int;
pub const lua_KFunction = ?*const fn (?*lua_State, c_int, lua_KContext) callconv(.C) c_int;
pub const lua_Reader = ?*const fn (?*lua_State, ?*anyopaque, [*c]usize) callconv(.C) [*c]const u8;
pub const lua_Writer = ?*const fn (?*lua_State, ?*const anyopaque, usize, ?*anyopaque) callconv(.C) c_int;
pub const lua_WarnFunction = ?*const fn (?*anyopaque, [*c]const u8, c_int) callconv(.C) void;
pub const lua_Alloc = ?*const fn (?*anyopaque, ?*anyopaque, usize, usize) callconv(.C) ?*anyopaque;
pub const lua_Hook = ?*const fn (?*lua_State, [*c]lua_Debug) callconv(.C) void;

const BufInitArgs = extern union {
    n: lua_Number,
    u: f64,
    s: ?*anyopaque,
    i: lua_Integer,
    l: c_long,
    b: [1024]u8,
};
pub const luaL_Buffer = extern struct {
    b: [*c]u8 = std.mem.zeroes([*c]u8),
    size: usize = std.mem.zeroes(usize),
    n: usize = std.mem.zeroes(usize),
    L: ?*lua_State = std.mem.zeroes(?*lua_State),
    init: BufInitArgs = std.mem.zeroes(BufInitArgs),
};
pub const luaL_Reg = extern struct {
    name: [*c]const u8 = std.mem.zeroes([*c]const u8),
    func: lua_CFunction = std.mem.zeroes(lua_CFunction),
};

pub const LUA_OK = 0;
pub const LUA_YIELD = 1;
pub const LUA_ERRRUN = 2;
pub const LUA_ERRSYNTAX = 3;
pub const LUA_ERRMEM = 4;
pub const LUA_ERRERR = 5;

pub const LUA_TNONE = -1;
pub const LUA_TNIL = 0;
pub const LUA_TBOOLEAN = 1;
pub const LUA_TLIGHTUSERDATA = 2;
pub const LUA_TNUMBER = 3;
pub const LUA_TSTRING = 4;
pub const LUA_TTABLE = 5;
pub const LUA_TFUNCTION = 6;
pub const LUA_TUSERDATA = 7;
pub const LUA_TTHREAD = 8;

pub const LUA_NUMTYPES = 9;
pub const LUA_MINSTACK = 20;
pub const LUA_RIDX_MAINTHREAD = 1;
pub const LUA_RIDX_GLOBALS = 2;
pub const LUA_RIDX_LAST = LUA_RIDX_GLOBALS;

pub const LUA_OPADD = 0;
pub const LUA_OPSUB = 1;
pub const LUA_OPMUL = 2;
pub const LUA_OPMOD = 3;
pub const LUA_OPPOW = 4;
pub const LUA_OPDIV = 5;
pub const LUA_OPIDIV = 6;
pub const LUA_OPBAND = 7;
pub const LUA_OPBOR = 8;
pub const LUA_OPBXOR = 9;
pub const LUA_OPSHL = 10;
pub const LUA_OPSHR = 11;
pub const LUA_OPUNM = 12;
pub const LUA_OPBNOT = 13;
pub const LUA_OPEQ = 0;
pub const LUA_OPLT = 1;
pub const LUA_OPLE = 2;
