# IT'S OK !

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$HOME\Desktop\")
$Shortcut.TargetPath = "./powercat.ps1"
$Shortcut.Save()
