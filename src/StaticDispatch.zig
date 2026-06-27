const types = @import("types.zig");


pub extern fn glfwInit() types.Bool;
pub extern fn glfwTerminate() void;
pub extern fn glfwInitHint(hint: types.InitHint, value: types.Int) void;
pub extern fn glfwInitAllocator(allocator: ?*const types.Allocator) void;
pub extern fn glfwInitVulkanLoader(loader: ?types.vk.PFN_vkGetInstanceProcAddr) void; // vk 1.0

pub extern fn glfwGetVersion(major: ?*types.Int, minor: ?*types.Int, revision: ?*types.Int) void;
pub extern fn glfwGetVersionString() ?[*:0]const u8;

pub extern fn glfwGetError(description: ?* ?[*:0]const u8) types.ErrorCode;
pub extern fn glfwSetErrorCallback(cb: ?types.errorCallback) ?types.errorCallback;

pub extern fn glfwGetPlatform() types.Platform;
pub extern fn glfwPlatformSupported(platform: types.Platform) types.Bool;

pub extern fn glfwGetMonitors(count: *types.Int) ?[*] ?*types.Monitor;
pub extern fn glfwGetPrimaryMonitor() ?*types.Monitor;
pub extern fn glfwGetMonitorPos(monitor: *types.Monitor, pos_x: ?*types.Int, pos_y: ?*types.Int) void;
pub extern fn glfwGetMonitorWorkarea(monitor: *types.Monitor, pos_x: ?*types.Int, pos_y: ?*types.Int, width: ?*types.Int, height: ?*types.Int) void;
pub extern fn glfwGetMonitorPhysicalSize(monitor: *types.Monitor, width_mm: ?*types.Int, height_mm: ?*types.Int) void;
pub extern fn glfwGetMonitorContentScale(monitor: *types.Monitor, scale_x: ?*f32, scale_y: ?*f32) void;
pub extern fn glfwGetMonitorName(monitor: *types.Monitor) ?[*:0]const u8;
pub extern fn glfwSetMonitorUserPointer(monitor: *types.Monitor, user_data: ?*anyopaque) void;
pub extern fn glfwGetMonitorUserPointer(monitor: *types.Monitor) ?*anyopaque;
pub extern fn glfwSetMonitorCallback(cb: ?types.monitorCallback) ?types.monitorCallback;
pub extern fn glfwGetVideoModes(monitor: *types.Monitor, count: *types.Int) ?[*]const types.VideoMode;
pub extern fn glfwGetVideoMode(monitor: *types.Monitor) ?*const types.VideoMode;
pub extern fn glfwSetGamma(monitor: *types.Monitor, gamma: f32) void;
pub extern fn glfwGetGammaRamp(monitor: *types.Monitor) ?*const types.GammaRamp;
pub extern fn glfwSetGammaRamp(monitor: *types.Monitor, ramp: *const types.GammaRamp) void;

pub extern fn glfwDefaultWindowHints() void;
pub extern fn glfwWindowHint(hint: types.WindowHint, value: types.Int) void;
pub extern fn glfwWindowHintString(hint: types.WindowHint, value: [*:0]const u8) void;
pub extern fn glfwCreateWindow(width: types.Int, height: types.Int, title: [*:0]const u8, monitor: ?*types.Monitor, share: ?*types.Window) ?*types.Window;
pub extern fn glfwDestroyWindow(window: *types.Window) void;
pub extern fn glfwWindowShouldClose(window: *types.Window) types.Bool;
pub extern fn glfwSetWindowShouldClose(window: *types.Window, value: types.Bool) void;
pub extern fn glfwGetWindowTitle(window: *types.Window) ?[*:0]const u8;
pub extern fn glfwSetWindowTitle(window: *types.Window, title: [*:0]const u8) void;
pub extern fn glfwSetWindowIcon(window: *types.Window, count: types.Int, images: ?[*]const types.Image) void;
pub extern fn glfwGetWindowPos(window: *types.Window, pos_x: ?*types.Int, pos_y: ?*types.Int) void;
pub extern fn glfwSetWindowPos(window: *types.Window, pos_x: types.Int, pos_y: types.Int) void;
pub extern fn glfwGetWindowSize(window: *types.Window, width: ?*types.Int, height: ?*types.Int) void;
pub extern fn glfwSetWindowSizeLimits(window: *types.Window, min_width: types.Int, min_height: types.Int, max_width: types.Int, max_height: types.Int) void;
pub extern fn glfwSetWindowAspectRatio(window: *types.Window, numerator: types.Int, denominator: types.Int) void;
pub extern fn glfwSetWindowSize(window: *types.Window, width: types.Int, height: types.Int) void;
pub extern fn glfwGetFramebufferSize(window: *types.Window, width: ?*types.Int, height: ?*types.Int) void;
pub extern fn glfwGetWindowFrameSize(window: *types.Window, left: ?*types.Int, top: ?*types.Int, right: ?*types.Int, bottom: ?*types.Int) void;
pub extern fn glfwGetWindowContentScale(window: *types.Window, scale_x: ?*f32, scale_y: ?*f32) void;
pub extern fn glfwGetWindowOpacity(window: *types.Window) f32;
pub extern fn glfwSetWindowOpacity(window: *types.Window, opacity: f32) void;
pub extern fn glfwIconifyWindow(window: *types.Window) void;
pub extern fn glfwRestoreWindow(window: *types.Window) void;
pub extern fn glfwMaximizeWindow(window: *types.Window) void;
pub extern fn glfwShowWindow(window: *types.Window) void;
pub extern fn glfwHideWindow(window: *types.Window) void;
pub extern fn glfwFocusWindow(window: *types.Window) void;
pub extern fn glfwRequestWindowAttention(window: *types.Window) void;
pub extern fn glfwGetWindowMonitor(window: *types.Window) ?*types.Monitor;
pub extern fn glfwSetWindowMonitor(window: *types.Window, monitor: ?*types.Monitor, pos_x: types.Int, pos_y: types.Int, width: types.Int, height: types.Int, refresh_rate: types.Int) void;
pub extern fn glfwGetWindowAttrib(window: *types.Window, attrib: types.WindowAttribute) types.Int;
pub extern fn glfwSetWindowAttrib(window: *types.Window, attrib: types.WindowAttribute, value: types.Int) void;
pub extern fn glfwSetWindowUserPointer(window: *types.Window, user_data: ?*anyopaque) void;
pub extern fn glfwGetWindowUserPointer(window: *types.Window) ?*anyopaque;
pub extern fn glfwSetWindowPosCallback(window: *types.Window, cb: ?types.windowPosCallback) ?types.windowPosCallback;
pub extern fn glfwSetWindowSizeCallback(window: *types.Window, cb: ?types.windowSizeCallback) ?types.windowSizeCallback;
pub extern fn glfwSetWindowCloseCallback(window: *types.Window, cb: ?types.windowCloseCallback) ?types.windowCloseCallback;
pub extern fn glfwSetWindowRefreshCallback(window: *types.Window, cb: ?types.windowRefreshCallback) ?types.windowRefreshCallback;
pub extern fn glfwSetWindowFocusCallback(window: *types.Window, cb: ?types.windowFocusCallback) ?types.windowFocusCallback;
pub extern fn glfwSetWindowIconifyCallback(window: *types.Window, cb: ?types.glfwIconifyWindow) ?types.glfwIconifyWindow;
pub extern fn glfwSetWindowMaximizeCallback(window: *types.Window, cb: ?types.windowMaximizeCallback) ?types.windowMaximizeCallback;
pub extern fn glfwSetFramebufferSizeCallback(window: *types.Window, cb: ?types.framebufferSizeCallback) ?types.framebufferSizeCallback;
pub extern fn glfwSetWindowContentScaleCallback(window: *types.Window, cb: ?types.windowContentScaleCallback) ?types.windowContentScaleCallback;
pub extern fn glfwGetInputMode(window: *types.Window, mode: types.InputMode) types.Int;
pub extern fn glfwSetInputMode(window: *types.Window, mode: types.InputMode, value: types.Int) void;
pub extern fn glfwGetKey(window: *types.Window, key: types.Key) types.ActionPadded;
pub extern fn glfwGetMouseButton(window: *types.Window, button: types.MouseButton) types.ActionPadded;
pub extern fn glfwGetCursorPos(window: *types.Window, pos_x: ?*f64, pos_y: ?*f64) void;
pub extern fn glfwSetCursorPos(window: *types.Window, pos_x: f64, pos_y: f64) void;
pub extern fn glfwSetCursor(window: *types.Window, cursor: ?*types.Cursor) void;
pub extern fn glfwSetKeyCallback(window: *types.Window, cb: ?types.keyCallback) ?types.keyCallback;
pub extern fn glfwSetCharCallback(window: *types.Window, cb: ?types.charCallback) ?types.charCallback;
pub extern fn glfwSetCharModsCallback(window: *types.Window, cb: ?types.charModsCallback) ?types.charModsCallback;
pub extern fn glfwSetMouseButtonCallback(window: *types.Window, cb: ?types.mouseButtonCallback) ?types.mouseButtonCallback;
pub extern fn glfwSetCursorPosCallback(window: *types.Window, cb: ?types.cursorPosCallback) ?types.cursorPosCallback;
pub extern fn glfwSetCursorEnterCallback(window: *types.Window, cb: ?types.cursorEnterCallback) ?types.cursorEnterCallback;
pub extern fn glfwSetScrollCallback(window: *types.Window, cb: ?types.scrollCallback) ?types.scrollCallback;
pub extern fn glfwSetDropCallback(window: *types.Window, cb: ?types.dropCallback) ?types.dropCallback;

pub extern fn glfwPollEvents() void;
pub extern fn glfwWaitEvents() void;
pub extern fn glfwWaitEventsTimeout(timeout: f64) void;
pub extern fn glfwPostEmptyEvent() void;

pub extern fn glfwRawMouseMotionSupported() types.Bool;

pub extern fn glfwGetKeyName(key: types.Key, scancode: types.Int) ?[*:0]const u8;
pub extern fn glfwGetKeyScancode(key: types.Key) types.Int;

pub extern fn glfwCreateCursor(image: *const types.Image, hotspot_x: types.Int, hotspot_y: types.Int) ?*types.Cursor;
pub extern fn glfwCreateStandardCursor(shape: types.Cursor.Shape) ?*types.Cursor;
pub extern fn glfwDestroyCursor(cursor: *types.Cursor) void;

pub extern fn glfwJoystickPresent(jid: types.Int) types.Bool;
pub extern fn glfwGetJoystickAxes(jid: types.Int, count: *types.Int) ?[*]const f32;
pub extern fn glfwGetJoystickButtons(jid: types.Int, count: *types.Int) ?[*]const types.Action;
pub extern fn glfwGetJoystickHats(jid: types.Int, count: *types.Int) ?[*]const types.Joystick.Hat;
pub extern fn glfwGetJoystickName(jid: types.Int) ?[*:0]const u8;
pub extern fn glfwGetJoystickGUID(jid: types.Int) ?[*:0]const u8;
pub extern fn glfwSetJoystickUserPointer(jid: types.Int, user_data: ?*anyopaque) void;
pub extern fn glfwGetJoystickUserPointer(jid: types.Int) ?*anyopaque;
pub extern fn glfwJoystickIsGamepad(jid: types.Int) types.Bool;
pub extern fn glfwSetJoystickCallback(cb: ?types.joystickCallback) ?types.joystickCallback;
pub extern fn glfwUpdateGamepadMappings(string: [*:0]const u8) types.Bool;
pub extern fn glfwGetGamepadName(jid: types.Int) ?[*:0]const u8;
pub extern fn glfwGetGamepadState(jid: types.Int, state: *types.Gamepad.State) types.Bool;

pub extern fn glfwSetClipboardString(window: ?*types.Window, string: [*:0]const u8) void;
pub extern fn glfwGetClipboardString(window: ?*types.Window) ?[*:0]const u8;

pub extern fn glfwGetTime() f64;
pub extern fn glfwSetTime(time: f64) void;
pub extern fn glfwGetTimerValue() u64;
pub extern fn glfwGetTimerFrequency() u64;

pub extern fn glfwMakeContextCurrent(window: ?*types.Window) void;
pub extern fn glfwGetCurrentContext() ?*types.Window;

pub extern fn glfwSwapBuffers(window: *types.Window) void;
pub extern fn glfwSwapInterval(interval: types.Int) void;

pub extern fn glfwExtensionSupported(extension: [*:0]const u8) types.Bool;

pub extern fn glfwGetProcAddress(proccess_name: [*:0]const u8) ?types.glproc;
pub extern fn glfwVulkanSupported() types.Bool;
pub extern fn glfwGetRequiredInstanceExtensions(count: *u32) ?[*]const ?[*:0]const u8;
pub extern fn glfwGetInstanceProcAddress(instance: types.vk.Instance, proccess_name: [*:0]const u8) ?types.vkproc; // vk 1.0
pub extern fn glfwGetPhysicalDevicePresentationSupport(instance: types.vk.Instance, device: types.vk.PhysicalDevice, queue_family: u32) types.Bool; // vk 1.0
pub extern fn glfwCreateWindowSurface(instance: types.vk.Instance, window: *types.Window, vk_alloc_cb: ?*const types.vk.AllocationCallbacks, out_surface: *types.vk.SurfaceKHR) types.vk.Result; // vk 1.0
