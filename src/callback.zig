const glfw = @import("lib.zig");


pub const monitor = *const fn (monitor: *glfw.Monitor, event: glfw.Connection) callconv(.c) void;

pub const windowPos             = *const fn (window: *glfw.Window, pos_x: c_int, pos_y: c_int) callconv(.c) void;
pub const windowSize            = *const fn (window: *glfw.Window, width: c_int, height: c_int) callconv(.c) void;
pub const windowClose           = *const fn (window: *glfw.Window) callconv(.c) void;
pub const windowRefresh         = *const fn (window: *glfw.Window) callconv(.c) void;
pub const windowFocus           = *const fn (window: *glfw.Window, focused: glfw.Bool) callconv(.c) void;
pub const windowIconify         = *const fn (window: *glfw.Window, iconify: glfw.Bool) callconv(.c) void;
pub const windowMaximize        = *const fn (window: *glfw.Window, maximized: glfw.Bool) callconv(.c) void;
pub const windowFramebufferSize = *const fn (window: *glfw.Window, width: c_int, height: c_int) callconv(.c) void;
pub const windowContentScale    = *const fn (window: *glfw.Window, scale_x: f32, scale_y: f32) callconv(.c) void;
pub const windowMouseButton     = *const fn (window: *glfw.Window, button: glfw.MouseButton, action: glfw.ActionPadded, mods: glfw.Modifier) callconv(.c) void;
pub const windowCursorPos       = *const fn (window: *glfw.Window, pos_x: f64, pos_y: f64) callconv(.c) void;
pub const windowCursorEnter     = *const fn (window: *glfw.Window, entered: glfw.Bool) callconv(.c) void;
pub const windowScroll          = *const fn (window: *glfw.Window, offset_x: f64, offset_y: f64) callconv(.c) void;
pub const windowKey             = *const fn (window: *glfw.Window, key: glfw.Key, scan_code: c_int, action: glfw.ActionPadded, mods: glfw.Modifier) callconv(.c) void;
pub const windowChar            = *const fn (window: *glfw.Window, code_point: u21) callconv(.c) void;
pub const windowCharMods        = *const fn (window: *glfw.Window, code_point: u21, mods: glfw.Modifier) callconv(.c) void;
pub const windowDrop            = *const fn (window: *glfw.Window, path_count: c_int, paths: ?[*]const [*:0]const u8) callconv(.c) void;

pub const @"error" = *const fn (error_code: glfw.ErrorCode, description: [*:0]const u8) callconv(.c) void;

pub const joystick = *const fn (jid: c_int, event: glfw.Connection) callconv(.c) void;

pub const allocate = *const fn (size: usize, user_data: ?*anyopaque) callconv(.c) ?*anyopaque;
pub const reallocate = *const fn (block: ?*anyopaque, size: usize, user_data: ?*anyopaque) callconv(.c) ?*anyopaque;
pub const deallocate = *const fn (block: ?*anyopaque, user_data: ?*anyopaque) callconv(.c) void;
