<#
    Finit le 28/06/2022 par Samuel PAGES 
    Le script permet : https://esrefirfu.extra.cea.fr/seedocument.php?id=75
    d'aller chercher les sources des applications et les deplacer dans dsmecommuns 
    Le Parametre -help dans "Download-Application -Help" permet d'avoir un petit exemple de comment fonctionne la fonction Download-Application
#>

Import-Module "C:\Tache_Auto\Download-Application.psm1" -Function Download-Application -Force -DisableNameChecking -Verbose


[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

# Execute Module :

$VLC = 
@{
    ApplicationName = 'VLC'
    
    DownloadLink = "http://download.videolan.org/pub/videolan/vlc/[Version]/win64/vlc-[Version]-win64.msi" 
    AllVersionLink = "https://download.videolan.org/pub/videolan/vlc/"
    
    OutFolder = "\\...\produits\Instapc\Freeware\VLC\LastVersion" 
    
    SplitLeft = "vlc-" 
    SplitRight = "-win64.msi"
    ReferenceVersion = "3.0.17.0"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 
}

$7Zip = 
@{
    ApplicationName = '7-Zip'
    
    DownloadLink = "https://sourceforge.net/projects/sevenzip/files/7-Zip/[Version7]/7z[Version]-x64.exe/download" 
    AllVersionLink = "https://sourceforge.net/projects/sevenzip/files/7-Zip/"
    
    OutFolder = "\\...\produits\Instapc\Freeware\7-Zip\LastVersion" 
    
    SplitLeft = "7z" 
    SplitRight = "-x64.exe"
    ReferenceVersion = "21.06"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 
}

$Notepad32 = 
@{
    ApplicationName = 'Notepad++'
    
    DownloadLink = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v[Version]/npp.[Version].Installer.exe" 
    AllVersionLink = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases"
    
    OutFolder = "\\...\produits\Instapc\Freeware\Notepad++\LastVersion" 
    
    SplitLeft = "npp." 
    SplitRight = ".Installer.exe"
    ReferenceVersion = "8.4.1"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 

    InvokeSpecialRequest = (((((Invoke-WebRequest -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases").Links  | Format-List href) | Out-String).Replace('href : ','').Replace(' ','').Replace('..','').replace('v','').Split('/') -replace "\s", "" -ne ' ' -match "\d+" -like "*x64*" -notlike "*.sig" -notlike "*.7z" -notlike "*.zip").Replace('npp.','').Replace('.Installer.x64.exe','')) -replace "\s", "" -notmatch '[a-z]' -notmatch '[A-Z]'
}

$Notepad64 = 
@{
    ApplicationName = 'Notepad++'
    
    DownloadLink = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v[Version]/npp.[Version].Installer.exe" 
    AllVersionLink = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases"
    
    OutFolder = "\\...\produits\Instapc\Freeware\Notepad++\LastVersion" 
    
    SplitLeft = "npp." 
    SplitRight = ".Installer.x64.exe"
    ReferenceVersion = "8.4.1"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 

    InvokeSpecialRequest = (((((Invoke-WebRequest -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases").Links  | Format-List href) | Out-String).Replace('href : ','').Replace(' ','').Replace('..','').replace('v','').Split('/') -replace "\s", "" -ne ' ' -match "\d+" -like "*x64*" -notlike "*.sig" -notlike "*.7z" -notlike "*.zip").Replace('npp.','').Replace('.Installer.x64.exe','')) -replace "\s", "" -notmatch '[a-z]' -notmatch '[A-Z]'
}

$KeePass = 
@{
    ApplicationName = 'KeePass'
    
    DownloadLink = "https://sourceforge.net/projects/keepass/files/KeePass%202.x/[Version]/KeePass-[Version]-Setup.exe/download"
    AllVersionLink = "https://sourceforge.net/projects/keepass/files/KeePass%202.x/" 
    
    OutFolder = "\\...\produits\Instapc\Freeware\KeePass\LastVersion" 
    
    SplitLeft = "KeePass-" 
    SplitRight = "-Setup.exe"
    ReferenceVersion = "2.50.1"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 
}

$PuTTY = 
@{
    ApplicationName = 'PuTTY'
    
    DownloadLink = "https://the.earth.li/~sgtatham/putty/[Version]/w64/putty-64bit-[Version]-installer.msi"
    AllVersionLink = "https://www.chiark.greenend.org.uk/~sgtatham/putty/changes.html" 
    
    OutFolder = "\\...\produits\Instapc\Freeware\PuTTY\LastVersion" 
    
    SplitLeft = "putty-64bit-" 
    SplitRight = "-installer.msi"
    ReferenceVersion = "0.76"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 

    InvokeSpecialRequest = (((Invoke-WebRequest -Uri "https://www.chiark.greenend.org.uk/~sgtatham/putty/changes.html").Links  | Format-List outerText) | Out-String).Replace('outerText : ','').Split('')  -replace "\s", "" -notlike "#*" -notlike "* *" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
}

$FileZilla = 
@{
    ApplicationName = 'FileZilla'
    
    DownloadLink = "https://download.filezilla-project.org/client/FileZilla_[Version]_win64-setup.exe"
    AllVersionLink = "https://download.filezilla-project.org/client/"
    
    OutFolder = "\\...\produits\Instapc\Freeware\FileZilla\LastVersion" 
    
    SplitLeft = "FileZilla_" 
    SplitRight = "_win64-setup.exe"
    ReferenceVersion = "3.60.0"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 

    InvokeSpecialRequest = (((Invoke-WebRequest -Uri "https://download.filezilla-project.org/client/").Links  | Format-List href) | Out-String).Replace("href : ","").Replace(" ","").Replace("-","").Split("_") -replace "\s", "" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
}

$WinSCP = 
@{
    ApplicationName = 'WinSCP'
    
    DownloadLink = "https://sourceforge.net/projects/winscp/files/WinSCP/[Version]/WinSCP-[Version]-Setup.exe/download"
    AllVersionLink = "https://sourceforge.net/projects/winscp/files/WinSCP/"
    
    OutFolder = "\\...\produits\Instapc\Freeware\Winscp\LastVersion" 
    
    SplitLeft = "WinSCP-" 
    SplitRight = "-Setup.exe"
    ReferenceVersion = "5.20.0"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 
}


$PaintDotNet = 
@{
    ApplicationName = 'Paint.NET'
    
    DownloadLink = "https://github.com/paintdotnet/release/releases/download/v[Version]/paint.net.[Version].winmsi.x64.zip"
    AllVersionLink = "https://github.com/paintdotnet/release/releases"
    
    OutFolder = "\\...\produits\Instapc\Freeware\Paint.NET\LastVersion" 
    
    SplitLeft = "paint.net." 
    SplitRight = ".winmsi.x64.zip"
    ReferenceVersion = "4.3.10"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 

    InvokeSpecialRequest = (((Invoke-WebRequest -Uri "https://github.com/paintdotnet/release/releases").Links  | Format-List href) | Out-String).Replace('href : ','').Replace(' ','').Replace('..','').Replace('v','').Split('/')  -replace "\s", "" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
    
    Extract = $true
}

$PDFSam = 
@{
    ApplicationName = 'PDFSam'
    
    DownloadLink = "https://sourceforge.net/projects/pdfsam/files/v[Version]/pdfsam-[Version].msi/download"
    AllVersionLink = "https://sourceforge.net/projects/pdfsam/files/"
    
    OutFolder = "\\...\produits\Instapc\Freeware\pdfsam\LastVersion" 
    
    SplitLeft = "pdfsam-" 
    SplitRight = ".msi"
    ReferenceVersion = "4.3.1"
   
    MailRecever = ""
    MailSender = "" 
    MailEncoding = "UTF8" 
    MailServer = "" 

    InvokeSpecialRequest = (((Invoke-WebRequest -Uri "https://sourceforge.net/projects/pdfsam/files/").Links | Format-List href) | Out-String).Replace('href : ','').Replace(' ','').Replace('..','').Replace('v','').Split('/')  -replace "\s", "" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
}

<#$AutreApplication = 
@{
    ApplicationName = ''
    
    DownloadLink = ""
    AllVersionLink = ""
    
    OutFolder = "" 
    
    SplitLeft = "" 
    SplitRight = ""
    ReferenceVersion = ""
   
    MailRecever = "IRFU-AdminSysWindows@cea.fr"
    MailSender = "sccm-drf-e@cea.fr" 
    #MailCopy = "" 
    MailEncoding = "UTF8" 
    MailServer = "mx.extra.cea.fr" 
}
#>

$d = Get-Date -Format "dd/MM/yyyy HH:mm:ss"

$transcript = Get-ChildItem -Path "C:\Tache_Auto\WebRequestLog\" -Force | Where-Object -Property Name -eq "WebRequest.log"

if(($transcript) -and ($transcript.Length) -ge 900000)
{
    Remove-Item "C:\Tache_Auto\WebRequestLog\WebRequest.log" -Force
}
Start-Transcript "C:\Tache_Auto\WebRequestLog\WebRequest.log" -Force -Append

Write-Host "Start date : $d" 

Download-Application @VLC
Download-Application @7Zip
Download-Application @Notepad32 
Download-Application @Notepad64 
Download-Application @KeePass 
Download-Application @PuTTY 
Download-Application @FileZilla 
Download-Application @WinSCP
Download-Application @PaintDotNet
Download-Application @PDFSam
#Download-Application @AutreApplication

Stop-Transcript 

            
