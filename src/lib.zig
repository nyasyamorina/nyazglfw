const build_options = @import("build_options");
const std = @import("std");

const DynamicDispatch = @import("DynamicDispatch.zig");

pub const types = @import("types.zig");
pub const api = if (build_options.dynamic) DynamicDispatch.warpper else @import("StaticDispatch.zig");


pub const LoadError = if (build_options.dynamic) api.LoadError else error {};
pub inline fn load(lib_path: []const u8) LoadError!void {
    if (build_options.dynamic) return api.load(lib_path);
}
pub inline fn loadZ(lib_path: [*:0]const u8) LoadError!void {
    if (build_options.dynamic) return api.loadZ(lib_path);
}
pub inline fn unload() void {
    if (build_options.dynamic) return api.unload();
}

pub fn loadEx(ctx: ?*anyopaque, lookup: DynamicDispatch.warpper.lookupFn) DynamicDispatch.warpper.LoadExError!void {
    if (build_options.dynamic) return api.loadEx(ctx, lookup);
}
pub fn unloadEx() void {
    if (build_options.dynamic) return api.unloadEx();
}


pub const version = struct {
    pub const major = 3;
    pub const minor = 4;
    pub const revision = 0;
};

pub const Bool = types.Bool;
pub const Action = types.Action;
pub const ActionPadded = types.ActionPadded;
pub const Key = types.Key;
pub const Modifier = types.Modifier;
pub const MouseButton = types.MouseButton;
pub const ErrorCode = types.ErrorCode;
pub const ClientApi = types.ClientApi;
pub const ContextRobustness = types.ContextRobustness;
pub const OpenglProfile = types.OpenglProfile;
pub const ContextReleaseBehavior = types.ContextReleaseBehavior;
pub const ContextCreationApi = types.ContextCreationApi;
pub const AnglePlatformType = types.AnglePlatformType;
pub const WaylandLibdecor = types.WaylandLibdecor;
pub const Position = types.Position;
pub const Connection = types.Connection;

pub const InitHint = enum(types.Int) {
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

pub const Platform = enum(types.Int) {
    any     = 0x00060000,
    win32   = 0x00060001,
    cocoa   = 0x00060002,
    wayland = 0x00060003,
    x11     = 0x00060004,
    null    = 0x00060005,
    _,

    pub inline fn get() Platform {
        return @enumFromInt(@intFromEnum(api.glfwGetPlatform()));
    }

    pub fn isSupported(self: Platform) bool {
        return api.glfwPlatformSupported(@enumFromInt(@intFromEnum(self))).castTo();
    }
};

pub const dont_care = -1;


pub const VideoMode = types.VideoMode;
pub const GammaRamp = types.GammaRamp;
pub const Image = types.Image;
pub const Allocator = types.Allocator;


pub const GetErrorResult = struct {
    code: ErrorCode,
    description: ?[:0]const u8,
};
pub const Pos = extern struct {
    x: types.Int,
    y: types.Int,
};
pub const Size = extern struct {
    width: types.Int,
    height: types.Int,
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
    left: types.Int,
    top: types.Int,
    right: types.Int,
    bottom: types.Int,
};
pub const BitDepths = extern struct {
    red: types.Int,
    green: types.Int,
    blue: types.Int,
    alpha: types.Int,
    depth: types.Int,
    stencil: types.Int,
};


pub const Version = struct {
    major: types.Int,
    minor: types.Int,
    revision: types.Int,

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
        var count: types.Int = undefined;
        const ptr = api.glfwGetMonitors(&count) orelse return null;
        if (count == 0) return null;
        return @as([*]?*Monitor, @ptrCast(ptr))[0 .. count];
    }
    pub inline fn getPrimary() ?*Monitor {
        return @ptrCast(api.glfwGetPrimaryMonitor());
    }

    pub inline fn setCallback(cb: ?types.monitorCallback) ?types.monitorCallback {
        return api.glfwSetMonitorCallback(cb);
    }

    pub fn getPos(self: *Monitor) Pos {
        var pos: Pos = undefined;
        api.glfwGetMonitorPos(@ptrCast(self), &pos.x, &pos.y);
        return pos;
    }
    pub fn getWorkarea(self: *Monitor) Area {
        var area: Area = undefined;
        api.glfwGetMonitorWorkarea(@ptrCast(self), &area.pos.x, &area.pos.y, &area.size.width, &area.size.height);
        return area;
    }
    /// size in millimeter
    pub fn getPhysicalSize(self: *Monitor) Size {
        var size: Size = undefined;
        api.glfwGetMonitorPhysicalSize(@ptrCast(self), &size.width, &size.height);
        return size;
    }
    pub fn getContentScale(self: *Monitor) Scale {
        var scale: Scale = undefined;
        api.glfwGetMonitorContentScale(@ptrCast(self), &scale.x, &scale.y);
        return scale;
    }

    pub inline fn getName(self: *Monitor) ?[*:0]const u8 {
        return api.glfwGetMonitorName(@ptrCast(self));
    }

    pub inline fn setUserPointer(self: *Monitor, user_data: ?*anyopaque) void {
        return api.glfwSetMonitorUserPointer(@ptrCast(self), user_data);
    }
    pub inline fn getUserPointer(self: *Monitor) ?*anyopaque {
        return api.glfwGetMonitorUserPointer(@ptrCast(self));
    }

    pub fn getVideoMods(self: *Monitor) ?[]const VideoMode {
        var count: types.Int = undefined;
        const ptr = api.glfwGetVideoModes(@ptrCast(self), &count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }
    pub inline fn getVideoMod(self: *Monitor) ?*const VideoMode {
        return api.glfwGetVideoMode(@ptrCast(self));
    }

    pub inline fn setGamma(self: *Monitor, gamma: f32) void {
        return api.glfwSetGamma(@ptrCast(self), gamma);
    }
    pub inline fn setGammaRamp(self: *Monitor, ramp: GammaRamp) void {
        return api.glfwSetGammaRamp(@ptrCast(self), &ramp);
    }
    pub inline fn getGammaRamp(self: *Monitor) ?*const GammaRamp {
        return api.glfwGetGammaRamp(@ptrCast(self));
    }
};

pub const Window = opaque {
    pub const Hint = enum(types.Int) {
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

        pub fn ValueType(comptime hint: Hint) type {
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
                => types.Int,

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
                else => @compileError("not specity the value type of window hint " ++ @tagName(hint) ++ ", call api function directy instead")
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
            pub fn position(x: ?types.Int, y: ?types.Int) void {
                if (x) |x_| api.glfwWindowHint(.position_x, x_);
                if (y) |y_| api.glfwWindowHint(Hint.position_y, y_);
            }

            pub fn bitDepths(red: ?types.Int, green: ?types.Int, blue: ?types.Int, alpha: ?types.Int, depth: ?types.Int, stencil: ?types.Int) void {
                if (red)     |r| api.glfwWindowHint(.red_bits, r);
                if (green)   |g| api.glfwWindowHint(.green_bits, g);
                if (blue)    |b| api.glfwWindowHint(.blue_bits, b);
                if (alpha)   |a| api.glfwWindowHint(.alpha_bits, a);
                if (depth)   |d| api.glfwWindowHint(.depth_bits, d);
                if (stencil) |s| api.glfwWindowHint(.stencil_bits, s);
            }
            pub fn accumulationBitDepths(red: ?types.Int, green: ?types.Int, blue: ?types.Int, alpha: ?types.Int) void {
                if (red)     |r| api.glfwWindowHint(.accum_red_bits, r);
                if (green)   |g| api.glfwWindowHint(.accum_green_bits, g);
                if (blue)    |b| api.glfwWindowHint(.accum_blue_bits, b);
                if (alpha)   |a| api.glfwWindowHint(.accum_alpha_bits, a);
            }
            pub inline fn auxBuffers(count: types.Int) void {
                return api.glfwWindowHint(.aux_buffers, count);
            }
            pub inline fn stereo(value: bool) void {
                return api.glfwWindowHint(.stereo, @intFromBool(value));
            }
            pub inline fn samples(count: types.Int) void {
                return api.glfwWindowHint(.samples, count);
            }
            pub inline fn srgbCapable(value: bool) void {
                return api.glfwWindowHint(.srgb_capable, @intFromBool(value));
            }
            pub inline fn refreshRate(count: types.Int) void {
                return api.glfwWindowHint(.refresh_rate, count);
            }
            pub inline fn doublebuffer(value: bool) void {
                return api.glfwWindowHint(.doublebuffer, @intFromBool(value));
            }

            pub inline fn clientApi(value: ClientApi) void {
                return api.glfwWindowHint(.client_api, @intFromEnum(value));
            }
            pub fn contextVersion(major: ?types.Int, minor: ?types.Int, revision: ?types.Int) void {
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

    pub const Attribute = enum(types.Int) {
        focused                     = @intFromEnum(Window.Hint.focused),
        iconified                   = @intFromEnum(Window.Hint.iconified),
        resizable                   = @intFromEnum(Window.Hint.resizable),
        visible                     = @intFromEnum(Window.Hint.visible),
        decorated                   = @intFromEnum(Window.Hint.decorated),
        auto_iconify                = @intFromEnum(Window.Hint.auto_iconify),
        floating                    = @intFromEnum(Window.Hint.floating),
        maximized                   = @intFromEnum(Window.Hint.maximized),
        transparent_framebuffer     = @intFromEnum(Window.Hint.transparent_framebuffer),
        hovered                     = @intFromEnum(Window.Hint.hovered),
        focus_on_show               = @intFromEnum(Window.Hint.focus_on_show),
        mouse_passthrough           = @intFromEnum(Window.Hint.mouse_passthrough),

        red_bits                    = @intFromEnum(Window.Hint.red_bits),
        green_bits                  = @intFromEnum(Window.Hint.green_bits),
        blue_bits                   = @intFromEnum(Window.Hint.blue_bits),
        alpha_bits                  = @intFromEnum(Window.Hint.alpha_bits),
        depth_bits                  = @intFromEnum(Window.Hint.depth_bits),
        stencil_bits                = @intFromEnum(Window.Hint.stencil_bits),
        samples                     = @intFromEnum(Window.Hint.samples),
        doublebuffer                = @intFromEnum(Window.Hint.doublebuffer),

        client_api                  = @intFromEnum(Window.Hint.client_api),
        context_version_major       = @intFromEnum(Window.Hint.context_version_major),
        context_version_minor       = @intFromEnum(Window.Hint.context_version_minor),
        context_revision            = @intFromEnum(Window.Hint.context_revision),
        context_robustness          = @intFromEnum(Window.Hint.context_robustness),
        opengl_forward_compat       = @intFromEnum(Window.Hint.opengl_forward_compat),
        opengl_context_debug        = @intFromEnum(Window.Hint.opengl_context_debug),
        opengl_profile              = @intFromEnum(Window.Hint.opengl_profile),
        context_release_behavior    = @intFromEnum(Window.Hint.context_release_behavior),
        context_no_error            = @intFromEnum(Window.Hint.context_no_error),
        context_creation_api        = @intFromEnum(Window.Hint.context_creation_api),
        _,

        pub fn ValueType(comptime attrib: Attribute) type {
            return Hint.ValueType(@enumFromInt(@intFromEnum(attrib)));
        }

        pub const get = struct {
            pub fn focused(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .focused));
                return b.castTo();
            }
            pub fn iconified(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .iconified));
                return b.castTo();
            }
            pub fn resizable(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .resizable));
                return b.castTo();
            }
            pub fn visible(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .visible));
                return b.castTo();
            }
            pub fn decorated(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .decorated));
                return b.castTo();
            }
            pub fn autoIconify(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .auto_iconify));
                return b.castTo();
            }
            pub fn floating(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .floating));
                return b.castTo();
            }
            pub fn maximized(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .maximized));
                return b.castTo();
            }
            pub fn transparentFramebuffer(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .transparent_framebuffer));
                return b.castTo();
            }
            pub fn hovered(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .hovered));
                return b.castTo();
            }
            pub fn focusOnShow(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .focus_on_show));
                return b.castTo();
            }
            pub fn mousePassthrough(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .mouse_passthrough));
                return b.castTo();
            }

            pub fn bitDepths(window: *Window) BitDepths {
                var bit_depths: BitDepths = undefined;
                bit_depths.red     = api.glfwGetWindowAttrib(@ptrCast(window), .red_bits);
                bit_depths.green   = api.glfwGetWindowAttrib(@ptrCast(window), .green_bits);
                bit_depths.blue    = api.glfwGetWindowAttrib(@ptrCast(window), .blue_bits);
                bit_depths.alpha   = api.glfwGetWindowAttrib(@ptrCast(window), .alpha_bits);
                bit_depths.depth   = api.glfwGetWindowAttrib(@ptrCast(window), .depth_bits);
                bit_depths.stencil = api.glfwGetWindowAttrib(@ptrCast(window), .stencil_bits);
                return bit_depths;
            }
            pub inline fn samples(window: *Window) types.Int {
                return api.glfwGetWindowAttrib(@ptrCast(window), .samples);
            }
            pub fn doublebuffer(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .doublebuffer));
                return b.castTo();
            }

            pub inline fn clientApi(window: *Window) ClientApi {
                return @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .client_api));
            }
            pub fn contextVersion(window: *Window) Version {
                var v: Version = undefined;
                v.major = api.glfwGetWindowAttrib(@ptrCast(window), .context_version_major);
                v.minor = api.glfwGetWindowAttrib(@ptrCast(window), .context_version_minor);
                v.revision = api.glfwGetWindowAttrib(@ptrCast(window), .context_revision);
                return v;
            }
            pub inline fn contextRobustness(window: *Window) ContextRobustness {
                return @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .context_robustness));
            }
            pub fn openglForwardCompat(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .opengl_forward_compat));
                return b.castTo();
            }
            pub fn openglContextDebug(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .opengl_context_debug));
                return b.castTo();
            }
            pub inline fn openglProfile(window: *Window) OpenglProfile {
                return @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .opengl_profile));
            }
            pub inline fn contextReleaseBehavior(window: *Window) ContextReleaseBehavior {
                return @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .context_release_behavior));
            }
            pub fn contextNoError(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .context_no_error));
                return b.castTo();
            }
            pub inline fn contextCreationApi(window: *Window) ContextCreationApi {
                return @enumFromInt(api.glfwGetWindowAttrib(@ptrCast(window), .context_creation_api));
            }
        };

        pub const set = struct {
            pub inline fn resizable(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(@ptrCast(window), .resizable, @intFromBool(value));
            }
            pub inline fn decorated(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(@ptrCast(window), .decorated, @intFromBool(value));
            }
            pub inline fn autoIconify(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(@ptrCast(window), .auto_iconify, @intFromBool(value));
            }
            pub inline fn floating(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(@ptrCast(window), .floating, @intFromBool(value));
            }
            pub inline fn focusOnShow(window: *Window, value: bool) void {
                return api.glfwSetWindowAttrib(@ptrCast(window), .focus_on_show, @intFromBool(value));
            }
        };
    };

    pub const InputMode = enum(types.Int) {
        cursor                  = 0x00033001,
        sticky_keys             = 0x00033002,
        sticky_mouse_buttons    = 0x00033003,
        lock_key_mods           = 0x00033004,
        raw_mouse_motion        = 0x00033005,
        _,

        pub fn ValueType(comptime mode: InputMode) type {
            return switch (mode) {
                .sticky_keys,
                .sticky_mouse_buttons,
                .lock_key_mods,
                .raw_mouse_motion,
                => bool,

                .cursor => Cursor.Visibility,
                else => @compileError("not specity the value type of input mode " ++ @tagName(mode) ++ ", call api function directy instead")
            };
        }

        pub const get = struct {
            pub inline fn cursor(window: *Window) Cursor.Visibility {
                return @enumFromInt(api.glfwGetInputMode(@ptrCast(window), .cursor));
            }
            pub fn stickyKeys(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetInputMode(@ptrCast(window), .sticky_keys));
                return b.castTo();
            }
            pub fn stickyMouseButtons(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetInputMode(@ptrCast(window), .sticky_mouse_buttons));
                return b.castTo();
            }
            pub fn lockKeyMods(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetInputMode(@ptrCast(window), .lock_key_mods));
                return b.castTo();
            }
            pub fn rawMouseMotion(window: *Window) bool {
                const b: Bool = @enumFromInt(api.glfwGetInputMode(@ptrCast(window), .raw_mouse_motion));
                return b.castTo();
            }
        };

        pub const set = struct {
            pub inline fn cursor(window: *Window, value: Cursor.Visibility) void {
                return api.glfwSetInputMode(@ptrCast(window), .cursor, @intFromEnum(value));
            }
            pub inline fn stickyKeys(window: *Window, value: bool) void {
                return api.glfwSetInputMode(@ptrCast(window), .sticky_keys, @intFromBool(value));
            }
            pub inline fn stickyMouseButtons(window: *Window, value: bool) void {
                return api.glfwSetInputMode(@ptrCast(window), .sticky_mouse_buttons, @intFromBool(value));
            }
            pub inline fn lockKeyMods(window: *Window, value: bool) void {
                return api.glfwSetInputMode(@ptrCast(window), .lock_key_mods, @intFromBool(value));
            }
            pub inline fn rawMouseMotion(window: *Window, value: bool) void {
                return api.glfwSetInputMode(@ptrCast(window), .raw_mouse_motion, @intFromBool(value));
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

    pub fn getInputMode(self: *Window, comptime mode: InputMode) InputMode.ValueType(mode) {
        switch (mode) {
            .cursor => return InputMode.get.cursor(self),
            .sticky_keys => return InputMode.get.stickyKeys(self),
            .sticky_mouse_buttons => return InputMode.get.stickyMouseButtons(self),
            .lock_key_mods => return InputMode.get.lockKeyMods(self),
            .raw_mouse_motion => return InputMode.get.rawMouseMotion(self),
            inline else => @compileError("should use `api.glfwGetInputMode(window, mode)` to get this input mode"),
        }
    }
    pub fn setInputMode(self: *Window, comptime mode: InputMode, value: InputMode.ValueType(mode)) void {
        switch (mode) {
            .cursor => InputMode.set.cursor(self, value),
            .sticky_keys => InputMode.set.stickyKeys(self, value),
            .sticky_mouse_buttons => InputMode.set.stickyMouseButtons(self, value),
            .lock_key_mods => InputMode.set.lockKeyMods(self, value),
            .raw_mouse_motion => InputMode.set.rawMouseMotion(self, value),
            inline else => @compileError("should use `api.glfwSetInputMode(window, mode)` to set this input mode"),
        }
    }

    pub inline fn create(size: Size, title: [*:0]const u8, monitor: ?*Monitor, share: ?*Window) ?*Window {
        return @ptrCast(api.glfwCreateWindow(size.width, size.height, title, @ptrCast(monitor), @ptrCast(share)));
    }
    pub inline fn destroy(self: *Window) void {
        return api.glfwDestroyWindow(@ptrCast(self));
    }

    pub fn shouldClose(self: *Window) bool {
        return api.glfwWindowShouldClose(@ptrCast(self)).castTo();
    }
    pub inline fn setShouldClose(self: *Window, value: bool) void {
        return api.glfwSetWindowShouldClose(@ptrCast(self), @enumFromInt(@intFromBool(value)));
    }

    /// i.e. minimize
    pub inline fn iconify(self: *Window) void {
        return api.glfwIconifyWindow(@ptrCast(self));
    }
    pub inline fn restore(self: *Window) void {
        return api.glfwRestoreWindow(@ptrCast(self));
    }
    pub inline fn maximize(self: *Window) void {
        return api.glfwMaximizeWindow(@ptrCast(self));
    }
    pub inline fn show(self: *Window) void {
        return api.glfwShowWindow(@ptrCast(self));
    }
    pub inline fn hide(self: *Window) void {
        return api.glfwHideWindow(@ptrCast(self));
    }
    pub inline fn focus(self: *Window) void {
        return api.glfwFocusWindow(@ptrCast(self));
    }
    pub inline fn requestAttention(self: *Window) void {
        return api.glfwRequestWindowAttention(@ptrCast(self));
    }

    pub fn getFramebufferSize(self: *Window) Size {
        var size: Size = undefined;
        api.glfwGetFramebufferSize(@ptrCast(self), &size.width, &size.height);
        return size;
    }
    pub fn getFrameSize(self: *Window) FrameSize {
        var frame_size: FrameSize = undefined;
        api.glfwGetWindowFrameSize(@ptrCast(self), &frame_size.left, &frame_size.top, &frame_size.right, &frame_size.bottom);
        return frame_size;
    }
    pub fn getContentScale(self: *Window) Scale {
        var scale: Scale = undefined;
        api.glfwGetWindowContentScale(@ptrCast(self), &scale.x, &scale.y);
        return scale;
    }
    pub fn getKey(self: *Window, key: Key) Action {
        return @enumFromInt(@intFromEnum(api.glfwGetKey(@ptrCast(self), key).action));
    }
    pub fn getMouseButton(self: *Window, button: MouseButton) Action {
        return @enumFromInt(@intFromEnum(api.glfwGetMouseButton(@ptrCast(self), button).action));
    }

    pub fn setIcon(self: *Window, images: []const Image) void {
        return api.glfwSetWindowIcon(@ptrCast(self), @intCast(images.len), images.ptr);
    }
    pub inline fn setCursor(self: *Window, cursor: ?*Cursor) void {
        return api.glfwSetCursor(@ptrCast(self), @ptrCast(cursor));
    }

    pub inline fn getTitle(self: *Window) ?[*:0]const u8 {
        return api.glfwGetWindowTitle(@ptrCast(self));
    }
    pub inline fn setTitle(self: *Window, title: [*:0]const u8) void {
        return api.glfwSetWindowTitle(@ptrCast(self), title);
    }

    pub fn getPos(self: *Window) Pos {
        var pos: Pos = undefined;
        api.glfwGetWindowPos(@ptrCast(self), &pos.x, &pos.y);
        return pos;
    }
    pub inline fn setPos(self: *Window, pos: Pos) void {
        return api.glfwSetWindowPos(@ptrCast(self), pos.x, pos.y);
    }

    pub inline fn getOpacity(self: *Window) f32 {
        return api.glfwGetWindowOpacity(@ptrCast(self));
    }
    pub inline fn setOpacity(self: *Window, opacity: f32) void {
        return api.glfwSetWindowOpacity(@ptrCast(self), opacity);
    }

    pub fn getSize(self: *Window) Size {
        var size: Size = undefined;
        api.glfwGetWindowSize(@ptrCast(self), &size.width, &size.height);
        return size;
    }
    pub inline fn setSize(self: *Window, size: Size) void {
        return api.glfwSetWindowSize(@ptrCast(self), size.width, size.height);
    }
    pub inline fn setSizeLimits(self: *Window, min: Size, max: Size) void {
        return api.glfwSetWindowSizeLimits(@ptrCast(self), min.width, min.height, max.width, max.height);
    }
    pub inline fn setAspectRatio(self: *Window, numerator: ?types.Int, denominator: ?types.Int) void {
        return api.glfwSetWindowAspectRatio(@ptrCast(self), numerator orelse dont_care, denominator orelse dont_care);
    }

    pub inline fn getMonitor(self: *Window) ?*Monitor {
        return @ptrCast(api.glfwGetWindowMonitor(@ptrCast(self)));
    }
    pub inline fn setMonitor(self: *Window, monitor: ?*Monitor, pos: Pos, size: Size, refresh_rate: ?types.Int) void {
        return api.glfwSetWindowMonitor(@ptrCast(self), @ptrCast(monitor), pos.x, pos.y, size.width, size.height, refresh_rate orelse dont_care);
    }

    pub fn getCursorPos(self: *Window) Cursor.Pos {
        var pos: Cursor.Pos = undefined;
        api.glfwGetCursorPos(@ptrCast(self), &pos.x, &pos.y);
        return pos;
    }
    pub inline fn setCursorPos(self: *Window, pos: Cursor.Pos) void {
        return api.glfwSetCursorPos(@ptrCast(self), pos.x, pos.y);
    }

    pub inline fn getUserPointer(self: *Window) ?*anyopaque {
        return api.glfwGetWindowUserPointer(@ptrCast(self));
    }
    pub inline fn setUserPointer(self: *Window, user_data: ?*anyopaque) void {
        return api.glfwSetWindowUserPointer(@ptrCast(self), user_data);
    }

    pub inline fn setPosCallback(self: *Window, cb: ?types.windowPosCallback) ?types.windowPosCallback {
        return api.glfwSetWindowPosCallback(@ptrCast(self), cb);
    }
    pub inline fn setSizeCallback(self: *Window, cb: ?types.windowSizeCallback) ?types.windowSizeCallback {
        return api.glfwSetWindowSizeCallback(@ptrCast(self), cb);
    }
    pub inline fn setCloseCallback(self: *Window, cb: ?types.windowCloseCallback) ?types.windowCloseCallback {
        return api.glfwSetWindowCloseCallback(@ptrCast(self), cb);
    }
    pub inline fn setRefreshCallback(self: *Window, cb: ?types.windowRefreshCallback) ?types.windowRefreshCallback {
        return api.glfwSetWindowRefreshCallback(@ptrCast(self), cb);
    }
    pub inline fn setFocusCallback(self: *Window, cb: ?types.windowFocusCallback) ?types.windowFocusCallback {
        return api.glfwSetWindowFocusCallback(@ptrCast(self), cb);
    }
    pub inline fn setIconifyCallback(self: *Window, cb: ?types.windowIconifyCallback) ?types.windowIconifyCallback {
        return api.glfwSetWindowIconifyCallback(@ptrCast(self), cb);
    }
    pub inline fn setMaximizeCallback(self: *Window, cb: ?types.windowMaximizeCallback) ?types.windowMaximizeCallback {
        return api.glfwSetWindowMaximizeCallback(@ptrCast(self), cb);
    }
    pub inline fn setFramebufferSizeCallback(self: *Window, cb: ?types.framebufferSizeCallback) ?types.framebufferSizeCallback {
        return api.glfwSetFramebufferSizeCallback(@ptrCast(self), cb);
    }
    pub inline fn setContentScaleCallback(self: *Window, cb: ?types.windowContentScaleCallback) ?types.windowContentScaleCallback {
        return api.glfwSetWindowContentScaleCallback(@ptrCast(self), cb);
    }
    pub inline fn setKeyCallback(self: *Window, cb: ?types.keyCallback) ?types.keyCallback {
        return api.glfwSetKeyCallback(@ptrCast(self), cb);
    }
    pub inline fn setCharCallback(self: *Window, cb: ?types.charCallback) ?types.charCallback {
        return api.glfwSetCharCallback(@ptrCast(self), cb);
    }
    pub inline fn setCharModsCallback(self: *Window, cb: ?types.charModsCallback) ?types.charModsCallback {
        return api.glfwSetCharModsCallback(@ptrCast(self), cb);
    }
    pub inline fn setMouseButtonCallback(self: *Window, cb: ?types.mouseButtonCallback) ?types.mouseButtonCallback {
        return api.glfwSetMouseButtonCallback(@ptrCast(self), cb);
    }
    pub inline fn setCursorPosCallback(self: *Window, cb: ?types.cursorPosCallback) ?types.cursorPosCallback {
        return api.glfwSetCursorPosCallback(@ptrCast(self), cb);
    }
    pub inline fn setCursorEnterCallback(self: *Window, cb: ?types.cursorEnterCallback) ?types.cursorEnterCallback {
        return api.glfwSetCursorEnterCallback(@ptrCast(self), cb);
    }
    pub inline fn setScrollCallback(self: *Window, cb: ?types.scrollCallback) ?types.scrollCallback {
        return api.glfwSetScrollCallback(@ptrCast(self), cb);
    }
    pub inline fn setDropCallback(self: *Window, cb: ?types.dropCallback) ?types.dropCallback {
        return api.glfwSetDropCallback(@ptrCast(self), cb);
    }

    pub inline fn swapBuffers(self: *Window) void {
        return api.glfwSwapBuffers(@ptrCast(self));
    }
};

pub const Cursor = opaque {
    pub const Pos = extern struct {
        x: f64,
        y: f64,
    };

    pub const Shape = types.CursorShape;
    pub const Visibility = types.CursorVisibility;

    pub inline fn create(image: Image, hotspot: Cursor.Pos) ?*Cursor {
        return @ptrCast(api.glfwCreateCursor(&image, hotspot.x, hotspot.y));
    }
    pub inline fn createStandard(shape: Cursor.Shape) ?*Cursor {
        return @ptrCast(api.glfwCreateStandardCursor(shape));
    }

    pub inline fn destroy(self: *Cursor) void {
        return api.glfwDestroyCursor(@ptrCast(self));
    }
};

pub const Joystick = enum(types.Int) {
    _,

    pub const Hat = types.JoystickHat;
    pub const Button = types.JoystickButton;

    pub inline fn setCallback(cb: ?types.joystickCallback) ?types.joystickCallback {
        return api.glfwSetJoystickCallback(cb);
    }

    pub fn isPresent(self: Joystick) bool {
        return api.glfwJoystickPresent(@intFromEnum(self)).castTo();
    }
    pub fn isGamepad(self: Joystick) bool {
        return api.glfwJoystickIsGamepad(@intFromEnum(self)).castTo();
    }

    pub fn getAxes(self: Joystick) ?[]const f32 {
        var count: types.Int = undefined;
        const ptr = api.glfwGetJoystickAxes(@intFromEnum(self), &count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }
    pub fn getButtons(self: Joystick) ?[]const Action {
        var count: types.Int = undefined;
        const ptr = api.glfwGetJoystickButtons(@intFromEnum(self), &count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }
    pub fn getHats(self: Joystick) ?[]const Hat {
        var count: types.Int = undefined;
        const ptr = api.glfwGetJoystickHats(@intFromEnum(self), &count) orelse return null;
        if (count == 0) return null;
        return ptr[0 .. count];
    }

    pub inline fn getName(self: Joystick) ?[*:0]const u8 {
        return api.glfwGetJoystickName(@intFromEnum(self));
    }
    pub inline fn getGuid(self: Joystick) ?[*:0]const u8 {
        return api.glfwGetJoystickGUID(@intFromEnum(self));
    }

    pub inline fn setUserPointer(self: Joystick, user_data: ?*anyopaque) void {
        return api.glfwSetJoystickUserPointer(@intFromEnum(self), user_data);
    }
    pub inline fn getUserPointer(self: Joystick) ?*anyopaque {
        return api.glfwGetJoystickUserPointer(@intFromEnum(self));
    }
};

pub const Gamepad = enum(types.Int) {
    _,

    pub const Button = types.GamepadButton;
    pub const Axis = types.GamepadAxis;

    pub const State = extern struct {
        buttons: [15]Action,
        axes: [6]f32,

        pub fn buttonAction(self: Gamepad.State, button: Gamepad.Button) Action {
            return @enumFromInt(self.buttons[@intFromEnum(button)]);
        }
        pub fn axisState(self: Gamepad.State, axis: Gamepad.Axis) f32 {
            return self.axes[@intFromEnum(axis)];
        }
    };

    pub fn updateMappings(string: [*:0]const u8) bool {
        return api.glfwUpdateGamepadMappings(string).castTo();
    }

    pub inline fn fromJoystick(joystick: Joystick) Gamepad {
        return @enumFromInt(@intFromEnum(joystick));
    }

    pub inline fn getName(self: Gamepad) ?[*:0]const u8 {
        return api.glfwGetGamepadName(@intFromEnum(self));
    }
    pub fn getState(self: Gamepad) ?State {
        var state: State = undefined;
        const success = api.glfwGetGamepadState(@intFromEnum(self), @ptrCast(&state)).castTo();
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
pub inline fn setErrorCallback(cb: ?types.errorCallback) ?types.errorCallback {
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

pub fn getKeyName(key: Key, scancode: types.Int) ?[:0]const u8 {
    const name = api.glfwGetKeyName(key, scancode);
    return std.mem.span(name);
}
pub inline fn getKeyScancode(key: Key) types.Int {
    return api.glfwGetKeyScancode(key);
}

pub inline fn setClipboardString(window: ?*Window, string: [*:0]const u8) void {
    return api.glfwSetClipboardString(@ptrCast(window), string);
}
pub inline fn getClipboardString(window: ?*Window) ?[*:0]const u8 {
    return api.glfwGetClipboardString(@ptrCast(window));
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
    return api.glfwMakeContextCurrent(@ptrCast(window));
}
pub inline fn getCurrentContext() ?*Window {
    return @ptrCast(api.glfwGetCurrentContext());
}

pub inline fn swapInterval(interval: types.Int) void {
    return api.glfwSwapInterval(interval);
}

pub fn isExtensionSupported(extension: [*:0]const u8) bool {
    return api.glfwExtensionSupported(extension).castTo();
}

pub inline fn getProcAddress(proccess_name: [*:0]const u8) ?types.glproc {
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

pub fn initVulkanLoader(loader: ?types.PFN_vkGetInstanceProcAddr) void {
    return api.glfwInitVulkanLoader(loader);
}
pub fn getInstanceProcAddress(instance: types.vk.Instance, proccess_name: [*:0]const u8) ?types.vkproc {
    return api.glfwGetInstanceProcAddress(instance, proccess_name);
}
pub fn glfwGetPhysicalDevicePresentationSupport(instance: types.vk.Instance, device: types.vk.PhysicalDevice, queue_family: u32) bool {
    return api.glfwGetPhysicalDevicePresentationSupport(instance, device, queue_family).castTo();
}
pub fn glfwCreateWindowSurface(instance: types.vk.Instance, window: *Window, vk_alloc_cb: ?*const types.vk.AllocationCallbacks, out_surface: *types.vk.SurfaceKHR) types.vk.Result {
    return api.glfwCreateWindowSurface(instance, @ptrCast(window), vk_alloc_cb, out_surface);
}
