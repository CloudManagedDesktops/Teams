# install Teams related plugins - start with C++ Redistributable


write-host ' Customization: Install the latest Microsoft Visual C++ Redistributable'

$appName = 'teams'

$drive = 'C:\'

New-Item -Path $drive -Name $appName -ItemType Directory -ErrorAction SilentlyContinue
reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsWVDEnvironment /t REG_DWORD /d 1 /f /reg:64
reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsW365Environment /t REG_DWORD /d 1 /f /reg:64

$LocalPath = $drive + '\' + $appName

set-Location $LocalPath

$visCplusURL = 'https://aka.ms/vs/16/release/vc_redist.x64.exe'

$visCplusURLexe = 'vc_redist.x64.exe'

$outputPath = $LocalPath + '\' + $visCplusURLexe

Invoke-WebRequest -Uri $visCplusURL -OutFile $outputPath

write-host ' Customization: Starting Install the latest Microsoft Visual C++ Redistributable'

Start-Process -FilePath $outputPath -Args "/install /quiet /norestart /log vcdist.log" -Wait

write-host 'Customization: Finished Install the latest Microsoft Visual C++ Redistributable'

# install webSoc svc

write-host 'Customization: Install the Teams WebSocket Service'

$webSocketsURL = 'https://aka.ms/msrdcwebrtcsvc/msi'

$webSocketsInstallerMsi = 'webSocketSvc.msi'

$outputPath = $LocalPath + '\' + $webSocketsInstallerMsi

Invoke-WebRequest -Uri $webSocketsURL -OutFile $outputPath

Start-Process -FilePath msiexec.exe -Args "/I $outputPath /quiet /norestart /log webSocket.log" -Wait

Remove-Item -Path C:\teams\ -Recurse

write-host ' Customization: Finished Install the Teams WebSocket Service'

write-host 'Customization: Finished Install Teams plugins'



