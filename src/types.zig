const std = @import("std");
const builtin = @import("builtin");


/// from [vulkan-zig](https://github.com/Snektron/vulkan-zig/tree/master)
pub const call_conv: std.builtin.CallingConvention = if (builtin.os.tag == .windows and builtin.cpu.arch == .x86)
    .winapi
else if (builtin.abi == .android and (builtin.cpu.arch.isArm() or builtin.cpu.arch.isThumb()) and std.Target.arm.featureSetHas(builtin.cpu.features, .has_v7) and builtin.cpu.arch.ptrBitWidth() == 32)
    .arm_aapcs_vfp
else
    .c;

/// there are several zig vulkan wrappers, and the their types are different (to the compiler)
pub const vk = if (@hasDecl(@import("root"), "vk")) @import("root").vk else struct {
    pub const PFN_vkGetInstanceProcAddr = *anyopaque;
    pub const Instance = ?*anyopaque;
    pub const PhysicalDevice = ?*anyopaque;
    pub const AllocationCallbacks = anyopaque;
    pub const SurfaceKHR = ?*anyopaque;
    pub const Result = enum(Int) { success = 0, _ };
};


const _ = {
    // `code_point` is a valid Unicode that can fit in `u21`, but glfw need a `c_uint`
    if (@sizeOf(u21) != @sizeOf(c_uint)) unreachable;
};

// `c_int` is not used in daily, so determite its size in comptime, normally it is 32-bit
pub const Int = @Int(.signed, 8 * @sizeOf(c_int));
pub const UInt = @Int(.unsigned, 8 * @sizeOf(c_int));


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
    _pad: @Int(.unsigned, @typeInfo(Int).int.bits - 8) = 0,
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
    pub const @" ": Key = .space;
    pub const @"'": Key = .apostrophe;
    pub const @",": Key = .comma;
    pub const @"-": Key = .minus;
    pub const @".": Key = .period;
    pub const @"/": Key = .slash;
    pub const @";": Key = .semicolon;
    pub const @"=": Key = .equal;
    pub const @"[": Key = .left_braket;
    pub const @"\\": Key = .backslash;
    pub const @"]": Key = .right_braket;
    pub const @"`": Key = .grave_accent;
};

pub const Modifier = packed struct(Int) {
    shift: bool = false,
    control: bool = false,
    alt: bool = false,
    super: bool = false,
    caps_lock: bool = false,
    num_lock: bool = false,
    _pad: @Int(.unsigned, @typeInfo(Int).int.bits - 6) = 0,
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
};

pub const Platform = enum(Int) {
    any     = 0x00060000,
    win32   = 0x00060001,
    cocoa   = 0x00060002,
    wayland = 0x00060003,
    x11     = 0x00060004,
    null    = 0x00060005,
    _,
};


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
    allocate: allocateCallback,
    reallocate: reallocateCallback,
    deallocate: deallocateCallback,
    user_data: ?*anyopaque,
};

pub const WindowHint = enum(Int) {
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
};

pub const WindowAttribute = enum(Int) {
    focused                     = @intFromEnum(WindowHint.focused),
    iconified                   = @intFromEnum(WindowHint.iconified),
    resizable                   = @intFromEnum(WindowHint.resizable),
    visible                     = @intFromEnum(WindowHint.visible),
    decorated                   = @intFromEnum(WindowHint.decorated),
    auto_iconify                = @intFromEnum(WindowHint.auto_iconify),
    floating                    = @intFromEnum(WindowHint.floating),
    maximized                   = @intFromEnum(WindowHint.maximized),
    transparent_framebuffer     = @intFromEnum(WindowHint.transparent_framebuffer),
    hovered                     = @intFromEnum(WindowHint.hovered),
    focus_on_show               = @intFromEnum(WindowHint.focus_on_show),
    mouse_passthrough           = @intFromEnum(WindowHint.mouse_passthrough),

    red_bits                    = @intFromEnum(WindowHint.red_bits),
    green_bits                  = @intFromEnum(WindowHint.green_bits),
    blue_bits                   = @intFromEnum(WindowHint.blue_bits),
    alpha_bits                  = @intFromEnum(WindowHint.alpha_bits),
    depth_bits                  = @intFromEnum(WindowHint.depth_bits),
    stencil_bits                = @intFromEnum(WindowHint.stencil_bits),
    samples                     = @intFromEnum(WindowHint.samples),
    doublebuffer                = @intFromEnum(WindowHint.doublebuffer),

    client_api                  = @intFromEnum(WindowHint.client_api),
    context_version_major       = @intFromEnum(WindowHint.context_version_major),
    context_version_minor       = @intFromEnum(WindowHint.context_version_minor),
    context_revision            = @intFromEnum(WindowHint.context_revision),
    context_robustness          = @intFromEnum(WindowHint.context_robustness),
    opengl_forward_compat       = @intFromEnum(WindowHint.opengl_forward_compat),
    opengl_context_debug        = @intFromEnum(WindowHint.opengl_context_debug),
    opengl_profile              = @intFromEnum(WindowHint.opengl_profile),
    context_release_behavior    = @intFromEnum(WindowHint.context_release_behavior),
    context_no_error            = @intFromEnum(WindowHint.context_no_error),
    context_creation_api        = @intFromEnum(WindowHint.context_creation_api),
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

pub const CursorShape = enum(Int) {
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

    pub const hresize: CursorShape = .resize_ew;
    pub const vresize: CursorShape = .resize_ns;
    pub const hand: CursorShape = .pointing_hand;
};

pub const CursorVisibility = enum(Int) {
    normal      = 0x00034001,
    hidden      = 0x00034002,
    disable     = 0x00034003,
    captured    = 0x00034004,
    _,
};

pub const JoystickHat = packed struct(u8) {
    up_bit: bool = false,
    right_bit: bool = false,
    down_bit: bool = false,
    left_bit: bool = false,
    _pad: u4 = 0,

    pub const centered: JoystickHat = .{};
    pub const up: JoystickHat = .{ .up_bit = true };
    pub const right: JoystickHat = .{ .right_bit = true };
    pub const down: JoystickHat = .{ .down_bit = true };
    pub const left: JoystickHat = .{ .left_bit = true };
    pub const right_up: JoystickHat = .{ .right_bit = true, .up_bit = true };
    pub const right_down: JoystickHat = .{ .right_bit = true, .down_bit = true };
};

pub const JoystickButton = enum(Int) {
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

    pub const last: JoystickButton = .@"16";
};

pub const GamepadButton = enum(Int) {
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

    pub const last: GamepadButton = .left;
    pub const cross: GamepadButton = .A;
    pub const circle: GamepadButton = .B;
    pub const square: GamepadButton = .X;
    pub const triangle: GamepadButton = .Y;
};

pub const GamepadAxis = enum(Int) {
    left_x = 0,
    left_y = 1,
    right_x = 2,
    right_y = 3,
    left_trigger = 4,
    right_trigger = 5,
    _,

    pub const last: GamepadAxis = .right_trigger;
};

pub const GamepadState = extern struct {
    buttons: [15]Action,
    axes: [6]f32,
};


pub const Monitor = opaque {};
pub const Window = opaque {};
pub const Cursor = opaque {};


pub const glproc = *const fn() callconv(call_conv) void;
pub const vkproc = *const fn() callconv(call_conv) void;

pub const monitorCallback = *const fn(monitor: *Monitor, event: Connection) callconv(call_conv) void;

pub const windowPosCallback = *const fn(window: *Window, pos_x: c_int, pos_y: c_int) callconv(call_conv) void;
pub const windowSizeCallback = *const fn(window: *Window, width: c_int, height: c_int) callconv(call_conv) void;
pub const windowCloseCallback = *const fn(window: *Window) callconv(call_conv) void;
pub const windowRefreshCallback = *const fn(window: *Window) callconv(call_conv) void;
pub const windowFocusCallback = *const fn(window: *Window, focused: Bool) callconv(call_conv) void;
pub const windowIconifyCallback = *const fn(window: *Window, iconify: Bool) callconv(call_conv) void;
pub const windowMaximizeCallback = *const fn(window: *Window, maximized: Bool) callconv(call_conv) void;
pub const windowContentScaleCallback = *const fn(window: *Window, scale_x: f32, scale_y: f32) callconv(call_conv) void;
pub const framebufferSizeCallback = *const fn(window: *Window, width: c_int, height: c_int) callconv(call_conv) void;
pub const mouseButtonCallback = *const fn(window: *Window, button: MouseButton, action: ActionPadded, mods: Modifier) callconv(call_conv) void;
pub const cursorPosCallback = *const fn(window: *Window, pos_x: f64, pos_y: f64) callconv(call_conv) void;
pub const cursorEnterCallback = *const fn(window: *Window, entered: Bool) callconv(call_conv) void;
pub const scrollCallback = *const fn(window: *Window, offset_x: f64, offset_y: f64) callconv(call_conv) void;
pub const keyCallback = *const fn(window: *Window, key: Key, scan_code: c_int, action: ActionPadded, mods: Modifier) callconv(call_conv) void;
pub const charCallback = *const fn(window: *Window, code_point: u21) callconv(call_conv) void;
pub const charModsCallback = *const fn(window: *Window, code_point: u21, mods: Modifier) callconv(call_conv) void;
pub const dropCallback = *const fn(window: *Window, path_count: c_int, paths: ?[*]const [*:0]const u8) callconv(call_conv) void;

pub const errorCallback = *const fn(error_code: ErrorCode, description: [*:0]const u8) callconv(call_conv) void;

pub const joystickCallback = *const fn(jid: c_int, event: Connection) callconv(call_conv) void;

pub const allocateCallback = *const fn(size: usize, user_data: ?*anyopaque) callconv(call_conv) ?*anyopaque;
pub const reallocateCallback = *const fn(block: ?*anyopaque, size: usize, user_data: ?*anyopaque) callconv(call_conv) ?*anyopaque;
pub const deallocateCallback = *const fn(block: ?*anyopaque, user_data: ?*anyopaque) callconv(call_conv) void;


pub const glfwInit = *const fn() callconv(call_conv) Bool;
pub const glfwTerminate = *const fn() callconv(call_conv) void;
pub const glfwInitHint = *const fn(hint: InitHint, value: Int) callconv(call_conv) Bool;
pub const glfwInitAllocator = *const fn(allocator: ?*const Allocator) callconv(call_conv) Bool;
pub const glfwInitVulkanLoader = *const fn(loader: ?vk.PFN_vkGetInstanceProcAddr) callconv(call_conv) Bool; // vk 1.0

pub const glfwGetVersion = *const fn(major: ?*Int, minor: ?*Int, revision: ?*Int) callconv(call_conv) void;
pub const glfwGetVersionString = *const fn() callconv(call_conv) ?[*:0]const u8;

pub const glfwGetError = *const fn(description: ?* ?[*:0]const u8) callconv(call_conv) ErrorCode;
pub const glfwSetErrorCallback = *const fn(cb: ?errorCallback) callconv(call_conv) ?errorCallback;

pub const glfwGetPlatform = *const fn() callconv(call_conv) Platform;
pub const glfwPlatformSupported = *const fn(platform: Platform) callconv(call_conv) Bool;

pub const glfwGetMonitors = *const fn(count: *Int) callconv(call_conv) ?[*] ?*Monitor;
pub const glfwGetPrimaryMonitor = *const fn() ?*Monitor;
pub const glfwGetMonitorPos = *const fn(monitor: *Monitor, pos_x: ?*Int, pos_y: ?*Int) callconv(call_conv) void;
pub const glfwGetMonitorWorkarea = *const fn(monitor: *Monitor, pos_x: ?*Int, pos_y: ?*Int, width: ?*Int, height: ?*Int) callconv(call_conv) void;
pub const glfwGetMonitorPhysicalSize = *const fn(monitor: *Monitor, width_mm: ?*Int, height_mm: ?*Int) callconv(call_conv) void;
pub const glfwGetMonitorContentScale = *const fn(monitor: *Monitor, scale_x: ?*f32, scale_y: ?*f32) callconv(call_conv) void;
pub const glfwGetMonitorName = *const fn(monitor: *Monitor) callconv(call_conv) ?[*:0]const u8;
pub const glfwSetMonitorUserPointer = *const fn(monitor: *Monitor, user_data: ?*anyopaque) callconv(call_conv) void;
pub const glfwGetMonitorUserPointer = *const fn(monitor: *Monitor) callconv(call_conv) ?*anyopaque;
pub const glfwSetMonitorCallback = *const fn(cb: ?monitorCallback) callconv(call_conv) ?monitorCallback;
pub const glfwGetVideoModes = *const fn(monitor: *Monitor, count: *Int) callconv(call_conv) ?[*]const VideoMode;
pub const glfwGetVideoMode = *const fn(monitor: *Monitor) callconv(call_conv) ?*const VideoMode;
pub const glfwSetGamma = *const fn(monitor: *Monitor, gamma: f32) callconv(call_conv) void;
pub const glfwGetGammaRamp = *const fn(monitor: *Monitor) callconv(call_conv) ?*const GammaRamp;
pub const glfwSetGammaRamp = *const fn(monitor: *Monitor, ramp: *const GammaRamp) callconv(call_conv) void;

pub const glfwDefaultWindowHints = *const fn() callconv(call_conv) void;
pub const glfwWindowHint = *const fn(hint: WindowHint, value: Int) callconv(call_conv) void;
pub const glfwWindowHintString = *const fn(hint: WindowHint, value: [*:0]const u8) callconv(call_conv) void;
pub const glfwCreateWindow = *const fn(width: Int, height: Int, title: [*:0]const u8, monitor: ?*Monitor, share: ?*Window) callconv(call_conv) ?*Window;
pub const glfwDestroyWindow = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwWindowShouldClose = *const fn(window: *Window) callconv(call_conv) Bool;
pub const glfwSetWindowShouldClose = *const fn(window: *Window, value: Bool) callconv(call_conv) void;
pub const glfwGetWindowTitle = *const fn(window: *Window) callconv(call_conv) ?[*:0]const u8;
pub const glfwSetWindowTitle = *const fn(window: *Window, title: [*:0]const u8) callconv(call_conv) void;
pub const glfwSetWindowIcon = *const fn(window: *Window, count: Int, images: ?[*]const Image) void;
pub const glfwGetWindowPos = *const fn(window: *Window, pos_x: ?*Int, pos_y: ?*Int) callconv(call_conv) void;
pub const glfwSetWindowPos = *const fn(window: *Window, pos_x: Int, pos_y: Int) callconv(call_conv) void;
pub const glfwGetWindowSize = *const fn(window: *Window, width: ?*Int, height: ?*Int) callconv(call_conv) void;
pub const glfwSetWindowSizeLimits = *const fn(window: *Window, min_width: Int, min_height: Int, max_width: Int, max_height: Int) callconv(call_conv) void;
pub const glfwSetWindowAspectRatio = *const fn(window: *Window, numerator: Int, denominator: Int) callconv(call_conv) void;
pub const glfwSetWindowSize = *const fn(window: *Window, width: Int, height: Int) callconv(call_conv) void;
pub const glfwGetFramebufferSize = *const fn(window: *Window, width: ?*Int, height: ?*Int) callconv(call_conv) void;
pub const glfwGetWindowFrameSize = *const fn(window: *Window, left: ?*Int, top: ?*Int, right: ?*Int, bottom: ?*Int) callconv(call_conv) void;
pub const glfwGetWindowContentScale = *const fn(window: *Window, scale_x: ?*f32, scale_y: ?*f32) callconv(call_conv) void;
pub const glfwGetWindowOpacity = *const fn(window: *Window) f32;
pub const glfwSetWindowOpacity = *const fn(window: *Window, opacity: f32) callconv(call_conv) void;
pub const glfwIconifyWindow = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwRestoreWindow = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwMaximizeWindow = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwShowWindow = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwHideWindow = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwFocusWindow = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwRequestWindowAttention = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwGetWindowMonitor = *const fn(window: *Window) ?*Monitor;
pub const glfwSetWindowMonitor = *const fn(window: *Window, monitor: ?*Monitor, pos_x: Int, pos_y: Int, width: Int, height: Int, refresh_rate: Int) callconv(call_conv) void;
pub const glfwGetWindowAttrib = *const fn(window: *Window, attrib: WindowAttribute) callconv(call_conv) Int;
pub const glfwSetWindowAttrib = *const fn(window: *Window, attrib: WindowAttribute, value: Int) callconv(call_conv) void;
pub const glfwSetWindowUserPointer = *const fn(window: *Window, user_data: ?*anyopaque) callconv(call_conv) void;
pub const glfwGetWindowUserPointer = *const fn(window: *Window) callconv(call_conv) ?*anyopaque;
pub const glfwSetWindowPosCallback = *const fn(window: *Window, cb: ?windowPosCallback) callconv(call_conv) ?windowPosCallback;
pub const glfwSetWindowSizeCallback = *const fn(window: *Window, cb: ?windowSizeCallback) callconv(call_conv) ?windowSizeCallback;
pub const glfwSetWindowCloseCallback = *const fn(window: *Window, cb: ?windowCloseCallback) callconv(call_conv) ?windowCloseCallback;
pub const glfwSetWindowRefreshCallback = *const fn(window: *Window, cb: ?windowRefreshCallback) callconv(call_conv) ?windowRefreshCallback;
pub const glfwSetWindowFocusCallback = *const fn(window: *Window, cb: ?windowFocusCallback) callconv(call_conv) ?windowFocusCallback;
pub const glfwSetWindowIconifyCallback = *const fn(window: *Window, cb: ?windowIconifyCallback) callconv(call_conv) ?windowIconifyCallback;
pub const glfwSetWindowMaximizeCallback = *const fn(window: *Window, cb: ?windowMaximizeCallback) callconv(call_conv) ?windowMaximizeCallback;
pub const glfwSetFramebufferSizeCallback = *const fn(window: *Window, cb: ?framebufferSizeCallback) callconv(call_conv) ?framebufferSizeCallback;
pub const glfwSetWindowContentScaleCallback = *const fn(window: *Window, cb: ?windowContentScaleCallback) callconv(call_conv) ?windowContentScaleCallback;
pub const glfwGetInputMode = *const fn(window: *Window, mode: InputMode) callconv(call_conv) Int;
pub const glfwSetInputMode = *const fn(window: *Window, mode: InputMode, value: Int) callconv(call_conv) void;
pub const glfwGetKey = *const fn(window: *Window, key: Key) callconv(call_conv) ActionPadded;
pub const glfwGetMouseButton = *const fn(window: *Window, button: MouseButton) callconv(call_conv) ActionPadded;
pub const glfwGetCursorPos = *const fn(window: *Window, pos_x: ?*f64, pos_y: ?*f64) callconv(call_conv) void;
pub const glfwSetCursorPos = *const fn(window: *Window, pos_x: f64, pos_y: f64) callconv(call_conv) void;
pub const glfwSetCursor = *const fn(window: *Window, cursor: ?*Cursor) callconv(call_conv) void;
pub const glfwSetKeyCallback = *const fn(window: *Window, cb: ?keyCallback) callconv(call_conv) ?keyCallback;
pub const glfwSetCharCallback = *const fn(window: *Window, cb: ?charCallback) callconv(call_conv) ?charCallback;
pub const glfwSetCharModsCallback = *const fn(window: *Window, cb: ?charModsCallback) callconv(call_conv) ?charModsCallback;
pub const glfwSetMouseButtonCallback = *const fn(window: *Window, cb: ?mouseButtonCallback) callconv(call_conv) ?mouseButtonCallback;
pub const glfwSetCursorPosCallback = *const fn(window: *Window, cb: ?cursorPosCallback) callconv(call_conv) ?cursorPosCallback;
pub const glfwSetCursorEnterCallback = *const fn(window: *Window, cb: ?cursorEnterCallback) callconv(call_conv) ?cursorEnterCallback;
pub const glfwSetScrollCallback = *const fn(window: *Window, cb: ?scrollCallback) callconv(call_conv) ?scrollCallback;
pub const glfwSetDropCallback = *const fn(window: *Window, cb: ?dropCallback) callconv(call_conv) ?dropCallback;

pub const glfwPollEvents = *const fn() callconv(call_conv) void;
pub const glfwWaitEvents = *const fn() callconv(call_conv) void;
pub const glfwWaitEventsTimeout = *const fn(timeout: f64) callconv(call_conv) void;
pub const glfwPostEmptyEvent = *const fn() callconv(call_conv) void;

pub const glfwRawMouseMotionSupported = *const fn() callconv(call_conv) Bool;

pub const glfwGetKeyName = *const fn(key: Key, scancode: Int) callconv(call_conv) ?[*:0]const u8;
pub const glfwGetKeyScancode = *const fn(key: Key) callconv(call_conv) Int;

pub const glfwCreateCursor = *const fn(image: *const Image, hotspot_x: Int, hotspot_y: Int) callconv(call_conv) ?*Cursor;
pub const glfwCreateStandardCursor = *const fn(shape: CursorShape) callconv(call_conv) ?*Cursor;
pub const glfwDestroyCursor = *const fn(cursor: *Cursor) callconv(call_conv) void;

pub const glfwJoystickPresent = *const fn(jid: Int) Bool;
pub const glfwGetJoystickAxes = *const fn(jid: Int, count: *Int) callconv(call_conv) ?[*]const f32;
pub const glfwGetJoystickButtons = *const fn(jid: Int, count: *Int) callconv(call_conv) ?[*]const Action;
pub const glfwGetJoystickHats = *const fn(jid: Int, count: *Int) callconv(call_conv) ?[*]const JoystickHat;
pub const glfwGetJoystickName = *const fn(jid: Int) callconv(call_conv) ?[*:0]const u8;
pub const glfwGetJoystickGUID = *const fn(jid: Int) callconv(call_conv) ?[*:0]const u8;
pub const glfwSetJoystickUserPointer = *const fn(jid: Int, user_data: ?*anyopaque) callconv(call_conv) void;
pub const glfwGetJoystickUserPointer = *const fn(jid: Int) callconv(call_conv) ?*anyopaque;
pub const glfwJoystickIsGamepad = *const fn(jid: Int) callconv(call_conv) Bool;
pub const glfwSetJoystickCallback = *const fn(cb: ?joystickCallback) callconv(call_conv) ?joystickCallback;
pub const glfwUpdateGamepadMappings = *const fn(string: [*:0]const u8) callconv(call_conv) Bool;
pub const glfwGetGamepadName = *const fn(jid: Int) callconv(call_conv) ?[*:0]const u8;
pub const glfwGetGamepadState = *const fn(jid: Int, state: *GamepadState) callconv(call_conv) Bool;

pub const glfwSetClipboardString = *const fn(window: ?*Window, string: [*:0]const u8) callconv(call_conv) void;
pub const glfwGetClipboardString = *const fn(window: ?*Window) callconv(call_conv) ?[*:0]const u8;

pub const glfwGetTime = *const fn() callconv(call_conv) f64;
pub const glfwSetTime = *const fn(time: f64) callconv(call_conv) void;
pub const glfwGetTimerValue = *const fn() callconv(call_conv) u64;
pub const glfwGetTimerFrequency = *const fn() callconv(call_conv) u64;

pub const glfwMakeContextCurrent = *const fn(window: ?*Window) callconv(call_conv) void;
pub const glfwGetCurrentContext = *const fn() callconv(call_conv) ?*Window;

pub const glfwSwapBuffers = *const fn(window: *Window) callconv(call_conv) void;
pub const glfwSwapInterval = *const fn(interval: Int) callconv(call_conv) void;

pub const glfwExtensionSupported = *const fn(extension: [*:0]const u8) callconv(call_conv) Bool;

pub const glfwGetProcAddress = *const fn(proccess_name: [*:0]const u8) callconv(call_conv) ?glproc;
pub const glfwVulkanSupported = *const fn() callconv(call_conv) Bool;
pub const glfwGetRequiredInstanceExtensions = *const fn(count: *u32) callconv(call_conv) ?[*]const ?[*:0]const u8;
pub const glfwGetInstanceProcAddress = *const fn(instance: vk.Instance, proccess_name: [*:0]const u8) callconv(call_conv) ?vkproc; // vk 1.0
pub const glfwGetPhysicalDevicePresentationSupport = *const fn(instance: vk.Instance, device: vk.PhysicalDevice, queue_family: u32) callconv(call_conv) Bool; // vk 1.0
pub const glfwCreateWindowSurface = *const fn(instance: vk.Instance, window: *Window, vk_alloc_cb: ?*const vk.AllocationCallbacks, out_surface: *vk.SurfaceKHR) callconv(call_conv) vk.Result; // vk 1.0
