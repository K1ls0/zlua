const std = @import("std");
const testing = std.testing;
const mem = std.mem;
const log = std.log;
const assert = std.debug.assert;
const panic = std.debug.panic;

pub const c = @import("luac.zig");
pub const cfg = @import("config.zig");
pub const util = @import("lua_util.zig");
pub const LuaError = util.LuaError;
pub const LuaType = util.LuaType;
pub const toValue = util.toValue;
pub const pushValue = util.pushValue;
pub const popValue = util.popValue;

pub const StdLib = cfg.StdLib;

pub fn State() type {
    return struct {
        const Self = @This();

        ud: *mem.Allocator,
        state: *c.lua_State,

        pub const InitOptions = struct {
            lib: cfg.StdLib = .{},
        };

        pub fn init(
            alloc: mem.Allocator,
            options: InitOptions,
        ) (LuaError || mem.Allocator.Error)!Self {
            const ud = try alloc.create(mem.Allocator);
            errdefer alloc.destroy(ud);
            ud.* = alloc;

            const state = c.lua_newstate(allocFn, @ptrCast(ud)) orelse {
                return LuaError.StateInit;
            };
            errdefer c.lua_close(state);

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

            return Self{
                .ud = ud,
                .state = state,
            };
        }

        pub fn deinit(self: Self) void {
            const alloc = self.ud;
            c.lua_close(self.state);
            alloc.destroy(self.ud);
        }

        pub fn getErrString(self: Self) [:0]const u8 {
            const as_val = toValue(self.state, -1, LuaType.String) catch @panic("No Error String");
            return as_val.@"0";
        }

        /// Load a chunk of code/data into the lua vm. If name is set, store
        /// the resulting thread/function in a global variable with that name.
        /// If `name` parameter is null, the resulting thread is only being
        /// pushed onto the stack.
        pub fn load(
            self: *Self,
            allocator: mem.Allocator,
            reader: anytype,
            filename: ?[:0]const u8,
            global_name: ?[:0]const u8,
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
                ) callconv(.c) [*c]const u8 {
                    assert(sizen != null);
                    assert(datan != null);

                    const size = sizen.?;
                    const data_self: *@This() = @ptrCast(@alignCast(datan.?));

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
            _ = util.toResult(c.lua_load(
                self.state,
                RState.readerFn,
                @ptrCast(&read_state),
                if (filename) |f| f.ptr else null,
                null,
            )) catch |e| {
                const cause = self.getErrString();
                log.err("Error while loading: {}: {s}", .{ e, cause });
            };

            if (global_name) |fn_name| c.lua_setglobal(self.state, fn_name.ptr);
        }

        pub inline fn call(
            self: Self,
            name: ?[:0]const u8,
            args: anytype,
            comptime RetT: type,
        ) LuaError!RetT {
            return try util.call(self.state, name, args, RetT);
        }

        pub inline fn registerFn(
            self: Self,
            name: ?[:0]const u8,
            func: anytype,
        ) LuaError!void {
            try util.registerFn(self.state, name, func);
        }

        // Call a lua function given the arguments an optional name and a
        // comptime return value. The return value will be inferred from the
        // VM. If the returned value from the lua function can not be cast
        // into the target value, an error is returned.
        //pub fn callFn(
        //    self: *Self,
        //    name: FnName,
        //    args: anytype,
        //    comptime Retval: type,
        //) LuaError!Retval {
        //    const state = self.state;

        //    // If no name was given, use the top value from the Lua VM stack.
        //    if (name) |s| {
        //        const glob_type = c.lua_getglobal(state, s.ptr);
        //        switch (glob_type) {
        //            c.LUA_TTHREAD, c.LUA_TFUNCTION => {},
        //            else => return LuaError.NotExecutable,
        //        }
        //    }

        //    const args_ti = @typeInfo(@TypeOf(args));

        //    inline for (args_ti.@"struct".fields) |field| {
        //        try util.pushValue(state, @field(args, field.name));
        //    }

        //    const params_count = args_ti.@"struct".fields.len;
        //    const retval_count = switch (@typeInfo(Retval)) {
        //        inline .@"struct" => |struct_ti| struct_ti.fields.len,
        //        else => 1,
        //    };

        //    switch (c.lua_pcallk(state, params_count, retval_count, 0, 0, null)) {
        //        c.LUA_OK => {},
        //        c.LUA_ERRRUN => {
        //            log.err("Runtime Error occured: {s}", .{try util.toString(state, -1)});
        //            return LuaError.CodeRuntime;
        //        },
        //        c.LUA_ERRMEM => {
        //            log.err("Memory Error occured: {s}", .{try util.toString(state, -1)});
        //            return LuaError.CodeMem;
        //        },
        //        else => unreachable,
        //    }

        //    const ret_ti = @typeInfo(Retval);
        //    switch (ret_ti) {
        //        inline .@"struct" => |struct_ti| {
        //            var r: Retval = undefined;
        //            inline for (struct_ti.fields) |field| {
        //                @field(r, field.name) = try util.toValue(field.type);
        //                util.pop(state, 1);
        //            }
        //            return r;
        //        },
        //        else => {
        //            const r = try util.toValue(state, Retval, -1);
        //            util.pop(state, 1);
        //            return r;
        //        },
        //    }
        //}

        // register a new function under a given name inside the lua vm
        //pub fn registerFn(self: *Self, name: ?[:0]const u8, func: anytype) LuaError!void {
        //    const CFunc = struct {
        //        inline fn cclosureInner(s: *c.lua_State) LuaError!c_int {
        //            const fn_ti = switch (@typeInfo(@TypeOf(func))) {
        //                inline .@"fn" => |fn_ti| fn_ti,
        //                else => @compileError("Only functions may be registered by this function."),
        //            };

        //            const ArgsTi = std.builtin.Type{
        //                .@"struct" = std.builtin.Type.Struct{
        //                    .layout = .auto,
        //                    .is_tuple = true,
        //                    .fields = &blk: {
        //                        // TODO: Add user context to function as default parameter
        //                        comptime var fields: [fn_ti.params.len]std.builtin.Type.StructField = undefined;
        //                        inline for (fn_ti.params, 0..) |param, i| {
        //                            const Ty = param.type orelse @compileError("All function parameters must have types");
        //                            fields[i] = std.builtin.Type.StructField{
        //                                .name = std.fmt.comptimePrint("{d}", .{i}),
        //                                .type = Ty,
        //                                .default_value_ptr = null,
        //                                .is_comptime = false,
        //                                .alignment = @alignOf(Ty),
        //                            };
        //                        }
        //                        break :blk fields;
        //                    },
        //                    .decls = &.{},
        //                },
        //            };
        //            const ArgsT = @Type(ArgsTi);

        //            var args: ArgsT = undefined;
        //            inline for (fn_ti.params, 0..) |param, i| {
        //                const ty = param.type orelse @compileError("All function parameters must have types");
        //                @field(args, std.fmt.comptimePrint("{d}", .{i})) = try util.toValue(s, ty, -1);
        //                util.pop(s, 1);
        //            }

        //            const r = @call(.auto, func, args);
        //            const ret_ti = @typeInfo(fn_ti.return_type orelse @compileError("Function has to have return type"));
        //            var ret_values: c_int = 0;
        //            switch (ret_ti) {
        //                inline .error_union => |eunion_ti| switch (@typeInfo(eunion_ti.payload)) {
        //                    inline .Struct => |struct_ti| {
        //                        const r_noerr = try r;
        //                        inline for (struct_ti.fields) |field| {
        //                            ret_values += 1;
        //                            try util.pushValue(s, @field(r_noerr, field.name));
        //                        }
        //                        return r;
        //                    },
        //                    else => {
        //                        ret_values += 1;
        //                        try util.pushValue(s, r);
        //                    },
        //                },
        //                inline .@"struct" => |struct_ti| {
        //                    inline for (struct_ti.fields) |field| {
        //                        ret_values += 1;
        //                        try util.pushValue(s, @field(r, field.name));
        //                    }
        //                    return r;
        //                },
        //                else => {
        //                    ret_values += 1;
        //                    try util.pushValue(s, r);
        //                },
        //            }

        //            return ret_values;
        //        }

        //        pub fn cclosure(s: ?*c.lua_State) callconv(.c) c_int {
        //            const state = s orelse unreachable;
        //            const r = cclosureInner(state) catch |e| {
        //                std.debug.panic("Error while executing c function: {}", .{e});
        //                return -1;
        //            };
        //            return r;
        //        }
        //    };
        //    c.lua_pushcclosure(self.state, CFunc.cclosure, 0);
        //    if (name) |n| {
        //        c.lua_setglobal(self.state, n.ptr);
        //    }
        //}

        //pub fn allocFn2(
        //    ud: ?*anyopaque,
        //    ptr: ?*anyopaque,
        //    osize: usize,
        //    nsize: usize,
        //) callconv(.c) ?*anyopaque {
        //    const c_alignment = 16;
        //    const allocator: *const std.mem.Allocator = @ptrCast(@alignCast(ud));
        //    const aligned_ptr: ?[*]align(c_alignment) u8 = @ptrCast(@alignCast(ptr));
        //    if (aligned_ptr) |previous_pointer| {
        //        const previous_slice = previous_pointer[0..osize];
        //        if (allocator.realloc(previous_slice, nsize)) |new_slice| {
        //            return new_slice.ptr;
        //        } else |_| {
        //            if (osize >= nsize) {
        //                // Lua assumes that the allocator never fails when osize >= nsize.
        //                // We could lie and say that `previous_slice.ptr` is still correct
        //                // However then osize will be incorrect, which means the next shrink/grow would lie to the allocator implementation
        //                @panic("unable to shrink");
        //            }
        //            return null;
        //        }
        //    } else {
        //        // osize is any of LUA_TSTRING, LUA_TTABLE, LUA_TFUNCTION, LUA_TUSERDATA, or LUA_TTHREAD
        //        // when (and only when) Lua is creating a new object of that type.
        //        // When osize is some other value, Lua is allocating memory for something else.
        //        return (allocator.alignedAlloc(u8, c_alignment, nsize) catch return null).ptr;
        //    }
        //}
    };
}

fn luaPanicReport(s_opt: ?*c.lua_State) callconv(.c) c_int {
    const s = s_opt orelse return 1;
    const cause = util.toValue(s, -1, util.LuaType.String) catch |e| {
        log.err("Error while converting to string: {}", .{e});
        return 2;
    };
    log.err("LUA PANIC: {s}", .{cause.@"0"});
    return 0;
}

pub const FnName = ?[:0]const u8;

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

/// Wrapper function for the allocation function for the lua VM. It
/// allows utilizing any zig allocator for the LUA VM.
fn allocFn(
    ud: ?*anyopaque,
    ptr: ?*anyopaque,
    osize: usize,
    nsize: usize,
) callconv(.c) ?*anyopaque {
    const ZAlloc = struct {
        fn alloc(
            allocator: *mem.Allocator,
            a_ptr: ?*anyopaque,
            a_osize: usize,
            a_nsize: usize,
        ) mem.Allocator.Error!?*anyopaque {
            if (a_ptr) |existing_ptr| {
                const ptr_slice = @as([*]u8, @ptrCast(existing_ptr))[0..a_osize];
                if (a_nsize == 0) {
                    // Free ptr
                    allocator.free(ptr_slice);
                    return null;
                } else {
                    // realloc
                    const new = try allocator.realloc(ptr_slice, a_nsize);
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
                const new = try allocator.allocWithOptions(u8, a_nsize, null, null);
                return @ptrCast(new.ptr);
            }
        }
    };

    const userdata: *mem.Allocator = @ptrCast(@alignCast(ud orelse {
        panic("lua alloc fn userdata is zero, but is expected to be set!", .{});
    }));

    return ZAlloc.alloc(userdata, ptr, osize, nsize) catch |e| {
        log.err("Error while allocating memory for lua vm: {}", .{e});
        return null;
    };
}
