<#

Finit le 10/11/2021 par Samuel PAGES et Joël SURGET 
Modifs le 13/01/2022 par Samuel PAGES
Le script sert à télécharger les patchs dans WSUS de l'année qu'il faut
Le script se lance le mercredi apres le 2e mardi du mois et les 6 jours d'apres (jusquau lundi)
Exemple : du 10/11/2021 au 15/11/2021
Modifié le 26/07/2022 par Samuel PAGES (Switch ligne 33 et ligne 56)
#>


# Gestion des logs avant le commencement du script 
$dateTranscript = Get-Date -Format "dd/MM/yyyy"
$Anne = $dateTranscript.Split('/')[2]
$ErrorActionPreference = 'Ignore'

# pour le foreach (ligne.39)
$childs = (Get-ChildItem "C:\Tache_Auto\Logs-DownloadPatchs-SCCM").Name

# pour récupérer les logs existants
if($childs -eq $null) 
{ 
    $child = "" 
} 
else 
{ 
    $child = (Get-ChildItem "C:\Tache_Auto\Logs-DownloadPatchs-SCCM").Name.Split()[0] 
}

# si on est la bonne année
if( ($child.Split('-')[1]) -eq $Anne) 
{
    Switch ($dateTranscript.Split('/')[1])
    {
        '01' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Janvier-$Anne-Patchs.log" -Append -Force }
        '02' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Fevrier-$Anne-Patchs.log" -Append -Force }
        '03' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Mars-$Anne-Patchs.log" -Append -Force }
        '04' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Avril-$Anne-Patchs.log" -Append -Force }
        '05' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Mai-$Anne-Patchs.log" -Append -Force }
        '06' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Juin-$Anne-Patchs.log" -Append -Force }
        '07' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Juillet-$Anne-Patchs.log" -Append -Force }
        '08' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Aout-$Anne-Patchs.log" -Append -Force }
        '09' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Septembre-$Anne-Patchs.log" -Append -Force }
        '10' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Octobre-$Anne-Patchs.log" -Append -Force }
        '11' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Novembre-$Anne-Patchs.log" -Append -Force }
        '12' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Decembre-$Anne-Patchs.log" -Append -Force }
    }
} 
else 
{

    #suppression des logs de l'année / si on est pas la bonne année
    foreach ($log in $childs) { if($log.Endswith('.log')) { Remove-Item "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\$log" -Force } }

    # création dans tous les cas du fichier de logs
    Switch ($dateTranscript.Split('/')[1])
    {
        '01' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Janvier-$Anne-Patchs.log" -Append -Force }
        '02' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Fevrier-$Anne-Patchs.log" -Append -Force }
        '03' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Mars-$Anne-Patchs.log" -Append -Force }
        '04' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Avril-$Anne-Patchs.log" -Append -Force }
        '05' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Mai-$Anne-Patchs.log" -Append -Force }
        '06' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Juin-$Anne-Patchs.log" -Append -Force }
        '07' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Juillet-$Anne-Patchs.log" -Append -Force }
        '08' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Aout-$Anne-Patchs.log" -Append -Force }
        '09' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Septembre-$Anne-Patchs.log" -Append -Force }
        '10' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Octobre-$Anne-Patchs.log" -Append -Force }
        '11' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Novembre-$Anne-Patchs.log" -Append -Force }
        '12' { Start-Transcript -Path "C:\Tache_Auto\Logs-DownloadPatchs-SCCM\Decembre-$Anne-Patchs.log" -Append -Force }
    }
}

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

#SofwareUpdate Name : référence pour créer un Package de depoiement par exemple WSUS2022
$SoftNameRef = "Security Update for Microsoft Visio Viewer 2010 (KB2999465) 32-Bit Edition" 

# nom du package de cette année
$Package = "WSUS"+"$Year"

function SecondTuesday  
{
    $FindNthDay = 2
    $WeekDay = 'Tuesday'
    [datetime]$Today = [datetime]::NOW
    $todayM = $Today.Month.ToString()
    $todayY = $Today.Year.ToString()
    [datetime]$StrtMonth = $todayM+'/1/'+$todayY

    while ($StrtMonth.DayofWeek -ine $WeekDay ) { $StrtMonth=$StrtMonth.AddDays(1) }
    return $StrtMonth.AddDays(7*($FindNthDay-1)) 
}

$date = SecondTuesday
$dateTest = Get-Date -Format "dd/MM/yyyy"

$date1 = $date.AddDays(1).ToString("dd/MM/yyyy") #Mercredi apres le 2nd mardi du mois
$date2 = $date.AddDays(2).ToString("dd/MM/yyyy") #Jeudi apres le 2nd mardi du mois
$date3 = $date.AddDays(3).ToString("dd/MM/yyyy") #Vendredi apres le 2nd mardi du mois
$date4 = $date.AddDays(4).ToString("dd/MM/yyyy") #Samedi apres le 2nd mardi du mois
$date5 = $date.AddDays(5).ToString("dd/MM/yyyy") #Dimanche apres le 2nd mardi du mois
$date6 = $date.AddDays(6).ToString("dd/MM/yyyy") #Lundi apres le 2nd mardi du mois


# Var for mails
$EmailAddress = ""
$Server = ""
$Encoding = "UTF8"
$Sender = ""

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


# SI ON EST AU MOINS : le mercredi après le 2e mardi du mois ET AU PLUS : le lundi suivant le 2e mardi du mois
if( ($dateTest -eq $date1) -or ($dateTest -eq $date2) -or ($dateTest -eq $date3) -or ($dateTest -eq $date4) -or ($dateTest -eq $date5) -or ($dateTest -eq $date6) ) {
    
    # Package de cette année
    $PackageTest = (Get-CMSoftwareUpdateDeploymentPackage -Name $Package)
    

    # si le package de cette année n'est pas créé, alors on le crée 
    if ($PackageTest.Name -ne $Package ) 
    {

        $WsusPath = "\\...\sources_sccm\WSUS\"
                
        if(Test-Path "$WsusPath\$Package") 
        {
            # Set Location a C:\ pour avoir les bons droits
            Set-Location 'C:\' -PassThru -ErrorAction Continue
            New-Item -Path $WsusPath -Name $Package -ItemType Directory -Force

        elseif((Get-CMSoftwareUpdateDeploymentPackage -Name $Package) -eq $false) 
        {
            # Set Location a PS CME:\>  pour avoir les bons droits
            if((Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue) -eq $null) 
            { 
                New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams 
            }
            Set-Location "$($SiteCode):\" @initParams

            New-CMSoftwareUpdateDeploymentPackage -Name $Package -Fast -Path $WsusPath -Priority Normal -Description "Créé par le script : DownloadPatchs-SCCM.ps1 (sur ...) " -Verbose -ErrorVariable err1
            #$Get = Get-CMSoftwareUpdateDeploymentPackage -Name $Package | Set-CMPackage -EnableBinaryDeltaReplication $true -PrestageBehavior ManualCopy

            Update-CMDistributionPoint -SoftwareUpdateDeploymentPackageName $Package -Verbose -ErrorVariable err2
            Start-Sleep 5
            
            if($err1) 
            { 
                Write-Warning "Package $Package Création sur SCCM Problème ?" 
            }
            if($err2)
            { 
                Write-Warning "Package $Package Update Failed ? Voir SCCM ..." 
            }

            if((-not $err1) -and (-not $err2)) 
            { 
                $Subject = "INFO ET MODIFS A FAIRE : la  création de CMSoftwareUpdateDeploymentPackage : $Package"
                $Body = "La création de $Package s'est bien déroulé... MAIS il faut lancer Configuration Manager Console puis dans \Software Library\Overview\Software Updates\Deployment Packages clique droit sur $Package puis properties,
                 Cocher : 'Enable Binary differential replication' puis toujours dans properties aller dans 'Distribution settings' et cocher 'Manually Copy...' Et voilà !"

                $BodyText = "<!DOCTYPE HTML>"
                $BodyText += "<HTML><HEAD><META http-equiv=Content-Type content='text/html; charset=iso-8859-1'>"
                $BodyText += "</HEAD><BODY><DIV style='font-size:14.5px; font-family:Calibri;'>"
                $BodyText += $Body
                $BodyText += "</DIV></BODY></HTML>";	

                Write-Host "$Package created and updated in distribution point !" -ForegroundColor Green 
                Send-MailMessage -from $Sender -To $EmailAddress -Subject $Subject -Body $BodyText -BodyAsHtml -Encoding $Encoding -SmtpServer $Server 
            }
        }
        if($PackageTest.Name -ne $Package) 
        {
            Write-Host "New-CMSoftwareUpdateDeploymentPackage -Name $Package : Failed `nOu Update-CMDistributionPoint -SoftwareUpdateDeploymentPackageName $Package : Failed `nOu les deux. "
            

            $Subject = "ERREUR : Les Patchs dans $Package (pas réussis à créer/update?)"
            $Body = "New-CMSoftwareUpdateDeploymentPackage -Name $Package : Failed <br>Ou Update-CMDistributionPoint -SoftwareUpdateDeploymentPackageName $Package : Failed <br>Ou les deux."

            $BodyText = "<!DOCTYPE HTML>"
            $BodyText += "<HTML><HEAD><META http-equiv=Content-Type content='text/html; charset=iso-8859-1'>"
            $BodyText += "</HEAD><BODY><DIV style='font-size:14.5px; font-family:Calibri;'>"
            $BodyText += $Body
            $BodyText += "</DIV></BODY></HTML>";	
            
            try 
            { 
                Send-MailMessage -from $Sender -To $EmailAddress -Subject $Subject -Body $BodyText -BodyAsHtml -Encoding $Encoding -SmtpServer $Server    
                Write-Warning "Mail pour erreur envoyé !"
            }
            catch 
            {
                Write-Error "AUCUN MAIL ENVOYE !!!!!!!" -ErrorId 3  
            }
        } 
    }

    # GetCMSU : récupère les patchs disponibles à installer (voir dans SCCM\Software Library\Overview\Software Updates\All Software Updates\ 
    # SavedSearches\Manage Searches for Current Node\Patchs Required ET non expirés ET non approuvés ET non supersded ET ne contenant pas Defender
    # le script a été changé me 10/03/2022 par Samuel PAGES : -NotLike (avant : -NotContains) ci-dessous
    $GetCMSU = (((Get-CMSoftwareUpdate  -Fast `
                                        -IsSuperseded 0 `
                                        -IsDeployed 0 `
                                        -IsExpired 0 `
                                        | Where-Object NumMissing -ge 1 ) `
                                        | Where-Object LocalizedDisplayName -NotLike "*Defender*") `
                                        | Where-Object LocalizedDisplayName -NotLike "Feature Update*" `
                                        | Where-Object LocalizedDisplayName -NotLike "*Windows Malicious Software Removal Tool*" `
                                        | Where-Object ObjectPath -eq "/").LocalizedDisplayName ;
    
    
    # Si des patchs sont trouvé alors ont les liste pour les logs et on les telecharge et on les met dans WSUS de cette année
    if ($GetCMSU.count -ne 0)
    {
        Write-Host "Les patchs dispo trouvés sont : " -ForegroundColor Gray -ErrorAction SilentlyContinue
        $Body = " Patchs à télécharger : <br><br>  " 
        
        foreach ($patchs in $GetCMSU)
        { 
            Write-Host "$patchs" -ForegroundColor Cyan -ErrorAction SilentlyContinue 
            $Body += $patchs  + " <br> "
        }
        # démarcation entre mes patchs dispo et la sauvegarde de ceux-ci
        Write-Host "-----------------------------------------------------------------"
        $Erreur=$null
        # On essaie la sauvegarde 1 par 1 des patchs et on les télécharge dans le WSUS de cette année
        # Si on y arrive pas on envoie un mail et on écrit le nom de lupdate qui n'a pas marché dans les logs
        foreach ($DataCMSU in $GetCMSU) 
        {
            try 
            { 
                Write-Host "Sauvegarde de $DataCMSU lancée..." -ForegroundColor Gray -ErrorAction Ignore
                Save-CMSoftwareUpdate -SoftwareUpdateName $DataCMSU -DeploymentPackageName $Package -Verbose
                Write-Host "Sauvegarde de $DataCMSU effectuée avec succes !" -ForegroundColor Green -ErrorAction Ignore
                Write-Host "Ajout de $DataCMSU dans $mois..." -ForegroundColor Cyan -ErrorAction Ignore
                Add-CMSoftwareUpdateToGroup -SoftwareUpdateGroupName $mois -SoftwareUpdateName $DataCMSU -Verbose
                Write-Host "Ajout de $DataCMSU dans $mois effectue avec succes ! " -ForegroundColor Green -ErrorAction Ignore
            }
            catch 
            {
                $Erreur = "$Erreur"+"`n- $DataCMSU"
                Write-Host "Erreur pour : $DataCMSU " -ForegroundColor Red -ErrorAction Ignore
            }
        }
        # Se lance si erreur dans le foreach
        if($Erreur.Length -gt 0) 
        {
            $Subject = "ERREUR : Les Patchs de '$mois' "
            $Body += "<br><br><strong>Les patchs : $Erreur <br> n'ont pas été sauvegardés correctement dans $Package et/ou n'ont pas été ajoutés à '$mois' </strong>"      
        }
        else 
        {
            $Subject = "Les Patchs de '$mois' ont été téléchargés"
            $Body +=  "<br><br><strong>Les patchs ci-dessus ont bien été correctement sauvegardés dans $Package et ont été ajoutés à '$mois' </strong>"
        }

        $BodyText = "<!DOCTYPE HTML>"
        $BodyText += "<HTML><HEAD><META http-equiv=Content-Type content='text/html; charset=iso-8859-1'>"
        $BodyText += "</HEAD><BODY><DIV style='font-size:14.5px; font-family:Calibri;'>"
        $BodyText += $Body
        $BodyText += "</DIV></BODY></HTML>";

        try 
        { 
            # Mail 1
            Send-MailMessage -from $Sender -To $EmailAddress -Subject $Subject -Body $BodyText -BodyAsHtml -Encoding $Encoding -SmtpServer $Server    
            Write-Warning "Mail envoyé !" -ErrorAction Ignore
        }
        catch 
        {
            Write-Error "AUCUN MAIL ENVOYE !!!!!!!" -ErrorAction SilentlyContinue
        }
    } 
    else 
    { 
        Write-Warning "Pas de Patchs disponibles à installer." 
    }
}

Stop-Transcript
