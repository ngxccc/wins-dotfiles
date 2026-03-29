function dot-help {
    <#
    .SYNOPSIS
    Menu tổng hợp các bí thuật (Auto Generate Doc).
    #>
    Clear-Host
    Write-Host "🚀 BẢNG PHONG THẦN - AUTO DOTFILES COMMANDS 🚀" -ForegroundColor Cyan

    # Sửa regex: Quét tất cả các hàm được định nghĩa trong thư mục scripts
    $customFunctions = Get-Command -CommandType Function | Where-Object {
        $_.ScriptBlock.File -match "scripts\\[^\\]+\.ps1$"
    }

    $commands = foreach ($cmd in $customFunctions) {
        $helpInfo = Get-Help $cmd.Name -ErrorAction SilentlyContinue
        $description = if (-not [string]::IsNullOrWhiteSpace($helpInfo.Synopsis)) { 
            $helpInfo.Synopsis.Trim() 
        } else { 
            "⚠️ Kẻ lười biếng chưa viết doc cho tool này!" 
        }

        [PSCustomObject]@{ Command = $cmd.Name; Description = $description }
    }
    $commands | Sort-Object Command | Format-Table -AutoSize | Out-String | Write-Host -ForegroundColor Green
}
Set-Alias -Name dh -Value dot-help