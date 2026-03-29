function block-winkey {
    <#
    .SYNOPSIS
    Khóa các tổ hợp phím Windows + <Key> (Ví dụ: Win+R, Win+D).
    
    .DESCRIPTION
    Sử dụng Registry để vô hiệu hóa hotkeys. Có tích hợp thuật toán lọc trùng lặp
    Idempotent (chỉ ghi khi có thay đổi) và tự động khởi động lại Explorer.
    
    .EXAMPLE
    block-winkey -keys "DRE"
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        # Ép kiểu String, cấm truyền Null hoặc chuỗi rỗng, bắt buộc phải nhập
        [Parameter(Mandatory=$true, Position=0, HelpMessage="Nhập chuỗi các phím cần khóa (VD: 'DRE')")]
        [ValidateNotNullOrEmpty()]
        [string]$keys
    )

    begin {
        $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $name = "DisabledHotkeys"
        # Chuẩn hóa input ngay từ đầu
        $keysToDisable = $keys.ToUpper()
    }

    process {
        # 1. Đọc value hiện tại (ép về chuỗi rỗng nếu null để tránh lỗi)
        $currentValue = (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue).$name
        if ([string]::IsNullOrWhiteSpace($currentValue)) { $currentValue = "" }

        # 2. Thuật toán hợp nhất và lọc trùng (Union & Deduplicate)
        $combined = $currentValue + $keysToDisable
        $newValue = -join ($combined.ToCharArray() | Select-Object -Unique)

        # 3. Tối ưu I/O: Chỉ chọc vào Registry nếu có sự thay đổi thực sự
        if ($currentValue -cne $newValue) { 
            
            # Khóa an toàn: Support chế độ -WhatIf để test trước khi chạy thật
            if ($PSCmdlet.ShouldProcess("Registry: $name", "Ghi đè giá trị mới: [$newValue]")) {
                
                if (-not (Test-Path $registryPath)) { New-Item -Path $registryPath -Force | Out-Null }
                Set-ItemProperty -Path $registryPath -Name $name -Value $newValue -PropertyType String -Force
                
                Write-Host "✅ Đã nạp bộ giáp khóa phím mới: [$newValue]" -ForegroundColor Green
                
                # Reset Explorer để ăn config
                Stop-Process -Name explorer -Force
                Write-Host "🔄 Đã khởi động lại Explorer! Bấm thử Win+$keysToDisable đi xem có trầm cảm không =))" -ForegroundColor Cyan
            }
        } else {
            Write-Host "⚡ Các phím [$keysToDisable] đã nằm gọn trong danh sách cấm [$currentValue] từ trước rồi, không cần ghi đè!" -ForegroundColor DarkGray
        }
    }
}

function unblock-winkey {
    <#
    .SYNOPSIS
    Mở khóa các tổ hợp phím Windows + <Key> đã bị phong ấn.
    
    .DESCRIPTION
    Gỡ bỏ các ký tự khỏi Registry DisabledHotkeys. Xử lý triệt để Edge Case chuỗi rỗng.
	
	.EXAMPLE
    unblock-winkey -keys "DRE" | "ALL"
    #>
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        # Ép kiểu String, cho phép nhập phím hoặc cờ 'ALL'
        [Parameter(Mandatory=$true, Position=0, HelpMessage="Nhập phím cần mở (VD: 'dre') hoặc 'ALL' để clear hết")]
        [ValidateNotNullOrEmpty()]
        [string]$keys
    )

    begin {
        $registryPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $name = "DisabledHotkeys"
        # Luôn uppercase để so khớp chính xác tuyệt đối với data trong Registry
        $keysToEnable = $keys.ToUpper()
    }

    process {
        # Đọc value hiện tại (ép về chuỗi rỗng nếu null để tránh crash logic)
        $currentValue = (Get-ItemProperty -Path $registryPath -Name $name -ErrorAction SilentlyContinue).$name
        
        if ([string]::IsNullOrEmpty($currentValue)) {
            Write-Host "⚡ Cởi chuồng sẵn rồi, không có giáp nào đang bật đâu bro!" -ForegroundColor DarkGray
            return
        }

        $newValue = $currentValue

        # Thuật toán Subtraction (Lọc bỏ)
        if ($keysToEnable -eq "ALL") {
            $newValue = ""
        } else {
            # Lặp qua từng ký tự user muốn xóa, Replace nó bằng chuỗi rỗng
            foreach ($char in $keysToEnable.ToCharArray()) {
                $newValue = $newValue.Replace($char.ToString(), "")
            }
        }

        # Tối ưu I/O: Chỉ tác động Registry nếu chuỗi thực sự thay đổi
        if ($currentValue -cne $newValue) {
            
            # Chế độ bảo vệ: Hỏi ý kiến trước khi chọc ngoáy (-WhatIf)
            if ($PSCmdlet.ShouldProcess("Registry: $name", "Gỡ giáp: [$keysToEnable] -> Trạng thái còn lại: [$newValue]")) {
                
                # EDGE CASE: Nếu gỡ xong mà chuỗi rỗng -> Dọn rác Registry luôn
                if ([string]::IsNullOrEmpty($newValue)) {
                    Remove-ItemProperty -Path $registryPath -Name $name -Force
                    Write-Host "✅ Đã gỡ sạch sẽ toàn bộ lệnh cấm Win+Key! Trả về Default OS." -ForegroundColor Green
                } else {
                    Set-ItemProperty -Path $registryPath -Name $name -Value $newValue -PropertyType String -Force
                    Write-Host "✅ Đã mở khóa [$keysToEnable]. Các phím vẫn đang bị cấm: [$newValue]" -ForegroundColor Yellow
                }
                
                # Hard reset UI process để API nhận diện lại cấu hình
                Stop-Process -Name explorer -Force
                Write-Host "🔄 Đã reset Explorer! Chơi lại Win+$keysToEnable mượt mà rồi nhé 🚀" -ForegroundColor Cyan
            }
        } else {
            Write-Host "⚡ Mấy phím [$keysToEnable] này vốn dĩ có bị khóa đâu mà đòi mở, ngáo à =))" -ForegroundColor DarkGray
        }
    }
}

function set-userenv {
    <#
    .SYNOPSIS
    Bơm biến môi trường thẳng vào lõi Registry (User Scope).
    .DESCRIPTION
    Đóng mộc vĩnh viễn cấu hình vào Windows. Chỉ nên chạy 1 lần lúc mới setup máy, không nên vứt vào profile để chạy auto mỗi lần mở Terminal tránh lag.
    .EXAMPLE
    set-userenv -name "EDITOR" -value "nvim"
    #>
    param(
        [Parameter(Mandatory=$true)][string]$name, 
        [Parameter(Mandatory=$true)][string]$value
    )
    
    # Quét Registry xem đã có chưa
    $currentValue = [Environment]::GetEnvironmentVariable($name, "User")
    
    if ($currentValue -ne $value) {
        # Đóng mộc vào Registry
        [Environment]::SetEnvironmentVariable($name, $value, "User")
        Write-Host "✅ Đã ghim $name = $value vĩnh viễn cho tài khoản của bạn!" -ForegroundColor Green
        
        # Buff nóng cho session hiện tại
        Set-Item -Path "Env:\$name" -value $value
    } else {
        Write-Host "⚡ Biến $name = $value đã chuẩn chỉ từ trước, bỏ qua I/O!" -ForegroundColor DarkGray
    }
}