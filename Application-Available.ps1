# Finit par Samuel PAGES le 25/03/2022 | refait le 25/07/2022 par Samuel PAGES
# Création des nouvelles versions d'applcations (1h après le téltéchargement de l'exe/msi sur \\...\C$\Tache_Auto)

begin # --> création des variables "statiques"
{
    $date = Get-Date -Format "dd/MM/yyyy"
    $hours = Get-Date -Format "HH:mm:ss"

    $PathFreeware = "\\...\produits\Instapc\Freeware"
    $PathSource = "\\...\...\Produits"
}

process # --> vérification et suppression des sources + création des logs
{
    ############## Logs ###############
    if(((Get-ItemProperty "C:\Tache_Auto\Applications-Available.log" -ErrorAction Ignore).Length) -gt 250000000 )
    {
        Remove-Item "C:\Tache_Auto\Applications-Available.log" -Force -Verbose -Confirm:$false -ErrorAction Continue
    }

    Start-Transcript "C:\Tache_Auto\Applications-Available.log" -Force -Append -ErrorAction Continue

    # VLC
    $VLC_Path = Get-ChildItem "$PathFreeware\VLC\LastVersion\"
    $VLC_PathVersion = (Get-ChildItem "$PathFreeware\VLC\LastVersion\").Name.Replace('vlc-','').Replace('-win64.msi','')
    $VLC_Count = 0
    foreach($file in $VLC_Path) { $VLC_Count = $VLC_Count + 1 }
    if($VLC_Count -eq 2)
    {
    
        # SI Version0 > Version1
        if([System.Version]$VLC_PathVersion[0] -gt [System.Version]$VLC_PathVersion[1]) 
        {
            $VLC_Version = $VLC_PathVersion[1]
        }
         # SI Version1 > Version0
        elseif([System.Version]$VLC_PathVersion[1] -gt [System.Version]$VLC_PathVersion[0]) 
        {
            $VLC_Version = $VLC_PathVersion[0]
        }

        # on détruit le plus petit
        $vl = "$PathFreeware\VLC\LastVersion\" + "vlc-" + $VLC_Version + "-win64.msi"
        Remove-Item $vl -Force 
        $VLC_P = (Get-ChildItem "$PathFreeware\VLC\LastVersion\").FullName
        $VLC_PName = (Get-ChildItem "$PathFreeware\VLC\LastVersion\").Name
        $VLC_Version = (Get-ChildItem "$PathFreeware\VLC\LastVersion\").Name.Replace('vlc-','').Replace('-win64.msi','')
    }
    else
    {
        $VLC_P = (Get-ChildItem "$PathFreeware\VLC\LastVersion\").FullName
        $VLC_PName = (Get-ChildItem "$PathFreeware\VLC\LastVersion\").Name
        $VLC_Version = (Get-ChildItem "$PathFreeware\VLC\LastVersion\").Name.Replace('vlc-','').Replace('-win64.msi','')
    }


    # 7-Zip
    $7Zip_Path = Get-ChildItem "$PathFreeware\7-Zip\LastVersion"
    $7Zip_PathVersion = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion").Name.Replace('7z','').Replace('-x64.exe','')
    $7Zip_Count = 0
    foreach($file in $7Zip_Path) { $7Zip_Count = $7Zip_Count + 1 }
    $7point = $false
    foreach($file in $7Zip_PathVersion) { if($file.Name -like '*.*') { $7point = $true } }
        
    if(($7Zip_Count -eq 2) -and ($7point -eq $false))
    {
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version0 > Version1
        if ($7Zip_PathVersion[0] -gt $7Zip_PathVersion[1])
        {
            $7Zip_Version = $7Zip_PathVersion[1]
        }
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version1 > Version0
        elseif($7Zip_PathVersion[1] -gt $7Zip_PathVersion[0])
        {
            $7Zip_Version = $7Zip_PathVersion[0]
        }

        # on détruit le plus petit
        $7z = "$PathFreeware\7-Zip\LastVersion\" + "7z" + $7Zip_Version + "-x64.exe"
        Remove-Item -Force $7z
        $7Zip_P = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").FullName
        $7Zip_PName = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").Name
        $7Zip_Version = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").Name.Replace('7z','').Replace('-x64.exe','')

    }
    elseif(($7Zip_Count -eq 2) -and ($7point -eq $true))
    {
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version0 > Version1
        if ([System.Version]$7Zip_PathVersion[0] -gt [System.Version]$7Zip_PathVersion[1])
        {
            $7Zip_Version = $7Zip_PathVersion[1]
        }
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version1 > Version0
        elseif([System.Version]$7Zip_PathVersion[1] -gt [System.Version]$7Zip_PathVersion[0])
        {
            $7Zip_Version = $7Zip_PathVersion[0]
        }

        # on détruit le plus petit
        $7z = "$PathFreeware\7-Zip\LastVersion\" + "7z" + $7Zip_Version + "-x64.exe"
        Remove-Item -Force $7z
        $7Zip_P = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").FullName
        $7Zip_PName = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").Name
        $7Zip_Version = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").Name.Replace('7z','').Replace('-x64.exe','')

    }
    else
    {
        $7Zip_Version = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").Name.Replace('7z','').Replace('-x64.exe','')
        $7Zip_P = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").FullName
        $7Zip_PName = (Get-ChildItem "$PathFreeware\7-Zip\LastVersion\").Name
    }

    # Notepad ++
    $Notepad_Path = Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -like *x64*
    $Notepad_PathVersion = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -like *x64*).Name.Replace('npp.','').Replace('.Installer.x64.exe','')
    $Notepad_Count = 0
    foreach($file in $Notepad_Path) { $Notepad_Count = $Notepad_Count + 1 }
    if($Notepad_Count -eq 2)
    {
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version0 > Version1
        if([System.Version]$Notepad_PathVersion[0] -gt [System.Version]$Notepad_PathVersion[1])
        {
            $Notepad_Version = $Notepad_PathVersion[1]
        }
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version1 > Version0
        elseif([System.Version]$Notepad_PathVersion[1] -gt [System.Version]$Notepad_PathVersion[0])
        {
            $Notepad_Version = $Notepad_PathVersion[0]
        }


        # on détruit le plus petite
        $npd = "$PathFreeware\Notepad++\LastVersion\" + "npp." + $Notepad_Version + ".Installer.x64.exe"
        Remove-Item -Force $npd
        $Notepad_P = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -like *x64* ).FullName
        $Notepad_Version = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -like *x64* ).Name.Replace('npp.','').Replace('.Installer.x64.exe','')
        $Notepad_PName = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -like *x64* ).Name
    }
    else
    {
        $Notepad_Version = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -like *x64* ).Name.Replace('npp.','').Replace('.Installer.x64.exe','')
        $Notepad_P = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -like *x64* ).FullName
        $Notepad_PName = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -like *x64* ).Name
    }

    # Notepad ++ 32bits
    $Notepad_Path32 = Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -NotLike *x64*
    $Notepad_PathVersion32 = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -NotLike *x64*).Name.Replace('npp.','').Replace('.Installer.exe','')
    $Notepad_Count32 = 0
    foreach($file in $Notepad_Path32) { $Notepad_Count32 = $Notepad_Count32 + 1 }
    if($Notepad_Count32 -eq 2)
    {
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version0 > Version1
        if 
        ([System.Version]$Notepad_PathVersion32[0] -gt [System.Version]$Notepad_PathVersion32[1])
        {
            $Notepad_Version32 = $Notepad_PathVersion32[1]
        }
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version1 > Version0
        elseif 
        ([System.Version]$Notepad_PathVersion32[1] -gt [System.Version]$Notepad_PathVersion32[0])
        {
            $Notepad_Version32 = $Notepad_PathVersion32[0]
        }

        # on détruit le plus petite
        $npd32 = "$PathFreeware\Notepad++\LastVersion\" + "npp." + $Notepad_Version32 + ".Installer.exe"
        Remove-Item -Force $npd32
        $Notepad_P32 = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -NotLike *x64* ).FullName
        $Notepad_Version32 = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -NotLike *x64* ).Name.Replace('npp.','').Replace('.Installer.exe','')
        $Notepad_PName32 = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -NotLike *x64* ).Name
    }
    else
    {
        $Notepad_Version32 = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -NotLike *x64* ).Name.Replace('npp.','').Replace('.Installer.exe','')
        $Notepad_P32 = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -NotLike *x64* ).FullName
        $Notepad_PName32 = (Get-ChildItem "$PathFreeware\Notepad++\LastVersion" | Where-Object -Property Name -NotLike *x64* ).Name
    }

    # KeePass
    $KeePass_Path = Get-ChildItem "$PathFreeware\KeePass\LastVersion"
    $KeePass_PathVersion = (Get-ChildItem "$PathFreeware\KeePass\LastVersion").Name.Replace('KeePass-','').Replace('-Setup.exe','')
    $KeePass_Count = 0
    foreach($file in $KeePass_Path) { $KeePass_Count = $KeePass_Count + 1 }
    if($KeePass_Count -eq 2)
    {
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version0 > Version1
        if([System.Version]$KeePass_PathVersion[0] -gt [System.Version]$KeePass_PathVersion[1])
        {
            $KeePass_Version = $KeePass_PathVersion[1]
        }
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version1 > Version0
        elseif([System.Version]$KeePass_PathVersion[1] -gt [System.Version]$KeePass_PathVersion[0])
        {
            $KeePass_Version = $KeePass_PathVersion[0]
        }

        # on détruit le plus petite
        $kps = "$PathFreeware\KeePass\LastVersion\" + "KeePass-" + $KeePass_Version + "-Setup.exe"
        Remove-Item -Force $kps
        $KeePass_P = (Get-ChildItem "$PathFreeware\KeePass\LastVersion").FullName
        $KeePass_Version = (Get-ChildItem "$PathFreeware\KeePass\LastVersion").Name.Replace('KeePass-','').Replace('-Setup.exe','')
        $KeePass_PName = (Get-ChildItem "$PathFreeware\KeePass\LastVersion").Name
    }
    else
    {
        $KeePass_Version = (Get-ChildItem "$PathFreeware\KeePass\LastVersion").Name.Replace('KeePass-','').Replace('-Setup.exe','')
        $KeePass_P = (Get-ChildItem "$PathFreeware\KeePass\LastVersion").FullName
        $KeePass_PName = (Get-ChildItem "$PathFreeware\KeePass\LastVersion").Name
    }

    # PuTTY
    $PuTTY_Path = Get-ChildItem "$PathFreeware\Putty\LastVersion"
    $PuTTY_PathVersion = (Get-ChildItem "$PathFreeware\Putty\LastVersion").Name.Replace('putty-64bit-','').Replace('-installer.msi','')
    $PuTTY_Count = 0
    foreach($file in $PuTTY_Path) { $PuTTY_Count = $PuTTY_Count + 1 }
    if($PuTTY_Count -eq 2)
    {
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version0 > Version1
        if([System.Version]$PuTTY_PathVersion[0] -gt [System.Version]$PuTTY_PathVersion[1])
        {
            $PuTTY_Version = $PuTTY_PathVersion[1]
        }
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version1 > Version0
        elseif([System.Version]$PuTTY_PathVersion[1] -gt [System.Version]$PuTTY_PathVersion[0])
        {
            $PuTTY_Version = $PuTTY_PathVersion[0]
        }

        # on détruit le plus petite
        $pty = "$PathFreeware\Putty\LastVersion\" + "putty-64bit-" + $PuTTY_Version + "-installer.msi"
        Remove-Item -Force $pty
        $PuTTY_P = (Get-ChildItem "$PathFreeware\Putty\LastVersion").FullName
        $PuTTY_Version = (Get-ChildItem "$PathFreeware\Putty\LastVersion").Name.Replace('putty-64bit-','').Replace('-installer.msi','')
        $PuTTY_PName = (Get-ChildItem "$PathFreeware\Putty\LastVersion").Name
    }
    else
    {
        $PuTTY_Version = (Get-ChildItem "$PathFreeware\Putty\LastVersion").Name.Replace('putty-64bit-','').Replace('-installer.msi','')
        $PuTTY_P = (Get-ChildItem "$PathFreeware\Putty\LastVersion").FullName
        $PuTTY_PName = (Get-ChildItem "$PathFreeware\Putty\LastVersion").Name
    }

    # FileZilla
    $FileZilla_Path = Get-ChildItem "$PathFreeware\Filezilla\LastVersion"
    $FileZilla_PathVersion = (Get-ChildItem "$PathFreeware\Filezilla\LastVersion").Name.Replace('FileZilla_','').Replace('_win64-setup.exe','')
    $FileZilla_Count = 0
    foreach($file in $FileZilla_Path) { $FileZilla_Count = $FileZilla_Count + 1 }
    if($FileZilla_Count -eq 2)
    {
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version0 > Version1
        if([System.Version]$FileZilla_PathVersion[0] -gt [System.Version]$FileZilla_PathVersion[1])
        {
            $FileZilla_Version = $FileZilla_PathVersion[1]
        }
        # test de version : si la version est de type : 0000 ou 00 ou 0 SI Version1 > Version0
        elseif([System.Version]$FileZilla_PathVersion[1] -gt [System.Version]$FileZilla_PathVersion[0])
        {
            $FileZilla_Version = $FileZilla_PathVersion[0]
        }
       
        # on détruit le plus petite
        $flza = "$PathFreeware\Filezilla\LastVersion\" + "FileZilla_" + $FileZilla_Version + "_win64-setup.exe"
        Remove-Item -Force $flza
        $FileZilla_P = (Get-ChildItem "$PathFreeware\Filezilla\LastVersion").FullName
        $FileZilla_Version = (Get-ChildItem "$PathFreeware\Filezilla\LastVersion").Name.Replace('FileZilla_','').Replace('_win64-setup.exe','')
        $FileZilla_PName = (Get-ChildItem "$PathFreeware\Filezilla\LastVersion").Name
    }
    else
    {
        $FileZilla_Version = (Get-ChildItem "$PathFreeware\Filezilla\LastVersion").Name.Replace('FileZilla_','').Replace('_win64-setup.exe','')
        $FileZilla_P = (Get-ChildItem "$PathFreeware\Filezilla\LastVersion").FullName
        $FileZilla_PName = (Get-ChildItem "$PathFreeware\Filezilla\LastVersion").Name
    }

    Write-Host "Started : $date $hours "

    # VLC
    if(!(Test-Path "$PathSource\VLC\LastestVersion\$VLC_PName"))
    {
        Copy-Item $VLC_P -Destination "$PathSource\VLC\LastestVersion" -Force -PassThru -Confirm:$false -Verbose -ErrorAction Continue
    }
    # 7-Zip
    if(!(Test-Path "$PathSource\7-Zip\LastestVersion\$7Zip_PName"))
    {
        Copy-Item $7Zip_P -Destination "$PathSource\7-Zip\LastestVersion" -Force -PassThru -Confirm:$false -Verbose -ErrorAction Continue
    }
    # Notepad++
    if(!(Test-Path "$PathSource\Notepad++\LastestVersion\$Notepad_PName"))
    {
        Copy-Item $Notepad_P -Destination "$PathSource\Notepad++\LastestVersion" -Force -PassThru -Confirm:$false -Verbose -ErrorAction Continue
    }
    # Notepad++ 32bits
    if(!(Test-Path "$PathSource\Notepad++\LastestVersion\$Notepad_PName32"))
    {
        Copy-Item $Notepad_P32 -Destination "$PathSource\Notepad++\LastestVersion" -Force -PassThru -Confirm:$false -Verbose -ErrorAction Continue
    }
    # KeePass
    if(!(Test-Path "$PathSource\KeePass\LastestVersion\$KeePass_PName"))
    {
        Copy-Item $KeePass_P -Destination "$PathSource\KeePass\LastestVersion" -Force -PassThru -Confirm:$false -Verbose -ErrorAction Continue
    }
    # PuTTY
    if(!(Test-Path "$PathSource\Putty\LastestVersion\$PuTTY_PName"))
    {
        Copy-Item $PuTTY_P -Destination "$PathSource\Putty\LastestVersion\$PuTTY_PName" -Force -PassThru -Confirm:$false -Verbose -ErrorAction Continue
    }
    # FileZilla
    if(!(Test-Path "$PathSource\FileZilla\LastestVersion\$FileZilla_PName"))
    {
        Copy-Item $FileZilla_P -Destination "$PathSource\FileZilla\LastestVersion\$FileZilla_PName" -Force -PassThru -Confirm:$false -Verbose -ErrorAction Continue
    }

    $VLC_ProductCode = (Get-AppLockerFileInformation -Path "$PathSource\VLC\LastestVersion\vlc-$VLC_Version-win64.msi" | select -ExpandProperty Publisher | Select BinaryName).BinaryName
    $PuTTY_ProductCode = (Get-AppLockerFileInformation -Path "$PathSource\Putty\LastestVersion\putty-64bit-$PuTTY_Version-installer.msi" | select -ExpandProperty Publisher | Select BinaryName).BinaryName
}
end # --> Création des apps et envoie des mails
{
    # CD $ProviderMachineName + Import les modules SCCM etc... 
    # Site configuration
    $SiteCode = "CME" # Site code 
    $ProviderMachineName = "" # SMS Provider machine name
    $initParams = @{}
    # Import the ConfigurationManager.psd1 module 
    if((Get-Module ConfigurationManager) -eq $null) 
    {
        Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
    }
    # Connect to the site's drive if it is not already present
    if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) 
    {
        New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
    }
    # Set the current location to be the site code.
    Set-Location "$($SiteCode):\" @initParams

    ##################################################################################################################################################################################################################################
    ##################################################################################################################################################################################################################################
    ##################################################################################################################################################################################################################################
    # Création des applcations sur SCCM

    $Body = ""
    $VLC_Version.GetType().Name
    function Test-NotNullOrEmpty
    {
        Param
        (
            [Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [ValidateScript({
                if(($_.GetType().Name -eq 'String') -or (($_.GetType().Name) -like 'Int*') -or (($_.GetType().Name) -eq 'Version'))
                {
                    return $true
                }
                else
                {
                    return $false
                }
            })]
            $Version
        )
        return $true
    }

    ############################################# VLC #############################################
    if(Test-NotNullOrEmpty -Version $VLC_Version)
    {    
        [bool]$VLC_NewQuery = $false
        try 
        { 
            if(-not (Get-CMQuery -Name "VLC = $VLC_Version"))
            {
                $VLC_Query = New-CMQuery -Expression 'select SMS_R_System.Name, SMS_R_System.LastLogonUserName, SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName, SMS_G_System_INSTALLED_SOFTWARE.ProductVersion, SMS_G_System_INSTALLED_SOFTWARE.SoftwareCode, SMS_G_System_WORKSTATION_STATUS.LastHardwareScan, SMS_G_System_INSTALLED_SOFTWARE.ProductName, SMS_G_System_INSTALLED_SOFTWARE.UninstallString from  SMS_R_System inner join SMS_G_System_INSTALLED_SOFTWARE on SMS_G_System_INSTALLED_SOFTWARE.ResourceID = SMS_R_System.ResourceId inner join SMS_G_System_WORKSTATION_STATUS on SMS_G_System_WORKSTATION_STATUS.ResourceID = SMS_R_System.ResourceId where SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName like "%VLC media player%" and SMS_G_System_INSTALLED_SOFTWARE.ProductVersion = "$VLC_Version" order by SMS_G_System_INSTALLED_SOFTWARE.ProductVersion'.Replace('$VLC_Version',$VLC_Version) `
                    -Comment "Created by Powershell Script in by the service account : " `
                    -LimitToCollectionId "CME0018C" -Name "VLC = $VLC_Version" -TargetClassName "SMS_R_System" -Verbose

                Move-CMObject -FolderPath "CME:\Query\Samuel\VLC" -InputObject $VLC_Query -Verbose
                [bool]$VLC_NewQuery = $true
            }
            else
            {
                Write-Warning "Query Already Exist VLC = $VLC_Version"
            }
        }
        catch [System.Management.Automation.TerminateException],[System.ArgumentException]
        { 
            Write-Warning "This is a catched error : The selected Query item 'VLC = $VLC_Version' already exist"  
        }
        
        $VLC_VersDepType = (Get-CMDeploymentType -ApplicationName "VLC media player Lastest")
        $VLC_App = Get-CMApplication -Name "VLC media player Lastest" -Fast -ShowHidden
        $VLC_AppVersion = $VLC_App.SoftwareVersion

        if([System.Version]$VLC_Version -gt [System.Version]$VLC_AppVersion)
        {
            $VLC_App | Set-CMApplication -SoftwareVersion "$VLC_Version" -Verbose
            $VLC_VersDepType | Set-CMScriptDeploymentType -NewName "VLC media player $VLC_Version" -Verbose
       
            Update-CMDistributionPoint -ApplicationName "VLC media player Lastest" -DeploymentTypeName "VLC media player $VLC_Version" -Verbose

            $EmailAddress = ""

            $Server = ""
            $Encoding = "UTF8"
            $Sender = ""

            $Copie =   ""
            $Subject = "New Application(s) on SCCM"
    
            $Body += "VLC media player $VLC_Version : $PathSource\VLC\LastestVersion\ <br>"
            if($VLC_NewQuery -eq $true)
            {
                $body += "Une Query a été créée : \Monitoring\Overview\Queries\Samuel\VLC\VLC = $VLC_Version <br><br>"  
            }
            else
            {
                $Body += "<br>"
            }
            Write-Warning "La dernière version de VLC x64 msi : $VLC_Version est prête" 
        }
        else
        {
            Write-Warning "La version de VLC $VLC_Version est < ou = que celle de l'application Lastest"
        }                     
    }

    ############################################# 7-Zip #############################################
    if(Test-NotNullOrEmpty -Version $7Zip_Version)
    {
        if( (($7Zip_Version.Length) -eq 4) -and (-not ($7Zip_Version.Contains('.'))))
        {
            $7Zip_VersionPoint = $7Zip_Version.Substring(0,2) + "." + $7Zip_Version.Substring(0,4).Replace($7Zip_Version.Substring(0,2),'')
        }
        [bool]$7Zip_NewQuery = $false
        try 
        { 
            if(-not (Get-CMQuery -Name "7-Zip = $7Zip_Version"))
            {
                $7Zip_Query = New-CMQuery -Verbose -Expression 'select SMS_R_System.LastLogonUserName, SMS_R_System.Name, SMS_G_System_INSTALLED_SOFTWARE.ProductName, SMS_G_System_INSTALLED_SOFTWARE.ProductVersion, SMS_G_System_INSTALLED_SOFTWARE.InstalledLocation, SMS_G_System_WORKSTATION_STATUS.LastHardwareScan from  SMS_R_System inner join SMS_G_System_INSTALLED_SOFTWARE on SMS_G_System_INSTALLED_SOFTWARE.ResourceID = SMS_R_System.ResourceId inner join SMS_G_System_WORKSTATION_STATUS on SMS_G_System_WORKSTATION_STATUS.ResourceID = SMS_R_System.ResourceId where SMS_G_System_INSTALLED_SOFTWARE.ProductName like "%7-Zip%" and (SMS_G_System_INSTALLED_SOFTWARE.ProductVersion = "$7Zip_VersionPoint" or SMS_G_System_INSTALLED_SOFTWARE.ProductVersion = "$7Zip_VersionPoint2") and SMS_G_System_INSTALLED_SOFTWARE.ProductVersion not like "%alpha%" and SMS_G_System_INSTALLED_SOFTWARE.ProductVersion not like "%beta%"'.Replace('$7Zip_VersionPoint2',"$7Zip_VersionPoint" + ".00.0").Replace('$7Zip_VersionPoint',"$7Zip_VersionPoint") `
                        -Comment "Created by Powershell Script in by the service account : " `
                        -LimitToCollectionId "CME0018C" -Name "7-Zip = $7Zip_VersionPoint" -TargetClassName "SMS_R_System"
                
                Move-CMObject -FolderPath "CME:\Query\Samuel\7-Zip" -InputObject $7Zip_Query -Verbose
                
                [bool]$7Zip_NewQuery = $true
            }
            else
            {
                Write-Warning "Query Already Exist 7Zip = $7Zip_VersionPoint"
            }
        }
        catch [System.Management.Automation.TerminateException],[System.ArgumentException]
        { 
            Write-Warning "This is a catched error : The selected Query item '7-Zip = $7Zip_VersionPoint' already exist"  
        }
        
        $7Zip_VersDepType = (Get-CMDeploymentType -ApplicationName "7-Zip Lastest")
        $7Zip_App = Get-CMApplication -Name "7-Zip Lastest" -Fast -ShowHidden
        $7Zip_AppVersion = $7Zip_App.SoftwareVersion

        if([System.Version]$7Zip_VersionPoint -gt [System.Version]$7Zip_AppVersion)
        {
            $7Zip_App | Set-CMApplication -SoftwareVersion "$7Zip_VersionPoint" -Verbose
            $7Zip_VersDepType | Set-CMScriptDeploymentType -NewName "7-Zip $7Zip_VersionPoint" -Verbose
       
            Update-CMDistributionPoint -ApplicationName "7-Zip Lastest" -DeploymentTypeName "7-Zip $7Zip_VersionPoint" -Verbose

            $EmailAddress = ""

            $Server = ""
            $Encoding = "UTF8"
            $Sender = ""

            $Copie =   ""
            $Subject = "New Application(s) on SCCM"
    
            $Body += "7-Zip $7Zip_VersionPoint : $PathSource\7-Zip\LastestVersion\ <br>"
            if($7Zip_NewQuery -eq $true)
            {
                $body += "<br> Une Query a été créée : \Monitoring\Overview\Queries\Samuel\7-Zip\7-Zip = $7Zip_VersionPoint <br><br> "
            }
            else
            {
                $Body += "<br>"
            }
            Write-Warning "La dernière version de 7-Zip x64 exe : $7Zip_VersionPoint est prête" 
        }
        else
        {
            Write-Warning "La version de 7-Zip $7Zip_VersionPoint est < ou = que celle de l'application Lastest"
        } 
    }


    ############################################# Notepad++ #############################################
    if(Test-NotNullOrEmpty -Version $Notepad_Version)
    {    
        [bool]$Notepad_NewQuery = $false
        try 
        { 
            if(-not (Get-CMQuery -Name "Notepad++ = $Notepad_Version"))
            {
                $Notepad_Query = New-CMQuery -Verbose -Expression 'select SMS_R_System.Name, SMS_R_System.LastLogonUserName, SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName, SMS_G_System_INSTALLED_SOFTWARE.ProductVersion, SMS_G_System_INSTALLED_SOFTWARE.SoftwareCode, SMS_G_System_WORKSTATION_STATUS.LastHardwareScan, SMS_G_System_INSTALLED_SOFTWARE.ProductName, SMS_G_System_INSTALLED_SOFTWARE.UninstallString from  SMS_R_System inner join SMS_G_System_INSTALLED_SOFTWARE on SMS_G_System_INSTALLED_SOFTWARE.ResourceID = SMS_R_System.ResourceId inner join SMS_G_System_WORKSTATION_STATUS on SMS_G_System_WORKSTATION_STATUS.ResourceID = SMS_R_System.ResourceId where (SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName like "Notepad++" or SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName like "Notepad++ (32-bit x86)" or SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName like "Notepad++ (64-bit x64)") and SMS_G_System_INSTALLED_SOFTWARE.ProductVersion = "$Notepad_Version" order by SMS_G_System_INSTALLED_SOFTWARE.ProductVersion'.Replace('$Notepad_Version',"$NotepadVersion") `
                        -Comment "Created by Powershell Script in by the service account : " `
                        -LimitToCollectionId "CME0018C" -Name "Notepad++ = $NotepadVersion" -TargetClassName "SMS_R_System"
                
                Move-CMObject -Verbose -FolderPath "CME:\Query\Samuel\Notepad++" -InputObject $Notepad_Query
                
                [bool]$Notepad_NewQuery = $true
            }
            else
            {
                Write-Warning "Query Already Exist Notepad++ = $Notepad_Version"
            }
        }
        catch [System.Management.Automation.TerminateException],[System.ArgumentException]
        { 
            Write-Warning "This is a catched error : The selected Query item 'Notepad++ = $Notepad_Version' already exist"  
        }
        $Notepad_VersDepType = (Get-CMDeploymentType -ApplicationName "Notepad++ Lastest")
        $Notepad_App = Get-CMApplication -Name "Notepad++ Lastest" -Fast -ShowHidden
        $Notepad_AppVersion = $Notepad_App.SoftwareVersion
        
        
        if([System.Version]$Notepad_Version -gt [System.Version]$Notepad_AppVersion)
        {
            $Notepad_App | Set-CMApplication -SoftwareVersion "$Notepad_Version" -Verbose
            $Notepad_VersDepType | Set-CMScriptDeploymentType -NewName "Notepad++ $Notepad_Version" -Verbose
       
            Update-CMDistributionPoint -ApplicationName "Notepad++ Lastest" -DeploymentTypeName "Notepad++ $Notepad_Version" -Verbose

            $EmailAddress = ""

            $Server = ""
            $Encoding = "UTF8"
            $Sender = ""

            $Copie =   ""
            $Subject = "New Application(s) on SCCM"
    
            $Body += "Notepad++ $Notepad_Version : $PathSource\Notepad++\LastestVersion\ <br>"
            if($Notepad_NewQuery -eq $true)
            {
                $body += "Une Query a été créée : \Monitoring\Overview\Queries\Samuel\Notepad++\Notepad++ = $Notepad_Version <br><br> "
            }
            else
            {
                $Body += "<br>" 
            }
            Write-Warning "La dernière version de Notepad++ x64 exe : $Notepad_Version est prête" 
        }
        else
        {
            Write-Warning "La version de Notepad++ $Notepad_Version est < ou = que celle de l'application Lastest"
        }                      
    }

    ############################################# KeePass #############################################
    if(Test-NotNullOrEmpty -Version $KeePass_Version)
    {    
        [bool]$KeePass_NewQuery = $false
        try 
        { 
            if(-not (Get-CMQuery -Name "KeePass = $KeePass_Version"))
            {
                $KeePass_Query = New-CMQuery -Verbose -Expression 'select SMS_R_System.LastLogonUserName, SMS_R_System.Name, SMS_G_System_INSTALLED_SOFTWARE.ProductName, SMS_G_System_INSTALLED_SOFTWARE.ProductVersion, SMS_G_System_INSTALLED_SOFTWARE.InstalledLocation, SMS_G_System_WORKSTATION_STATUS.LastHardwareScan from  SMS_R_System inner join SMS_G_System_INSTALLED_SOFTWARE on SMS_G_System_INSTALLED_SOFTWARE.ResourceID = SMS_R_System.ResourceId inner join SMS_G_System_WORKSTATION_STATUS on SMS_G_System_WORKSTATION_STATUS.ResourceID = SMS_R_System.ResourceId where SMS_G_System_INSTALLED_SOFTWARE.ProductName like "%KeePass Password Safe%" and SMS_G_System_INSTALLED_SOFTWARE.ProductVersion = "$KeePass_Version"'.Replace('$KeePass_Version',"$KeePass_Version") `
                        -Comment "Created by Powershell Script in by the service account : " `
                        -LimitToCollectionId "CME00014" -Name "KeePass = $KeePass_Version" -TargetClassName "SMS_R_System"
                
                Move-CMObject -FolderPath "CME:\Query\Samuel\KeePass" -InputObject $KeePass_Query -Verbose
                
                [bool]$KeePass_NewQuery = $true
            }
            else
            {
                Write-Warning "Query Already Exist KeePass = $KeePass_Version"
            }
        }
        catch [System.Management.Automation.TerminateException],[System.ArgumentException]
        { 
            Write-Warning "This is a catched error : The selected Query item 'KeePass = $KeePass_Version' already exist"  
        }
        $KeePass_VersDepType = (Get-CMDeploymentType -ApplicationName "KeePass Lastest (Gestionnaire de mots de passe)")
        $KeePass_App = Get-CMApplication -Name "KeePass Lastest (Gestionnaire de mots de passe)" -Fast -ShowHidden
        $KeePass_AppVersion = $KeePass_App.SoftwareVersion
        
        
        if([System.Version]$KeePass_Version -gt [System.Version]$KeePass_AppVersion)
        {
            $KeePass_App | Set-CMApplication -SoftwareVersion "$KeePass_Version" -Verbose
            $KeePass_VersDepType | Set-CMScriptDeploymentType -NewName "KeePass $KeePass_Version" -Verbose
       
            Update-CMDistributionPoint -ApplicationName "KeePass Lastest (Gestionnaire de mots de passe)" -DeploymentTypeName "KeePass $KeePass_Version" -Verbose

            $EmailAddress = ""

            $Server = ""
            $Encoding = "UTF8"
            $Sender = ""

            $Copie =   ""
            $Subject = "New Application(s) on SCCM"
    
            $Body += "KeePass $KeePass_Version : $PathSource\KeePass\LastestVersion\ <br>"
            if($KeePass_NewQuery -eq $true)
            {
                $Body += "Une Query a été créée : \Monitoring\Overview\Queries\Samuel\KeePass\KeePass = $KeePass_Version <br> <br> "
            }
            else
            {
                $Body = "<br>"
            }
            Write-Warning "La dernière version de KeePass x64 exe : $KeePass_Version est prête" 
        }
        else
        {
            Write-Warning "La version de KeePass $KeePass_Version est < ou = que celle de l'application Lastest"
        }                      
    }

    ############################## ############### PuTTY #############################################
    if(Test-NotNullOrEmpty -Version $PuTTY_Version)
    {    
        [bool]$PuTTY_NewQuery = $false
        try 
        { 
            if(-not (Get-CMQuery -Name "PuTTY = $PuTTY_Version"))
            {
                $PuTTY_Query = New-CMQuery -Verbose -Expression 'select distinct SMS_G_System_COMPUTER_SYSTEM.Name, SMS_G_System_INSTALLED_SOFTWARE.UninstallString, SMS_G_System_INSTALLED_SOFTWARE.ProductVersion, SMS_G_System_INSTALLED_SOFTWARE.InstalledLocation from  SMS_R_System inner join SMS_G_System_INSTALLED_SOFTWARE on SMS_G_System_INSTALLED_SOFTWARE.ResourceID = SMS_R_System.ResourceId inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName = "PuTTY release $PuTTY_Version (64-bit)"'.Replace('$PuTTY_Version',"$PuTTY_Version") `
                        -Comment "Created by Powershell Script in by the service account : " `
                        -LimitToCollectionId "CME00014" -Name "PuTTY = $PuTTY_Version" -TargetClassName "SMS_R_System"
                
                Move-CMObject -FolderPath "CME:\Query\Samuel\Putty" -InputObject $PuTTY_Query
                
                [bool]$PuTTY_NewQuery = $true
            }
            else
            {
                Write-Warning "Query Already Exist PuTTY = $PuTTY_Version"
            }
        }
        catch [System.Management.Automation.TerminateException],[System.ArgumentException]
        { 
            Write-Warning "This is a catched error : The selected Query item 'PuTTY = $PuTTY_Version' already exist"  
        }
        $PuTTY_VersDepType = (Get-CMDeploymentType -ApplicationName "PuTTY Lastest (64-bit)")
        $PuTTY_App = Get-CMApplication -Name "PuTTY Lastest (64-bit)" -Fast -ShowHidden
        $PuTTY_AppVersion = $PuTTY_App.SoftwareVersion
        
        
        if([System.Version]$PuTTY_Version -gt [System.Version]$PuTTY_AppVersion)
        {
            $PuTTY_App | Set-CMApplication -SoftwareVersion "$PuTTY_Version" -Verbose
            $PuTTY_VersDepType | Set-CMScriptDeploymentType -NewName "PuTTY $PuTTY_Version" -Verbose
       
            Update-CMDistributionPoint -ApplicationName "PuTTY Lastest (64-bit)" -DeploymentTypeName "PuTTY $PuTTY_Version" -Verbose

            $EmailAddress = ""

            $Server = ""
            $Encoding = "UTF8"
            $Sender = ""

            $Copie =   ""
            $Subject = "New Application(s) on SCCM"
    
            $Body += "PuTTY $PuTTY_Version : $PathSource\PuTTY\LastestVersion\ <br>"
            if($PuTTY_NewQuery -eq $true)
            {
                $body += "Une Query a été créée : \Monitoring\Overview\Queries\Samuel\PuTTY\PuTTY = $PuTTY_Version <br><br> "
            }
            else 
            {
                $Body += "<br>"
            }
            Write-Warning "La dernière version de PuTTY x64 exe : $PuTTY_Version est prête" 
        }
        else
        {
            Write-Warning "La version de PuTTY $PuTTY_Version est < ou = que celle de l'application Lastest"
        }                      
    }

    #FileZilla
    if(Test-NotNullOrEmpty -Version $FileZilla_Version)
    {    
        [bool]$FileZilla_NewQuery = $false
        try 
        { 
            if(-not (Get-CMQuery -Name "FileZilla = $FileZilla_Version"))
            {
                $FileZilla_Query = New-CMQuery -Verbose -Expression 'select distinct SMS_G_System_COMPUTER_SYSTEM.Name, SMS_G_System_INSTALLED_SOFTWARE.UninstallString, SMS_G_System_INSTALLED_SOFTWARE.ProductVersion, SMS_G_System_INSTALLED_SOFTWARE.InstalledLocation from  SMS_R_System inner join SMS_G_System_INSTALLED_SOFTWARE on SMS_G_System_INSTALLED_SOFTWARE.ResourceID = SMS_R_System.ResourceId inner join SMS_G_System_COMPUTER_SYSTEM on SMS_G_System_COMPUTER_SYSTEM.ResourceID = SMS_R_System.ResourceId where SMS_G_System_INSTALLED_SOFTWARE.ARPDisplayName = "FileZilla release $FileZilla_Version"'.Replace('$FileZilla_Version',"$FileZilla_Version") `
                    -Comment "Created by Powershell Script in by the service account : " `
                    -LimitToCollectionId "CME00014" -Name "FileZilla = $FileZilla_Version" -TargetClassName "SMS_R_System"
                
                Move-CMObject -FolderPath "CME:\Query\Samuel\FileZilla" -InputObject $FileZilla_Query
                
                [bool]$FileZilla_NewQuery = $true
            }
            else
            {
                Write-Warning "Query Already Exist FileZilla = $FileZilla_Version"
            }
        }
        catch [System.Management.Automation.TerminateException],[System.ArgumentException]
        { 
            Write-Warning "This is a catched error : The selected Query item 'FileZilla = $FileZilla_Version' already exist"  
        }
        $FileZilla_VersDepType = (Get-CMDeploymentType -ApplicationName "FileZilla Lastest")
        $FileZilla_App = Get-CMApplication -Name "FileZilla Lastest" -Fast -ShowHidden
        $FileZilla_AppVersion = $FileZilla_App.SoftwareVersion
        
        
        if([System.Version]$FileZilla_Version -gt [System.Version]$FileZilla_AppVersion)
        {
            $FileZilla_App | Set-CMApplication -SoftwareVersion "$FileZilla_Version" -Verbose
            $FileZilla_VersDepType | Set-CMScriptDeploymentType -NewName "FileZilla $FileZilla_Version" -Verbose
       
            Update-CMDistributionPoint -ApplicationName "FileZilla Lastest" -DeploymentTypeName "FileZilla $FileZilla_Version" -Verbose

            $EmailAddress = ""

            $Server = ""
            $Encoding = "UTF8"
            $Sender = ""

            $Copie =   ""
            $Subject = "New Application(s) on SCCM"
    
            $Body += "FileZilla $FileZilla_Version : $PathSource\FileZilla\LastestVersion\ <br> "
            if($FileZilla_NewQuery -eq $true)
            {
                $body += "Une Query a été créée : \Monitoring\Overview\Queries\Samuel\FileZilla\FileZilla = $FileZilla_Version <br> <br> "
            }
            else
            {
                $Body += "<br> "
            }
            Write-Warning "La dernière version de FileZilla x64 msi : $FileZilla_Version est prête" 
        }
        else
        {
            Write-Warning "La version de FileZilla $FileZilla_Version est < ou = que celle de l'application Lastest"
        }                      
    }
    if($Body -ne "")
    {
        $BodyText = "<!DOCTYPE HTML>"
        $BodyText += "<HTML><HEAD><META http-equiv=Content-Type content='text/html; charset=iso-8859-1'>"
        $BodyText += "</HEAD><BODY><DIV style='font-size:14.5px; font-family:Calibri;'>"
        $BodyText += $Body
        $BodyText += "</DIV></BODY></HTML>";

        Send-MailMessage -from $Sender -To $EmailAddress -Subject $Subject -Body $BodyText -BodyAsHtml  -Encoding $Encoding -SmtpServer $Server -Cc $Copie -Verbose
    }

    $date_end = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

    Write-Host "End : $date_end"

    Stop-Transcript -ErrorAction Ignore
}
