# Module Powershell créé par Samuel PAGES 
# modifié le 07/04/2022 par Samuel PAGES pour les espaces disque


# Fonction de Check réseau (ping l'ip que l'on choisis)
function Check-Network
{
    [OutputType([bool])]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [Switch]$TestCeaExtra,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$false, Position=1)]
        # Validate IP : 'int.int.int.int'
        [ValidatePattern('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')]
        [String]$Ip,

        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory=$false, Position=2)]
        # Validate IP : 'int.int.int.int'
        [ValidatePattern('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')]
        [String]$Ip2
    )
    if($TestCeaExtra)
    {
        $extra = $false
        Get-NetConnectionProfile | ForEach-Object -process { if ($_.Name -like "extra.cea.fr*") { $extra = $true } }
        if($extra -eq $true)
        {
            return $true;
        }
        else
        {
            return $false;
        }
    }
    if( ($Ip) -or ($Ip2))
    {
        if(Test-Connection -ComputerName $Ip -Count 3 -Delay 1 -ea Ignore)
        {
            return $true;
        }
        else 
        {
            if(Test-Connection -ComputerName $Ip2 -Count 3 -Delay 1 -ea Ignore)
            {
                return $true;
            }
            else 
            { 
                return $false;
            }
        }
    }
}

# Fonction de messageBox simples
function Show-Message {

param (
    [string]$Message = "Veuillez entrer votre message",
    [string]$Titre = "Titre de la fenêtre",
    [switch]$OKCancel,
    [switch]$AbortRetryIgnore,
    [switch]$YesNoCancel,
    [switch]$YesNo,
    [switch]$RetryCancel,
    [switch]$IconErreur,
    [switch]$IconQuestion,
    [switch]$IconAvertissement,
    [switch]$IconInformation
    )

    # Affecter la valeur selon le type de boutons choisis
    if ($OKCancel) { $Btn = 1 }
    elseif ($AbortRetryIgnore) { $Btn = 2 }
    elseif ($YesNoCancel) { $Btn = 3 }
    elseif ($YesNo) { $Btn = 4 }
    elseif ($RetryCancel) { $Btn = 5 }
    else { $Btn = 0 }

    # Affecter la valeur pour l'icone 
    if ($IconErreur) {$Icon = 16 }
    elseif ($IconQuestion) {$Icon = 32 }
    elseif ($IconAvertissement) {$Icon = 48 }
    elseif ($IconInformation) {$Icon = 64 }
    else {$Icon = 0 }
    

    # Charger la bibliotheque d'objets graphiques Windows.Forms
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

    # Afficher la boite de dialogue et renvoyer la valeur de retour (bouton appuyE)
    $Reponse = [System.Windows.Forms.MessageBox]::Show($Message, $Titre , $Btn, $Icon)
    Return $Reponse
}

# Récupérer des infos sur la taille
function Get-AllSize
{
    $letters = (Get-CimInstance -Class Win32_LogicalDisk).DeviceID
    foreach($letter in $letters)
    {
        $Size = ( Get-CimInstance -Class Win32_LogicalDisk `
                  | Where-Object -Property DeviceID -eq $letter `
                  | Select-Object -Property DeviceID, 
                  @{ 
                      label='Size' 
                      expression={(($_.Size)/1GB).ToString('F2')}
                   }).size

        $UsedSpace = ( Get-CimInstance -Class Win32_LogicalDisk `
                       | Where-Object -Property DeviceID -eq $letter `
                       | Select-Object -Property DeviceID, 
                       @{ 
                           label='UsedSpace' 
                           expression={(($_.Size - $_.FreeSpace)/1GB).ToString('F2')} 
                        }).UsedSpace

                        
           Write-Output "Size --> $letter = $Size Go "
           Write-Output "UsedSpace --> $letter = $UsedSpace = Go"


           $maths = $UsedSpace / $Size
           $TauxOccupation = $maths * 100

           Write-Output "Taux d'occupation --> $letter = $TauxOccupation% `n`n"
    }
}

# Version actuelle de windows
function Get-WinVers()
{
    $win_release = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").displayversion
    
    if (!($win_release)) 
    {
        #Version ?
        $win_release = (Get-ItemProperty -Path "$env:windir\system32\hal.dll").VersionInfo.FileVersion.split('(')[0]
        $win_release = $win_release.split('.')[0] + "." + $win_release.split('.')[1]+ "." + $win_release.split('.')[2]

        #Version ?
        Switch ($win_release)
        {
            default { $win_release = $null }
            "10.0.14393" { $win_release = "1607" }
            "10.0.15063" { $win_release = "1703" }
            "10.0.16299" { $win_release = "1709" }
            "10.0.17134" { $win_release = "1803" }
            "10.0.17763" { $win_release = "1809" }
            "10.0.18362" { $win_release = "1903" }
            "10.0.18363" { $win_release = "1909" }
            "10.0.19041" { $win_release = "2004" }
            "10.0.19042" { $win_release = "20H2" }
            "10.0.19043" { $win_release = "21H1" }
            "10.0.19044" { $win_release = "21H2" }
            "10.0.20348" { $win_release = "21H2" }
        }
    }
    return $win_release
}

# get number of all Unused Items (Files Folders) (you can choose the CutOffDate)
# récupère le nombre de fichiers+dossiers non utilisé (avec le param -CutOffDate, on choisis la date qui définit ce qui 
# est considéré comme "Out of date")
function Get-NumberOfUnusedItems
{
    param
    (
        [Parameter(Mandatory=$false)]
        [ValidateScript({$_ -match '^\d{2}\/\d{2}\/\d{4} \d{2}:\d{2}:\d{2} [AP]M$'})]
        [string]$CutOffDate
    )
    if(!$CutOffDate)
    {
        $AM_PM = Get-Date -Format tt
        $date = (Get-Date -Format "MM/dd/yyyy HH:mm:ss") + $AM_PM
    }
    else { $date = $CutOffDate }

    $let = (Get-PSDrive).Name
    Write-Output "Searching, pls wait..."
    $ok =""
    foreach ($letter in $let)
    {
        if(($letter.Length -lt 2) -and ($letter.Length -gt 0))
        {
            $ok += Get-ChildItem "${letter}:\" -Force -Recurse -ErrorAction Ignore | Where-Object -Property LastAccessTime -lt $date | Select-Object Name, *time
        }
    }
    if($ok -eq "") { Write-Output "There is no File or Folder which is OutOfDate" }
    else { return $ok.Count }
}

funtion Remove-LimitedConnection
{
    $log = Get-Item "$env:windir\Logs\Scripts-DRF\Check-MeeteredConnection.log" -ErrorAction Ignore

    if($log.Length -ge 100000000) { Rename-Item -Path "$env:windir\Logs\Scripts-DRF\Check-MeeteredConnection.log" -NewName "Check-MeeteredConnection(old).log" -Force }
    elseif($log.Length -ge 200000000) { Remove-Item "$env:windir\Logs\Scripts-DRF\Check-MeeteredConnection(old).log" -Force }
    else { Start-Transcript "$env:windir\Logs\Scripts-DRF\Check-MeeteredConnection.log" -Append -Force }


    $Startdate = Get-Date -Format 'dd/MM/yyyy HH:mm:ss' -ErrorAction Ignore
    Write-Host "Startd at : $Startdate" -ErrorAction Ignore

    $nicGuid = (Get-NetAdapter | Where { $_.InterfaceDescription -like "*Ethernet*" }).InterfaceGuid
    $count = $nicGuid.Count
    Write-Host "INFO : Il y a $count interfaces réseaux" -ForegroundColor Yellow -ErrorAction Ignore

    foreach($interface in $nicGuid)
    {
        $regValue = (Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\*" -Name UserCost -ErrorAction Ignore)
        if($regValue -eq 0)
        {
            Write-Warning "Une valeur $regValue a été trouvée pour les clées de registre de limitation de réseau..." -ErrorAction Ignore
            Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\*" -Name UserCost -Value 1 -Force
            Restart-Service -Name DusmSvc -Force

            $regValue = (Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\*" -Name UserCost -ErrorAction Ignore)
            # Vérification
            if($regValue -eq 1) 
            { 
                Write-Host "INFO : Tâche éffectuée avec succès ! " -ForegroundColor Green -ErrorAction Ignore 
            }
            elseif((Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\*" -Name UserCost -ErrorAction Ignore) -eq 0)
            {
                Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\*" -Name UserCost -Value 1 -Force
                Restart-Service -Name DusmSvc -Force
                $regValue = (Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\*" -Name UserCost -ErrorAction Ignore)
                if($regValue -eq 0) 
                { 
                    Write-Host "ERROR : HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\* --> UserCost n'est pas modifiée à 1 ! " -ForegroundColor Red -ErrorAction Ignore 
                }
                elseif((Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\*" -Name UserCost -ErrorAction Ignore) -eq 1)
                {
                    Write-Host "INFO : Tâche éffectuée avec succès ! (après avoir eu un éssaie loupé)" -ForegroundColor Green -ErrorAction Ignore 
                }
            }
        }
        else
        {
            Write-Host "INFO de la valeur des clées registre pour le réseau limité n'est pas définie pour HKLM:\SOFTWARE\Microsoft\DusmSvc\Profiles\$interface\* (valeur de la clé : $regValue) " -ErrorAction Ignore
        } 
    }

    $dateEnd = Get-Date -Format 'dd/MM/yyyy HH:mm:ss' -ErrorAction Ignore
    Write-Host "Ended at : $dateEnd" -ErrorAction Ignore

    Stop-Transcript
}
