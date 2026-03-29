function make-link {
    <#
    .SYNOPSIS
    Tạo Symlink (liên kết mềm) siêu tốc.
    .DESCRIPTION
    Wrapper bọc lại lệnh New-Item cực dài của PowerShell để tạo SymbolicLink giống lệnh `ln -s` trên Linux.
    .EXAMPLE
    make-link -link "C:\alias" -target "D:\real_folder"
    #>
    param($link, $target)
    New-Item -ItemType SymbolicLink -Path $link -Target $target
}

function notepad {
    <#
    .SYNOPSIS
    Gọi triệu hồi Notepad++ thay thế hàng mặc định.
    .DESCRIPTION
    Đẩy toàn bộ arguments (tên file) thẳng vào process Notepad++ dưới nền (Start-Process) để không bị treo Terminal.
    #>
    Start-Process notepad++ $args
}

function scoop-export {
    <#
    .SYNOPSIS
    Backup toàn bộ ứng dụng Scoop ra file JSON.
    .DESCRIPTION
    Kết xuất (export) danh sách app đang cài đặt vào kho Dotfiles để sau này cài lại Win chỉ cần 1 lệnh là full đồ.
    #>
    scoop export > "$HOME\.config\scoop\scoop.json"
	Write-Host "✅ Đã export thành công!" -ForegroundColor Green
}

function y {
    <#
    .SYNOPSIS
    Bật Yazi Terminal File Manager và giữ lại context thư mục.
    .DESCRIPTION
    Tạo file Temp để Yazi ghi đè đường dẫn cuối cùng khi thoát, giúp PowerShell nhảy (cd) tới đúng vị trí đó thay vì quay lại điểm xuất phát.
    #>
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    if (Test-Path -Path $tmp) {
        $cwd = Get-Content -Path $tmp -TotalCount 1
        if ($cwd -ne $PWD.Path) { Set-Location -Path $cwd }
        Remove-Item -Path $tmp
    }
}

function dot-sync {
    <#
    .SYNOPSIS
    Tự động quét, đồng bộ và đẩy Dotfiles lên GitHub qua động cơ Chezmoi.
    
    .DESCRIPTION
    1. Gọi 'chezmoi re-add' để update biến động từ Target (ổ cứng) vào Source State.
    2. Dùng cơ chế Git Proxy (chezmoi git --) để soi trạng thái O(1).
    3. Tự động format Commit Message theo Timestamp và Push.
    #>
    Write-Host "🚀 Đang kích hoạt Radar Chezmoi quét lõi hệ thống..." -ForegroundColor Cyan

    # 1. BÍ THUẬT ÉP ĐỒNG BỘ: 
    # Quét tất cả các file hệ thống đã được Chezmoi theo dõi, 
    # nếu có thay đổi lén lút ở bên ngoài, gom hết vào Source State.
    Write-Host "🔄 Đang đối chiếu Target State và Source State..." -ForegroundColor Yellow
    chezmoi re-add

    # 2. Xuyên không qua Git Proxy để check biến động ở kho ẩn
    $status = chezmoi git -- status --porcelain
    
    if ([string]::IsNullOrWhiteSpace($status)) {
        Write-Host "⚡ Config đang nguyên vẹn, hệ thống tĩnh lặng!" -ForegroundColor DarkGray
    } else {
        Write-Host "📦 Phát hiện biến động config trong hầm chứa! Đang đóng gói..." -ForegroundColor Yellow
        
        # Gọi thẳng Git ở tầng dưới của Chezmoi
        chezmoi git -- add .
        
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        chezmoi git -- commit -m "chore: auto-sync dotfiles at $timestamp" | Out-Null
        
        Write-Host "🚀 Đang phóng tên lửa lên GitHub..." -ForegroundColor Cyan
        chezmoi git -- push
        
        Write-Host "✅ Sync Chezmoi thành công rực rỡ! Code đã được backup an toàn." -ForegroundColor Green
    }
}

function cdz {
	<#
	.SYNOPSIS
		Function wrapper để nhảy thẳng vào thư mục source của chezmoi 
		mà không đẻ thêm tiến trình mới.
	#>
    # Gọi chezmoi để lấy đường dẫn gốc (source-path)
    # Dùng biến cục bộ để code clean và dễ debug
    $ChezmoiPath = chezmoi source-path
    
    # Kiểm tra xem path có tồn tại không trước khi nhảy (Defensive Programming)
    if (Test-Path $ChezmoiPath) {
        Set-Location $ChezmoiPath
    } else {
        Write-Warning "🚩 Không tìm thấy thư mục source của chezmoi."
    }
}
