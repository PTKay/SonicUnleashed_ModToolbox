Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run "rebuilder.exe"
WScript.Sleep 1000

objShell.AppActivate "rebuilder.exe"
objShell.SendKeys"2"
objShell.SendKeys("{Enter}")
WScript.Sleep 200


objShell.AppActivate "rebuilder.exe"
objShell.SendKeys"a"
objShell.SendKeys("{Enter}")
WScript.Sleep 200


objShell.AppActivate "rebuilder.exe"
objShell.SendKeys"UP0177-NPUB31204_00-SONICUNLEASHED01"
objShell.SendKeys("{Enter}")
WScript.Sleep 200


objShell.AppActivate "rebuilder.exe"
objShell.SendKeys"680B34143C511F51002C26F977CA3EE3"
objShell.SendKeys("{Enter}")