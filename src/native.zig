const glfw = @import("lib.zig");


pub extern fn glfwGetWin32Adapter(monitor: *glfw.Monitor) ?[*:0]const u8;
pub extern fn glfwGetWin32Monitor(monitor: *glfw.Monitor) ?[*:0]const u8;
pub extern fn glfwGetWin32Window(window: *glfw.Window) ?*anyopaque;

pub extern fn glfwGetWGLContext(window: *glfw.Window) ?*anyopaque;

//pub extern fn glfwGetCocoaMonitor(monitor: *glfw.Monitor) ?
pub extern fn glfwGetCocoaWindow(window: *glfw.Window) ?*anyopaque;
pub extern fn glfwGetCocoaView(window: *glfw.Window) ?*anyopaque;

pub extern fn glfwGetNSGLContext(window: *glfw.Window) ?*anyopaque;

pub extern fn glfwGetX11Display() ?*anyopaque;
pub extern fn glfwGetX11Adapter(monitor: *glfw.Monitor) c_ulong;
pub extern fn glfwGetX11Monitor(monitor: *glfw.Monitor) c_ulong;
pub extern fn glfwGetX11Window(window: *glfw.Window) c_ulong;
pub extern fn glfwSetX11SelectionString(string: [*:0]const u8) void;
pub extern fn glfwGetX11SelectionString() ?[*:0]const u8;

pub extern fn glfwGetGLXContext(window: *glfw.Window) ?*anyopaque;
pub extern fn glfwGetGLXWindow(window: *glfw.Window) c_ulong;

pub extern fn glfwGetWaylandDisplay() ?*anyopaque;
pub extern fn glfwGetWaylandMonitor(monitor: *glfw.Monitor) ?*anyopaque;
pub extern fn glfwGetWaylandWindow(window: *glfw.Window) ?*anyopaque;

//pub extern fn glfwGetEGLDisplay() ?
//pub extern fn glfwGetEGLContext(window: *glfw.Window) ?
//pub extern fn glfwGetEGLSurface(window: *glfw.Window) ?

pub extern fn glfwGetOSMesaColorBuffer(window: *glfw.Window, width: ?*glfw.Int, height: ?*glfw.Int, format: ?*glfw.Int, buffer: ?*?*anyopaque) glfw.Bool;
pub extern fn glfwGetOSMesaDepthBuffer(window: *glfw.Window, width: ?*glfw.Int, height: ?*glfw.Int, bytes_per_value: ?*glfw.Int, buffer: ?*?*anyopaque) glfw.Bool;
pub extern fn glfwGetOSMesaContext(window: *glfw.Window) ?*anyopaque;
