$global:overallPass = $true
$global:Summary = @()

function Add-Result {
    param(
        [string]$Check,
        [string]$Value,
        [string]$Status
    )

    $global:Summary += [PSCustomObject]@{
        Check  = $Check
        Value  = $Value
        Status = $Status
    }

    if ($Status -eq "PASS") {
        Write-Host "[PASS] $Check : $Value" -ForegroundColor Green
    }
    else {
        Write-Host "[FAIL] $Check : $Value" -ForegroundColor Red
        $global:overallPass = $false
    }
}

Clear-Host

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       SYSTEM REQUIREMENTS CHECK" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# RAM CHECK (>= 8 GB)

$ramGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)

if ($ramGB -ge 8) {
    Add-Result "RAM" "$ramGB GB" "PASS"
}
else {
    Add-Result "RAM" "$ramGB GB (Minimum 8 GB Required)" "FAIL"
}

# DISK CHECK (>= 1 TB)

$totalDiskTB = [math]::Round(
    ((Get-CimInstance Win32_DiskDrive | Measure-Object Size -Sum).Sum / 1TB),
    2
)

if ($totalDiskTB -ge 1) {
    Add-Result "Disk Capacity" "$totalDiskTB TB" "PASS"
}
else {
    Add-Result "Disk Capacity" "$totalDiskTB TB (Minimum 1 TB Required)" "FAIL"
}

# CAMERA CHECK

$camera = Get-PnpDevice -Class Camera -ErrorAction SilentlyContinue

if ($camera) {
    Add-Result "Camera" "Detected" "PASS"

    try {
        Start-Process "microsoft.windows.camera:"
    }
    catch {
        Write-Host "Unable to open Camera app." -ForegroundColor Yellow
    }
}
else {
    Add-Result "Camera" "Not Detected" "FAIL"
}

# MICROPHONE CHECK

$audioDevices = Get-CimInstance Win32_SoundDevice -ErrorAction SilentlyContinue

if ($audioDevices) {
    Add-Result "Microphone" "Detected" "PASS"

    try {
        Start-Process "ms-settings:sound"
    }
    catch {
        Write-Host "Unable to open Sound settings." -ForegroundColor Yellow
    }
}
else {
    Add-Result "Microphone" "Not Detected" "FAIL"
}

# SPEAKER CHECK

try {
    [console]::Beep(1000,700)
    Add-Result "Speaker" "Test Signal Sent" "PASS"
}
catch {
    Add-Result "Speaker" "Speaker Test Failed" "FAIL"
}

# NETWORK CHECK

Write-Host ""
Write-Host "Checking Network..." -ForegroundColor Cyan

$speedtest = Get-Command speedtest -ErrorAction SilentlyContinue

if (-not $speedtest) {

    Write-Host "Installing Speedtest CLI..." -ForegroundColor Yellow

    $winget = Get-Command winget -ErrorAction SilentlyContinue

    if ($winget) {

        winget install --id Ookla.Speedtest.CLI `
            --accept-package-agreements `
            --accept-source-agreements `
            --silent

        Start-Sleep -Seconds 10

        $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" +
                    [Environment]::GetEnvironmentVariable("Path","User")

        $speedtest = Get-Command speedtest -ErrorAction SilentlyContinue
    }
}

if ($speedtest) {

    try {

        $result = speedtest --accept-license --accept-gdpr --format=json | ConvertFrom-Json

        $downloadMbps = [math]::Round(($result.download.bandwidth * 8) / 1000000, 2)
        $uploadMbps   = [math]::Round(($result.upload.bandwidth * 8) / 1000000, 2)
        $latency      = [math]::Round($result.ping.latency, 2)

        if ($downloadMbps -ge 12) {
            Add-Result "Download Speed" "$downloadMbps Mbps" "PASS"
        }
        else {
            Add-Result "Download Speed" "$downloadMbps Mbps (Min 12 Mbps)" "FAIL"
        }

        if ($uploadMbps -ge 3) {
            Add-Result "Upload Speed" "$uploadMbps Mbps" "PASS"
        }
        else {
            Add-Result "Upload Speed" "$uploadMbps Mbps (Min 3 Mbps)" "FAIL"
        }

        if ($latency -le 150) {
            Add-Result "Latency" "$latency ms" "PASS"
        }
        else {
            Add-Result "Latency" "$latency ms (Max 150 ms)" "FAIL"
        }
    }
    catch {
        Add-Result "Network Test" "Speed Test Failed" "FAIL"
    }
}
else {
    Add-Result "Network Test" "Unable To Run Speedtest CLI" "FAIL"
}

# WINDOWS DEFENDER REAL-TIME PROTECTION

try {
    Start-Process "windowsdefender://threatsettings"
}
catch {
    Write-Host "Unable to open Windows Defender settings." -ForegroundColor Yellow
}

# SUMMARY REPORT

Write-Host ""
Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "                           SUMMARY REPORT" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

$header = "{0,-25} {1,-35} {2,-10}" -f "CHECK","VALUE","STATUS"
Write-Host $header -ForegroundColor White
Write-Host ("-" * 75)

foreach ($item in $Summary) {

    $line = "{0,-25} {1,-35} {2,-10}" -f `
        $item.Check,
        $item.Value,
        $item.Status

    if ($item.Status -eq "PASS") {
        Write-Host $line -ForegroundColor Green
    }
    else {
        Write-Host $line -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Cyan

if ($overallPass) {
    Write-Host "FINAL RESULT : PASS" -ForegroundColor Green
}
else {
    Write-Host "FINAL RESULT : FAIL" -ForegroundColor Red
}

Write-Host "======================================================================" -ForegroundColor Cyan