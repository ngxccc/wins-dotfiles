#Requires AutoHotkey v2.0
#SingleInstance Force

; ==========================================
; 🚀 BỘ ĐIỀU KHIỂN PHÍM TẮT TOÀN CỤC (AHK v2)
; ==========================================

if not A_IsAdmin {
    ; Gọi cờ *RunAs để kích hoạt bảng hỏi UAC của Windows
    Run '*RunAs "' A_ScriptFullPath '"'
    ExitApp ; Đóng bản quyền thấp hiện tại lại
}

; Hàm lấy đường dẫn terminal từ biến môi trường
GetTerminal() {
    ; EnvGet soi thẳng vào biến môi trường của Windows
    term := EnvGet("TERMINAL")
    
    ; Logic fallback an toàn: Nếu quên set biến, mở tạm pwsh
    if (term == "") {
        return "pwsh.exe"
    }
	
	if InStr(term, "wezterm") {
        return "wezterm-gui.exe"
    }
	
    return term
}

; Win + T: Mở Terminal
#t:: {
    targetApp := GetTerminal()
    Run(targetApp)
}

; Win + Q: Trảm cửa sổ đang Active
#q:: {
    ; "A" là tham số nội bộ của AHK, đại diện cho "Active Window" (Cửa sổ đang được focus)
    ; WinClose gửi lệnh WM_CLOSE (Đóng lịch sự, cho phép app hỏi Save file)
    WinClose("A") 
    
    ; Tip nâng cao: Nếu muốn nó tàn bạo như lệnh `xkill` của Linux (rút điện, chết luôn không kịp ngáp)
    ; thì comment dòng WinClose ở trên lại và xài dòng WinKill bên dưới:
    ; WinKill("A")
}

#c::CenterActiveWindow()

CenterActiveWindow() {
    ; 1. Lấy mã định danh (HWND) của app em vừa mở từ Keypirinha
    active_id := WinGetID("A")
    if !active_id
        return

    ; 2. Lấy chiều dài (W), chiều cao (H) của cái app đó
    WinGetPos(&appX, &appY, &appW, &appH, active_id)

    ; 3. Lấy kích thước của Màn hình (Đã trừ đi cái Taskbar bên dưới)
    MonitorGetWorkArea(1, &screenLeft, &screenTop, &screenRight, &screenBottom)
    screenWidth := screenRight - screenLeft
    screenHeight := screenBottom - screenTop

    ; 4. Thuật toán căn giữa siêu kinh điển
    newX := screenLeft + (screenWidth - appW) / 2
    newY := screenTop + (screenHeight - appH) / 2

    ; 5. Nắm đầu ném nó ra giữa
    WinMove(newX, newY, appW, appH, active_id)
}

; Win + F: Fullscreen cửa sổ đang Active
#f:: {
    ; "A" là Active Window
    active_id := WinGetID("A")
    
    ; Đọc bộ quần áo (Style) hiện tại của cửa sổ
    style := WinGetStyle("ahk_id " active_id)
    
    ; 0x00C00000 = WS_CAPTION (Thanh tiêu đề)
    ; Dùng toán tử AND (&) để check xem nó có đang mặc áo không
    if (style & 0x00C00000) {
        ; ĐANG CÓ VIỀN -> Lột viền và Phóng to
        WinSetStyle("-0x00C00000", "ahk_id " active_id) ; Trừ đi Caption
        WinSetStyle("-0x00040000", "ahk_id " active_id) ; Trừ đi Sizebox
        WinMaximize("ahk_id " active_id)
    } else {
        ; KHÔNG CÓ VIỀN -> Mặc lại viền và Thu nhỏ về cũ
        WinSetStyle("+0x00C00000", "ahk_id " active_id)
        WinSetStyle("+0x00040000", "ahk_id " active_id)
        WinRestore("ahk_id " active_id)
    }
}