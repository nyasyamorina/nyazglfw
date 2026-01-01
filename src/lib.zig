pub const api = @import("api.zig");
pub const callback = @import("callback.zig");

const _ = {
    // `code_point` is a valid Unicode that can fit in `u21`, but glfw need a `c_uint`
    if (@sizeOf(u21) != @sizeOf(c_uint)) unreachable;
};

// `c_int` is not used in daily, so determite its size in comptime, normally it is 32-bit
pub const Int = @Type(.{ .int = .{ .bits = 8 * @sizeOf(c_int), .signedness = .signed } });
pub const UInt = @Type(.{ .int = .{ .bits = 8 * @sizeOf(c_int), .signedness = .unsigned } });


pub const version = struct {
    pub const major = 3;
    pub const minor = 4;
    pub const revision = 0;
};

pub const Bool = enum(Int) {
    false = 0,
    true = 1,
    _,

    pub fn castTo(self: Bool) bool {
        switch (self) {
            .false, .true => {},
            _ => unreachable,
        }
        return self != .false;
    }
};

// there are two different `Action` types in glfw with different sizes,
// `c_int` is used as function input/output, and `u8` is used in arrays)
pub const Action = enum(u8)  {
    release = 0,
    press = 1,
    repeat = 2, // this may never appears in some case
    _,
};
pub const ActionPadded = packed struct(Int) {
    action: Action,
    _pad: @Type(.{ .int = .{ .signedness = .unsigned, .bits = @typeInfo(Int).int.bits - 8 } }) = 0,
};

pub const Key = enum(Int) {
    unknown = -1,
    space = 32,
    apostrophe = 39,
    comma = 44,
    minus = 45,
    period = 46,
    slash = 47,
    @"0" = 48,
    @"1" = 49,
    @"2" = 50,
    @"3" = 51,
    @"4" = 52,
    @"5" = 53,
    @"6" = 54,
    @"7" = 55,
    @"8" = 56,
    @"9" = 57,
    semicolon = 59,
    equal = 61,
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90,
    left_braket = 91,
    backslash = 92,
    right_braket = 93,
    grave_accent = 96,
    world_1 = 161,
    world_2 = 162,
    escape = 256,
    enter = 257,
    tab = 258,
    backspace = 259,
    insert = 260,
    delete = 261,
    right = 262,
    left = 263,
    down = 264,
    up = 265,
    page_up = 266,
    page_down = 2677,
    home = 268,
    end = 269,
    caps_lock = 280,
    scroll_lock = 281,
    num_lock = 282,
    print_screen = 283,
    pause = 284,
    F1 = 290,
    F2 = 291,
    F3 = 292,
    F4 = 293,
    F5 = 294,
    F6 = 295,
    F7 = 296,
    F8 = 297,
    F9 = 298,
    F10 = 299,
    F11 = 300,
    F12 = 301,
    F13 = 302,
    F14 = 303,
    F15 = 304,
    F16 = 305,
    F17 = 306,
    F18 = 307,
    F19 = 308,
    F20 = 309,
    F21 = 310,
    F22 = 311,
    F23 = 312,
    F24 = 313,
    F25 = 314,
    kp_0 = 320,
    kp_1 = 321,
    kp_2 = 322,
    kp_3 = 323,
    kp_4 = 324,
    kp_5 = 325,
    kp_6 = 326,
    kp_7 = 327,
    kp_8 = 328,
    kp_9 = 329,
    kp_decimal = 330,
    kp_divide = 331,
    kp_multiply = 332,
    kp_subtract = 333,
    kp_add = 334,
    kp_enter = 335,
    kp_equal = 336,
    left_shift = 340,
    left_control = 341,
    left_alt = 342,
    left_super = 343,
    right_shift = 344,
    right_control = 345,
    right_alt = 346,
    right_super = 347,
    menu = 348,
    _,
    pub const last: Key = .menu;
};

pub const Modifier = packed struct(Int) {
    shift: bool = false,
    control: bool = false,
    alt: bool = false,
    super: bool = false,
    caps_lock: bool = false,
    num_lock: bool = false,
    _pad: @Type(.{ .int = .{ .signedness = .unsigned, .bits = @typeInfo(Int).int.bits - 6 } }) = 0,
};

pub const MouseButton = enum(Int) {
    @"1" = 0,
    @"2" = 1,
    @"3" = 2,
    @"4" = 3,
    @"5" = 4,
    @"6" = 5,
    @"7" = 6,
    @"8" = 7,
    _,
    pub const last: MouseButton = .@"8";
    pub const left: MouseButton = .@"1";
    pub const right: MouseButton = .@"2";
    pub const middle: MouseButton = .@"3";
};

pub const ErrorCode = enum(Int) {
    no_error                = 0,
    not_initialized         = 0x00010001,
    no_current_context      = 0x00010002,
    invalid_enum            = 0x00010003,
    invalid_value           = 0x00010004,
    out_of_memory           = 0x00010005,
    api_unavailable         = 0x00010006,
    version_unavailable     = 0x00010007,
    platform_error          = 0x00010008,
    format_unavailable      = 0x00010009,
    no_window_context       = 0x0001000A,
    cursor_unavailable      = 0x0001000B,
    feature_unavailable     = 0x0001000C,
    feature_unimplemented   = 0x0001000D,
    platform_unavailable    = 0x0001000E,
    _,
};

pub const ClientApi = enum(Int) {
    no_api          = 0,
    opengl_api      = 0x00030001,
    opengl_es_api   = 0x00030002,
    _,
};

pub const ContextRobustness = enum(Int) {
    no_robustness           = 0,
    no_reset_notification   = 0x00031001,
    lose_context_on_reset   = 0x00031002,
    _,
};

pub const OpenglProfile = enum(Int) {
    any_profile     = 0,
    core_profile    = 0x00032001,
    compat_profile  = 0x00032002,
    _,
};

pub const InputMode = enum(Int) {
    cursor                  = 0x00033001,
    sticky_keys             = 0x00033002,
    sticky_mouse_buttons    = 0x00033003,
    lock_key_mods           = 0x00033004,
    raw_mouse_motion        = 0x00033005,
    _,
};

pub const ContextReleaseBehavior = enum(Int) {
    any     = 0,
    flush   = 0x00035001,
    none    = 0x00035002,
    _,
};

pub const ContextCreationApi = enum(Int) {
    native  = 0x00036001,
    egl     = 0x00036002,
    osmesa  = 0x00036003,
    _,
};

pub const AnglePlatformType = enum(Int) {
    none        = 0x00037001,
    opengl      = 0x00037002,
    opengles    = 0x00037003,
    d3d9        = 0x00037004,
    d3d11       = 0x00037005,
    vulkan      = 0x00037007,
    metal       = 0x00037008,
    _,
};

pub const WaylandLibdecor = enum(Int) {
    prefer  = 0x00038001,
    disable = 0x00038002,
    _,
};

pub const Position = enum(Int) {
    any = 0x80000000,
    _,
};

pub const Connection = enum(Int) {
    connected       = 0x00040001,
    disconnected    = 0x00040002,
    _,
};

pub const InitHint = enum(Int) {
    joystick_hat_buttons    = 0x00050001,
    angle_platform_type     = 0x00050002,
    platform                = 0x00050003,
    cocoa_chdir_resources   = 0x00051001,
    cocoa_menubar           = 0x00051002,
    x11_xcb_vulkan_surface  = 0x00052001,
    wayland_libdecor        = 0x00053001,
    _,

    pub const set = struct {
        pub inline fn joystickHatButtons(value: bool) void {
            return api.glfwInitHint(.joystick_hat_buttons, @intFromBool(value));
        }
        pub inline fn anglePlatformType(platform_: AnglePlatformType) void {
            return api.glfwInitHint(.angle_platform_type, @intFromEnum(platform_));
        }
        pub inline fn platform(platform_: Platform) void {
            return api.glfwInitHint(.platform, @intFromEnum(platform_));
        }
        pub inline fn cocoaChdirResources(value: bool) void {
            return api.glfwInitHint(.cocoa_chdir_resources, @intFromBool(value));
        }
        pub inline fn cocoaMenuvar(value: bool) void {
            return api.glfwInitHint(.cocoa_menubar, @intFromBool(value));
        }
        pub inline fn x11XcbVulkanSurface(value: bool) void {
            return api.glfwInitHint(.x11_xcb_vulkan_surface, @intFromBool(value));
        }
        pub inline fn waylandLibdecor(value: WaylandLibdecor) void {
            return api.glfwInitHint(.wayland_libdecor, @intFromEnum(value));
        }
    };
};

pub const Platform = enum(Int) {
    any     = 0x00060000,
    win32   = 0x00060001,
    cocoa   = 0x00060002,
    wayland = 0x00060003,
    x11     = 0x00060004,
    null    = 0x00060005,
    _,

    pub inline fn get() Platform {
        return api.glfwGetPlatform();
    }

    pub fn isSupported(self: Platform) bool {
        return api.glfwPlatformSupported(self).castTo();
    }
};

pub const dont_care = -1;


pub const glproc = *const fn () callconv(.c) void;
pub const vkproc = *const fn () callconv(.c) void;

pub const VideoMode = extern struct {
    width: Int,
    height: Int,
    red_bits: Int,
    green_bits: Int,
    blue_bits: Int,
    refresh_rate: Int,
};

pub const GammaRamp = extern struct {
    red: ?[*]u16,
    green: ?[*]u16,
    blue: ?[*]u16,
    size: UInt,
};

pub const Image = extern struct {
    width: Int,
    height: Int,
    pixels: ?[*]u8,
};

pub const Allocator = extern struct {
    allocate: callback.allocate,
    reallocate: callback.reallocate,
    deallocate: callback.deallocate,
    user_data: ?*anyopaque,
};



const std = @import("std");

pub const GetErrorResult = struct {
    code: ErrorCode,
    description: ?[:0]const u8,
};

pub const Pos = extern struct {
    x: Int,
    y: Int,
};

pub const Size = extern struct {
    width: Int,
    height: Int,
};

pub const Area = extern struct {
    pos: Pos,
    size: Size,
};

pub const Scale = extern struct {
    x: f32,
    y: f32,
};

pub const FrameSize = extern struct {
    left: Int,
    top: Int,
    right: Int,
    bottom: Int,
};

pub const BitDepths = extern struct {
    red: Int,
    green: Int,
    blue: Int,
    alpha: Int,
    depth: Int,
    stencil: Int,
};


pub const Version = struct {
    major: Int,
    minor: Int,
    revision: Int,

    pub fn get() Version {
        var v: Version = undefined;
        api.glfwGetVersion(&v.major, &v.minor, &v.revision);
        return v;
    }

    pub inline fn getString() ?[*:0]const u8 {
        return api.glfwGetVersionString();
    }
};

pub const Monitor = opaque {
    pub fn getMonitors() ?[] ?*Monitor {
        var count: Int = undefined;
        const ptr = api.glfwGetMonitors(&count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }
    pub inline fn getPrimary() ?*Monitor {
        return api.glfwGetPrimaryMonitor();
    }

    pub inline fn setCallback(cb: ?callback.monitor) ?callback.monitor {
        return api.glfwSetMonitorCallback(cb);
    }

    pub fn getPos(self: *Monitor) Pos {
        var pos: Pos = undefined;
        api.glfwGetMonitorPos(self, &pos.x, &pos.y);
        return pos;
    }
    pub fn getWorkarea(self: *Monitor) Area {
        var area: Area = undefined;
        api.glfwGetMonitorWorkarea(self, &area.pos.x, &area.pos.y, &area.size.width, &area.size.height);
        return area;
    }
    /// size in millimeter
    pub fn getPhysicalSize(self: *Monitor) Size {
        var size: Size = undefined;
        api.glfwGetMonitorPhysicalSize(self, &size.width, &size.height);
        return size;
    }
    pub fn getContentScale(self: *Monitor) Scale {
        var scale: Scale = undefined;
        api.glfwGetMonitorContentScale(self, &scale.x, &scale.y);
        return scale;
    }

    pub fn getName(self: *Monitor) ?[:0]const u8 {
        const name = api.glfwGetMonitorName(self);
        return std.mem.span(name);
    }

    pub inline fn setUserPointer(self: *Monitor, user_data: ?*anyopaque) void {
        return api.glfwSetMonitorUserPointer(self, user_data);
    }
    pub inline fn getUserPointer(self: *Monitor) ?*anyopaque {
        return api.glfwGetMonitorUserPointer(self);
    }

    pub fn getVideoMods(self: *Monitor) ?[]const VideoMode {
        var count: Int = undefined;
        const ptr = api.glfwGetVideoModes(self, &count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }
    pub fn getVideoMod(self: *Monitor) ?VideoMode {
        const ptr = api.glfwGetVideoMode(self) orelse return null;
        return ptr.*;
    }

    pub inline fn setGamma(self: *Monitor, gamma: f32) void {
        return api.glfwSetGamma(self, gamma);
    }
    pub inline fn setGammaRamp(self: *Monitor, ramp: GammaRamp) void {
        return api.glfwSetGammaRamp(self, &ramp);
    }
    pub fn getGammaRamp(self: *Monitor) ?GammaRamp {
        const ptr = api.glfwGetGammaRamp(self) orelse return null;
        return ptr.*;
    }
};

pub const Window = opaque {
    pub const Hint = enum(Int) {
        focused                     = 0x00020001,
        iconified                   = 0x00020002,
        resizable                   = 0x00020003,
        visible                     = 0x00020004,
        decorated                   = 0x00020005,
        auto_iconify                = 0x00020006,
        floating                    = 0x00020007,
        maximized                   = 0x00020008,
        center_cursor               = 0x00020009,
        transparent_framebuffer     = 0x0002000A,
        hovered                     = 0x0002000B,
        focus_on_show               = 0x0002000C,
        mouse_passthrough           = 0x0002000D,
        position_x                  = 0x0002000E,
        position_y                  = 0x0002000F,

        red_bits                    = 0x00021001,
        green_bits                  = 0x00021002,
        blue_bits                   = 0x00021003,
        alpha_bits                  = 0x00021004,
        depth_bits                  = 0x00021005,
        stencil_bits                = 0x00021006,
        accum_red_bits              = 0x00021007,
        accum_green_bits            = 0x00021008,
        accum_blue_bits             = 0x00021009,
        accum_alpha_bits            = 0x0002100A,
        aux_buffers                 = 0x0002100B,
        stereo                      = 0x0002100C,
        samples                     = 0x0002100D,
        srgb_capable                = 0x0002100E,
        refresh_rate                = 0x0002100F,
        doublebuffer                = 0x00021010,

        client_api                  = 0x00022001,
        context_version_major       = 0x00022002,
        context_version_minor       = 0x00022003,
        context_revision            = 0x00022004,
        context_robustness          = 0x00022005,
        opengl_forward_compat       = 0x00022006,
        opengl_context_debug        = 0x00022007,
        opengl_profile              = 0x00022008,
        context_release_behavior    = 0x00022009,
        context_no_error            = 0x0002200A,
        context_creation_api        = 0x0002200B,
        scale_to_monitor            = 0x0002200C,
        scale_framebuffer           = 0x0002200D,

        cocoa_retina_framebuffer    = 0x00023001,
        cocoa_frame_name            = 0x00023002,
        cocoa_graphics_switching    = 0x00023003,

        x11_class_name              = 0x00024001,
        x11_instance_name           = 0x00024002,

        win32_keyboard_menu         = 0x00025001,
        win32_showdefault           = 0x00025002,

        wayland_app_id              = 0x00026001,
        _,

        fn ValueType(comptime hint: Hint) type {
            return switch (hint) {
                .focused,
                .iconified,
                .resizable,
                .visible,
                .decorated,
                .auto_iconify,
                .floating,
                .maximized,
                .center_cursor,
                .transparent_framebuffer,
                .hovered,
                .focus_on_show,
                .mouse_passthrough,
                .stereo,
                .srgb_capable,
                .doublebuffer,
                .opengl_forward_compat,
                .opengl_context_debug,
                .context_no_error,
                .scale_to_monitor,
                .scale_framebuffer,
                .cocoa_retina_framebuffer,
                .cocoa_graphics_switching,
                .win32_keyboard_menu,
                .win32_showdefault,
                => bool,

                .position_x,
                .position_y,
                .red_bits,
                .green_bits,
                .blue_bits,
                .alpha_bits,
                .depth_bits,
                .stencil_bits,
                .accum_red_bits,
                .accum_green_bits,
                .accum_blue_bits,
                .accum_alpha_bits,
                .aux_buffers,
                .samples,
                .refresh_rate,
                .context_version_major,
                .context_version_minor,
                .context_revision,
                => Int,

                .cocoa_frame_name,
                .x11_class_name,
                .x11_instance_name,
                .wayland_app_id,
                => [*:0]const u8,

                .client_api => ClientApi,
                .context_robustness => ContextRobustness,
                .opengl_profile => OpenglProfile,
                .context_release_behavior => ContextReleaseBehavior,
                .context_creation_api => ContextCreationApi,
                else => @compileError("not specity the value type of window hint " ++ @tagName(hint) ++ ", use `api.glfwWindowHint(hint, value)` instead")
            };
        }

        pub const set = struct {
            pub inline fn defaults() void {
                return api.glfwDefaultWindowHints();
            }

            pub inline fn focused(value: bool) void {
                return api.glfwWindowHint(.focused, @intFromBool(value));
            }
            pub inline fn iconified(value: bool) void {
                return api.glfwWindowHint(.iconified, @intFromBool(value));
            }
            pub inline fn resizable(value: bool) void {
                return api.glfwWindowHint(.resizable, @intFromBool(value));
            }
            pub inline fn visible(value: bool) void {
                return api.glfwWindowHint(.visible, @intFromBool(value));
            }
            pub inline fn decorated(value: bool) void {
                return api.glfwWindowHint(.decorated, @intFromBool(value));
            }
            pub inline fn autoIconify(value: bool) void {
                return api.glfwWindowHint(.auto_iconify, @intFromBool(value));
            }
            pub inline fn floating(value: bool) void {
                return api.glfwWindowHint(.floating, @intFromBool(value));
            }
            pub inline fn maximized(value: bool) void {
                return api.glfwWindowHint(.maximized, @intFromBool(value));
            }
            pub inline fn centerCursor(value: bool) void {
                return api.glfwWindowHint(.center_cursor, @intFromBool(value));
            }
            pub inline fn transparentFramebuffer(value: bool) void {
                return api.glfwWindowHint(.transparent_framebuffer, @intFromBool(value));
            }
            pub inline fn hovered(value: bool) void {
                return api.glfwWindowHint(.hovered, @intFromBool(value));
            }
            pub inline fn focusOnShow(value: bool) void {
                return api.glfwWindowHint(.focus_on_show, @intFromBool(value));
            }
            pub inline fn mousePassthrough(value: bool) void {
                return api.glfwWindowHint(.mouse_passthrough, @intFromBool(value));
            }
            pub fn position(x: ?Int, y: ?Int) void {
                if (x) |x_| api.glfwWindowHint(.position_x, x_);
                if (y) |y_| api.glfwWindowHint(Hint.position_y, y_);
            }

            pub fn bitDepths(red: ?Int, green: ?Int, blue: ?Int, alpha: ?Int, depth: ?Int, stencil: ?Int) void {
                if (red)     |r| api.glfwWindowHint(.red_bits, r);
                if (green)   |g| api.glfwWindowHint(.green_bits, g);
                if (blue)    |b| api.glfwWindowHint(.blue_bits, b);
                if (alpha)   |a| api.glfwWindowHint(.alpha_bits, a);
                if (depth)   |d| api.glfwWindowHint(.depth_bits, d);
                if (stencil) |s| api.glfwWindowHint(.stencil_bits, s);
            }
            pub fn accumulationBitDepths(red: ?Int, green: ?Int, blue: ?Int, alpha: ?Int) void {
                if (red)     |r| api.glfwWindowHint(.accum_red_bits, r);
                if (green)   |g| api.glfwWindowHint(.accum_green_bits, g);
                if (blue)    |b| api.glfwWindowHint(.accum_blue_bits, b);
                if (alpha)   |a| api.glfwWindowHint(.accum_alpha_bits, a);
            }
            pub inline fn auxBuffers(count: Int) void {
                return api.glfwWindowHint(.aux_buffers, count);
            }
            pub inline fn stereo(value: bool) void {
                return api.glfwWindowHint(.stereo, @intFromBool(value));
            }
            pub inline fn samples(count: Int) void {
                return api.glfwWindowHint(.samples, count);
            }
            pub inline fn srgbCapable(value: bool) void {
                return api.glfwWindowHint(.srgb_capable, @intFromBool(value));
            }
            pub inline fn refreshRate(count: Int) void {
                return api.glfwWindowHint(.refresh_rate, count);
            }
            pub inline fn doublebuffer(value: bool) void {
                return api.glfwWindowHint(.doublebuffer, @intFromBool(value));
            }

            pub inline fn clientApi(value: ClientApi) void {
                return api.glfwWindowHint(.client_api, @intFromEnum(value));
            }
            pub fn contextVersion(major: ?Int, minor: ?Int, revision: ?Int) void {
                if (major) |m| api.glfwWindowHint(.context_version_major, m);
                if (minor) |m| api.glfwWindowHint(.context_version_minor, m);
                if (revision) |r| api.glfwWindowHint(.context_revision, r);
            }
            pub inline fn contextRobustness(value: ContextRobustness) void {
                return api.glfwWindowHint(.context_robustness, @intFromEnum(value));
            }
            pub inline fn openglForwardCompat(value: bool) void {
                return api.glfwWindowHint(.opengl_forward_compat, @intFromBool(value));
            }
            pub inline fn openglContextDebug(value: bool) void {
                return api.glfwWindowHint(.opengl_context_debug, @intFromBool(value));
            }
            pub inline fn openglProfile(value: OpenglProfile) void {
                return api.glfwWindowHint(.opengl_profile, @intFromEnum(value));
            }
            pub inline fn contextReleaseBehavior(value: ContextReleaseBehavior) void {
                return api.glfwWindowHint(.context_release_behavior, @intFromEnum(value));
            }
            pub inline fn contextNoError(value: bool) void {
                return api.glfwWindowHint(.context_no_error, @intFromBool(value));
            }
            pub inline fn contextCreationApi(value: ContextCreationApi) void {
                return api.glfwWindowHint(.context_creation_api, @intFromEnum(value));
            }
            pub inline fn scaleToMonitor(value: bool) void {
                return api.glfwWindowHint(.scale_to_monitor, @intFromBool(value));
            }
            pub inline fn scaleFramebuffer(value: bool) void {
                return api.glfwWindowHint(.scale_framebuffer, @intFromBool(value));
            }

            pub inline fn cocoaRetinaFramebuffer(value: bool) void {
                return api.glfwWindowHint(.cocoa_retina_framebuffer, @intFromBool(value));
            }
            pub inline fn cocoaFrameName(name: [*:0]const u8) void {
                return api.glfwWindowHintString(.cocoa_frame_name, name);
            }
            pub inline fn cocoaGraphicsSwitching(value: bool) void {
                return api.glfwWindowHint(.cocoa_graphics_switching, @intFromBool(value));
            }

            pub inline fn x11ClassName(name: [*:0]const u8) void {
                return api.glfwWindowHintString(.x11_class_name, name);
            }
            pub inline fn x11InstanceName(name: [*:0]const u8) void {
                return api.glfwWindowHintString(.x11_instance_name, name);
            }

            pub inline fn win32KeyboardMenu(value: bool) void {
                return api.glfwWindowHint(.win32_keyboard_menu, @intFromBool(value));
            }
            pub inline fn win32Showdefault(value: bool) void {
                return api.glfwWindowHint(.win32_showdefault, @intFromBool(value));
            }

            pub inline fn waylandAppId(name: [*:0]const u8) void {
                return api.glfwWindowHintString(.wayland_app_id, name);
            }
        };
    };

    pub const Attribute = enum(Int) {
        focused                     = @intFromEnum(Hint.focused),
        iconified                   = @intFromEnum(Hint.iconified),
        resizable                   = @intFromEnum(Hint.resizable),
        visible                     = @intFromEnum(Hint.visible),
        decorated                   = @intFromEnum(Hint.decorated),
        auto_iconify                = @intFromEnum(Hint.auto_iconify),
        floating                    = @intFromEnum(Hint.floating),
        maximized                   = @intFromEnum(Hint.maximized),
        transparent_framebuffer     = @intFromEnum(Hint.transparent_framebuffer),
        hovered                     = @intFromEnum(Hint.hovered),
        focus_on_show               = @intFromEnum(Hint.focus_on_show),
        mouse_passthrough           = @intFromEnum(Hint.mouse_passthrough),

        red_bits                    = @intFromEnum(Hint.red_bits),
        green_bits                  = @intFromEnum(Hint.green_bits),
        blue_bits                   = @intFromEnum(Hint.blue_bits),
        alpha_bits                  = @intFromEnum(Hint.alpha_bits),
        depth_bits                  = @intFromEnum(Hint.depth_bits),
        stencil_bits                = @intFromEnum(Hint.stencil_bits),
        samples                     = @intFromEnum(Hint.samples),
        doublebuffer                = @intFromEnum(Hint.doublebuffer),

        client_api                  = @intFromEnum(Hint.client_api),
        context_version_major       = @intFromEnum(Hint.context_version_major),
        context_version_minor       = @intFromEnum(Hint.context_version_minor),
        context_revision            = @intFromEnum(Hint.context_revision),
        context_robustness          = @intFromEnum(Hint.context_robustness),
        opengl_forward_compat       = @intFromEnum(Hint.opengl_forward_compat),
        opengl_context_debug        = @intFromEnum(Hint.opengl_context_debug),
        opengl_profile              = @intFromEnum(Hint.opengl_profile),
        context_release_behavior    = @intFromEnum(Hint.context_release_behavior),
        context_no_error            = @intFromEnum(Hint.context_no_error),
        context_creation_api        = @intFromEnum(Hint.context_creation_api),
        _,

        fn ValueType(comptime attrib: Attribute) type {
            return Hint.ValueType(@enumFromInt(@intFromEnum(attrib)));
        }

        pub const get = struct {
            pub fn focused(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .focused));
                return b.castTo();
            }
            pub fn iconified(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .iconified));
                return b.castTo();
            }
            pub fn resizable(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .resizable));
                return b.castTo();
            }
            pub fn visible(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .visible));
                return b.castTo();
            }
            pub fn decorated(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .decorated));
                return b.castTo();
            }
            pub fn autoIconify(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .auto_iconify));
                return b.castTo();
            }
            pub fn floating(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .floating));
                return b.castTo();
            }
            pub fn maximized(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .maximized));
                return b.castTo();
            }
            pub fn transparentFramebuffer(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .transparent_framebuffer));
                return b.castTo();
            }
            pub fn hovered(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .hovered));
                return b.castTo();
            }
            pub fn focusOnShow(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .focus_on_show));
                return b.castTo();
            }
            pub fn mousePassthrough(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .mouse_passthrough));
                return b.castTo();
            }

            pub fn bitDepths(window: *Window) BitDepths {
                var bit_depths: BitDepths = undefined;
                bit_depths.red     = api.glfwGetWindowAttrib(window, .red_bits);
                bit_depths.green   = api.glfwGetWindowAttrib(window, .green_bits);
                bit_depths.blue    = api.glfwGetWindowAttrib(window, .blue_bits);
                bit_depths.alpha   = api.glfwGetWindowAttrib(window, .alpha_bits);
                bit_depths.depth   = api.glfwGetWindowAttrib(window, .depth_bits);
                bit_depths.stencil = api.glfwGetWindowAttrib(window, .stencil_bits);
                return bit_depths;
            }
            pub inline fn samples(window: *Window) Int {
                return api.glfwGetWindowAttrib(window, .samples);
            }
            pub fn doublebuffer(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .doublebuffer));
                return b.castTo();
            }

            pub inline fn clientApi(window: *Window) ClientApi {
                return @enumFromInt(api.glfwGetWindowAttrib(window, .client_api));
            }
            pub fn contextVersion(window: *Window) Version {
                var v: Version = undefined;
                v.major = api.glfwGetWindowAttrib(window, .context_version_major);
                v.minor = api.glfwGetWindowAttrib(window, .context_version_minor);
                v.revision = api.glfwGetWindowAttrib(window, .context_revision);
                return v;
            }
            pub inline fn contextRobustness(window: *Window) ContextRobustness {
                return @enumFromInt(api.glfwGetWindowAttrib(window, .context_robustness));
            }
            pub fn openglForwardCompat(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .opengl_forward_compat));
                return b.castTo();
            }
            pub fn openglContextDebug(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .opengl_context_debug));
                return b.castTo();
            }
            pub inline fn openglProfile(window: *Window) OpenglProfile {
                return @enumFromInt(api.glfwGetWindowAttrib(window, .opengl_profile));
            }
            pub inline fn contextReleaseBehavior(window: *Window) ContextReleaseBehavior {
                return @enumFromInt(api.glfwGetWindowAttrib(window, .context_release_behavior));
            }
            pub fn contextNoError(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(window, .context_no_error));
                return b.castTo();
            }
            pub inline fn contextCreationApi(window: *Window) ContextCreationApi {
                return @enumFromInt(api.glfwGetWindowAttrib(window, .context_creation_api));
            }
        };

        pub const set = struct {
            pub inline fn resizable(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(window, .resizable, @intFromBool(value));
            }
            pub inline fn decorated(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(window, .decorated, @intFromBool(value));
            }
            pub inline fn autoIconify(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(window, .auto_iconify, @intFromBool(value));
            }
            pub inline fn floating(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(window, .floating, @intFromBool(value));
            }
            pub inline fn focusOnShow(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(window, .focus_on_show, @intFromBool(value));
            }
        };
    };

    pub fn getAttrib(self: *Window, comptime attrib: Attribute) Attribute.ValueType(attrib) {
        switch (attrib) {
            .focused => return Attribute.get.focused(self),
            .iconified => return Attribute.get.iconified(self),
            .resizable => return Attribute.get.resizable(self),
            .visible => return Attribute.get.visible(self),
            .decorated => return Attribute.get.decorated(self),
            .auto_iconify => return Attribute.get.autoIconify(self),
            .floating => return Attribute.get.floating(self),
            .transparent_framebuffer => return Attribute.get.transparentFramebuffer(self),
            .hovered => return Attribute.get.hovered(self),
            .focus_on_show => return Attribute.get.focusOnShow(self),
            .samples => return Attribute.get.samples(self),
            .doublebuffer => return Attribute.get.doublebuffer(self),
            .client_api => return Attribute.get.clientApi(self),
            .context_robustness => return Attribute.get.contextRobustness(self),
            .opengl_forward_compat => return Attribute.get.openglForwardCompat(self),
            .opengl_context_debug => return Attribute.get.openglContextDebug(self),
            .opengl_profile => return Attribute.get.openglProfile(self),
            .context_release_behavior => return Attribute.get.contextReleaseBehavior(self),
            .context_no_error => return Attribute.get.contextNoError(self),
            .context_creation_api => return Attribute.get.contextCreationApi(self),
            inline else => @compileError("should use `Window.Attribute.get.<attrib>(window)` or `api.glfwGetWindowAttrib(window, attrib)` to get this attribute"),
        }
    }
    pub fn setAttrib(self: *Window, comptime attrib: Attribute, value: Attribute.ValueType(attrib)) void {
        switch (attrib) {
            .resizable     => Attribute.set.resizable(self, value),
            .decorated     => Attribute.set.decorated(self, value),
            .auto_iconify  => Attribute.set.autoIconify(self, value),
            .floating      => Attribute.set.floating(self, value),
            .focus_on_show => Attribute.set.focusOnShow(self, value),
            inline else => @compileError("should use `api.glfwSetWindowAttrib(window, attrib, value)` to set this attribute"),
        }
    }

    pub inline fn create(size: Size, title: [*:0]const u8, monitor: ?*Monitor, share: ?*Window) ?*Window {
        return api.glfwCreateWindow(size.width, size.height, title, monitor, share);
    }
    pub inline fn destroy(self: *Window) void {
        return api.glfwDestroyWindow(self);
    }

    pub fn shouldClose(self: *Window) bool {
        return api.glfwWindowShouldClose(self).castTo();
    }
    pub inline fn setShouldClose(self: *Window, value: bool) void {
        return api.glfwSetWindowShouldClose(self, @intFromBool(value));
    }

    /// i.e. minimize
    pub inline fn iconify(self: *Window) void {
        return api.glfwIconifyWindow(self);
    }
    pub inline fn restore(self: *Window) void {
        return api.glfwRestoreWindow(self);
    }
    pub inline fn maximize(self: *Window) void {
        return api.glfwMaximizeWindow(self);
    }
    pub inline fn show(self: *Window) void {
        return api.glfwShowWindow(self);
    }
    pub inline fn hide(self: *Window) void {
        return api.glfwHideWindow(self);
    }
    pub inline fn focus(self: *Window) void {
        return api.glfwFocusWindow(self);
    }
    pub inline fn requestAttention(self: *Window) void {
        return api.glfwRequestWindowAttention(self);
    }

    pub fn getFramebufferSize(self: *Window) Size {
        var size: Size = undefined;
        api.glfwGetFramebufferSize(self, &size.width, &size.height);
        return size;
    }
    pub fn getFrameSize(self: *Window) FrameSize {
        var frame_size: FrameSize = undefined;
        api.glfwGetWindowFrameSize(self, &frame_size.left, &frame_size.top, &frame_size.right, &frame_size.bottom);
        return frame_size;
    }
    pub fn getContentScale(self: *Window) Scale {
        var scale: Scale = undefined;
        api.glfwGetWindowContentScale(self, &scale.x, &scale.y);
        return scale;
    }
    pub fn getKey(self: *Window, key: Key) Action {
        return api.glfwGetKey(self, key).action;
    }
    pub fn getMouseButton(self: *Window, button: MouseButton) Action {
        return api.glfwGetMouseButton(self, button).action;
    }

    pub fn setIcon(self: *Window, images: []const Image) void {
        return api.glfwSetWindowIcon(self, @intCast(images.len), images.ptr);
    }
    pub inline fn setCursor(self: *Window, cursor: ?*Cursor) void {
        return api.glfwSetCursor(self, cursor);
    }

    pub fn getTitle(self: *Window) ?[:0]const u8 {
        const title = api.glfwGetWindowTitle(self);
        return std.mem.span(title);
    }
    pub inline fn setTitle(self: *Window, title: [*:0]const u8) void {
        return api.glfwSetWindowTitle(self, title);
    }

    pub fn getPos(self: *Window) Pos {
        var pos: Pos = undefined;
        api.glfwGetWindowPos(self, &pos.x, &pos.y);
        return pos;
    }
    pub inline fn setPos(self: *Window, pos: Pos) void {
        return api.glfwSetWindowPos(self, pos.x, pos.y);
    }

    pub inline fn getOpacity(self: *Window) f32 {
        return api.glfwGetWindowOpacity(self);
    }
    pub inline fn setOpacity(self: *Window, opacity: f32) void {
        return api.glfwSetWindowOpacity(self, opacity);
    }

    pub fn getSize(self: *Window) Size {
        var size: Size = undefined;
        api.glfwGetWindowSize(self, &size.width, &size.height);
        return size;
    }
    pub inline fn setSize(self: *Window, size: Size) void {
        return api.glfwSetWindowSize(self, size.width, size.height);
    }
    pub inline fn setSizeLimits(self: *Window, min: Size, max: Size) void {
        return api.glfwSetWindowSizeLimits(self, min.width, min.height, max.width, max.height);
    }
    pub inline fn setAspectRatio(self: *Window, numerator: ?Int, denominator: ?Int) void {
        return api.glfwSetWindowAspectRatio(self, numerator orelse dont_care, denominator orelse dont_care);
    }

    pub inline fn getMonitor(self: *Window) ?*Monitor {
        return api.glfwGetWindowMonitor(self);
    }
    pub inline fn setMonitor(self: *Window, monitor: ?*Monitor, pos: Pos, size: Size, refresh_rate: ?Int) void {
        return api.glfwSetWindowMonitor(self, monitor, pos.x, pos.y, size.width, size.height, refresh_rate orelse dont_care);
    }

    pub inline fn getInputMode(self: *Window, mode: InputMode) Int {
        return api.glfwGetInputMode(self, mode);
    }
    pub inline fn setInputMode(self: *Window, mode: InputMode, value: Int) void {
        return api.glfwSetInputMode(self, mode, value);
    }

    pub fn getCursorPos(self: *Window) Cursor.Pos {
        var pos: Cursor.Pos = undefined;
        api.glfwGetCursorPos(self, &pos.x, &pos.y);
        return pos;
    }
    pub inline fn setCursorPos(self: *Window, pos: Cursor.Pos) void {
        return api.glfwSetCursorPos(self, pos.x, pos.y);
    }

    pub inline fn getUserPointer(self: *Window) ?*anyopaque {
        return api.glfwGetWindowUserPointer(self);
    }
    pub inline fn setUserPointer(self: *Window, user_data: ?*anyopaque) void {
        return api.glfwSetWindowUserPointer(self, user_data);
    }

    pub inline fn setPosCallback(self: *Window, cb: ?callback.windowPos) ?callback.windowPos {
        return api.glfwSetWindowPosCallback(self, cb);
    }
    pub inline fn setSizeCallback(self: *Window, cb: ?callback.windowSize) ?callback.windowSize {
        return api.glfwSetWindowSizeCallback(self, cb);
    }
    pub inline fn setCloseCallback(self: *Window, cb: ?callback.windowClose) ?callback.windowClose {
        return api.glfwSetWindowCloseCallback(self, cb);
    }
    pub inline fn setRefreshCallback(self: *Window, cb: ?callback.windowRefresh) ?callback.windowRefresh {
        return api.glfwSetWindowRefreshCallback(self, cb);
    }
    pub inline fn setFocusCallback(self: *Window, cb: ?callback.windowFocus) ?callback.windowFocus {
        return api.glfwSetWindowFocusCallback(self, cb);
    }
    pub inline fn setIconifyCallback(self: *Window, cb: ?callback.windowIconify) ?callback.windowIconify {
        return api.glfwSetWindowIconifyCallback(self, cb);
    }
    pub inline fn setMaximizeCallback(self: *Window, cb: ?callback.windowMaximize) ?callback.windowMaximize {
        return api.glfwSetWindowMaximizeCallback(self, cb);
    }
    pub inline fn setFramebufferSizeCallback(self: *Window, cb: ?callback.windowFramebufferSize) ?callback.windowFramebufferSize {
        return api.glfwSetFramebufferSizeCallback(self, cb);
    }
    pub inline fn setContentScaleCallback(self: *Window, cb: ?callback.windowContentScale) ?callback.windowContentScale {
        return api.glfwSetWindowContentScaleCallback(self, cb);
    }
    pub inline fn setKeyCallback(self: *Window, cb: ?callback.windowKey) ?callback.windowKey {
        return api.glfwSetKeyCallback(self, cb);
    }
    pub inline fn setCharCallback(self: *Window, cb: ?callback.windowChar) ?callback.windowChar {
        return api.glfwSetCharCallback(self, cb);
    }
    pub inline fn setCharModsCallback(self: *Window, cb: ?callback.windowCharMods) ?callback.windowCharMods {
        return api.glfwSetCharModsCallback(self, cb);
    }
    pub inline fn setMouseButtonCallback(self: *Window, cb: ?callback.windowMouseButton) ?callback.windowMouseButton {
        return api.glfwSetMouseButtonCallback(self, cb);
    }
    pub inline fn setCursorPosCallback(self: *Window, cb: ?callback.windowCursorPos) ?callback.windowCursorPos {
        return api.glfwSetCursorPosCallback(self, cb);
    }
    pub inline fn setCursorEnterCallback(self: *Window, cb: ?callback.windowCursorEnter) ?callback.windowCursorEnter {
        return api.glfwSetCursorEnterCallback(self, cb);
    }
    pub inline fn setScrollCallback(self: *Window, cb: ?callback.windowScroll) ?callback.windowScroll {
        return api.glfwSetScrollCallback(self, cb);
    }
    pub inline fn setDropCallback(self: *Window, cb: ?callback.windowDrop) ?callback.windowDrop {
        return api.glfwSetDropCallback(self, cb);
    }

    pub inline fn swapBuffers(self: *Window) void {
        return api.glfwSwapBuffers(self);
    }
};

pub const Cursor = opaque {
    pub const Pos = extern struct {
        x: f64,
        y: f64,
    };

    pub const Shape = enum(Int) {
        arrow           = 0x00036001,
        ibeam           = 0x00036002,
        crosshair       = 0x00036003,
        pointing_hand   = 0x00036004,
        resize_ew       = 0x00036005,
        resize_ns       = 0x00036006,
        resize_nwse     = 0x00036007,
        resize_nesw     = 0x00036008,
        resize_all      = 0x00036009,
        not_allowed     = 0x0003600A,
        _,
        pub const hresize: Shape = .resize_ew;
        pub const vresize: Shape = .resize_ns;
        pub const hand: Shape = .pointing_hand;
    };

    pub const Visibility = enum(Int) {
        normal      = 0x00034001,
        hidden      = 0x00034002,
        disable     = 0x00034003,
        captured    = 0x00034004,
        _,
    };

    pub inline fn create(image: Image, hotspot: Cursor.Pos) ?*Cursor {
        return api.glfwCreateCursor(&image, hotspot.x, hotspot.y);
    }
    pub inline fn createStandard(shape: Shape) ?*Cursor {
        return api.glfwCreateStandardCursor(shape);
    }

    pub inline fn destroy(self: *Cursor) void {
        return api.glfwDestroyCursor(self);
    }
};

pub const Joystick = enum(Int) {
    _,

    pub const Hat = packed struct(u8) {
        up_bit: bool = false,
        right_bit: bool = false,
        down_bit: bool = false,
        left_bit: bool = false,
        _pad: u4 = 0,

        pub const centered: Hat = .{};
        pub const up: Hat = .{ .up_bit = true };
        pub const right: Hat = .{ .right_bit = true };
        pub const down: Hat = .{ .down_bit = true };
        pub const left: Hat = .{ .left_bit = true };
        pub const right_up: Hat = .{ .right_bit = true, .up_bit = true };
        pub const right_down: Hat = .{ .right_bit = true, .down_bit = true };
    };

    pub const Button = enum(Int) {
        @"1" = 0,
        @"2" = 1,
        @"3" = 2,
        @"4" = 3,
        @"5" = 4,
        @"6" = 5,
        @"7" = 6,
        @"8" = 7,
        @"9" = 8,
        @"10" = 9,
        @"11" = 10,
        @"12" = 11,
        @"13" = 12,
        @"14" = 13,
        @"15" = 14,
        @"16" = 15,
        _,
        pub const last: Button = .@"16";
    };

    pub inline fn setCallback(cb: ?callback.joystick) ?callback.joystick {
        return api.glfwSetJoystickCallback(cb);
    }

    pub fn isPresent(self: Joystick) bool {
        return api.glfwJoystickPresent(@intFromEnum(self)).castTo();
    }
    pub fn isGamepad(self: Joystick) bool {
        return api.glfwJoystickIsGamepad(@intFromEnum(self)).castTo();
    }

    pub fn getAxes(self: Joystick) ?[]const f32 {
        var count: Int = undefined;
        const ptr = api.glfwGetJoystickAxes(@intFromEnum(self), &count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }
    pub fn getButtons(self: Joystick) ?[]const Action {
        var count: Int = undefined;
        const ptr = api.glfwGetJoystickButtons(@intFromEnum(self), &count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }
    pub fn getHats(self: Joystick) ?[]const Hat {
        var count: Int = undefined;
        const ptr = api.glfwGetJoystickHats(@intFromEnum(self), &count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }

    pub fn getName(self: Joystick) ?[:0]const u8 {
        const name = api.glfwGetJoystickName(@intFromEnum(self));
        return std.mem.span(name);
    }
    pub fn getGuid(self: Joystick) ?[:0]const u8 {
        const guid = api.glfwGetJoystickGUID(@intFromEnum(self));
        return std.mem.span(guid);
    }

    pub inline fn setUserPointer(self: Joystick, user_data: ?*anyopaque) void {
        return api.glfwSetJoystickUserPointer(@intFromEnum(self), user_data);
    }
    pub inline fn getUserPointer(self: Joystick) ?*anyopaque {
        return api.glfwGetJoystickUserPointer(@intFromEnum(self));
    }
};

pub const Gamepad = enum(Int) {
    _,

    pub const Button = enum(Int) {
        A = 0,
        B = 1,
        X = 2,
        Y = 3,
        left_bumper = 4,
        right_bumper = 5,
        back = 6,
        start = 7,
        guide = 8,
        left_thumb = 9,
        right_thumb = 10,
        up = 11,
        right = 12,
        down = 13,
        left = 14,
        _,
        pub const last: Button = .left;
        pub const cross: Button = .A;
        pub const circle: Button = .B;
        pub const square: Button = .X;
        pub const triangle: Button = .Y;
    };

    pub const Axis = enum(Int) {
        left_x = 0,
        left_y = 1,
        right_x = 2,
        right_y = 3,
        left_trigger = 4,
        right_trigger = 5,
        _,
        pub const last: Axis = .right_trigger;
    };

    pub const State = extern struct {
        buttons: [15]Action,
        axes: [6]f32,

        pub fn buttonAction(self: State, button: Button) Action {
            return @enumFromInt(self.buttons[@intFromEnum(button)]);
        }
        pub fn axisState(self: State, axis: Axis) f32 {
            return self.axes[@intFromEnum(axis)];
        }
    };

    pub fn updateMappings(string: [*:0]const u8) bool {
        return api.glfwUpdateGamepadMappings(string).castTo();
    }

    pub fn fromJoystick(joystick: Joystick) Gamepad {
        return @enumFromInt(@intFromEnum(joystick));
    }

    pub fn getName(self: Gamepad) ?[:0]const u8 {
        const name = api.glfwGetGamepadName(@intFromEnum(self));
        return std.mem.span(name);
    }
    pub fn getState(self: Gamepad) ?State {
        var state: State = undefined;
        const success = api.glfwGetGamepadState(@intFromEnum(self), &state).castTo();
        return if (success) state else null;
    }
};


pub fn init() bool {
    return api.glfwInit().castTo();
}
pub inline fn terminate() void {
    return api.glfwTerminate();
}
pub inline fn initAllocator(allocator: ?*const Allocator) void {
    return api.glfwInitAllocator(allocator);
}

pub fn getError() GetErrorResult {
    var desc: ?[*:0]const u8 = null;
    const code = api.glfwGetError(&desc);
    const description = std.mem.span(desc);
    return .{ .code = code, .description = description };
}
pub inline fn setErrorCallback(cb: ?callback.@"error") ?callback.@"error" {
    return api.glfwSetErrorCallback(cb);
}

pub inline fn pollEvents() void {
    return api.glfwPollEvents();
}
pub inline fn waitEvents() void {
    return api.glfwWaitEvents();
}
pub inline fn waitEventsTimeout(timeout: f64) void {
    return api.glfwWaitEventsTimeout(timeout);
}
pub inline fn postEmptyEvent() void {
    return api.glfwPostEmptyEvent();
}

pub fn rawMouseMotionSupported() bool {
    return api.glfwRawMouseMotionSupported().castTo();
}

pub fn getKeyName(key: Key, scancode: Int) ?[:0]const u8 {
    const name = api.glfwGetKeyName(key, scancode);
    return std.mem.span(name);
}
pub inline fn getKeyScancode(key: Key) Int {
    return api.glfwGetKeyScancode(key);
}

pub inline fn setClipboardString(window: ?*Window, string: [*:0]const u8) void {
    return api.glfwSetClipboardString(window, string);
}
pub fn getClipboardString(window: ?*Window) ?[:0]const u8 {
    const string = api.glfwGetClipboardString(window);
    return std.mem.span(string);
}

pub inline fn getTime() f64 {
    return api.glfwGetTime();
}
pub inline fn setTime(time: f64) void {
    return api.glfwSetTime(time);
}
pub inline fn getTimerValue() u64 {
    return api.glfwGetTimerValue();
}
pub inline fn getTimerFrequency() u64 {
    return api.glfwGetTimerFrequency();
}

pub inline fn makeContextCurrent(window: ?*Window) void {
    return api.glfwMakeContextCurrent(window);
}
pub inline fn getCurrentContext() ?*Window {
    return api.glfwGetCurrentContext();
}

pub inline fn swapInterval(interval: Int) void {
    return api.glfwSwapInterval(interval);
}

pub fn isExtensionSupported(extension: [*:0]const u8) bool {
    return api.glfwExtensionSupported(extension).castTo();
}

pub inline fn getProcAddress(proccess_name: [*:0]const u8) ?glproc {
    return api.glfwGetProcAddress(proccess_name);
}
pub fn isVulkanSupported() bool {
    return api.glfwVulkanSupported().castTo();
}
pub fn getRequiredInstanceExtensions() ?[]const ?[*:0]const u8 {
    var count: u32 = undefined;
    const ptr = api.glfwGetRequiredInstanceExtensions(&count) orelse return null;
    if (count == 0) return null;
    return ptr[0 .. count];
}
