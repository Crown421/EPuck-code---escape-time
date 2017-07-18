Set oWSH = CreateObject("WScript.Shell")
vbsInterpreter = "cscript.exe"

If InStr(LCase(WScript.FullName), vbsInterpreter) = 0 Then
        oWSH.Run vbsInterpreter & " //NoLogo " & Chr(34) & WScript.ScriptFullName & Chr(34)
        WScript.Quit
End If

If Not WScript.Arguments.Named.Exists("elevate") Then
  CreateObject("Shell.Application").ShellExecute WScript.FullName _
    , """" & WScript.ScriptFullName & """ /elevate", "", "runas", 1
  WScript.Quit
End If


Set objShell = WScript.CreateObject("WScript.Shell")
Set objExecObject = objShell.Exec("cmd /c devcon Find =Bluetooth | findstr /r e-puck | findstr /v 3214")
Do While Not objExecObject.StdOut.AtEndOfStream
    x = objExecObject.StdOut.ReadLine()
    y=mid(x,9,16)
    z="cmd /c devcon enable *" & y & "*"
    Wscript.Echo(z)
    ' Set stat=objShell.Exec(z)
    objShell.Exec(z)
    ' Wscript.Echo(stat)
Loop
WScript.Sleep Int(1000)

Set objShell2 = WScript.CreateObject("WScript.Shell")

Set objExecObject2 = objShell2.Exec("cmd /c devcon Find @BTHENUM\* | findstr /r COM | findstr /v "& Chr(34) &" COM63) COM64) COM5) COM6) COM9) COM10)"& Chr(34) &" ")

Do While Not objExecObject2.StdOut.AtEndOfStream
    x2 = objExecObject2.StdOut.ReadLine()
    y2=mid(x2,74,21)
    z2="cmd /c devcon enable @*" & y2 & "*"
    Wscript.Echo z2
    ' Set stat=objShell2.Exec(z)
    objShell.Exec(z2)
    ' Wscript.Echo(stat)
Loop


' devcon Find @BTHENUM\* | findstr /r COM | findstr /v "COM63) COM64) COM5) COM6)"
WScript.Sleep Int(10 * 1000)



' command="devcon Find @BTHENUM\* | findstr /r COM | findstr /v " & Chr(34) & " COM63) COM64) COM5) COM6) " & Chr(34) & " "
' command="devcon Find @BTHENUM\* | findstr /r " & Chr(34) & "COM" & Chr(34) & " "

' Set objFSO = Wscript.CreateObject("Scripting.FileSystemObject")
' Set objShell = Wscript.CreateObject("Wscript.Shell")
' objName = objFSO.GetTempName
' objTempFile = objName
' objShell.Run "cmd /c devcon Find @BTHENUM\* | findstr /r COM | findstr /v " & Chr(34) & " COM63) COM64) COM5) COM6) " & Chr(34) & " >" & objTempFile, 0, True

' command="devcon Find @BTHENUM\* | findstr /r COM"
' Wscript.Echo command
' Set objExecObject2 = objShell2.Exec(command)

' devcon disable @*1000E8D3B5C1_C00000000*

' devcon disable *DEV_1000E8AD781D*
