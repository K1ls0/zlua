const std = @import("std");
const testing = std.testing;
const mem = std.mem;
const log = std.log;
const assert = std.debug.assert;
const panic = std.debug.panic;

const c = @import("lua_c.zig");
const cfg = @import("config.zig");
pub const util = @import("lua_util.zig");
pub const LuaError = util.LuaError;

pub const StdLib = cfg.StdLib;

pub fn State(comptime UD: type) type {
    return struct {
        const Self = @This();

        const StateUserData = struct {
            allocator: mem.Allocator,
            ud: ?UD,
            state: *c.lua_State,
        };
        ud: *StateUserData,

        pub const InitOptions = struct {
            userdata: ?UD = null,
            lib: cfg.StdLib = .{},
        };

        pub fn init(
            alloc: mem.Allocator,
            options: InitOptions,
        ) (LuaError || mem.Allocator.Error)!Self {
            const ud = try alloc.create(StateUserData);
            ud.ud = options.userdata;
            ud.allocator = alloc;

            const state = c.lua_newstate(allocFn, @ptrCast(ud)) orelse {
                return LuaError.StateInit;
            };
            errdefer c.lua_close(state);
            ud.state = state;
            _ = c.lua_atpanic(state, luaPanicReport);

            if (options.lib.base) _ = c.luaopen_base(state);
            if (options.lib.coroutine) _ = c.luaopen_coroutine(state);
            if (options.lib.table) _ = c.luaopen_table(state);
            if (options.lib.io) _ = c.luaopen_io(state);
            if (options.lib.os) _ = c.luaopen_os(state);
            if (options.lib.string) _ = c.luaopen_string(state);
            if (options.lib.utf8) _ = c.luaopen_utf8(state);
            if (options.lib.math) _ = c.luaopen_math(state);
            if (options.lib.debug) _ = c.luaopen_debug(state);
            if (options.lib.package) _ = c.luaopen_package(state);

            return Self{ .ud = ud };
        }

        pub fn deinit(self: Self) void {
            const alloc = self.ud.allocator;
            c.lua_close(self.lstate());
            alloc.destroy(self.ud);
        }

        /// Load a chunk of code/data into the lua vm.
        /// If name is set, store the resulting thread/function
        /// in a global variable with that name.
        /// If `name` parameter is null, the resulting thread
        /// is only being pushed onto the stack. Otherwise it's being
        pub fn load(
            self: *Self,
            reader: anytype,
            allocator: mem.Allocator,
            name: ?[:0]const u8,
        ) LuaError!void {
            const RTy = @TypeOf(reader);
            const RState = struct {
                const BUF_SIZE: usize = 512;

                reader: RTy,
                allocator: mem.Allocator,
                buf: [BUF_SIZE]u8 = undefined,

                fn readerFn(
                    _: ?*c.lua_State,
                    datan: ?*anyopaque,
                    sizen: ?*usize,
                ) callconv(.C) [*c]const u8 {
                    const size = sizen orelse unreachable;
                    const data_self: *@This() = @ptrCast(@alignCast(datan orelse unreachable));

                    const read_len = data_self.reader.read(&data_self.buf) catch |e| {
                        log.err("Error while reading: {any}", .{e});
                        size.* = 0;
                        return null;
                    };

                    size.* = read_len;
                    return &data_self.buf;
                }
            };

            var read_state = RState{
                .reader = reader,
                .allocator = allocator,
            };
            const r = c.lua_load(
                self.lstate(),
                RState.readerFn,
                @ptrCast(&read_state),
                null,
                null,
            );
            switch (r) {
                c.LUA_OK => {},
                c.LUA_ERRSYNTAX => {
                    const estr = try util.toString(self.lstate(), -1);
                    log.err("Syntax error in code: {s}", .{estr});
                    return LuaError.CodeSyntax;
                },
                c.LUA_ERRMEM => {
                    const estr = try util.toString(self.lstate(), -1);
                    log.err("Memory error occured: {s}", .{estr});
                    return LuaError.CodeMem;
                },
                else => unreachable,
            }

            if (name) |fn_name| {
                c.lua_setglobal(self.lstate(), fn_name.ptr);
            }
        }

        pub const CallFnOptions = struct {
            /// what kind of function to call
            name: FnName = .none,
            /// Call using protected call (pcall), otherwise unprotected (non-validating call)
            safe: bool = true,
        };
        pub fn callFn(
            self: *Self,
            args: anytype,
            comptime Retval: type,
            options: CallFnOptions,
        ) LuaError!Retval {
            const state = self.lstate();

            switch (options.name) {
                .none => {}, // Assume the function is on the stack already
                .global => |s| {
                    if (c.lua_getglobal(state, s.ptr) != c.LUA_OK) {
                        return LuaError.UnknownFunctionName;
                    }
                },
            }
            const cty = c.lua_type(state, -1);
            if (cty != c.LUA_TFUNCTION and
                cty != c.LUA_TTHREAD)
            {
                log.err("cty ({}) not executable", .{cty});
                return LuaError.NotExecutable;
            }

            log.info("Pushing: {any}", .{args});
            const args_ti = @typeInfo(@TypeOf(args));
            inline for (args_ti.Struct.fields) |field| {
                try util.pushValue(state, @field(args, field.name));
            }

            const params_count = args_ti.Struct.fields.len;
            // TODO: Add return values
            const retval_count = 0;
            switch (c.lua_pcallk(state, params_count, retval_count, 0, 0, null)) {
                c.LUA_OK => {},
                c.LUA_ERRRUN => return LuaError.CodeRuntime,
                c.LUA_ERRMEM => return LuaError.CodeMem,
                else => unreachable,
            }

            const ret_ti = @typeInfo(Retval);
            switch (ret_ti) {
                .Struct => |struct_ti| {
                    var r: Retval = undefined;
                    inline for (struct_ti.fields) |field| {
                        @field(r, field.name) = try util.toValue(field.type);
                        util.pop(state, 1);
                    }
                    return r;
                },
                else => {
                    const r = try util.toValue(state, Retval, -1);
                    util.pop(state, 1);
                    return r;
                },
            }
        }

        pub fn registerFunction(self: *Self, name: [:0]const u8, func: c.lua_Func) LuaError!void {
            comptime checkLuaCFunction(@TypeOf(func));
            const CFunc = struct {
                pub fn cclosure(s: ?*c.lua_State) c_int {
                    const state = s orelse unreachable;
                    const fn_ti = @typeInfo(@TypeOf(func));
                    inline for (fn_ti.Fn.params) |param| {
                        if (param.type) {
                            util.toValue(
                                state,
                            );
                        } else util.pushNil(state);
                    }
                    return 0;
                }
            };
            c.lua_pushcclosure(self.lstate(), CFunc.cclosure, 0);
            c.lua_setglobal(self.lstate(), name.ptr);
        }

        fn allocFn(
            ud: ?*anyopaque,
            ptr: ?*anyopaque,
            osize: usize,
            nsize: usize,
        ) callconv(.C) ?*anyopaque {
            const ZAlloc = struct {
                fn alloc(
                    a_ud: *StateUserData,
                    a_ptr: ?*anyopaque,
                    a_osize: usize,
                    a_nsize: usize,
                ) mem.Allocator.Error!?*anyopaque {
                    if (a_ptr) |existing_ptr| {
                        const ptr_slice = @as([*]u8, @ptrCast(existing_ptr))[0..a_osize];
                        if (a_nsize == 0) {
                            // Free ptr
                            a_ud.allocator.free(ptr_slice);
                            return null;
                        } else {
                            // realloc
                            const new = try a_ud.allocator.realloc(ptr_slice, a_nsize);
                            return @ptrCast(new.ptr);
                        }
                    } else {
                        if (a_nsize == 0) return null;
                        // Alloc
                        switch (a_osize) {
                            c.LUA_TNIL, c.LUA_TBOOLEAN, c.LUA_TLIGHTUSERDATA => {},
                            c.LUA_TNUMBER, c.LUA_TSTRING, c.LUA_TTABLE => {},
                            c.LUA_TFUNCTION, c.LUA_TUSERDATA, c.LUA_TTHREAD => {},
                            else => |id| log.debug("Unknown allocation id: {}", .{id}),
                        }

                        //const alignment = comptime (@import("builtin").target.ptrBitWidth() / 8);
                        const new = try a_ud.allocator.allocWithOptions(u8, a_nsize, null, null);
                        return @ptrCast(new.ptr);
                    }
                }
            };

            const userdata = @as(*StateUserData, @ptrCast(@alignCast(ud orelse {
                panic("lua alloc fn userdata is zero, but is expected to be set!", .{});
            })));

            return ZAlloc.alloc(userdata, ptr, osize, nsize) catch |e| {
                log.err("Error while allocating memory for lua vm: {}", .{e});
                return null;
            };
        }

        pub inline fn userData(self: *Self) ?*UD {
            return if (self.ud.ud) |ud| &ud else null;
        }

        pub inline fn lstate(self: *const Self) *c.lua_State {
            return self.ud.state;
        }
    };
}

fn luaPanicReport(s: ?*c.lua_State) callconv(.C) c_int {
    const cause = util.toString(s orelse return 1, -1) catch |e| {
        log.err("Error while converting to string: {}", .{e});
        return 2;
    };
    log.err("LUA PANIC: {s}", .{cause});
    return 0;
}

//fn alignmentFromSize(size: usize) u29 {
//    const bytewidth = ;
//    const alignment = blk: {
//        if (size < bytewidth) {
//            for (0..bytewidth) |i| {
//                _ = i; // autofix
//            }
//        } else break :blk bytewidth;
//    };
//    return alignment;
//}

pub const FnName = union(enum) {
    /// No function name (function ref taken from stack directly)
    none,
    /// global function name
    global: [:0]const u8,
};

fn checkLuaCFunction(comptime T: anytype) void {
    const ti = @typeInfo(T);
    switch (ti) {
        .Fn => |fn_ti| {
            if (fn_ti.params.len >= 1) @compileError("Two function parameters are needed");
            if (fn_ti.params[0].type) |ty| if (ty != c.lua_State) {
                @compileError("First parameter has to be a pointer to lua_State");
            };
        },
        else => @compileError("Only functions are allowed"),
    }
}
