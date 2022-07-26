<#

Création Software Update Group  dans SCCM une fois par mois
Joel / Samuel novembre 2021

Corrigé par Samuel PAGES le 18/02/2022

Ce script permet la création (tous les mois) du déploiement des patchs ainsi que du UpdatesoftwareGroup (novembre - 2021, décembre - 2021, etc....)

#>

$ErrorActionPreference = 'Ignore'

# Log : Forcé, se supprime si trop gros 
if(Test-Path "C:\Tache_Auto\CreationPatchs-SCCM(old).log") 
{ 
    $log1 = (Get-ChildItem "C:\Tache_Auto\CreationPatchs-SCCM(old).log").Length 
    if($log1 -gt 500000) { Remove-Item "C:\Tache_Auto\CreationPatchs-SCCM(old).log" -Force | Out-Null }
} 

if(Test-Path "C:\Tache_Auto\CreationPatchs-SCCM.log") 
{
    $log = (Get-ChildItem "C:\Tache_Auto\CreationPatchs-SCCM.log").Length 
    if($log -gt 100000) { Rename-Item "C:\Tache_Auto\CreationPatchs-SCCM.log" -Force -NewName "CreationPatchs-SCCM(old).log" -PassThru | Out-Null } 
}

Start-Transcript "C:\Tache_Auto\CreationPatchs-SCCM.log" -Force -Append

$testdate = Get-Date -Format "dd/MM/yyyy"

# Site configuration
$SiteCode = "CME" # Site code 
$ProviderMachineName = "" # SMS Provider machine name

# Customizations
$initParams = @{}
#$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
#$initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

# Do not change anything below this line

# Import the ConfigurationManager.psd1 module 
if((Get-Module ConfigurationManager) -eq $null)
{
    Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
}

# Connect to the site's drive if it is not already present
if((Get-PSDrive -Name $SiteCode -PSProvider CMSite) -eq $null) 
{
    New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
}

# Set the current location to be the site code.
Set-Location "$($SiteCode):\" @initParams


# Gestion des Dates
$CurrentDate = Get-Date
$Month = ($CurrentDate).ToUniversalTime().Month
$Year = ($CurrentDate).ToUniversalTime().Year
$MonthName = $Month | %{(Get-Culture).DateTimeFormat.GetMonthName($_)}

Switch ($MonthName)
{
    'January'   { $MonthName = 'Janvier'   }
    'February'  { $MonthName = 'Fevrier'   }
    'April'     { $MonthName = 'Avril'     }
    'May'       { $MonthName = 'Mai'       }
    'June'      { $MonthName = 'Juin'      }
    'July'      { $MonthName = 'Juillet'   }
    'August'    { $MonthName = 'Aout'      }
    'September' { $MonthName = 'Septembre' }
    'October'   { $MonthName = 'Octobre'   }
    'November'  { $MonthName = 'Novembre'  }
    'December'  { $MonthName = 'Decembre'  }
}

$mois = "$Year"+" $MonthName"

# nom du package (comme WSUS2021)
$Package= "WSUS"+"$Year"

# 2eme mardi du mois
function SecondTuesday  
{
    $FindNthDay=2
    $WeekDay='Tuesday'
    [datetime]$Today=[datetime]::NOW
    $todayM=$Today.Month.ToString()
    $todayY=$Today.Year.ToString()
    [datetime]$StrtMonth=$todayM+'/1/'+$todayY

    while ($StrtMonth.DayofWeek -ine $WeekDay ) { $StrtMonth=$StrtMonth.AddDays(1) }
    return $StrtMonth.AddDays(7*($FindNthDay-1)) 
}

#1 jeudi du mois après le 2eme mardi, 1er lundi après, 1er mercredi après
$date = SecondTuesday
$datejeudiAM = $date.AddDays(2).ToString("yyyy/MM/dd") + " 11:00AM"
$datejeudiPM = $date.AddDays(2).ToString("yyyy/MM/dd") + " 01:00PM"
$datelundiAM = $date.AddDays(6).ToString("yyyy/MM/dd") + " 10:00AM"
$datelundiPM = $date.AddDays(6).ToString("yyyy/MM/dd") + " 07:00PM"
$dateMercredi = $date.AddDays(8).ToString("yyyy/MM/dd")+ " 12:01PM"
$datelundi2031 = "2031/07/12 10:00AM"

$nomPremierPatch = "Security Update for Microsoft Visio Viewer 2010 (KB2999465) 32-Bit Edition"

$EmailAddress = ""
$Server = ""
$Encoding = "UTF8"
$Sender = ""
$Subject = "Report des Création de Patchs : $mois"

$Body = ""

#creaion du software group du mois
New-CMSoftwareUpdateGroup -name $mois
$Body += "Fait :  Création de '$mois' ($testdate) <br> "
Write-Host "Fait :  Création de '$mois' ($testdate)" -ForegroundColor Green 

#avant passage suivant, il faut mettre un patch dans la collection!!
#Save-CMSoftwareUpdate -SoftwareUpdateName $nomPremierPatch -DeploymentPackageName  $Package

Add-CMSoftwareUpdateToGroup  -SoftwareUpdateGroupName $mois -SoftwareUpdateName $nomPremierPatch
$Body += "Fait : ajout de '$nomPremierPatch' dans '$mois' ($testdate) <br> " 
Write-Host "Fait : ajout de '$nomPremierPatch' dans '$mois' ($testdate)" -ForegroundColor Green

#Création des 4 deploiement
# PC Patchs Standards  
New-CMSoftwareUpdateDeployment -DeploymentName "$mois - PC Patchs Standards" -SoftwareUpdateGroupName $mois `
    -CollectionName "PC Patchs Standards"  -DeploymentType Required -VerbosityLevel AllMessages `
    -AvailableDateTime $datelundiAM -DeadlineDateTime $dateMercredi -UserNotification DisplayAll `
    -SoftwareInstallation $True -AllowRestart $True  -RestartServer $False `
    -RestartWorkstation $False -PersistOnWriteFilterDevice $True `
    -RequirePostRebootFullScan $True -ProtectedType RemoteDistributionPoint ;


$Body += "Fait : Déploiement de '$mois - PC Patchs Standards' ($testdate) <br> "
Write-Host "Fait : Déploiement de '$mois - PC Patchs Standards' ($testdate)" -ForegroundColor Green 

# "PC sans Patchs"
New-CMSoftwareUpdateDeployment -DeploymentName "$mois - PC sans Patchs" -SoftwareUpdateGroupName $mois `
    -CollectionName "PC sans Patchs"  -DeploymentType Required -VerbosityLevel AllMessages `
    -AvailableDateTime $datelundiAM -DeadlineDateTime $datelundi2031 -UserNotification DisplayAll `
    -SoftwareInstallation $True  -AllowRestart $True -RestartServer $False -RestartWorkstation $False `
    -PersistOnWriteFilterDevice $True -RequirePostRebootFullScan $True -ProtectedType RemoteDistributionPoint ;


$Body += "Fait : Déploiement de '$mois - PC sans Patchs' ($testdate) <br> "
Write-Host "Fait : Déploiement de '$mois - PC sans Patchs' ($testdate)" -ForegroundColor Green 

#"Serveurs Patchs"
New-CMSoftwareUpdateDeployment -DeploymentName "$mois - Serveurs Patchs" -SoftwareUpdateGroupName $mois `
    -CollectionName "Serveurs Patchs"  -DeploymentType Required -VerbosityLevel AllMessages `
    -AvailableDateTime $datelundiAM -DeadlineDateTime  $datelundiPM -UserNotification DisplayAll `
    -SoftwareInstallation $False -AllowRestart $False -RestartServer $False -RestartWorkstation $False `
    -PersistOnWriteFilterDevice $True -RequirePostRebootFullScan $True -ProtectedType RemoteDistributionPoint ;


$Body += "Fait : Déploiement de '$mois - Serveurs Patchs' ($testdate) <br> "
Write-Host "Fait : Déploiement de '$mois - Serveurs Patchs' ($testdate)" -ForegroundColor Green 

#"Preview_Updates_Mensuelles"
New-CMSoftwareUpdateDeployment -DeploymentName "$mois - Preview_Updates_Mensuelles" -SoftwareUpdateGroupName $mois `
    -CollectionName "Preview_Updates_Mensuelles"  -DeploymentType Required -VerbosityLevel AllMessages `
    -AvailableDateTime $datejeudiAM -DeadlineDateTime $datejeudiPM -UserNotification DisplayAll `
    -SoftwareInstallation $True  -AllowRestart $True -RestartServer $False -RestartWorkstation $False `
    -PersistOnWriteFilterDevice $True -RequirePostRebootFullScan $True -ProtectedType RemoteDistributionPoint ;


$Body += "Fait : Déploiement de '$mois - Preview_Updates_Mensuelles' ($testdate) <br> "
Write-Host "Fait : Déploiement de '$mois - Preview_Updates_Mensuelles' ($testdate)" -ForegroundColor Green 

$BodyText = "<!DOCTYPE HTML>"
$BodyText += "<HTML><HEAD><META http-equiv=Content-Type content='text/html; charset=iso-8859-1'>"
$BodyText += "</HEAD><BODY><DIV style='font-size:14.5px; font-family:Calibri;'>"
$BodyText += $Body
$BodyText += "</DIV></BODY></HTML>"

Send-MailMessage -from $Sender -To $EmailAddress -Subject $Subject -Body $BodyText -BodyAsHtml -Encoding $Encoding -SmtpServer $Server 

Stop-Transcript
