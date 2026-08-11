# Ensure the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Please right-click and run this script AS ADMINISTRATOR!"
    Exit
}

# 1. Comprehensive list of target processes to terminate forcefully
$AppsToKill = @(
    # --- Newly Added (GlideX, ADB, Zoom VDI) ---
    "glidexremoteservice", "glidexservice", "glidexnearservice", "glidexserviceext", 
    "cptservice", "adb", "glidex",

    # --- Glider & Proctoring/Assessment Helpers ---
    "glider", "glider-agent", "GliderAI", "GliderService", "GliderHelper",
    "OverlayHelper", "OverlayHelperService", "Overlay", "GameBarOverlayServer",

    # Your specific additions & Remote tools
    "UltraViewer_Desktop", "UltraViewerService", "UltraViewer_Service", "WhatsApp", 
    "WebCompanion", "autodeskdesktopapp", "OperaBrowserAssistant", 
    "AdAppMgrSvc", "AutodeskAccess", "AdskAccessServiceHost", "outlook", "excel", 
    "winword", "powerpnt", "Claude", "claude", "Canva", "Copilot", "ms-teams", 
    "HPSystemEventUtilityHost", "ad_svc",
    
    # Core Browsers & Communication Tools
    "chrome", "msedge", "firefox", "opera", "brave", 
    "discord", "slack", "teams", "skype", "zoom", "webex",
    
    # Game Launchers, Overlays & Media
    "spotify", "steam", "epicgameslauncher", "origin", "obs", "obs64",
    "RiotClientServices", "DiscordCanary", "GeForceExperience", "NVIDIA Share",
    
    # System / Background tools to flush out
    "onedrive", "dropbox", "powertoys", "lightshot"
)

Write-Host "--- Terminating Target Applications & Background Processes ---" -ForegroundColor Cyan
foreach ($app in $AppsToKill) {
    if (Get-Process -Name $app -ErrorAction SilentlyContinue) {
        Write-Host "Force closing process: $app" -ForegroundColor Yellow
        Stop-Process -Name $app -Force -ErrorAction SilentlyContinue
    }
}

# 2. Stop & Disable Windows Services
$ServicesToProcess = @(
    # --- Newly Added Services ---
    "glidexremoteservice", "glidexservice", "glidexnearservice", "glidexserviceext",
    "cptservice",

    # Glider & Overlay Services
    "GliderService", "GliderAgent", "GliderUpdater", "OverlayHelperSvc", "OverlayHelper",

    # Remote Support & Device Services
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
        Write-Host "Setting $service startup to Disabled..." -ForegroundColor Gray
        Set-Service -Name $service -StartupType Disabled -ErrorAction SilentlyContinue
    }
}

# 3. Terminate Scheduled Tasks related to background helpers
Write-Host "`n--- Checking & Disabling Background Scheduled Tasks ---" -ForegroundColor Cyan
$TaskKeywords = @("Glider", "glidex", "OverlayHelper", "Overlay", "UltraViewer", "AnyDesk", "cptservice")

foreach ($keyword in $TaskKeywords) {
    $tasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "*$keyword*" } -ErrorAction SilentlyContinue
    foreach ($task in $tasks) {
        Write-Host "Disabling Scheduled Task: $($task.TaskName)" -ForegroundColor Yellow
        Disable-ScheduledTask -TaskName $task.TaskName -TaskPath $task.TaskPath -ErrorAction SilentlyContinue | Out-Null
    }
}

# 4. Flush Standard Command Consoles
Write-Host "`n--- Flushing Command Consoles ---" -ForegroundColor Cyan
$Consoles = @("cmd", "conhost")
foreach ($console in $Consoles) {
    Stop-Process -Name $console -Force -ErrorAction SilentlyContinue
}


Write-Host "`nAll targeted apps, GlideX/Glider/Overlay processes, and services successfully cleared! Ready for OnVUE." -ForegroundColor Green
