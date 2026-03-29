# ==========================================
# 🚀 WINDOWS POST-INSTALL AUTOMATION SCRIPT
# Tích hợp hệ kép: Scoop (User) & Choco (System)
# ==========================================

# Rào chắn: Ép buộc phải có quyền Admin mới cho chạy
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Warning "🛑 Kẹt ga rồi! Chạy script này bắt buộc phải mở PowerShell dưới quyền Administrator nhé bro!"
    Exit
}

Write-Host "🚀 Bắt đầu thiết lập môi trường Windows..." -ForegroundColor Cyan

# ------------------------------------------
# 1. KHỞI TẠO LÕI CHOCOLATEY (System Level)
# ------------------------------------------
Write-Host "[1/5] 🍫 Khởi động lò rèn Chocolatey..." -ForegroundColor Yellow
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "      ⏳ Choco chưa tồn tại. Đang triệu hồi..." -ForegroundColor DarkGray
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "      ✅ Chocolatey đã sẵn sàng." -ForegroundColor Green
}

# ------------------------------------------
# 2. KHỞI TẠO LÕI SCOOP & BUCKETS (User Level)
# ------------------------------------------
Write-Host "[2/5] 🍦 Khởi động lõi Scoop..." -ForegroundColor Yellow
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "      ⏳ Scoop chưa tồn tại. Đang triệu hồi..." -ForegroundColor DarkGray
    irm get.scoop.sh | iex
} else {
    Write-Host "      ✅ Scoop đã sẵn sàng." -ForegroundColor Green
}
scoop bucket add extras | Out-Null
scoop bucket add nerd-fonts | Out-Null

# ------------------------------------------
# 3. CÀI ĐẶT CÁC VŨ KHÍ HẠNG NẶNG TỪ CHOCO
# ------------------------------------------
$chocoJsonPath = "$PSScriptRoot\choco-apps.json"
$chocoLibPath = "$env:ChocolateyInstall\lib"

if (Test-Path $chocoJsonPath) {
    $chocoApps = Get-Content -Path $chocoJsonPath | ConvertFrom-Json
    
    if ($null -ne $chocoApps -and $chocoApps.Count -gt 0) {
        foreach ($app in $chocoApps) {
            if (Test-Path "$chocoLibPath\$app") {
                Write-Host "      ⚡ Bỏ qua [$app]: Cây súng này đã nằm sẵn trong kho!" -ForegroundColor DarkGray
            } else {
                Write-Host "      -> Bắn: Đang setup [$app]..." -ForegroundColor Cyan
                choco install $app -y | Out-Null
            }
        }
    }
}

# ------------------------------------------
# 4. ĐỒNG BỘ APP CLI TỪ DOTFILES (JSON) - SCOOP
# ------------------------------------------
Write-Host "[4/5] 📦 Nạp danh sách vũ khí từ kho chứa (scoop.json)..." -ForegroundColor Yellow
$scoopManifest = "$PSScriptRoot\..\scoop\scoop.json"

if (Test-Path $scoopManifest) {
    scoop import $scoopManifest
    Write-Host "      ✅ Đã import toàn bộ app CLI từ Dotfiles!" -ForegroundColor Green
} else {
    Write-Warning "      ⚠️ Không tìm thấy file scoop.json! Bỏ qua phase này."
}

# ------------------------------------------
# 5. 🚨 CƠ CHẾ BÁO CÁO NHỮNG APP CẦN CÀI TAY (Data-Driven) 🚨
# ------------------------------------------
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "🎉 HOÀN TẤT TỰ ĐỘNG HÓA! Môi trường đã lên đèn!" -ForegroundColor Green
Write-Host "=========================================="

$manualJsonPath = "$PSScriptRoot\manual-apps.json"

if (Test-Path $manualJsonPath) {
    # Đọc trực tiếp từ file JSON bên ngoài, không còn Hardcode nữa
    $manualInstalls = Get-Content -Path $manualJsonPath | ConvertFrom-Json
    Write-Host "🛑 BÁO CÁO NỢ NẦN: Bạn cần tự cài tay các phần mềm sau:" -ForegroundColor Red
    $manualInstalls | Format-Table -Property AppName, Reason -AutoSize | Out-String | Write-Host -ForegroundColor Yellow
} else {
    Write-Warning "Không tìm thấy file danh sách nợ nần manual-apps.json!"
}

# ------------------------------------------
# 6. 🔗 KÍCH HOẠT LINH HỒN (POWERSHELL PROFILE)
# ------------------------------------------
Write-Host "[6/6] 🧠 Đang nối dây thần kinh cho PowerShell..." -ForegroundColor Yellow

# Xác định vị trí file profile (Thường là Documents\PowerShell\...)
$profileDir = Split-Path -Parent $PROFILE
$targetScript = "$HOME\.config\powershell\user_profile.ps1"
$profileContent = ". `"$targetScript`""

# Tạo thư mục chứa profile nếu Windows chưa tạo (Thường bị thiếu trên máy mới)
if (-not (Test-Path $profileDir)) {
    New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
    Write-Host "      📂 Đã tạo thư mục Profile: $profileDir" -ForegroundColor DarkGray
}

# Kiểm tra xem đã nối dây chưa (Idempotent)
if (Test-Path $PROFILE) {
    $existingContent = Get-Content -Path $PROFILE
    if ($existingContent -match [regex]::Escape($profileContent)) {
        Write-Host "      ✅ Profile đã được nối dây từ trước. Skipping!" -ForegroundColor Green
    } else {
        # Nếu file có nội dung khác, ta Append (thêm vào cuối) thay vì ghi đè
        Add-Content -Path $PROFILE -Value "`n$profileContent"
        Write-Host "      ➕ Đã thêm lệnh nạp config vào Profile hiện tại." -ForegroundColor Cyan
    }
} else {
    # Nếu chưa có file, tạo mới và ghi nội dung nạp config
    Set-Content -Path $PROFILE -Value $profileContent -Force
    Write-Host "      ✨ Đã khởi tạo file Profile mới và nối dây thành công!" -ForegroundColor Green
}

# Gắn Symlink cho AHK
if (Test-Path "$HOME\.config\ahk\hotkeys.ahk") {
    make-link -link "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\hotkeys.lnk" -target "$HOME\.config\ahk\hotkeys.ahk"
	make-link -link "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\komorebi-keys.lnk" -target "$HOME\.config\komorebi\komorebi.ahk"
    Write-Host "      🎹 Đã nạp AutoHotkey vào danh sách Startup." -ForegroundColor Green
}
