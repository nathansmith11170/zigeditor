const std = @import("std");
const win32 = @import("win32.zig");

var operation = win32.WHITENESS;

pub export fn winproc(windowHandle: std.os.windows.HWND, uMsg: c_uint, wParam: c_ulonglong, lParam: c_longlong) callconv(std.os.windows.WINAPI) std.os.windows.LRESULT {
    if (uMsg == win32.WM_SIZE) {
        win32.OutputDebugStringW(std.unicode.utf8ToUtf16LeStringLiteral("WM_SIZE"));
    } else if (uMsg == win32.WM_CLOSE) {
        win32.OutputDebugStringW(std.unicode.utf8ToUtf16LeStringLiteral("WM_CLOSE"));
    } else if (uMsg == win32.WM_ACTIVATEAPP) {
        win32.OutputDebugStringW(std.unicode.utf8ToUtf16LeStringLiteral("WM_ACTIVATEAPP"));
    } else if (uMsg == win32.WM_PAINT) {
        var paint: win32.PAINTSTRUCT = std.mem.zeroes(win32.PAINTSTRUCT);
        const deviceContext = win32.BeginPaint(windowHandle, &paint);
        const x = paint.rcPaint.left;
        const y = paint.rcPaint.top;
        const width = paint.rcPaint.right - paint.rcPaint.left;
        const height = paint.rcPaint.bottom - paint.rcPaint.top;
        _ = win32.PatBlt(deviceContext, x, y, width, height, operation);
        if (operation == win32.WHITENESS) {
            operation = win32.BLACKNESS;
        } else {
            operation = win32.WHITENESS;
        }
        _ = win32.EndPaint(windowHandle, &paint);
    } else {
        return win32.DefWindowProcW(windowHandle, uMsg, wParam, lParam);
    }
    return 0;
}

pub export fn wWinMain(hInstance: std.os.windows.HINSTANCE, hPrevInstance: ?std.os.windows.HINSTANCE, pCmdLine: std.os.windows.LPWSTR, nCmdShow: c_int) c_int {
    _ = hPrevInstance;
    _ = pCmdLine;

    const CLASS_NAME = "Base Window Class";
    var wc: win32.WNDCLASSW = std.mem.zeroes(win32.WNDCLASSW);

    wc.lpfnWndProc = winproc;
    wc.hInstance = hInstance;
    wc.lpszClassName = std.unicode.utf8ToUtf16LeStringLiteral(CLASS_NAME);

    const classResult = win32.RegisterClassW(&wc);
    if (classResult == 0) {
        //TODO(nathan) logging
        win32.OutputDebugStringW(std.unicode.utf8ToUtf16LeStringLiteral("Could not register class\n"));
    }

    const result = win32.CreateWindowExW(
        0,
        wc.lpszClassName,
        std.unicode.utf8ToUtf16LeStringLiteral("zigeditor"),
        win32.WS_OVERLAPPEDWINDOW,
        win32.CW_USEDEFAULT,
        win32.CW_USEDEFAULT,
        win32.CW_USEDEFAULT,
        win32.CW_USEDEFAULT,
        null,
        null,
        hInstance,
        null,
    );

    if (result) |hwnd| {
        _ = win32.ShowWindow(hwnd, nCmdShow);

        var msg: win32.MSG = std.mem.zeroes(win32.MSG);
        while (true) {
            const message = win32.GetMessageW(&msg, hwnd, 0, 0);
            if (message > 0) {
                _ = win32.TranslateMessage(&msg);
                _ = win32.DispatchMessageW(&msg);
            } else {
                break;
            }
        }
    } else {
        win32.OutputDebugStringW(std.unicode.utf8ToUtf16LeStringLiteral("Invalid handle for some reason.\n"));
        // TODO(nathan) logging
        return 1;
    }

    return 0;
}
