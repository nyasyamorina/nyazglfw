const glfw = @import("lib.zig");
const callback = @import("callback.zig");
const vk = glfw.vk;

pub const native = @import("native.zig");


pub extern fn glfwInit() glfw.Bool;
pub extern fn glfwTerminate() void;
pub extern fn glfwInitHint(hint: glfw.InitHint, value: glfw.Int) void;
pub extern fn glfwInitAllocator(allocator: ?*const glfw.Allocator) void;
pub extern fn glfwInitVulkanLoader(loader: ?vk.PFN_vkGetInstanceProcAddr) void; // vk 1.0

pub extern fn glfwGetVersion(major: ?*glfw.Int, minor: ?*glfw.Int, revision: ?*glfw.Int) void;
pub extern fn glfwGetVersionString() ?[*:0]const u8;

pub extern fn glfwGetError(description: ?* ?[*:0]const u8) glfw.ErrorCode;
pub extern fn glfwSetErrorCallback(cb: ?callback.@"error") ?callback.@"error";

pub extern fn glfwGetPlatform() glfw.Platform;
pub extern fn glfwPlatformSupported(platform: glfw.Platform) glfw.Bool;

pub extern fn glfwGetMonitors(count: *glfw.Int) ?[*] ?*glfw.Monitor;
pub extern fn glfwGetPrimaryMonitor() ?*glfw.Monitor;
pub extern fn glfwGetMonitorPos(monitor: *glfw.Monitor, pos_x: ?*glfw.Int, pos_y: ?*glfw.Int) void;
pub extern fn glfwGetMonitorWorkarea(monitor: *glfw.Monitor, pos_x: ?*glfw.Int, pos_y: ?*glfw.Int, width: ?*glfw.Int, height: ?*glfw.Int) void;
pub extern fn glfwGetMonitorPhysicalSize(monitor: *glfw.Monitor, width_mm: ?*glfw.Int, height_mm: ?*glfw.Int) void;
pub extern fn glfwGetMonitorContentScale(monitor: *glfw.Monitor, scale_x: ?*f32, scale_y: ?*f32) void;
pub extern fn glfwGetMonitorName(monitor: *glfw.Monitor) ?[*:0]const u8;
pub extern fn glfwSetMonitorUserPointer(monitor: *glfw.Monitor, user_data: ?*anyopaque) void;
pub extern fn glfwGetMonitorUserPointer(monitor: *glfw.Monitor) ?*anyopaque;
pub extern fn glfwSetMonitorCallback(cb: ?callback.monitor) ?callback.monitor;
pub extern fn glfwGetVideoModes(monitor: *glfw.Monitor, count: *glfw.Int) ?[*]const glfw.VideoMode;
pub extern fn glfwGetVideoMode(monitor: *glfw.Monitor) ?*const glfw.VideoMode;
pub extern fn glfwSetGamma(monitor: *glfw.Monitor, gamma: f32) void;
pub extern fn glfwGetGammaRamp(monitor: *glfw.Monitor) ?*const glfw.GammaRamp;
pub extern fn glfwSetGammaRamp(monitor: *glfw.Monitor, ramp: *const glfw.GammaRamp) void;

pub extern fn glfwDefaultWindowHints() void;
pub extern fn glfwWindowHint(hint: glfw.Window.Hint, value: glfw.Int) void;
pub extern fn glfwWindowHintString(hint: glfw.Window.Hint, value: [*:0]const u8) void;
pub extern fn glfwCreateWindow(width: glfw.Int, height: glfw.Int, title: [*:0]const u8, monitor: ?*glfw.Monitor, share: ?*glfw.Window) ?*glfw.Window;
pub extern fn glfwDestroyWindow(window: *glfw.Window) void;
pub extern fn glfwWindowShouldClose(window: *glfw.Window) glfw.Bool;
pub extern fn glfwSetWindowShouldClose(window: *glfw.Window, value: glfw.Bool) void;
pub extern fn glfwGetWindowTitle(window: *glfw.Window) ?[*:0]const u8;
pub extern fn glfwSetWindowTitle(window: *glfw.Window, title: [*:0]const u8) void;
pub extern fn glfwSetWindowIcon(window: *glfw.Window, count: glfw.Int, images: ?[*]const glfw.Image) void;
pub extern fn glfwGetWindowPos(window: *glfw.Window, pos_x: ?*glfw.Int, pos_y: ?*glfw.Int) void;
pub extern fn glfwSetWindowPos(window: *glfw.Window, pos_x: glfw.Int, pos_y: glfw.Int) void;
pub extern fn glfwGetWindowSize(window: *glfw.Window, width: ?*glfw.Int, height: ?*glfw.Int) void;
pub extern fn glfwSetWindowSizeLimits(window: *glfw.Window, min_width: glfw.Int, min_height: glfw.Int, max_width: glfw.Int, max_height: glfw.Int) void;
pub extern fn glfwSetWindowAspectRatio(window: *glfw.Window, numerator: glfw.Int, denominator: glfw.Int) void;
pub extern fn glfwSetWindowSize(window: *glfw.Window, width: glfw.Int, height: glfw.Int) void;
pub extern fn glfwGetFramebufferSize(window: *glfw.Window, width: ?*glfw.Int, height: ?*glfw.Int) void;
pub extern fn glfwGetWindowFrameSize(window: *glfw.Window, left: ?*glfw.Int, top: ?*glfw.Int, right: ?*glfw.Int, bottom: ?*glfw.Int) void;
pub extern fn glfwGetWindowContentScale(window: *glfw.Window, scale_x: ?*f32, scale_y: ?*f32) void;
pub extern fn glfwGetWindowOpacity(window: *glfw.Window) f32;
pub extern fn glfwSetWindowOpacity(window: *glfw.Window, opacity: f32) void;
pub extern fn glfwIconifyWindow(window: *glfw.Window) void;
pub extern fn glfwRestoreWindow(window: *glfw.Window) void;
pub extern fn glfwMaximizeWindow(window: *glfw.Window) void;
pub extern fn glfwShowWindow(window: *glfw.Window) void;
pub extern fn glfwHideWindow(window: *glfw.Window) void;
pub extern fn glfwFocusWindow(window: *glfw.Window) void;
pub extern fn glfwRequestWindowAttention(window: *glfw.Window) void;
pub extern fn glfwGetWindowMonitor(window: *glfw.Window) ?*glfw.Monitor;
pub extern fn glfwSetWindowMonitor(window: *glfw.Window, monitor: ?*glfw.Monitor, pos_x: glfw.Int, pos_y: glfw.Int, width: glfw.Int, height: glfw.Int, refresh_rate: glfw.Int) void;
pub extern fn glfwGetWindowAttrib(window: *glfw.Window, attrib: glfw.Window.Attribute) glfw.Int;
pub extern fn glfwSetWindowAttrib(window: *glfw.Window, attrib: glfw.Window.Attribute, value: glfw.Int) void;
pub extern fn glfwSetWindowUserPointer(window: *glfw.Window, user_data: ?*anyopaque) void;
pub extern fn glfwGetWindowUserPointer(window: *glfw.Window) ?*anyopaque;
pub extern fn glfwSetWindowPosCallback(window: *glfw.Window, cb: ?callback.windowPos) ?callback.windowPos;
pub extern fn glfwSetWindowSizeCallback(window: *glfw.Window, cb: ?callback.windowSize) ?callback.windowSize;
pub extern fn glfwSetWindowCloseCallback(window: *glfw.Window, cb: ?callback.windowClose) ?callback.windowClose;
pub extern fn glfwSetWindowRefreshCallback(window: *glfw.Window, cb: ?callback.windowRefresh) ?callback.windowRefresh;
pub extern fn glfwSetWindowFocusCallback(window: *glfw.Window, cb: ?callback.windowFocus) ?callback.windowFocus;
pub extern fn glfwSetWindowIconifyCallback(window: *glfw.Window, cb: ?callback.windowIconify) ?callback.windowIconify;
pub extern fn glfwSetWindowMaximizeCallback(window: *glfw.Window, cb: ?callback.windowMaximize) ?callback.windowMaximize;
pub extern fn glfwSetFramebufferSizeCallback(window: *glfw.Window, cb: ?callback.windowFramebufferSize) ?callback.windowFramebufferSize;
pub extern fn glfwSetWindowContentScaleCallback(window: *glfw.Window, cb: ?callback.windowContentScale) ?callback.windowContentScale;
pub extern fn glfwGetInputMode(window: *glfw.Window, mode: glfw.Window.InputMode) glfw.Int;
pub extern fn glfwSetInputMode(window: *glfw.Window, mode: glfw.Window.InputMode, value: glfw.Int) void;
pub extern fn glfwGetKey(window: *glfw.Window, key: glfw.Key) glfw.ActionPadded;
pub extern fn glfwGetMouseButton(window: *glfw.Window, button: glfw.MouseButton) glfw.ActionPadded;
pub extern fn glfwGetCursorPos(window: *glfw.Window, pos_x: ?*f64, pos_y: ?*f64) void;
pub extern fn glfwSetCursorPos(window: *glfw.Window, pos_x: f64, pos_y: f64) void;
pub extern fn glfwSetCursor(window: *glfw.Window, cursor: ?*glfw.Cursor) void;
pub extern fn glfwSetKeyCallback(window: *glfw.Window, cb: ?callback.windowKey) ?callback.windowKey;
pub extern fn glfwSetCharCallback(window: *glfw.Window, cb: ?callback.windowChar) ?callback.windowChar;
pub extern fn glfwSetCharModsCallback(window: *glfw.Window, cb: ?callback.windowCharMods) ?callback.windowCharMods;
pub extern fn glfwSetMouseButtonCallback(window: *glfw.Window, cb: ?callback.windowMouseButton) ?callback.windowMouseButton;
pub extern fn glfwSetCursorPosCallback(window: *glfw.Window, cb: ?callback.windowCursorPos) ?callback.windowCursorPos;
pub extern fn glfwSetCursorEnterCallback(window: *glfw.Window, cb: callback.windowCursorEnter) callback.windowCursorEnter;
pub extern fn glfwSetScrollCallback(window: *glfw.Window, cb: ?callback.windowScroll) ?callback.windowScroll;
pub extern fn glfwSetDropCallback(window: *glfw.Window, cb: ?callback.windowDrop) ?callback.windowDrop;

pub extern fn glfwPollEvents() void;
pub extern fn glfwWaitEvents() void;
pub extern fn glfwWaitEventsTimeout(timeout: f64) void;
pub extern fn glfwPostEmptyEvent() void;

pub extern fn glfwRawMouseMotionSupported() glfw.Bool;

pub extern fn glfwGetKeyName(key: glfw.Key, scancode: glfw.Int) ?[*:0]const u8;
pub extern fn glfwGetKeyScancode(key: glfw.Key) glfw.Int;

pub extern fn glfwCreateCursor(image: *const glfw.Image, hotspot_x: glfw.Int, hotspot_y: glfw.Int) ?*glfw.Cursor;
pub extern fn glfwCreateStandardCursor(shape: glfw.Cursor.Shape) ?*glfw.Cursor;
pub extern fn glfwDestroyCursor(cursor: *glfw.Cursor) void;

pub extern fn glfwJoystickPresent(jid: glfw.Int) glfw.Bool;
pub extern fn glfwGetJoystickAxes(jid: glfw.Int, count: *glfw.Int) ?[*]const f32;
pub extern fn glfwGetJoystickButtons(jid: glfw.Int, count: *glfw.Int) ?[*]const glfw.Action;
pub extern fn glfwGetJoystickHats(jid: glfw.Int, count: *glfw.Int) ?[*]const glfw.Joystick.Hat;
pub extern fn glfwGetJoystickName(jid: glfw.Int) ?[*:0]const u8;
pub extern fn glfwGetJoystickGUID(jid: glfw.Int) ?[*:0]const u8;
pub extern fn glfwSetJoystickUserPointer(jid: glfw.Int, user_data: ?*anyopaque) void;
pub extern fn glfwGetJoystickUserPointer(jid: glfw.Int) ?*anyopaque;
pub extern fn glfwJoystickIsGamepad(jid: glfw.Int) glfw.Bool;
pub extern fn glfwSetJoystickCallback(cb: ?callback.joystick) ?callback.joystick;
pub extern fn glfwUpdateGamepadMappings(string: [*:0]const u8) glfw.Bool;
pub extern fn glfwGetGamepadName(jid: glfw.Int) ?[*:0]const u8;
pub extern fn glfwGetGamepadState(jid: glfw.Int, state: *glfw.Gamepad.State) glfw.Bool;

pub extern fn glfwSetClipboardString(window: ?*glfw.Window, string: [*:0]const u8) void;
pub extern fn glfwGetClipboardString(window: ?*glfw.Window) ?[*:0]const u8;

pub extern fn glfwGetTime() f64;
pub extern fn glfwSetTime(time: f64) void;
pub extern fn glfwGetTimerValue() u64;
pub extern fn glfwGetTimerFrequency() u64;

pub extern fn glfwMakeContextCurrent(window: ?*glfw.Window) void;
pub extern fn glfwGetCurrentContext() ?*glfw.Window;

pub extern fn glfwSwapBuffers(window: *glfw.Window) void;
pub extern fn glfwSwapInterval(interval: glfw.Int) void;

pub extern fn glfwExtensionSupported(extension: [*:0]const u8) glfw.Bool;

pub extern fn glfwGetProcAddress(proccess_name: [*:0]const u8) ?glfw.glproc;
pub extern fn glfwVulkanSupported() glfw.Bool;
pub extern fn glfwGetRequiredInstanceExtensions(count: *u32) ?[*]const ?[*:0]const u8;
pub extern fn glfwGetInstanceProcAddress(instance: vk.Instance, proccess_name: [*:0]const u8) ?glfw.vkproc; // vk 1.0
pub extern fn glfwGetPhysicalDevicePresentationSupport(instance: vk.Instance, device: vk.PhysicalDevice, queue_family: u32) glfw.Bool; // vk 1.0
pub extern fn glfwCreateWindowSurface(instance: vk.Instance, window: *glfw.Window, vk_alloc_cb: ?*const vk.AllocationCallbacks, out_surface: *vk.SurfaceKHR) vk.Result; // vk 1.0
