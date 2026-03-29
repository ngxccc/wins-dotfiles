# ==========================================
# 🚀 ENTRY POINT (Bộ định tuyến)
# Trái tim của hệ thống, chỉ làm nhiệm vụ import
# ==========================================

. "$PSScriptRoot\alias.ps1"

# Bơm giao diện Oh-My-Posh & Icons
oh-my-posh init pwsh --config 'C:\Users\Admin\scoop\apps\oh-my-posh\current\themes\amro.omp.json' | Invoke-Expression
Import-Module Terminal-Icons

# Nạp động (Dynamic Loading) toàn bộ súng ống trong thư mục scripts
$scriptsDir = "$PSScriptRoot\scripts"
if (Test-Path $scriptsDir) {
    Get-ChildItem -Path $scriptsDir -Filter "*.ps1" | ForEach-Object {
        # Dùng Dot-Sourcing để bơm function vào Global Scope
        . $_.FullName
    }
}
