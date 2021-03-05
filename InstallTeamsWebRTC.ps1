write-host ' Customization: Set required regKey'

New-Item -Path HKLM:\SOFTWARE\Microsoft -Name "Teams"

New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Teams -Name "IsWVDEnvironment" -Type "Dword" -Value "1"

write-host ' Customization: Finished Set required regKey'

# install vc

write-host ' Customization: Install the latest Microsoft Visual C++ Redistributable'

$appName = 'teams'

$drive = 'C:\'

New-Item -Path $drive -Name $appName -ItemType Directory -ErrorAction SilentlyContinue

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

$webSocketsURL = 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt'

$webSocketsInstallerMsi = 'webSocketSvc.msi'

$outputPath = $LocalPath + '\' + $webSocketsInstallerMsi

Invoke-WebRequest -Uri $webSocketsURL -OutFile $outputPath

Start-Process -FilePath msiexec.exe -Args "/I $outputPath /quiet /norestart /log webSocket.log" -Wait

write-host ' Customization: Finished Install the Teams WebSocket Service'

write-host 'Customization: Finished Install Teams plugins'
