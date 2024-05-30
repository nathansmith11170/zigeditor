const std = @import("std");
const win = std.os.windows;

pub const WM_SIZE = 0x0005;
pub const WM_CLOSE = 0x0010;
pub const WM_ACTIVATEAPP = 0x001C;
pub const WM_DESTROY = 0x002;
pub const WM_PAINT = 0x00F;
pub const WS_OVERLAPPEDWINDOW = 13565952;
pub const CW_USEDEFAULT = -2147483648;
pub const WHITENESS: c_ulong = 0x00FF0062;
pub const BLACKNESS: c_ulong = 0x00000042;
pub const FORMAT_MESSAGE_FROM_SYSTEM = 4096;
pub const FORMAT_MESSAGE_ALLOCATE_BUFFER = 0x00000100;

pub const PAINTSTRUCT = extern struct {
    hdc: win.HDC,
    fErase: win.BOOL,
    rcPaint: win.RECT,
    fRestore: win.BOOL,
    fIncUpdate: win.BOOL,
    rgbReserved: [32]win.BYTE,
};

pub const WNDCLASSW = extern struct {
    style: win.UINT,
    lpfnWndProc: *const fn (windowHandle: win.HWND, uMsg: c_uint, wParam: c_ulonglong, lParam: c_longlong) callconv(win.WINAPI) win.LRESULT,
    cbClsExtra: c_int,
    cbWndExtra: c_int,
    hInstance: win.HINSTANCE,
    hIcon: win.HICON,
    hCursor: win.HCURSOR,
    hbrBackground: win.HBRUSH,
    lpszMenuName: win.LPCWSTR,
    lpszClassName: win.LPCWSTR,
};

pub const MSG = extern struct {
    hwnd: win.HWND,
    message: win.UINT,
    wParam: win.WPARAM,
    lParam: win.LPARAM,
    time: win.DWORD,
    pt: win.POINT,
    lPrivate: win.DWORD,
};

pub extern fn OutputDebugStringW(lpOutputString: [*c]const c_ushort) callconv(win.WINAPI) void;

pub extern fn DefWindowProcW(
    windowHandle: win.HWND,
    message: c_uint,
    wParam: c_ulonglong,
    lParam: c_longlong,
) callconv(win.WINAPI) win.LRESULT;

pub extern fn BeginPaint(
    hWnd: win.HWND,
    lpPaint: *PAINTSTRUCT,
) callconv(win.WINAPI) win.HDC;

pub extern fn PatBlt(
    hdc: win.HDC,
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,
    rop: c_ulong,
) callconv(win.WINAPI) win.BOOL;

pub extern fn EndPaint(
    hWnd: win.HWND,
    lpPaint: *const PAINTSTRUCT,
) callconv(win.WINAPI) win.BOOL;

pub extern fn RegisterClassW(pnl: *WNDCLASSW) callconv(win.WINAPI) win.ATOM;

pub extern fn CreateWindowExW(
    dwExStyle: win.DWORD,
    lpClassName: win.LPCWSTR,
    lpWindowName: win.LPCWSTR,
    dwStyle: win.DWORD,
    x: c_int,
    y: c_int,
    nWidth: c_int,
    nHeight: c_int,
    hWndParent: ?win.HWND,
    hMenu: ?win.HMENU,
    hInstance: win.HINSTANCE,
    lpParam: ?win.LPVOID,
) callconv(win.WINAPI) ?win.HWND;

pub extern fn ShowWindow(hWnd: win.HWND, nCmdShow: c_int) callconv(win.WINAPI) win.BOOL;

pub extern fn GetMessageW(
    lpMsg: *MSG,
    hWnd: win.HWND,
    wMsgFilterMin: win.UINT,
    wMsgFilterMax: win.UINT,
) callconv(win.WINAPI) win.BOOL;

pub extern fn TranslateMessage(lpMsg: *MSG) callconv(win.WINAPI) win.BOOL;

pub extern fn DispatchMessageW(lpMsg: *MSG) callconv(win.WINAPI) win.LRESULT;

pub extern fn GetLastError() callconv(win.WINAPI) win.DWORD;

pub extern fn FormatMessageW(
    dwFlags: win.DWORD,
    lpSource: ?win.LPCVOID,
    dwMessageId: win.DWORD,
    dwLanguageId: win.DWORD,
    lpBuffer: win.LPWSTR,
    nSize: win.DWORD,
    args: ?win.va_list,
) callconv(win.WINAPI) win.DWORD;
