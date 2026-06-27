const builtin = @import("builtin");
const std = @import("std");
const types = @import("types.zig");

const DynamicDispatch = @This();


pub const warpper = struct {
    // TODO: modify `std.DynLib`, add windows supported using `LoadLibraryA(W)`, `FreeLibrary` and `GetProcAddress`.
    pub var lib: std.DynLib = undefined;
    pub var dispatch: DynamicDispatch = undefined;

    pub const LoadError = std.DynLib.Error;
    pub fn load(lib_path: []const u8) LoadError!void {
        lib = try .open(lib_path);
        loadFns(&lib, &dispatch);
    }
    pub fn loadZ(lib_path: [*:0]const u8) LoadError!void {
        lib = try .openZ(lib_path);
        loadFns(&lib, &dispatch);
    }

    pub fn unload() void {
        unloadFns(&dispatch);
        lib.close();
    }

    fn loadFns(dyn_lib: *std.DynLib, fns: *DynamicDispatch) void {
        const fields = @typeInfo(DynamicDispatch).@"struct".fields;
        inline for (fields) |field| {
            @field(fns, field.name) = dyn_lib.lookup(@typeInfo(field.type).optional.child, field.name);
        }
    }
    fn unloadFns(fns: *DynamicDispatch) void {
        const fields = @typeInfo(DynamicDispatch).@"struct".fields;
        inline for (fields) |field| {
            @field(fns, field.name) = null;
        }
    }

    pub const LoadExError = error { LoopupError };
    pub const lookupFn = *const fn(ctx: ?*anyopaque, fn_name: [:0]const u8) LoadExError!?*anyopaque;
    pub fn loadEx(ctx: ?*anyopaque, lookup: lookupFn) LoadExError!void {
        const fields = @typeInfo(DynamicDispatch).@"struct".fields;
        inline for (fields) |field| {
            const f = try lookup(ctx, field.name);
            @field(dispatch, field.name) = @ptrCast(f);
        }
    }
    pub fn unloadEx() void {
        unloadFns(&dispatch);
    }


    pub fn glfwInit() types.Bool { return dispatch.glfwInit.?(); }
    pub fn glfwTerminate() void { return dispatch.glfwTerminate.?(); }
    pub fn glfwInitHint(hint: types.InitHint, value: types.Int) void { return dispatch.glfwInitHint.?(hint, value); }
    pub fn glfwInitAllocator(allocator: ?*const types.Allocator) void { return dispatch.glfwInitAllocator.?(allocator); }
    pub fn glfwInitVulkanLoader(loader: ?types.PFN_vkGetInstanceProcAddr) void { return dispatch.glfwInitVulkanLoader.?(loader); }

    pub fn glfwGetVersion(major: ?*types.Int, minor: ?*types.Int, revision: ?*types.Int) void { return dispatch.glfwGetVersion.?(major, minor, revision); }
    pub fn glfwGetVersionString() ?[*:0]const u8 { return dispatch.glfwGetVersionString.?(); }

    pub fn glfwGetError(description: ?* ?[*:0]const u8) types.ErrorCode { return dispatch.glfwGetError.?(description); }
    pub fn glfwSetErrorCallback(cb: ?types.errorCallback) ?types.errorCallback { return dispatch.glfwSetErrorCallback.?(cb); }

    pub fn glfwGetPlatform() types.Platform { return dispatch.glfwGetPlatform.?(); }
    pub fn glfwPlatformSupported(platform: types.Platform) types.Bool { return dispatch.glfwPlatformSupported.?(platform); }

    pub fn glfwGetMonitors(count: *types.Int) ?[*] ?*types.Monitor { return dispatch.glfwGetMonitors.?(count); }
    pub fn glfwGetPrimaryMonitor() ?*types.Monitor { return dispatch.glfwGetPrimaryMonitor.?(); }
    pub fn glfwGetMonitorPos(monitor: *types.Monitor, pos_x: ?*types.Int, pos_y: ?*types.Int) void { return dispatch.glfwGetMonitorPos.?(monitor, pos_x, pos_y); }
    pub fn glfwGetMonitorWorkarea(monitor: *types.Monitor, pos_x: ?*types.Int, pos_y: ?*types.Int, width: ?*types.Int, height: ?*types.Int) void { return dispatch.glfwGetMonitorWorkarea.?(monitor, pos_x, pos_y, width, height); }
    pub fn glfwGetMonitorPhysicalSize(monitor: *types.Monitor, width_mm: ?*types.Int, height_mm: ?*types.Int) void { return dispatch.glfwGetMonitorPhysicalSize.?(monitor, width_mm, height_mm); }
    pub fn glfwGetMonitorContentScale(monitor: *types.Monitor, scale_x: ?*f32, scale_y: ?*f32) void { return dispatch.glfwGetMonitorContentScale.?(monitor, scale_x, scale_y); }
    pub fn glfwGetMonitorName(monitor: *types.Monitor) ?[*:0]const u8 { return dispatch.glfwGetMonitorName.?(monitor); }
    pub fn glfwSetMonitorUserPointer(monitor: *types.Monitor, user_data: ?*anyopaque) void { return dispatch.glfwSetMonitorUserPointer.?(monitor, user_data); }
    pub fn glfwGetMonitorUserPointer(monitor: *types.Monitor) ?*anyopaque { return dispatch.glfwGetMonitorUserPointer.?(monitor); }
    pub fn glfwSetMonitorCallback(cb: ?types.monitorCallback) ?types.monitorCallback { return dispatch.glfwSetMonitorCallback.?(cb); }
    pub fn glfwGetVideoModes(monitor: *types.Monitor, count: *types.Int) ?[*]const types.VideoMode { return dispatch.glfwGetVideoModes.?(monitor, count); }
    pub fn glfwGetVideoMode(monitor: *types.Monitor) ?*const types.VideoMode { return dispatch.glfwGetVideoMode.?(monitor); }
    pub fn glfwSetGamma(monitor: *types.Monitor, gamma: f32) void { return dispatch.glfwSetGamma.?(monitor, gamma); }
    pub fn glfwGetGammaRamp(monitor: *types.Monitor) ?*const types.GammaRamp { return dispatch.glfwGetGammaRamp.?(monitor); }
    pub fn glfwSetGammaRamp(monitor: *types.Monitor, ramp: *const types.GammaRamp) void { return dispatch.glfwSetGammaRamp.?(monitor, ramp); }

    pub fn glfwDefaultWindowHints() void { return dispatch.glfwDefaultWindowHints.?(); }
    pub fn glfwWindowHint(hint: types.WindowHint, value: types.Int) void { return dispatch.glfwWindowHint.?(hint, value); }
    pub fn glfwWindowHintString(hint: types.WindowHint, value: [*:0]const u8) void { return dispatch.glfwWindowHintString.?(hint, value); }
    pub fn glfwCreateWindow(width: types.Int, height: types.Int, title: [*:0]const u8, monitor: ?*types.Monitor, share: ?*types.Window) ?*types.Window { return dispatch.glfwCreateWindow.?(width, height, title, monitor, share); }
    pub fn glfwDestroyWindow(window: *types.Window) void { return dispatch.glfwDestroyWindow.?(window); }
    pub fn glfwWindowShouldClose(window: *types.Window) types.Bool { return dispatch.glfwWindowShouldClose.?(window); }
    pub fn glfwSetWindowShouldClose(window: *types.Window, value: types.Bool) void { return dispatch.glfwSetWindowShouldClose.?(window, value); }
    pub fn glfwGetWindowTitle(window: *types.Window) ?[*:0]const u8 { return dispatch.glfwGetWindowTitle.?(window); }
    pub fn glfwSetWindowTitle(window: *types.Window, title: [*:0]const u8) void { return dispatch.glfwSetWindowTitle.?(window, title); }
    pub fn glfwSetWindowIcon(window: *types.Window, count: types.Int, images: ?[*]const types.Image) void { return dispatch.glfwSetWindowIcon.?(window, count, images); }
    pub fn glfwGetWindowPos(window: *types.Window, pos_x: ?*types.Int, pos_y: ?*types.Int) void { return dispatch.glfwGetWindowPos.?(window, pos_x, pos_y); }
    pub fn glfwSetWindowPos(window: *types.Window, pos_x: types.Int, pos_y: types.Int) void { return dispatch.glfwSetWindowPos.?(window, pos_x, pos_y); }
    pub fn glfwGetWindowSize(window: *types.Window, width: ?*types.Int, height: ?*types.Int) void { return dispatch.glfwGetWindowSize.?(window, width, height); }
    pub fn glfwSetWindowSizeLimits(window: *types.Window, min_width: types.Int, min_height: types.Int, max_width: types.Int, max_height: types.Int) void { return dispatch.glfwSetWindowSizeLimits.?(window, min_width, min_height, max_width, max_height); }
    pub fn glfwSetWindowAspectRatio(window: *types.Window, numerator: types.Int, denominator: types.Int) void { return dispatch.glfwSetWindowAspectRatio.?(window, numerator, denominator); }
    pub fn glfwSetWindowSize(window: *types.Window, width: types.Int, height: types.Int) void { return dispatch.glfwSetWindowSize.?(window, width, height); }
    pub fn glfwGetFramebufferSize(window: *types.Window, width: ?*types.Int, height: ?*types.Int) void { return dispatch.glfwGetFramebufferSize.?(window, width, height); }
    pub fn glfwGetWindowFrameSize(window: *types.Window, left: ?*types.Int, top: ?*types.Int, right: ?*types.Int, bottom: ?*types.Int) void { return dispatch.glfwGetWindowFrameSize.?(window, left, top, right, bottom); }
    pub fn glfwGetWindowContentScale(window: *types.Window, scale_x: ?*f32, scale_y: ?*f32) void { return dispatch.glfwGetWindowContentScale.?(window, scale_x, scale_y); }
    pub fn glfwGetWindowOpacity(window: *types.Window) f32 { return dispatch.glfwGetWindowOpacity.?(window); }
    pub fn glfwSetWindowOpacity(window: *types.Window, opacity: f32) void { return dispatch.glfwSetWindowOpacity.?(window, opacity); }
    pub fn glfwIconifyWindow(window: *types.Window) void { return dispatch.glfwIconifyWindow.?(window); }
    pub fn glfwRestoreWindow(window: *types.Window) void { return dispatch.glfwRestoreWindow.?(window); }
    pub fn glfwMaximizeWindow(window: *types.Window) void { return dispatch.glfwMaximizeWindow.?(window); }
    pub fn glfwShowWindow(window: *types.Window) void { return dispatch.glfwShowWindow.?(window); }
    pub fn glfwHideWindow(window: *types.Window) void { return dispatch.glfwHideWindow.?(window); }
    pub fn glfwFocusWindow(window: *types.Window) void { return dispatch.glfwFocusWindow.?(window); }
    pub fn glfwRequestWindowAttention(window: *types.Window) void { return dispatch.glfwRequestWindowAttention.?(window); }
    pub fn glfwGetWindowMonitor(window: *types.Window) ?*types.Monitor { return dispatch.glfwGetWindowMonitor.?(window); }
    pub fn glfwSetWindowMonitor(window: *types.Window, monitor: ?*types.Monitor, pos_x: types.Int, pos_y: types.Int, width: types.Int, height: types.Int, refresh_rate: types.Int) void { return dispatch.glfwSetWindowMonitor.?(window, monitor, pos_x, pos_y, width, height, refresh_rate); }
    pub fn glfwGetWindowAttrib(window: *types.Window, attrib: types.WindowAttribute) types.Int { return dispatch.glfwGetWindowAttrib.?(window, attrib); }
    pub fn glfwSetWindowAttrib(window: *types.Window, attrib: types.WindowAttribute, value: types.Int) void { return dispatch.glfwSetWindowAttrib.?(window, attrib, value); }
    pub fn glfwSetWindowUserPointer(window: *types.Window, user_data: ?*anyopaque) void { return dispatch.glfwSetWindowUserPointer.?(window, user_data); }
    pub fn glfwGetWindowUserPointer(window: *types.Window) ?*anyopaque { return dispatch.glfwGetWindowUserPointer.?(window); }
    pub fn glfwSetWindowPosCallback(window: *types.Window, cb: ?types.windowPosCallback) ?types.windowPosCallback { return dispatch.glfwSetWindowPosCallback.?(window, cb); }
    pub fn glfwSetWindowSizeCallback(window: *types.Window, cb: ?types.windowSizeCallback) ?types.windowSizeCallback { return dispatch.glfwSetWindowSizeCallback.?(window, cb); }
    pub fn glfwSetWindowCloseCallback(window: *types.Window, cb: ?types.windowCloseCallback) ?types.windowCloseCallback { return dispatch.glfwSetWindowCloseCallback.?(window, cb); }
    pub fn glfwSetWindowRefreshCallback(window: *types.Window, cb: ?types.windowRefreshCallback) ?types.windowRefreshCallback { return dispatch.glfwSetWindowRefreshCallback.?(window, cb); }
    pub fn glfwSetWindowFocusCallback(window: *types.Window, cb: ?types.windowFocusCallback) ?types.windowFocusCallback { return dispatch.glfwSetWindowFocusCallback.?(window, cb); }
    pub fn glfwSetWindowIconifyCallback(window: *types.Window, cb: ?types.glfwIconifyWindow) ?types.glfwIconifyWindow { return dispatch.glfwSetWindowIconifyCallback.?(window, cb); }
    pub fn glfwSetWindowMaximizeCallback(window: *types.Window, cb: ?types.windowMaximizeCallback) ?types.windowMaximizeCallback { return dispatch.glfwSetWindowMaximizeCallback.?(window, cb); }
    pub fn glfwSetFramebufferSizeCallback(window: *types.Window, cb: ?types.framebufferSizeCallback) ?types.framebufferSizeCallback { return dispatch.glfwSetFramebufferSizeCallback.?(window, cb); }
    pub fn glfwSetWindowContentScaleCallback(window: *types.Window, cb: ?types.windowContentScaleCallback) ?types.windowContentScaleCallback { return dispatch.glfwSetWindowContentScaleCallback.?(window, cb); }
    pub fn glfwGetInputMode(window: *types.Window, mode: types.InputMode) types.Int { return dispatch.glfwGetInputMode.?(window, mode); }
    pub fn glfwSetInputMode(window: *types.Window, mode: types.InputMode, value: types.Int) void { return dispatch.glfwSetInputMode.?(window, mode, value); }
    pub fn glfwGetKey(window: *types.Window, key: types.Key) types.ActionPadded { return dispatch.glfwGetKey.?(window, key); }
    pub fn glfwGetMouseButton(window: *types.Window, button: types.MouseButton) types.ActionPadded { return dispatch.glfwGetMouseButton.?(window, button); }
    pub fn glfwGetCursorPos(window: *types.Window, pos_x: ?*f64, pos_y: ?*f64) void { return dispatch.glfwGetCursorPos.?(window, pos_x, pos_y); }
    pub fn glfwSetCursorPos(window: *types.Window, pos_x: f64, pos_y: f64) void { return dispatch.glfwSetCursorPos.?(window, pos_x, pos_y); }
    pub fn glfwSetCursor(window: *types.Window, cursor: ?*types.Cursor) void { return dispatch.glfwSetCursor.?(window, cursor); }
    pub fn glfwSetKeyCallback(window: *types.Window, cb: ?types.keyCallback) ?types.keyCallback { return dispatch.glfwSetKeyCallback.?(window, cb); }
    pub fn glfwSetCharCallback(window: *types.Window, cb: ?types.charCallback) ?types.charCallback { return dispatch.glfwSetCharCallback.?(window, cb); }
    pub fn glfwSetCharModsCallback(window: *types.Window, cb: ?types.charModsCallback) ?types.charModsCallback { return dispatch.glfwSetCharModsCallback.?(window, cb); }
    pub fn glfwSetMouseButtonCallback(window: *types.Window, cb: ?types.mouseButtonCallback) ?types.mouseButtonCallback { return dispatch.glfwSetMouseButtonCallback.?(window, cb); }
    pub fn glfwSetCursorPosCallback(window: *types.Window, cb: ?types.cursorPosCallback) ?types.cursorPosCallback { return dispatch.glfwSetCursorPosCallback.?(window, cb); }
    pub fn glfwSetCursorEnterCallback(window: *types.Window, cb: ?types.cursorEnterCallback) ?types.cursorEnterCallback { return dispatch.glfwSetCursorEnterCallback.?(window, cb); }
    pub fn glfwSetScrollCallback(window: *types.Window, cb: ?types.scrollCallback) ?types.scrollCallback { return dispatch.glfwSetScrollCallback.?(window, cb); }
    pub fn glfwSetDropCallback(window: *types.Window, cb: ?types.dropCallback) ?types.dropCallback { return dispatch.glfwSetDropCallback.?(window, cb); }

    pub fn glfwPollEvents() void { return dispatch.glfwPollEvents.?(); }
    pub fn glfwWaitEvents() void { return dispatch.glfwWaitEvents.?(); }
    pub fn glfwWaitEventsTimeout(timeout: f64) void { return dispatch.glfwWaitEventsTimeout.?(timeout); }
    pub fn glfwPostEmptyEvent() void { return dispatch.glfwPostEmptyEvent.?(); }

    pub fn glfwRawMouseMotionSupported() types.Bool { return dispatch.glfwRawMouseMotionSupported.?(); }

    pub fn glfwGetKeyName(key: types.Key, scancode: types.Int) ?[*:0]const u8 { return dispatch.glfwGetKeyName.?(key, scancode); }
    pub fn glfwGetKeyScancode(key: types.Key) types.Int { return dispatch.glfwGetKeyScancode.?(key); }

    pub fn glfwCreateCursor(image: *const types.Image, hotspot_x: types.Int, hotspot_y: types.Int) ?*types.Cursor { return dispatch.glfwCreateCursor.?(image, hotspot_x, hotspot_y); }
    pub fn glfwCreateStandardCursor(shape: types.Cursor.Shape) ?*types.Cursor { return dispatch.glfwCreateStandardCursor.?(shape); }
    pub fn glfwDestroyCursor(cursor: *types.Cursor) void { return dispatch.glfwDestroyCursor.?(cursor); }

    pub fn glfwJoystickPresent(jid: types.Int) types.Bool { return dispatch.glfwJoystickPresent.?(jid); }
    pub fn glfwGetJoystickAxes(jid: types.Int, count: *types.Int) ?[*]const f32 { return dispatch.glfwGetJoystickAxes.?(jid, count); }
    pub fn glfwGetJoystickButtons(jid: types.Int, count: *types.Int) ?[*]const types.Action { return dispatch.glfwGetJoystickButtons.?(jid, count); }
    pub fn glfwGetJoystickHats(jid: types.Int, count: *types.Int) ?[*]const types.Joystick.Hat { return dispatch.glfwGetJoystickHats.?(jid, count); }
    pub fn glfwGetJoystickName(jid: types.Int) ?[*:0]const u8 { return dispatch.glfwGetJoystickName.?(jid); }
    pub fn glfwGetJoystickGUID(jid: types.Int) ?[*:0]const u8 { return dispatch.glfwGetJoystickGUID.?(jid); }
    pub fn glfwSetJoystickUserPointer(jid: types.Int, user_data: ?*anyopaque) void { return dispatch.glfwSetJoystickUserPointer.?(jid, user_data); }
    pub fn glfwGetJoystickUserPointer(jid: types.Int) ?*anyopaque { return dispatch.glfwGetJoystickUserPointer.?(jid); }
    pub fn glfwJoystickIsGamepad(jid: types.Int) types.Bool { return dispatch.glfwJoystickIsGamepad.?(jid); }
    pub fn glfwSetJoystickCallback(cb: ?types.joystickCallback) ?types.joystickCallback { return dispatch.glfwSetJoystickCallback.?(cb); }
    pub fn glfwUpdateGamepadMappings(string: [*:0]const u8) types.Bool { return dispatch.glfwUpdateGamepadMappings.?(string); }
    pub fn glfwGetGamepadName(jid: types.Int) ?[*:0]const u8 { return dispatch.glfwGetGamepadName.?(jid); }
    pub fn glfwGetGamepadState(jid: types.Int, state: *types.GamepadState) types.Bool { return dispatch.glfwGetGamepadState.?(jid, state); }

    pub fn glfwSetClipboardString(window: ?*types.Window, string: [*:0]const u8) void { return dispatch.glfwSetClipboardString.?(window, string); }
    pub fn glfwGetClipboardString(window: ?*types.Window) ?[*:0]const u8 { return dispatch.glfwGetClipboardString.?(window); }

    pub fn glfwGetTime() f64 { return dispatch.glfwGetTime.?(); }
    pub fn glfwSetTime(time: f64) void { return dispatch.glfwSetTime.?(time); }
    pub fn glfwGetTimerValue() u64 { return dispatch.glfwGetTimerValue.?(); }
    pub fn glfwGetTimerFrequency() u64 { return dispatch.glfwGetTimerFrequency.?(); }

    pub fn glfwMakeContextCurrent(window: ?*types.Window) void { return dispatch.glfwMakeContextCurrent.?(window); }
    pub fn glfwGetCurrentContext() ?*types.Window { return dispatch.glfwGetCurrentContext.?(); }

    pub fn glfwSwapBuffers(window: *types.Window) void { return dispatch.glfwSwapBuffers.?(window); }
    pub fn glfwSwapInterval(interval: types.Int) void { return dispatch.glfwSwapInterval.?(interval); }

    pub fn glfwExtensionSupported(extension: [*:0]const u8) types.Bool { return dispatch.glfwExtensionSupported.?(extension); }

    pub fn glfwGetProcAddress(proccess_name: [*:0]const u8) ?types.glproc { return dispatch.glfwGetProcAddress.?(proccess_name); }
    pub fn glfwVulkanSupported() types.Bool { return dispatch.glfwVulkanSupported.?(); }
    pub fn glfwGetRequiredInstanceExtensions(count: *u32) ?[*]const ?[*:0]const u8 { return dispatch.glfwGetRequiredInstanceExtensions.?(count); }
    pub fn glfwGetInstanceProcAddress(instance: types.vk.Instance, proccess_name: [*:0]const u8) ?types.vkproc { return dispatch.glfwGetInstanceProcAddress.?(instance, proccess_name); }
    pub fn glfwGetPhysicalDevicePresentationSupport(instance: types.vk.Instance, device: types.vk.PhysicalDevice, queue_family: u32) types.Bool { return dispatch.glfwGetPhysicalDevicePresentationSupport.?(instance, device, queue_family); }
    pub fn glfwCreateWindowSurface(instance: types.vk.Instance, window: *types.Window, vk_alloc_cb: ?*const types.vk.AllocationCallbacks, out_surface: *types.vk.SurfaceKHR) types.vk.Result { return dispatch.glfwCreateWindowSurface.?(instance, window, vk_alloc_cb, out_surface); }
};


glfwInit: ?types.glfwInit,
glfwTerminate: ?types.glfwTerminate,
glfwInitHint: ?types.glfwInitHint,
glfwInitAllocator: ?types.glfwInitAllocator,
glfwInitVulkanLoader: ?types.glfwInitVulkanLoader,

glfwGetVersion: ?types.glfwGetVersion,
glfwGetVersionString: ?types.glfwGetVersionString,

glfwGetError: ?types.glfwGetError,
glfwSetErrorCallback: ?types.glfwSetErrorCallback,

glfwGetPlatform: ?types.glfwGetPlatform,
glfwPlatformSupported: ?types.glfwPlatformSupported,

glfwGetMonitors: ?types.glfwGetMonitors,
glfwGetPrimaryMonitor: ?types.glfwGetPrimaryMonitor,
glfwGetMonitorPos: ?types.glfwGetMonitorPos,
glfwGetMonitorWorkarea: ?types.glfwGetMonitorWorkarea,
glfwGetMonitorPhysicalSize: ?types.glfwGetMonitorPhysicalSize,
glfwGetMonitorContentScale: ?types.glfwGetMonitorContentScale,
glfwGetMonitorName: ?types.glfwGetMonitorName,
glfwSetMonitorUserPointer: ?types.glfwSetMonitorUserPointer,
glfwGetMonitorUserPointer: ?types.glfwGetMonitorUserPointer,
glfwSetMonitorCallback: ?types.glfwSetMonitorCallback,
glfwGetVideoModes: ?types.glfwGetVideoModes,
glfwGetVideoMode: ?types.glfwGetVideoMode,
glfwSetGamma: ?types.glfwSetGamma,
glfwGetGammaRamp: ?types.glfwGetGammaRamp,
glfwSetGammaRamp: ?types.glfwSetGammaRamp,

glfwDefaultWindowHints: ?types.glfwDefaultWindowHints,
glfwWindowHint: ?types.glfwWindowHint,
glfwWindowHintString: ?types.glfwWindowHintString,
glfwCreateWindow: ?types.glfwCreateWindow,
glfwDestroyWindow: ?types.glfwDestroyWindow,
glfwWindowShouldClose: ?types.glfwWindowShouldClose,
glfwSetWindowShouldClose: ?types.glfwSetWindowShouldClose,
glfwGetWindowTitle: ?types.glfwGetWindowTitle,
glfwSetWindowTitle: ?types.glfwSetWindowTitle,
glfwSetWindowIcon: ?types.glfwSetWindowIcon,
glfwGetWindowPos: ?types.glfwGetWindowPos,
glfwSetWindowPos: ?types.glfwSetWindowPos,
glfwGetWindowSize: ?types.glfwGetWindowSize,
glfwSetWindowSizeLimits: ?types.glfwSetWindowSizeLimits,
glfwSetWindowAspectRatio: ?types.glfwSetWindowAspectRatio,
glfwSetWindowSize: ?types.glfwSetWindowSize,
glfwGetFramebufferSize: ?types.glfwGetFramebufferSize,
glfwGetWindowFrameSize: ?types.glfwGetWindowFrameSize,
glfwGetWindowContentScale: ?types.glfwGetWindowContentScale,
glfwGetWindowOpacity: ?types.glfwGetWindowOpacity,
glfwSetWindowOpacity: ?types.glfwSetWindowOpacity,
glfwIconifyWindow: ?types.glfwIconifyWindow,
glfwRestoreWindow: ?types.glfwRestoreWindow,
glfwMaximizeWindow: ?types.glfwMaximizeWindow,
glfwShowWindow: ?types.glfwShowWindow,
glfwHideWindow: ?types.glfwHideWindow,
glfwFocusWindow: ?types.glfwFocusWindow,
glfwRequestWindowAttention: ?types.glfwRequestWindowAttention,
glfwGetWindowMonitor: ?types.glfwGetWindowMonitor,
glfwSetWindowMonitor: ?types.glfwSetWindowMonitor,
glfwGetWindowAttrib: ?types.glfwGetWindowAttrib,
glfwSetWindowAttrib: ?types.glfwSetWindowAttrib,
glfwSetWindowUserPointer: ?types.glfwSetWindowUserPointer,
glfwGetWindowUserPointer: ?types.glfwGetWindowUserPointer,
glfwSetWindowPosCallback: ?types.glfwSetWindowPosCallback,
glfwSetWindowSizeCallback: ?types.glfwSetWindowSizeCallback,
glfwSetWindowCloseCallback: ?types.glfwSetWindowCloseCallback,
glfwSetWindowRefreshCallback: ?types.glfwSetWindowRefreshCallback,
glfwSetWindowFocusCallback: ?types.glfwSetWindowFocusCallback,
glfwSetWindowIconifyCallback: ?types.glfwSetWindowIconifyCallback,
glfwSetWindowMaximizeCallback: ?types.glfwSetWindowMaximizeCallback,
glfwSetFramebufferSizeCallback: ?types.glfwSetFramebufferSizeCallback,
glfwSetWindowContentScaleCallback: ?types.glfwSetWindowContentScaleCallback,
glfwGetInputMode: ?types.glfwGetInputMode,
glfwSetInputMode: ?types.glfwSetInputMode,
glfwGetKey: ?types.glfwGetKey,
glfwGetMouseButton: ?types.glfwGetMouseButton,
glfwGetCursorPos: ?types.glfwGetCursorPos,
glfwSetCursorPos: ?types.glfwSetCursorPos,
glfwSetCursor: ?types.glfwSetCursor,
glfwSetKeyCallback: ?types.glfwSetKeyCallback,
glfwSetCharCallback: ?types.glfwSetCharCallback,
glfwSetCharModsCallback: ?types.glfwSetCharModsCallback,
glfwSetMouseButtonCallback: ?types.glfwSetMouseButtonCallback,
glfwSetCursorPosCallback: ?types.glfwSetCursorPosCallback,
glfwSetCursorEnterCallback: ?types.glfwSetCursorEnterCallback,
glfwSetScrollCallback: ?types.glfwSetScrollCallback,
glfwSetDropCallback: ?types.glfwSetDropCallback,

glfwPollEvents: ?types.glfwPollEvents,
glfwWaitEvents: ?types.glfwWaitEvents,
glfwWaitEventsTimeout: ?types.glfwWaitEventsTimeout,
glfwPostEmptyEvent: ?types.glfwPostEmptyEvent,

glfwRawMouseMotionSupported: ?types.glfwRawMouseMotionSupported,

glfwGetKeyName: ?types.glfwGetKeyName,
glfwGetKeyScancode: ?types.glfwGetKeyScancode,

glfwCreateCursor: ?types.glfwCreateCursor,
glfwCreateStandardCursor: ?types.glfwCreateStandardCursor,
glfwDestroyCursor: ?types.glfwDestroyCursor,

glfwJoystickPresent: ?types.glfwJoystickPresent,
glfwGetJoystickAxes: ?types.glfwGetJoystickAxes,
glfwGetJoystickButtons: ?types.glfwGetJoystickButtons,
glfwGetJoystickHats: ?types.glfwGetJoystickHats,
glfwGetJoystickName: ?types.glfwGetJoystickName,
glfwGetJoystickGUID: ?types.glfwGetJoystickGUID,
glfwSetJoystickUserPointer: ?types.glfwSetJoystickUserPointer,
glfwGetJoystickUserPointer: ?types.glfwGetJoystickUserPointer,
glfwJoystickIsGamepad: ?types.glfwJoystickIsGamepad,
glfwSetJoystickCallback: ?types.glfwSetJoystickCallback,
glfwUpdateGamepadMappings: ?types.glfwUpdateGamepadMappings,
glfwGetGamepadName: ?types.glfwGetGamepadName,
glfwGetGamepadState: ?types.glfwGetGamepadState,

glfwSetClipboardString: ?types.glfwSetClipboardString,
glfwGetClipboardString: ?types.glfwGetClipboardString,

glfwGetTime: ?types.glfwGetTime,
glfwSetTime: ?types.glfwSetTime,
glfwGetTimerValue: ?types.glfwGetTimerValue,
glfwGetTimerFrequency: ?types.glfwGetTimerFrequency,

glfwMakeContextCurrent: ?types.glfwMakeContextCurrent,
glfwGetCurrentContext: ?types.glfwGetCurrentContext,

glfwSwapBuffers: ?types.glfwSwapBuffers,
glfwSwapInterval: ?types.glfwSwapInterval,

glfwExtensionSupported: ?types.glfwExtensionSupported,

glfwGetProcAddress: ?types.glfwGetProcAddress,
glfwVulkanSupported: ?types.glfwVulkanSupported,
glfwGetRequiredInstanceExtensions: ?types.glfwGetRequiredInstanceExtensions,
glfwGetInstanceProcAddress: ?types.glfwGetInstanceProcAddress,
glfwGetPhysicalDevicePresentationSupport: ?types.glfwGetPhysicalDevicePresentationSupport,
glfwCreateWindowSurface: ?types.glfwCreateWindowSurface,
