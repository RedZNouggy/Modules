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
                throw "The link '$_' is not reachable"
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
                throw "The folder '$_' does not exist"
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
        $InvokeSpecialRequest,

        [Parameter(Mandatory=$false, Position=14)]
        [ValidateNotNullorEmpty()]
        [Switch]$Extract
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
    
                OutFolder = "\\...\produits\Instapc\Freeware\FileZilla\LastVersion" 
    
                SplitLeft = "FileZilla_" 
                SplitRight = "_win64-setup.exe"
                ReferenceVersion = "3.60.0" 
                MailRecever = "" 
                MailSender = "" 
                MailCopy = "" 
                MailEncoding = "UTF8" 
                MailServer = "" 
                InvokeSpecialRequest = (((Invoke-WebRequest -Uri "https://download.filezilla-project.org/client/").Links  | Format-List href) | Out-String).Replace("href : ","").Replace(" ","").Replace("-","").Split("_")  -replace "\s", "" -notlike "#*" -notlike "* *" -notlike "" -notmatch "[a-z]" -notmatch "[A-Z]"
            }


            The command : Download-Application @DefaultParameters

            If there is any version on your link : replace it :"https://sourceforge.net/projects/sevenzip/files/7-Zip/2107/7z2107-x64.exe/download" in "https://sourceforge.net/projects/sevenzip/files/7-Zip/[Version]/7z[Version]-x64.exe/download"
            and for 7-Zip :  "https://sourceforge.net/projects/sevenzip/files/7-Zip/[Version7]/7z[Version]-x64.exe/download" 
            Try : (((Invoke-WebRequest -Uri [YOUR_LINK]).Links  | Format-List href) | Out-String).Replace("href : ","").Replace(" ",'').Replace("-","").Split("_") -replace "\s", "" -notmatch "[a-z]" -notmatch "[A-Z]"
            And try to understand what filter you have to add on the Request to filter only versions  without any string or spaces
            '
        }
        else
        {
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
    }

    process
    {
        if(-not $Help)
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
    }
    end
    {
        if(-not $Help)
        {
            $Body = ""

            if(($vers -ne $null) -and (!($Extract)))
            {
                $DownloadLink = $DownloadLink.Replace("[Version]","$vers").Replace("[Version7]","$nbV")

                if(!(Test-Path "$OutFolder\${SplitLeft}${vers}${SplitRight}"))
                {

                    $Subject = "New Applications Versions $OutFolder"
                    $Body = "`n $ApplicationName : $OutFolder\${SplitLeft}${vers}${SplitRight}"
                
                    try { Invoke-WebRequest -Uri "$DownloadLink" -OutFile "$OutFolder\${SplitLeft}${vers}${SplitRight}" -UserAgent "Wget" -Verbose }
                    catch { Invoke-WebRequest -Uri "$DownloadLink" -OutFile "$OutFolder\${SplitLeft}${vers}${SplitRight}" -Verbose }
                }
                else
                {
                    Write-Warning "La derniere Version de $ApplicationName est déjà présente sur $OutFolder\${SplitLeft}${vers}${SplitRight}"
                }
    
            }
            elseif($Extract -eq $true)
            {
                Add-Type -AssemblyName System.IO.Compression.FileSystem
                function Unzip-File
                {
                    param
                    (
                        [Parameter(Mandatory=$true, Position=0)]
                        [ValidateNotNullorEmpty()]
                        [string]$Zipfile,

                        [Parameter(Mandatory=$true, Position=1)]
                        [ValidateNotNullorEmpty()]
                        [String]$Outpath,

                        [Parameter(Mandatory=$false, Position=2)]
                        [ValidateNotNullorEmpty()]
                        [Switch]$Removezip,

                        [Parameter(Mandatory=$false, Position=3)]
                        [ValidateNotNullorEmpty()]
                        [Switch]$Outfromfolder
                    )

                    [System.IO.Compression.ZipFile]::ExtractToDirectory($Zipfile, $Outpath)

                    if($Removezip) 
                    { 
                        Remove-Item -Force $Zipfile -Verbose
                    }
                    if($Outfromfolder)
                    { 
                        $P = $Outpath.Split("\")
                        $i = -1
                        foreach($l in $P)
                        {
                            $i++
                        }
                            
                        $Outpath1 = $Outpath.Replace($Outpath.Split('\')[$i],'')
                        
                        Get-ChildItem -Path $Outpath -Recurse | Copy-Item -Destination $Outpath1 -Verbose 
                        Remove-Item -Force $Outpath -Recurse -Verbose
                    
                    }
                }
            
                $DownloadLink = $DownloadLink.Replace("[Version]","$vers").Replace("[Version7]","$nbV")

                if(!(Test-Path "$OutFolder\${SplitLeft}${vers}.winmsi.x64.msi"))
                {

                    $Subject = "New Applications Versions $OutFolder"
                    $Body = "`n $ApplicationName : $OutFolder\${SplitLeft}${vers}.winmsi.x64.msi"
                
                    try { Invoke-WebRequest -Uri "$DownloadLink" -OutFile "$OutFolder\${SplitLeft}${vers}${SplitRight}" -UserAgent "Wget" -Verbose }
                    catch { Invoke-WebRequest -Uri "$DownloadLink" -OutFile "$OutFolder\${SplitLeft}${vers}${SplitRight}" -Verbose }

                    Unzip-File -Zipfile "$OutFolder\${SplitLeft}${vers}${SplitRight}" -Outpath "$OutFolder\OutFolder" -Removezip -Outfromfolder -Verbose
                }
                if(!$vers) 
                {
                    Write-Warning "La derniere Version de $ApplicationName est déjà présente sur $OutFolder\${SplitLeft}${vers}.winmsi.x64.msi"
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
}
