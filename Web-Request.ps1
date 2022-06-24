function Download-Application
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, Position=0)]
        [switch]$Help,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullorEmpty()]
        [string]$ApplicationName,

        [Parameter(Mandatory=$true, Position=2)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({
            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
            if(-not(Invoke-WebRequest -Uri $_)) 
            {
                throw "The link is not reachable"
            }    
            return $true
        })]
        [string]$AllVersionLink,

        [Parameter(Mandatory=$true, Position=3)]
        [ValidateNotNullorEmpty()]
        [string]$DownloadLink,

        [Parameter(Mandatory=$true, Position=4)]
        [ValidateNotNullorEmpty()]
        [ValidateScript({ 
            if(-not($_ | Test-Path))
            {
                throw "Folder does not exist"
            }
            return $true
        })]
        [System.IO.FileInfo]$OutFolder,

        [Parameter(Mandatory=$true, Position=5)]
        [ValidateNotNullorEmpty()]
        [string]$SplitLeft,

        [Parameter(Mandatory=$true, Position=6)]
        [ValidateNotNullorEmpty()]
        [string]$SplitRight,

        [Parameter(Mandatory=$true, Position=7)]
        [ValidateNotNullorEmpty()]
        [System.Version]$ReferenceVersion,

        [Parameter(Mandatory=$true, Position=8)]
        [ValidateNotNullorEmpty()]
        [mailaddress]$MailRecever,

        [Parameter(Mandatory=$true, Position=9)]
        [ValidateNotNullorEmpty()]
        [mailaddress]$MailSender,

        [Parameter(Mandatory=$false, Position=10)]
        [mailaddress]$MailCopy,

        [Parameter(Mandatory=$true, Position=11)]
        [ValidateNotNullorEmpty()]
        [string]$MailEncoding,

        [Parameter(Mandatory=$true, Position=12)]
        [ValidateNotNullorEmpty()]
        [string]$MailServer,

        [Parameter(Mandatory=$false, Position=13)]
        [ValidateNotNullorEmpty()]
        $InvokeSpecialRequest
    )


    begin 
    {

        if($Help)
        {
            return '
            
            Exemple : 


            $DefaultParameters = 
            @{
                ApplicationName = "FileZilla"
    
                DownloadLink = "https://download.filezilla-project.org/client/FileZilla_[Version]_win64-setup.exe" 
                AllVersionLink = "https://download.filezilla-project.org/client/" 
    
                OutFolder = "\\SERVER\produits\Instapc\Freeware\FileZilla\LastVersion" 
    
                SplitLeft = "FileZilla_" 
                SplitRight = "_win64-setup.exe"
                ReferenceVersion = "3.60.0" 
                MailRecever= "samuel.pages@cea.fr"
               # MailRecever = "IRFU-AdminSysWindows@cea.fr" 
                MailSender = "sccm-drf-e@cea.fr" 
                MailCopy = "samuel.pages@cea.fr" 
                MailEncoding = "UTF8" 
                MailServer = "mx.extra.cea.fr" 
                InvokeSpecialRequest = (((Invoke-WebRequest -Uri "https://download.filezilla-project.org/client/").Links  | Format-List href) | Out-String).Replace("href : ","").Replace(" ","").Replace("-","").Split("_")  -replace "\s", "" -notlike "#*" -notlike "* *" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
            }


            Download-Application @DefaultParameters

            If there is any version on your link : replace it :"https://sourceforge.net/projects/sevenzip/files/7-Zip/2107/7z2107-x64.exe/download" in "https://sourceforge.net/projects/sevenzip/files/7-Zip/[Version]/7z[Version]-x64.exe/download"
            and for 7-Zip :  "https://sourceforge.net/projects/sevenzip/files/7-Zip/[Version7]/7z[Version]-x64.exe/download" 
            Try : (((Invoke-WebRequest -Uri [YOUR_LINK]).Links  | Format-List href) | Out-String).Replace("href : ","").Replace(" ",'').Replace("-","").Split("_") -replace "\s", "" -notmatch "[a-z]" -notmatch "[A-Z]"
            And try to understand what filter you have to add on the Request to filter only versions  without any string or spaces
            '
        }

        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  # --> Sans cette ligne, certains téléchargements peuvent ne pas fonctionner

        if($InvokeSpecialRequest)
        {
            $VersionsApp = $InvokeSpecialRequest
        }
        else
        {
            $VersionsApp = (((Invoke-WebRequest -Uri $AllVersionLink).Links  | Format-List href) | Out-String).Replace('href : ','').Replace(' ','').Replace('..','').Split('/') -replace "\s", "" -notlike "#*" -notlike "* *" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
        }
    }

    process
    {
         # boucle foreach
        foreach($v in $VersionsApp) 
        { 
            $ErrorActionPreference = 0

            if([System.Version]$v -gt [System.Version]$ReferenceVersion)
            {
                if($v -eq $null)
                {
                    Write-Warning "Correct application Version : $v" 
                    $nbV = $v 
                }
                elseif([System.Version]$v -gt [System.Version]$nbV)
                {
                    Write-Warning "Correct application Version : $v" 
                    $nbV = $v
                }
            }
        }
        $ErrorActionPreference = 'Continue'

        # 7-zip est un cas particulier
        if($ApplicationName -like '*7*Zip*') 
        { 
            $vers = ($nbV -replace "\s", "").Replace('.','') 
            $nbV = ($nbV -replace "\s", "") 
        }
        else 
        { 
            $vers = ($nbV -replace "\s", "") 
            $vers
        }
        
        
    
    }
    end
    {
        $Body = ""

        if($vers -ne $null)
        {
            $DownloadLink = $DownloadLink.Replace("[Version]","$vers").Replace("[Version7]","$nbV")

            if(!(Test-Path "$OutFolder\${SplitLeft}${vers}${SplitRight}"))
            {

                $Subject = "New Applications Versions $OutFolder"
                $Body = "`n $ApplicationName : $OutFolder\${SplitLeft}${vers}${SplitRight}"
                
                try { Invoke-WebRequest -Uri "$DownloadLink" -OutFile "$OutFolder\${SplitLeft}${vers}${SplitRight}" -Verbose }
                catch {  Invoke-WebRequest -Uri "$DownloadLink" -OutFile "$OutFolder\${SplitLeft}${vers}${SplitRight}" -UserAgent "Wget" -Verbose }

            }
            else
            {
                Write-Warning "La derniere Version de $ApplicationName est déjà présente sur $OutFolder\${SplitLeft}${vers}${SplitRight}"
            }
    
        }
        
        if($Body -ne "")
        {
            $BodyText = "<!DOCTYPE HTML>"
            $BodyText += "<HTML><HEAD><META http-equiv=Content-Type content='text/html; charset=iso-8859-1'>"
            $BodyText += "</HEAD><BODY><DIV style='font-size:14.5px; font-family:Calibri;'>"
            $BodyText += $Body
            $BodyText += "</DIV></BODY></HTML>";

            if($MailCopy)
            {
                Send-MailMessage -from $MailSender -To $MailRecever -Subject $Subject -Body $BodyText -BodyAsHtml -Cc $MailCopy -Encoding $MailEncoding -SmtpServer $MailServer -Verbose
            }
            else
            {
                Send-MailMessage -from $MailSender -To $MailRecever -Subject $Subject -Body $BodyText -BodyAsHtml -Encoding $MailEncoding -SmtpServer $MailServer -Verbose
            }
        }
    }
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 

# Execute Module :

$VLC = 
@{
    ApplicationName = 'VLC'
    
    DownloadLink = "http://download.videolan.org/pub/videolan/vlc/[Version]/win64/vlc-[Version]-win64.msi" 
    AllVersionLink = "https://download.videolan.org/pub/videolan/vlc/"
    
    OutFolder = "\\SERVER\produits\Instapc\Freeware\VLC\LastVersion" 
    
    SplitLeft = "vlc-" 
    SplitRight = "-win64.msi"
    ReferenceVersion = "3.0.17.0"
   
    MailRecever = "mail"
    MailSender = "mail"
    MailCopy = "mail"
    MailEncoding = "UTF8" 
    MailServer = "servermail"
}

$7Zip = 
@{
    ApplicationName = '7-Zip'
    
    DownloadLink = "https://sourceforge.net/projects/sevenzip/files/7-Zip/[Version7]/7z[Version]-x64.exe/download" 
    AllVersionLink = "https://sourceforge.net/projects/sevenzip/files/7-Zip/"
    
    OutFolder = "\\SERVER\produits\Instapc\Freeware\7-Zip\LastVersion" 
    
    SplitLeft = "7z" 
    SplitRight = "-x64.exe"
    ReferenceVersion = "21.06"
   
    MailRecever = "mail"
    MailSender = "mail"
    MailCopy = "mail"
    MailEncoding = "UTF8" 
    MailServer = "servermail" 
}

$Notepad32 = 
@{
    ApplicationName = 'Notepad++'
    
    DownloadLink = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v[Version]/npp.[Version].Installer.exe" 
    AllVersionLink = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases"
    
    OutFolder = "\\SERVER\produits\Instapc\Freeware\Notepad++\LastVersion" 
    
    SplitLeft = "npp." 
    SplitRight = ".Installer.exe"
    ReferenceVersion = "8.4.1"
   
    MailRecever = "mail"
    MailSender = "mail"
    MailCopy = "mail"
    MailEncoding = "UTF8" 
    MailServer = "servermail"

    InvokeSpecialRequest = (((((Invoke-WebRequest -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases").Links  | Format-List href) | Out-String).Replace('href : ','').Replace(' ','').Replace('..','').replace('v','').Split('/') -replace "\s", "" -ne ' ' -match "\d+" -like "*x64*" -notlike "*.sig" -notlike "*.7z" -notlike "*.zip").Replace('npp.','').Replace('.Installer.x64.exe','')) -replace "\s", "" -notmatch '[a-z]' -notmatch '[A-Z]'
}

$Notepad64 = 
@{
    ApplicationName = 'Notepad++'
    
    DownloadLink = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v[Version]/npp.[Version].Installer.exe" 
    AllVersionLink = "https://github.com/notepad-plus-plus/notepad-plus-plus/releases"
    
    OutFolder = "\\SERVER\produits\Instapc\Freeware\Notepad++\LastVersion" 
    
    SplitLeft = "npp." 
    SplitRight = ".Installer.x64.exe"
    ReferenceVersion = "8.4.1"
   
    MailRecever = "mail"
    MailSender = "mail"
    MailCopy = "mail"
    MailEncoding = "UTF8" 
    MailServer = "servermail" 

    InvokeSpecialRequest = (((((Invoke-WebRequest -Uri "https://github.com/notepad-plus-plus/notepad-plus-plus/releases").Links  | Format-List href) | Out-String).Replace('href : ','').Replace(' ','').Replace('..','').replace('v','').Split('/') -replace "\s", "" -ne ' ' -match "\d+" -like "*x64*" -notlike "*.sig" -notlike "*.7z" -notlike "*.zip").Replace('npp.','').Replace('.Installer.x64.exe','')) -replace "\s", "" -notmatch '[a-z]' -notmatch '[A-Z]'
}

$KeePass = 
@{
    ApplicationName = 'KeePass'
    
    DownloadLink = "https://sourceforge.net/projects/keepass/files/KeePass%202.x/[Version]/KeePass-[Version]-Setup.exe/download"
    AllVersionLink = "https://sourceforge.net/projects/keepass/files/KeePass%202.x/" 
    
    OutFolder = "\\SERVER\produits\Instapc\Freeware\KeePass\LastVersion" 
    
    SplitLeft = "KeePass-" 
    SplitRight = "-Setup.exe"
    ReferenceVersion = "2.50.1"
   
    MailRecever = "mail"
    MailSender = "mail"
    MailCopy = "mail"
    MailEncoding = "UTF8" 
    MailServer = "servermail"
}

$PuTTY = 
@{
    ApplicationName = 'PuTTY'
    
    DownloadLink = "https://the.earth.li/~sgtatham/putty/[Version]/w64/putty-64bit-[Version]-installer.msi"
    AllVersionLink = "https://www.chiark.greenend.org.uk/~sgtatham/putty/changes.html" 
    
    OutFolder = "\\SERVER\produits\Instapc\Freeware\PuTTY\LastVersion" 
    
    SplitLeft = "putty-64bit-" 
    SplitRight = "-installer.msi"
    ReferenceVersion = "0.76"
   
    MailRecever = "mail"
    MailSender = "mail"
    MailCopy = "mail"
    MailEncoding = "UTF8" 
    MailServer = "servermail"

    InvokeSpecialRequest = (((Invoke-WebRequest -Uri "https://www.chiark.greenend.org.uk/~sgtatham/putty/changes.html").Links  | Format-List outerText) | Out-String).Replace('outerText : ','').Split('')  -replace "\s", "" -notlike "#*" -notlike "* *" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
}

$FileZilla = 
@{
    ApplicationName = 'FileZilla'
    
    DownloadLink = "https://download.filezilla-project.org/client/FileZilla_[Version]_win64-setup.exe"
    AllVersionLink = "https://download.filezilla-project.org/client/"
    
    OutFolder = "\\SERVER\produits\Instapc\Freeware\FileZilla\LastVersion" 
    
    SplitLeft = "FileZilla_" 
    SplitRight = "_win64-setup.exe"
    ReferenceVersion = "3.60.0"
   
    MailRecever = "mail"
    MailSender = "mail"
    MailCopy = "mail" 
    MailEncoding = "UTF8" 
    MailServer = "servermail"
    
    InvokeSpecialRequest = (((Invoke-WebRequest -Uri "https://download.filezilla-project.org/client/").Links  | Format-List href) | Out-String).Replace("href : ","").Replace(" ","").Replace("-","").Split("_") -replace "\s", "" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
}

$WinSCP = 
@{
    ApplicationName = 'WinSCP'
    
    DownloadLink = "https://sourceforge.net/projects/winscp/files/WinSCP/[Version]/WinSCP-[Version]-Setup.exe/download"
    AllVersionLink = "https://sourceforge.net/projects/winscp/files/WinSCP/"
    
    OutFolder = "\\SERVER\produits\Instapc\Freeware\Winscp\LastVersion" 
    
    SplitLeft = "WinSCP-" 
    SplitRight = "-Setup.exe"
    ReferenceVersion = "5.20.0"
   
    MailRecever = "mail"
    MailSender = "mail"
    MailCopy = "mail"
    MailEncoding = "UTF8" 
    MailServer = "servermail"
}


$transcript = Get-ChildItem -Path "C:\Tache_Auto\WebRequestLog\" | Where-Object -Property Name -eq "WebRequest.log"

if(($transcript) -and ($transcript.Length) -ge 900000)
{
    Remove-Item "C:\Tache_Auto\WebRequestLog\WebRequest.log" -Force -Verbose -ErrorAction Continue
}
Start-Transcript "C:\Tache_Auto\WebRequestLog\WebRequest.log" -Force -Append



Download-Application @VLC
Download-Application @7Zip
Download-Application @Notepad32
Download-Application @Notepad64
Download-Application @KeePass
Download-Application @PuTTY
Download-Application @FileZilla
Download-Application @WinSCP



Stop-Transcript -ErrorAction Continue
