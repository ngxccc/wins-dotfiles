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

#+l::DllCall("user32.dll\LockWorkStation")