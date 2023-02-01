B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8
@EndOfDesignText@
#IgnoreWarnings: 16, 9, 12
Sub Class_Globals
	Private fx As JFX
'	Private ftp As FTP
	Private os, appDownloadPath, fileName As String
	Private appName As String = "44.jar"
	Private fileDate, fileServerDate As Long
	Private don As String = "pdegrootafr"
	Private dop As String = "hkWpXtB1!"
	Private dos As String = "ftp.pdeg.nl"
	Private clsMAC As GetRot
	
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	clsMAC.Initialize
	os = DetectOS
	Select os
		Case "windows"
			appDownloadPath = File.DirApp&"\44\"
		Case "linux"
			appDownloadPath = File.DirApp&"/44/"
	End Select
	
End Sub

Sub parseJson(data As String) As String
	
	Dim parser As JSONParser
	parser.Initialize(data)
	Dim root As Map = parser.NextObject
	Dim city As String = root.Get("city")
	Dim ip As String = root.Get("ip")
	Dim zip_code As String = root.Get("zip_code")
	
	Return $"${city} ${ip} ${zip_code}"$
End Sub

Sub FTP_DownloadProgress (ServerPath As String, TotalDownloaded As Long, Total As Long)
	Dim s As String
	s = "Downloaded " & Round(TotalDownloaded / 1000) & "KB"
	If Total > 0 Then s = s & " out of " & Round(Total / 1000) & "KB"
End Sub

Sub FTP_DownloadCompleted (ServerPath As String, Success As Boolean)
	If Success = False Then
		func.WriteErrorToFile("ftpdlcompleted.txt", LastException)
		Log(LastException.Message)
	Else
		
		Dim str As String
		str = File.ReadString(appDownloadPath & "upd.pdg", "")
		fileDate = str
		File.WriteString(appDownloadPath , "upd.pdg", fileServerDate)
		If os = "linux" Then
			restartApp
		End If
	End If
End Sub



Sub DetectOS As String
	Dim os As String = GetSystemProperty("os.name", "").ToLowerCase
	If os.Contains("win") Then
		Return "windows"
	Else If os.Contains("mac") Then
		Return "mac"
	Else
		Return "linux"
	End If
End Sub


Sub getUpdateTimeStamp As Boolean
	Dim str As String
	str = File.ReadString(appDownloadPath & "upd.pdg", "")
	
	If str.Length < 1 Then
		str = DateTime.Now
		File.WriteString(appDownloadPath , "upd.pdg", str)
		fileDate = str
		Return False
	Else
		fileDate = str	
	End If
	Return True
	
End Sub

Sub updateFileExists
	If File.Exists(appDownloadPath, "upd.pdg") = False Then
		'Log("upd created..")
		File.WriteString(appDownloadPath , "upd.pdg", "")
	End If
	
End Sub

Sub processVersion(str As String)
'	Log(str)
	Dim version As String
	Dim lst As List
	
	lst.Initialize
	
	lst = Regex.Split("-", str)
	version = lst.Get(1)
	version = version.Replace("_", ".")
	version = version.Replace(".jar", "")
	File.WriteString(appDownloadPath, "ver.pdg", version)
	
End Sub

Sub restartApp
	Dim sh As Shell
'	sh.Initialize("sh", "/home/pi/44/run.sh", Null)
'	sh.WorkingDirectory = "/home/pi/44"
	sh.Initialize("sh", "sh", Array("/home/pi/44/run.sh"))
	sh.Run(5000)
	ExitApplication
End Sub

Sub sh_ProcessCompleted (Success As Boolean, ExitCode As Int, StdOut As String, StdErr As String)
	If Success And ExitCode = 0 Then
		Log("Success")
		Log(StdOut)
	Else
		Log("Error: " & StdErr)
	End If
End Sub
