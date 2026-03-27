# 1. Khai báo đường dẫn Registry cho đuôi "." và File Class mới
$extPath = "Registry::HKEY_CLASSES_ROOT\."
$classPath = "Registry::HKEY_CLASSES_ROOT\BlankFile"

# 2. Tạo File Class (Giấy khai sinh) và gán tên hiển thị là "Blank File"
if (!(Test-Path $classPath)) { New-Item -Path $classPath -Force | Out-Null }
Set-Item -Path $classPath -Value "Blank File" -Force

# 3. Map cái đuôi "." vào class "BlankFile" vừa tạo
if (!(Test-Path $extPath)) { New-Item -Path $extPath -Force | Out-Null }
Set-Item -Path $extPath -Value "BlankFile" -Force

# 4. Bơm NullFile vào nhánh ShellNew để kích hoạt tính năng tạo file
$shellNewPath = "$extPath\ShellNew"
if (!(Test-Path $shellNewPath)) { New-Item -Path $shellNewPath -Force | Out-Null }
Set-ItemProperty -Path $shellNewPath -Name "NullFile" -Value "" -Force

# 5. Khởi động lại UI của Windows để ăn setting ngay lập tức
Stop-Process -Name explorer -Force
Write-Host "✅ Done rùi! Ra desktop chuột phải check lại mục New nha!" -ForegroundColor Green