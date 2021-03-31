$TeamsMediaFile = "C:\Program Files\Remote Desktop WebRTC Redirector\MsRdcWebRTCSvc.exe"
$TeamsMediaPath = "C:\Program Files\Remote Desktop WebRTC Redirector"
$TeamMediaFileExist = Test-Path -Path $TeamsMediaFile
$folders = Get-ChildItem -Path C:\users -Directory -force -ErrorAction SilentlyContinue |select fullname,name
$totalFolders = $folders.Count + $folders.Count


if($TeamMediaFileExist -eq $true )
{

    foreach($eachfolder in $folders)
    {
      
        #write-host $eachfolder.FullName
        $TeamsPath = $eachfolder.Fullname + "\AppData\Local\Microsoft\Teams"
        $TeamsUpdateExePath = $TeamsPath + "\Update.exe"
        $TeamsUpdateExist = Test-Path -Path $TeamsUpdateExePath
        $TeamsPathExist = Test-Path -Path $TeamsPath
            
        if ( $TeamsUpdateExist -eq $True ) 
        {
          
            $TeamsCreationTime = get-date ( (get-item -path $TeamsPath).LastWriteTime)
            $TeamsMediaCreationTime = get-date ( (get-item -path $TeamsMediaPath).CreationTime)
            if( $TeamsMediaCreationTime -lt $TeamsCreationTime)
            {
                $totalFolders = $totalFolders -1
            }
        
        }
        elseif( $TeamsPathExist -eq $false)
        {
          
                $totalFolders = $totalFolders -1
               
        }  


        $TeamsUserPath = "C:\ProgramData\" + $eachfolder.name + "\Microsoft\Teams"
        $TeamsUserUpdateExePath = $TeamsUserPath + "\Update.exe" 
        $TeamsUserUpdateExist = Test-Path -Path $TeamsUserUpdateExePath
        $TeamsUserPathExist = Test-Path -Path $TeamsUserPath     

        if ( $TeamsUserUpdateExist -eq $True ) 
        {
          
            $TeamsCreationTime = get-date ( (get-item -path $TeamsUserPath).LastWriteTime)
            $TeamsMediaCreationTime = get-date ( (get-item -path $TeamsMediaPath).CreationTime)
            if( $TeamsMediaCreationTime -lt $TeamsCreationTime)
            {
                $totalFolders = $totalFolders -1
            }
        
        }
        elseif($TeamsUserPathExist -eq $false)
        {
          
                $totalFolders = $totalFolders - 1
               
        }  
    }

    $TeamsReg = "HKCU:\Software\Microsoft\Office\Teams"

    $TeamRegExist = test-path -path $TeamsReg
    if($TeamRegExist -eq $True)
    {
         $PreventInstallStateKey = Get-Item -Path $TeamsReg
         $preventInstall = $PreventInstallStateKey.GetValue("PreventInstallationFromMsi") 
          
    }
    else { $preventInstall = $null}


        
    if(($totalFolders -eq 0) -and ($preventInstall -eq $null))     
    { 
        write-host "Compliant"
        exit 0  #device is compliant,remediation will not run
        }

    else {
      write-host "Not Compliant"
        exit 1 #remediation will run
    }
}
else {
    write-host "Not Compliant"
        exit 1
}


