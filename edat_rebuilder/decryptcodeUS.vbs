Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "rebuilder.exe"
WScript.Sleep 1000

objShell.AppActivate "rebuilder.exe"
objShell.SendKeys"1"
objShell.SendKeys("{Enter}")
WScript.Sleep 200


objShell.AppActivate "rebuilder.exe"
objShell.SendKeys"a"
objShell.SendKeys("{Enter}")
WScript.Sleep 200