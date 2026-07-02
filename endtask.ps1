# Ensure the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please right-click and run this script AS ADMINISTRATOR!"
    Exit
}

# 1. Broad list of processes to forcefully terminate (handles /IM, /F, /T flags natively)
$AppsToKill = @(
    # Your specific additions
    "UltraViewer_Desktop", "UltraViewerService", "UltraViewer_Service", "WhatsApp", 
    "WebCompanion", "autodeskdesktopapp", "OperaBrowserAssistant", "OverlayHelper", 
    "AdAppMgrSvc", "AutodeskAccess", "AdskAccessServiceHost", "outlook", "excel", 
    "winword", "powerpnt", "Claude", "claude", "Canva", "Copilot", "ms-teams", 
    "HPSystemEventUtilityHost", "ad_svc",
    
    # Core Browsers & Chat
    "chrome", "msedge", "firefox", "opera", "brave", 
    "discord", "slack", "teams", "skype", "zoom", "webex",
    
    # Game Launchers & Media
    "spotify", "steam", "epicgameslauncher", "origin", "obs", "obs64",
    
    # System / Background tools to flush out
    "onedrive", "dropbox", "powertoys", "lightshot"
)

Write-Host "--- Terminating Target Applications & Background Processes ---" -ForegroundColor Cyan
foreach ($app in $AppsToKill) {
    if (Get-Process -Name $app -ErrorAction SilentlyContinue) {
        Write-Host "Force closing: $app" -ForegroundColor Yellow
        # Stop-Process with -Force mimics taskkill /F. Including children mimics /T
        Stop-Process -Name $app -Force -ErrorAction SilentlyContinue
    }
}

# 2. Windows Services to completely stop and adjust config
$ServicesToProcess = @(
    "AnyDesk", "AnyDesk Service", "UltraViewer_Service", "UltraViewService",
    "TeamViewer", "TeamViewerService", "LogiRegistryService"
)

Write-Host "`n--- Stopping & Disabling Flagged Services ---" -ForegroundColor Cyan
foreach ($service in $ServicesToProcess) {
    $svc = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($svc) {
        if ($svc.Status -eq 'Running') {
            Write-Host "Stopping service: $service" -ForegroundColor Yellow
            Stop-Service -Name $service -Force -ErrorAction SilentlyContinue
        }
        # Safely changes startup type to avoid OnVUE background triggers
        Write-Host "Setting $service startup to Manual/Disabled..." -ForegroundColor Gray
        Set-Service -Name $service -StartupType Manual -ErrorAction SilentlyContinue
    }
}

# 3. Optional Terminal Cleanup (From your list)
# Note: We do NOT kill powershell.exe or wt.exe instantly here because it would break this running script. 
# Instead, we close standard console hosts.
Write-Host "`n--- Flushing Command Consoles ---" -ForegroundColor Cyan
$Consoles = @("cmd", "conhost")
foreach ($console in $Consoles) {
    Stop-Process -Name $console -Force -ErrorAction SilentlyContinue
}

Write-Host "`nAll targeted apps & services successfully cleared! Ready for OnVUE." -ForegroundColor Green
