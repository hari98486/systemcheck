# Run PowerShell as Administrator

# ============================================================
# Detect installed antivirus products
# ============================================================

$AV = Get-CimInstance `
    -Namespace root/SecurityCenter2 `
    -ClassName AntivirusProduct |
    Select-Object displayName, productState, pathToSignedProductExe

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Detected Antivirus Products" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$AV | Format-Table -AutoSize

# ============================================================
# Process each detected antivirus
# ============================================================

foreach ($Product in $AV) {

    $Name = $Product.displayName

    Write-Host ""
    Write-Host "Checking: $Name" -ForegroundColor Cyan

    # --------------------------------------------------------
    # McAfee
    # --------------------------------------------------------

    if ($Name -match "(?i)McAfee") {

        Write-Host "McAfee detected." -ForegroundColor Yellow

        New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null

        $url = "https://download.mcafee.com/molbin/iss-loc/SupportTools/MCPR/MCPR.exe"
        $dest = "C:\Temp\MCPR.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest

        Start-Process "C:\Temp\MCPR.exe" -Verb RunAs -Wait

        Write-Host "McAfee removal tool finished." -ForegroundColor Green
    }

    # --------------------------------------------------------
    # Avast
    # --------------------------------------------------------

    elseif ($Name -match "(?i)Avast") {

        Write-Host "Avast detected." -ForegroundColor Yellow

        New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null

        $url = "https://bits.avcdn.net/productcl/AVAST_CLEAR"
        $dest = "C:\Temp\avastclear.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest

        bcdedit /set "{current}" safeboot minimal

        Write-Host "Avast Clear downloaded." -ForegroundColor Green
        Write-Host "Safe Mode has been configured." -ForegroundColor Yellow
        Write-Host "Restart the computer and run C:\Temp\avastclear.exe" -ForegroundColor Yellow
    }

    # --------------------------------------------------------
    # Kaspersky
    # --------------------------------------------------------

    elseif ($Name -match "(?i)Kaspersky") {

        Write-Host "Kaspersky detected." -ForegroundColor Yellow

        New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null

        $url = "https://devbuilds.kaspersky-labs.com/devbuilds/KAVRemover/kavremvr.exe"
        $dest = "C:\Temp\kavremvr.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest

        Start-Process `
            "C:\Temp\kavremvr.exe" `
            -ArgumentList "--silent", "--nodetect" `
            -Wait

        Write-Host "Kaspersky removal tool finished." -ForegroundColor Green
    }

    # --------------------------------------------------------
    # Norton 360
    # --------------------------------------------------------

    elseif ($Name -match "(?i)Norton") {

        Write-Host "Norton detected." -ForegroundColor Yellow

        New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null

        $url = "https://norton.com/nrnr"
        $dest = "C:\Temp\NRnR.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest

        Start-Process `
            "C:\Temp\NRnR.exe" `
            -Wait

        Write-Host "Norton removal tool finished." -ForegroundColor Green
    }

    # --------------------------------------------------------
    # Bitdefender Total Security
    # --------------------------------------------------------

    elseif ($Name -match "(?i)Bitdefender") {

        Write-Host "Bitdefender detected." -ForegroundColor Yellow

        New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null

        $url = "https://www.bitdefender.com/files/KnowledgeBase/file/Bitdefender_2020_UninstallTool.exe"
        $dest = "C:\Temp\Bitdefender_UninstallTool.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest

        Start-Process `
            "C:\Temp\Bitdefender_UninstallTool.exe" `
            -Wait

        Write-Host "Bitdefender removal tool finished." -ForegroundColor Green
    }

    # --------------------------------------------------------
    # ESET / NOD32
    # --------------------------------------------------------

    elseif ($Name -match "(?i)ESET|NOD32") {

        Write-Host "ESET/NOD32 detected." -ForegroundColor Yellow

        New-Item -Path "C:\Temp" -ItemType Directory -Force | Out-Null

        $url = "https://download.eset.com/com/eset/tools/installers/eset_uninstaller/latest/esetuninstaller.exe"
        $dest = "C:\Temp\ESETUninstaller.exe"

        Invoke-WebRequest -Uri $url -OutFile $dest

        bcdedit /set "{current}" safeboot network

        Write-Host "ESET Uninstaller downloaded." -ForegroundColor Green
        Write-Host "Safe Mode with Networking has been configured." -ForegroundColor Yellow

        Write-Host "Restarting computer..." -ForegroundColor Yellow

        shutdown.exe /r /t 0
    }

    # --------------------------------------------------------
    # Trend Micro Maximum Security
    # --------------------------------------------------------

    elseif ($Name -match "(?i)Trend\s*Micro") {

        Write-Host "Trend Micro detected." -ForegroundColor Yellow

        $path = Get-ChildItem `
            -Path "C:\Program Files\Trend Micro", `
                  "C:\Program Files (x86)\Trend Micro" `
            -Recurse `
            -Filter "supporttool.exe" `
            -ErrorAction SilentlyContinue |
            Select-Object -First 1 -ExpandProperty FullName

        if ($path) {

            Write-Host "Trend Micro Support Tool found:" -ForegroundColor Green
            Write-Host $path

            Start-Process `
                $path `
                -ArgumentList "/uninstall" `
                -Wait

            Write-Host "Trend Micro removal process finished." -ForegroundColor Green
        }
        else {

            Write-Host "Diagnostic toolkit not found." -ForegroundColor Red
            Write-Host "Use Trend Micro Method 2 for removal." -ForegroundColor Yellow
        }
    }

    # --------------------------------------------------------
    # Unsupported antivirus
    # --------------------------------------------------------

    else {

        Write-Host "Unsupported antivirus: $Name" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Antivirus processing completed."
Write-Host "========================================" -ForegroundColor Green