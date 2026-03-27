oh-my-posh init pwsh --config 'C:\Users\Admin\scoop\apps\oh-my-posh\current\themes\amro.omp.json' | Invoke-Expression

# Install-Module -Name Terminal-Icons -Scope CurrentUser -Force

Import-Module Terminal-Icons

Set-Alias -Name vim -Value nvim
Set-Alias -Name ls -Value Get-ChildItem

. "$PSScriptRoot\helpers.ps1"