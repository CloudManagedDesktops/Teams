
#Uninstall Teams, Then install media


$folders = Get-ChildItem -Path C:\users -Directory -force -ErrorAction SilentlyContinue |select fullname,name

$TeamsReg = "HKCU:\Software\Microsoft\Office\Teams"

$TeamRegExist = test-path -path $TeamsReg


try
{

    foreach($eachfolder in $folders)
    {
   
   
        #write-host $eachfolder.FullName
        $TeamsPath = $eachfolder.Fullname + "\AppData\Local\Microsoft\Teams"
        $TeamsUpdateExePath = $TeamsPath + "\Update.exe"
        $TeamsUserPath = "C:\ProgramData\" + $eachfolder.name + "\Microsoft\Teams"
        $TeamsUserUpdateExePath = $TeamsUserPath + "\Update.exe"

        if (Test-Path -Path $TeamsUpdateExePath) 
        {
            Write-Host "Uninstalling Teams process"

            # Uninstall app
            $proc = Start-Process -FilePath $TeamsUpdateExePath -ArgumentList "-uninstall -s" -PassThru
            $proc.WaitForExit()
        }
        if (Test-Path -Path $TeamsPath) {
            Write-Host "Deleting Teams directory"
            Remove-Item $Path $TeamsPath -Recurse
            if($Error[0])
            {
                $ErrorOut = $Error[0] | Out-String
                if($ErrorOut -match "Remove-Item")
                {
                    exit 1
                }
            }
        }

        if (Test-Path -Path $TeamsUserUpdateExePath) 
        {
            Write-Host "Uninstalling Teams process in ProgramData folder"

            # Uninstall app
            $proc = Start-Process -FilePath $TeamsUserUpdateExePath -ArgumentList "-uninstall -s" -PassThru
            $proc.WaitForExit()
        }
        if (Test-Path -Path $TeamsUserPath) {
            Write-Host "Deleting Teams directory"
            Remove-Item âPath $TeamsUserPath -Recurse
             if($Error[0])
            {
                $ErrorOut = $Error[0] | Out-String
                if($ErrorOut -match "Remove-Item")
                {
                    exit 1
                }
            }
        }

    }

    if($TeamRegExist -eq $True)
    {
         $PreventInstallStateKey = Get-Item -Path $TeamsReg
         $preventInstall = $PreventInstallStateKey.GetValue("PreventInstallationFromMsi") 
         if ($preventInstall -ne $null)
         {
            Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Office\Teams" -Name "PreventInstallationFromMsi"
         } 
    }

    #Create a directory to save download files
    $tempCreated = $false
    if (!(Test-Path C:\temp)) {
        New-Item -Path C:\ -ItemType Directory -Name temp

        $tempCreated = $true
    }

    # Add registry Key
    reg add "HKLM\SOFTWARE\Microsoft\Teams" /v IsWVDEnvironment /t REG_DWORD /d 1 /f /reg:64

    #Download C++ Runtime
    invoke-WebRequest -Uri https://aka.ms/vs/16/release/vc_redist.x64.exe -OutFile "C:\temp\vc_redist.x64.exe"

    #Download WebRTC
    invoke-WebRequest -Uri https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RE4AQBt -OutFile "C:\temp\MsRdcWebRTCSvc_HostSetup_1.0.2006.11001_x64.msi"

    #Install C++ runtime
    Start-Process "C:\temp\vc_redist.x64.exe" -ArgumentList @('/q', '/norestart') -NoNewWindow -Wait -PassThru

    #Install MSRDCWEBTRCSVC
    Start-Process msiexec.exe -ArgumentList '/i C:\temp\MsRdcWebRTCSvc_HostSetup_1.0.2006.11001_x64.msi /q /n' -Wait 

    if ($tempCreated) {
        #Remove temp folder
        Remove-Item -Path C:\temp\ -Recurse
    }
    else {
        #Remove downloaded C++ Runtime file
        Remove-Item -Path C:\temp\vc_redist.x64.exe

        #Remove downloaded WebRTC file
        Remove-Item -Path C:\temp\MsRdcWebRTCSvc_HostSetup_1.0.2006.11001_x64.msi
    }

        Write-host "Media Optimization Installed"
        
        exit 0
 }
 catch
 {
        Write-Error -ErrorRecord $_
        exit /b 1
 }


