function pg-up {
    <#
    .SYNOPSIS
    Kích hoạt PostgreSQL service (Buff mana).
    .DESCRIPTION
    Quét và ép khởi động toàn bộ background services có tiền tố "postgresql-". Cảnh báo lỗi ngay nếu bị kẹt port.
    #>
    Write-Host "🚀 Đang buff mana cho PostgreSQL..." -ForegroundColor Cyan
    Start-Service -Name "postgresql-*" -ErrorAction Stop
    Write-Host "✅ Database đã lên đèn ở port 5432! Chiến thôi!" -ForegroundColor Green
}

function pg-down {
    <#
    .SYNOPSIS
    Tắt nóng PostgreSQL service (Đi ngủ).
    .DESCRIPTION
    Force stop các tiến trình PostgreSQL để giải phóng RAM/CPU khi không code.
    #>
    Write-Host "💤 Đang cho PostgreSQL đi ngủ..." -ForegroundColor Yellow
    Stop-Service -Name "postgresql-*" -Force
    Write-Host "🛑 Đã sập nguồn Database an toàn!" -ForegroundColor Red
}

function pg-st {
    <#
    .SYNOPSIS
    Soi status của con PostgreSQL.
    .DESCRIPTION
    Truy xuất thẳng vào Service Control Manager để xem service đang Running hay Stopped.
    #>
    Get-Service -Name "postgresql-*" | Select-Object Status, Name, DisplayName
}