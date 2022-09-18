if(!(Get-Module -Name PowerShellGet))
    {
        Import-Module -Name PowerShellGet
    }
    if(!(Get-Module -Name Terminal-Icons))
    {
	Import-Module -Name Terminal-Icons
    }

    oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/jandedobbeleer.omp.json | Invoke-Expression
    Set-PSReadLineOption -PredictionViewStyle ListView
    Set-PSReadLineOption -EditMode Windows
    Set-PSReadLineOption -PredictionSource History
    Set-Alias -Name "neofetch" -Value C:\Users\<username>\winfetch.ps1
Write-Host "If you want to upgrade all apps : [Y], else [N]"
$Read = Read-Host

if($Read -eq "Y")
{
    winget source update  
    winget upgrade --all
    Write-Host "Upgraded" -ForegroundColor Green
}
else 
{
    Write-Host "Not upgraded" -ForegroundColor Yellow
}

Write-Host "..............................................................................." -BackgroundColor White -ForegroundColor White
Write-Host "..............................................................................." -BackgroundColor White -ForegroundColor White
Write-Host "..............................................................................." -BackgroundColor White -ForegroundColor White
Write-Host "..............................................................................." -BackgroundColor White -ForegroundColor White

Write-Host "...................................."                                 -NoNewline -BackgroundColor White -ForegroundColor White 
Write-Host "++++++++-"                                                            -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta 
Write-Host ".................................."                                              -BackgroundColor White -ForegroundColor White

Write-Host "..................................."                                  -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-"                                                           -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta 
Write-Host ".................................."                                              -BackgroundColor White -ForegroundColor White

Write-Host "......................"                                               -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "+=-"                                                                  -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host ".........."                                                           -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-"                                                           -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta  
Write-Host ".........."                                                           -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=:"                                                                  -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta  
Write-Host "....................."                                                           -BackgroundColor White -ForegroundColor White

Write-Host "....................."                                                -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "*#=-"                                                                 -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host ".........."                                                           -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-"                                                           -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host ".........."                                                           -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=#+"                                                                 -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "...................."                                                            -BackgroundColor White -ForegroundColor White

Write-Host "..................."                                                  -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-====-"                                                               -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host ".........."                                                           -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-"                                                           -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host ".........."                                                           -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-===="                                                                -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..................."                                                             -BackgroundColor White -ForegroundColor White

Write-Host ".................."                                                   -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host ":=====-"                                                              -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "....."                                                                -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-+*=.-========--=*+-"                                                 -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "....."                                                                -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=====-"                                                              -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................."                                                               -BackgroundColor White -ForegroundColor White

Write-Host "................."                                                    -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-======-.-+=#====.-========--====#=+..-======-"                       -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................"                                                                -BackgroundColor White -ForegroundColor White

Write-Host "................"                                                     -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=======-.========.-========--========.-======="                      -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................"                                                                -BackgroundColor White -ForegroundColor White

Write-Host "................"                                                     -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=======-.========.-========--========.-======="                      -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................"                                                                -BackgroundColor White -ForegroundColor White

Write-Host "................"                                                     -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=======-.========.-========--========.-======="                      -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................"                                                                -BackgroundColor White -ForegroundColor White

Write-Host "................"                                                     -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=======-.========.-========--========.-======="                      -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................"                                                                -BackgroundColor White -ForegroundColor White

Write-Host "................"                                                     -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=======-.========.-========--========.-======="                      -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................"                                                                -BackgroundColor White -ForegroundColor White

Write-Host "................"                                                     -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=======-.========.-========--========.-======="                      -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................"                                                                -BackgroundColor White -ForegroundColor White

Write-Host "................"                                                     -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "*=======-.========.-========--========.-======#+"                     -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-=======*"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White
 
Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-========"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "..............."                                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========-.========.-========--========.-=======*"                    -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "................"                                                     -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "+#======-.========.-========--========.-======#:"                     -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..............."                                                                 -BackgroundColor White -ForegroundColor White

Write-Host "................."                                                    -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "+======-.========..--------.-========.-======+"                       -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................"                                                                -BackgroundColor White -ForegroundColor White

Write-Host ".................."                                                   -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-*#===-.========...........-========.-===#*-"                         -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "................."                                                               -BackgroundColor White -ForegroundColor White

Write-Host "....................."                                                -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host ":==-.========"                                                        -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..........."                                                          -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-========.-=*-"                                                       -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "...................."                                                            -BackgroundColor White -ForegroundColor White

Write-Host ".........................."                                           -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "========"                                                             -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..........."                                                          -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=======*"                                                            -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "........................."                                                       -BackgroundColor White -ForegroundColor White

Write-Host "............................"                                         -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-*===="                                                               -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..........."                                                          -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-====*-"                                                              -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..........................."                                                     -BackgroundColor White -ForegroundColor White

Write-Host "..............................."                                      -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-*="                                                                  -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host "..........."                                                          -NoNewline -BackgroundColor White -ForegroundColor White
Write-Host "-=*-"                                                                 -NoNewline -BackgroundColor White -ForegroundColor DarkMagenta
Write-Host ".............................."                                                  -BackgroundColor White -ForegroundColor White

Write-Host "..............................................................................." -BackgroundColor White -ForegroundColor White
Write-Host "..............................................................................." -BackgroundColor White -ForegroundColor White
Write-Host "..............................................................................." -BackgroundColor White -ForegroundColor White

Write-Host "   "
Write-Host "   "
Write-Host "   "
Write-Host "   "

neofetch

Write-Host "Ping de <server's name> :" -ForegroundColor Red
ping <ip server> -n 1

Write-Host "Ping de <raspberrypi name> :" -ForegroundColor Red
ping <ip raspberrypi> -n 1
