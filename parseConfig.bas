B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	
	Public timeOut, rtTimeOut As Int
	Public timeOutActive, bRotateMedia As Boolean
	Public useDigitalFont As Boolean
'''	Private appPath As String
	Private cnf As String
	Private parser As JSONParser
End Sub


Sub getAppImagePath As String
	Dim os As String = DetectOS
	Dim mediaPath As String
	Select os
		Case "windows"
			mediaPath = File.DirApp&"\44\media\"'cnf.44"
		Case "linux"
			mediaPath = File.DirApp&"/44/media/"'cnf.44"
	End Select
	
	Return mediaPath
	
End Sub


Sub pullConfig
	Dim msgList As List
	
	useDigitalFont = False
'	cnf = File.ReadString(appPath, "cnf.44")
	cnf = File.ReadString(func.appPath, "cnf.44")
	parser.Initialize(cnf)
	msgList.Initialize


	Dim root As Map' = parser.NextObject
	root.Initialize
	root= parser.NextObject
	Dim fontColor As Map = root.Get("fontColor")
	Dim colorYellow As String = fontColor.Get("colorYellow")
	Dim message As Map = root.Get("message")
	Dim line_1 As String = message.Get("line_1")
	Dim line_2 As String = message.Get("line_2")
	Dim line_5 As String = message.Get("line_5")
	Dim line_3 As String = message.Get("line_3")
	Dim line_4 As String = message.Get("line_4")
	Dim fontColor As Map = root.Get("fontColor")

	Dim sponsor As Map = root.Get("reclame")
	Dim sponsorActive As String = sponsor.Get("active")
	
	Dim MoyRetro As Map = root.Get("lightSchema")
	Dim showMoyRetro As String = MoyRetro.Get("useLightSchema")
	
	Dim gameTime As Map = root.Get("partijDuur")
	Dim gameTimeActive As String = gameTime.Get("active")
	
	
	If root.ContainsKey("orderdrinks") Then
		Dim orderDrink As Map = root.Get("orderdrinks")
		Dim odActive As String = orderDrink.Get("od-active")
		CallSubDelayed2(scorebord, "showHideOrderDrinks", odActive <> "0")
	End If
	
'	If showMoyRetro = "1" Then
	CallSub2(retroBord, "HideShowMoyenne", showMoyRetro = "1")
	If gameTimeActive = "1" Then
		CallSub2(scorebord, "showHideGameTime", True)
	Else
		CallSub2(scorebord, "showHideGameTime", False)
	End If

	Dim showPromote As Map = root.Get("showPromote")
	If showPromote.Get("active") = "1" Then
		timeOutActive = True
	Else
		timeOutActive = False
	End If
	timeOut = showPromote.Get("timeOut")
	
'	Log($"PROMO ACTIVE: ${timeOutActive}"$)
	
	Dim rotMedia As Map = root.Get("rotateMedia")
	bRotateMedia = rotMedia.Get("active") = "1"
	If bRotateMedia Then
		timeOut = rotMedia.Get("timeOut")
	End If
	rtTimeOut = rotMedia.get("slidePause")
'	Log($"ROTMEDIA ACTIVE: ${bRotateMedia}"$)
'	Log($"ROTMEDIA TIMEOUT: ${timeOut}"$)
'	Log($"ROTMEDIA SLIDE PAUSE: ${rtTimeOut}"$)
	
	Dim digitalFont As Map = root.Get("digitalFont")
	Dim digitalActive As String = digitalFont.Get("active")
	
	If digitalActive  = "1" Then
		useDigitalFont = True
		funcScorebord.useDigitalFont = True
		CallSub2(scorebord, "useDigitalFont", True)
	Else
		funcScorebord.useDigitalFont = False
		CallSub2(scorebord, "useDigitalFont", False)
	End If
	
	If colorYellow = "1"  Then
		CallSub2(scorebord, "useFontYellow", True)
		funcScorebord.useYellowFont = True
	Else
		funcScorebord.useYellowFont = False
		CallSub2(scorebord, "useFontYellow", False)
	End If
	
	msgList.AddAll(Array As String(line_1, line_2, line_3, line_4, line_5))
	CallSub2(scorebord, "setMessage", msgList)
	CallSub2(scorebord, "ShowHideCommercialRunning", bRotateMedia)
	If sponsorActive = "1" Then
		CallSub2(scorebord, "showSponor", True)
	Else
		CallSub2(scorebord, "showSponor", False)
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

