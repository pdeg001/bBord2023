B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=9.3
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Public frm As Form
	Private gameTimerWorking, backupTmr As Timer
	Private gameDuration As Long
	Private caromP1, caromP2, caromP3, caromP4 As Int = 0
	Private startCarom As Int = 30
	Private newGameClicked As Boolean
	Private timeString, minutes, seconds As String
	Private clsListBords As ListOfBords
	Private clsScreenSaverSurvival As ScreenSaver
	Private parser As JSONParser
	Private partijFolder As String
	Private strBackup As String
	
	
	Private p1_100, p1_10, p1_1 As Label
	Private p1_1_8,  p1_10_8,  p1_100_8 As Label
	Private p2_100, p2_10, p2_1 As Label
	Private p2_1_8,  p2_10_8,  p2_100_8 As Label
	Private Inning_10, Inning_1 As Label
	Private Inning_1_8, Inning_10_8 As Label
	Private LblReset As B4XView
	Private lblCopyright As Label
	Public caromP1R As String, caromP2R As String, inningR As String
	Private lbl_kraai As Label
	Private lblIpNr As Label
	Private lblSpeler1 As Label
	Private lblSwafBal As Label
	Private lblSwafBal1 As Label
	Private pnSwaf As Pane
	Private p3_100_8 As Label
	Private p3_100 As Label
	Private p3_10_8 As Label
	Private p3_10 As Label
	Private p3_1_8 As Label
	Private p3_1 As Label
	Private p4_100_8 As Label
	Private p4_100 As Label
	Private p4_10_8 As Label
	Private p4_10 As Label
	Private p4_1_8 As Label
	Private p4_1 As Label
	Private lblSpeler2 As Label
	Private lblTimerWorking As Label
	Private pnDisableTimeInput As Pane
	Private pnInning As Pane
	Private paneP1 As Pane
	Private lblImgSwaf As Label
	Private Pane1 As Pane
	Private to_minutes8 As Label
	Private to_seconds8 As Label
	Private lblTimerWorking1 As Label
	Private to_seconds10 As Label
	Private to_seconds1 As Label
	Private lblSwitchBord As Label
	Private lblPause As Label
	Private lblWriteJson As Label
End Sub


Public Sub show
	gameTimerWorking.Initialize("gameTimerWorking", 1000)
	backupTmr.Initialize("backupTmr", 10000)
	func.GetPartijFolder
	partijFolder = func.partijFolder
	
	
	frm.Initialize("frm", 1920, 1080)
	frm.RootPane.LoadLayout("survivalbord")
	clsScreenSaverSurvival.Initialize(frm, Me, "survivalbord")
	clsListBords.Initialize(frm)
	SetFrans
	
	
	#if debug
	frm.SetFormStyle("DECORATED")
	#Else
	frm.SetFormStyle("UNDECORATED")
	frm.Resizable = False
	#End If
	func.SetCustomCursor1(File.DirAssets, "mouse.png", 370, 370, frm.RootPane)
	frm.Resizable = False
	useDigitalFont(True)
	frm.Stylesheets.Add(File.GetUri(File.DirAssets, "n205.css"))
	lblCopyright.Text = $"©2004 BC Heerhugowaard Electronics"$
	setFontStyle
	backupTmr.Enabled = True
	RecoverBord
End Sub

Sub frm_CloseRequest (EventData As Event)
	frm_Closed
End Sub

Sub frm_Closed
	backupTmr.Enabled = False
	gameTimerWorking.Enabled = False
	DateTime.TimeFormat = "HH:mm:ss"
	clsScreenSaverSurvival.DisableTimers
End Sub

Public Sub showBord
	strBackup = File.ReadString(File.DirAssets, "survivalbackup.json")
	RecoverBord
	func.SetCustomCursor1(File.DirAssets, "mouse.png", 370, 370, frm.RootPane)
	backupTmr.Enabled = True
	If funcScorebord.bordDisplayName <> "" Then
		lblIpNr.Text = $"${func.ipNumber} - ${funcScorebord.BordVersion} - ${funcScorebord.bordDisplayName}"$
	Else
		lblIpNr.Text = $"${func.ipNumber} - ${funcScorebord.BordVersion}"$
	End If
	frm.Show
End Sub

Sub SetFrans
	If File.Exists(parseConfig.getAppImagePath, "swaffie.png") Then
		CSSUtils.SetBackgroundImage(lblImgSwaf, parseConfig.getAppImagePath, "swaffie.png")
	End If
End Sub

Public Sub disableTimers
	clsScreenSaverSurvival.DisableTimers
End Sub

'handle seconds
Private Sub gameTimerWorking_Tick
	DateTime.TimeFormat = "mm:ss"
	gameDuration		= gameDuration-1000
	timeString			= DateTime.Time(gameDuration)
	minutes				= Regex.Split(":", timeString)(0)
	seconds				= Regex.Split(":", timeString)(1)
	Inning_10.Text		= minutes.SubString2(0,1)
	Inning_1.Text		= minutes.SubString2(1,2)
	to_seconds10.Text	= seconds.SubString2(0,1)
	to_seconds1.Text	= seconds.SubString2(1,2)
	
	If gameDuration <= 59000 Then
		CSSUtils.SetBackgroundColor(Pane1, fx.Colors.Blue)
		CSSUtils.SetBackgroundColor(LblReset, fx.Colors.Blue)
	End If

	If gameDuration <= 0  Then
		gameDuration 				= 0
		Inning_10.Text				= "0"
		Inning_1.Text				= "0"
		to_seconds10.Text			= "0"
		to_seconds1.Text			= "0"
		gameTimerWorking.Enabled	= False
		CSSUtils.SetBackgroundColor(Pane1, fx.Colors.From32Bit(0xFF001317))
		CSSUtils.SetBackgroundColor(LblReset, fx.Colors.From32Bit(0xFF001317))
		lblPause.Visible = False
		DeleteBackup
		DateTime.TimeFormat = "HH:mm:ss"
	End If
End Sub

Private Sub DeleteBackup
	If File.Exists(partijFolder, "survivalbackup.json") Then
		File.Delete(partijFolder, "survivalbackup.json")
	End If
End Sub

Public Sub hideRetro
	frm.RootPane.Visible = False
End Sub

Sub setFontStyle
	func.caromLabelCss(p1_1, "LabelLed")
	func.caromLabelCss(p1_10, "LabelLed")
	func.caromLabelCss(p1_100, "LabelLed")
	func.caromLabelCss(p2_100, "LabelLed")
	func.caromLabelCss(p2_10, "LabelLed")
	func.caromLabelCss(p2_1, "LabelLed")
	func.caromLabelCss(p3_1, "LabelLed")
	func.caromLabelCss(p3_10, "LabelLed")
	func.caromLabelCss(p3_100, "LabelLed")
	func.caromLabelCss(p4_1, "LabelLed")
	func.caromLabelCss(p4_10, "LabelLed")
	func.caromLabelCss(p4_100, "LabelLed")
	func.caromLabelCss(Inning_1, "LabelLed")
	func.caromLabelCss(Inning_10, "LabelLed")
End Sub

Private Sub enableCarom(enable As Boolean)
	p2_100.Enabled = enable
	p2_10.Enabled = enable
	p2_1.Enabled = enable
	p3_100.Enabled = enable
	p3_10.Enabled = enable
	p3_1.Enabled = enable
	p4_100.Enabled = enable
	p4_10.Enabled = enable
	p4_1.Enabled = enable
End Sub

Sub useDigitalFont(useDigital As Boolean)
	Dim fsCarom As Int
	Dim lst As List
	
	fsCarom = 300
	lst.Initialize
	
	lst.AddAll(Array As B4XView(p1_100, p1_10, p1_1, p1_100_8, p1_10_8, p1_1_8, _
		p2_100, p2_10, p2_1, p2_100_8, p2_10_8, p2_1_8, _
		p3_100_8, p3_10_8, p3_1_8, p3_100, p3_10, p3_1, _
		p4_100_8, p4_10_8, p4_1_8, p4_100, p4_10, p4_1))
		
	func.setFontRetroList(lst, fsCarom, useDigital)
	func.setFontRetroList(Array As B4XView(Inning_10, Inning_1, Inning_10_8, Inning_1_8, _
	to_seconds10, to_minutes8, to_seconds1, to_seconds8), 200, useDigital)
End Sub

Sub LblReset_MouseReleased (EventData As MouseEvent)
	'ResetPartij
	If newGameClicked Then
		If gameDuration = 0 Then Return
		enableCarom(True)
		LblReset.Text = "RESET"
		SetInitalCarom
		lblPause.Text = "PAUSE"
		lblPause.Visible = True
'		lblSwitchBord.Visible = False
		If gameDuration = 60000 Then
			gameTimerWorking.Enabled = True
			CSSUtils.SetBackgroundColor(Pane1, fx.Colors.Blue)
		Else
			gameTimerWorking.Enabled = True
			CSSUtils.SetBackgroundColor(Pane1, fx.Colors.From32Bit(0xFF001317))
		End If
		
		newGameClicked = False
		pnDisableTimeInput.Visible = True
		CSSUtils.SetBorder(pnInning, 21, fx.Colors.White, 0)
		CSSUtils.SetBorder(paneP1, 22, fx.Colors.White, 0)
	Else
		DeleteBackup
		enableCarom(False)
		CSSUtils.SetBackgroundColor(Pane1, fx.Colors.From32Bit(0xFF001317))
		LblReset.Text = "START"
		startCarom = 0
		SetInitalCarom
		lblPause.Visible = False
		Inning_10.Text = "3"
		Inning_1.Text = "0"
		to_seconds10.Text = "0"
		to_seconds1.Text = "0"
		gameDuration = 1800000
		
		newGameClicked = True
		gameTimerWorking.Enabled = False
		pnDisableTimeInput.Visible = False
		CSSUtils.SetBorder(pnInning, 21, fx.Colors.Green, 0)
		CSSUtils.SetBorder(paneP1, 22, fx.Colors.Green, 0)
	End If
End Sub

Sub LblReset_MouseEntered (EventData As MouseEvent)
	If LblReset.Text = "RESET" Then
	LblReset.Color = 0xFFFF0000
	Else
		LblReset.Color = 0xFF7FFF00
	End If	
End Sub

Sub LblReset_MouseExited (EventData As MouseEvent)
	LblReset.Color = 0xFF001317 '0xFF002529
End Sub

'Return true to allow the default exceptions handler to handle the uncaught exception. 
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	LogError(Error)
	LogError(StackTrace)
	File.WriteString(func.appPath, "errError.txt", Error)
	File.WriteString(func.appPath, "errStackTrace.txt", StackTrace)
	Return True
End Sub

Private Sub lblSpeler2_MouseReleased (EventData As MouseEvent)
	If EventData.SecondaryButtonPressed Then
		lbl_kraai.Visible = True
		CSSUtils.SetBackgroundImage(lbl_kraai, File.DirAssets, "ODT0.gif")
		Sleep(2000)
		lbl_kraai.Visible = False
	End If
End Sub


Private Sub lblSpeler1_MouseClicked (EventData As MouseEvent)
	If EventData.SecondaryButtonPressed Then
		pnSwaf.Visible = True
		Sleep(2000)
		pnSwaf.Visible = False
	End If
End Sub

Private Sub SetInitalCarom
	caromP1 = startCarom
	caromP2 = startCarom
	caromP3 = startCarom
	caromP4 = startCarom
	Dim iCarom As String =  NumberFormat2(startCarom,3,0,0,False)

	p1_100.Text = iCarom.SubString2(0,1)
	p1_10.Text = iCarom.SubString2(1,2)
	p1_1.Text = iCarom.SubString2(2,3)
	
	p2_100.Text = iCarom.SubString2(0,1)
	p2_10.Text = iCarom.SubString2(1,2)
	p2_1.Text = iCarom.SubString2(2,3)
	
	p3_100.Text = iCarom.SubString2(0,1)
	p3_10.Text = iCarom.SubString2(1,2)
	p3_1.Text = iCarom.SubString2(2,3)
	
	p4_100.Text = iCarom.SubString2(0,1)
	p4_10.Text = iCarom.SubString2(1,2)
	p4_1.Text = iCarom.SubString2(2,3)
End Sub

Private Sub SetCaromToMake(lbl As Label, lftBtn As Boolean)
	Dim setCarom As Int = $"${p1_100.text}${p1_10.text}${p1_1.text}"$
	Dim strCarom As String
	
	If lftBtn Then
		startCarom = setCarom+lbl.Tag
		strCarom = NumberFormat((startCarom), 3, 0)
	Else if lftBtn = False And startCarom > 0 Then	
		startCarom = setCarom-lbl.Tag
		strCarom = NumberFormat((startCarom), 3, 0)
	End If
	p1_100.Text = strCarom.SubString2(0,1)
	p1_10.Text = strCarom.SubString2(1,2)
	p1_1.Text = strCarom.SubString2(2,3)
	
	
End Sub

Private Sub p1Clicked_MouseClicked (EventData As MouseEvent)
	If newGameClicked Then
		SetCaromToMake(Sender, EventData.PrimaryButtonPressed)
		Return	
	End If
	CheckGamePaused
	If caromP1 = 0 Then 
		Return
	End If
	Dim tag As String = Sender.As(B4XView).Tag
'	Dim lbl As Label = Sender
	Dim multiplier As Int = tag'lbl.Tag
	Dim scorePlayerValue, scoreOppnentValue As Int
	
	If EventData.PrimaryButtonPressed Then
		scorePlayerValue = multiplier*1
		scoreOppnentValue = -Abs(scorePlayerValue)
	Else
		scoreOppnentValue = multiplier*1
		scorePlayerValue = -Abs(scoreOppnentValue)
	End If
	
	caromP1 = caromP1 + scorePlayerValue
	caromP2 = caromP2 + scoreOppnentValue
	caromP3 = caromP3 + scoreOppnentValue
	caromP4 = caromP4 + scoreOppnentValue
		
	ShowPlayerCarom
	
End Sub

Private Sub p2Clicked_MouseClicked (EventData As MouseEvent)
	If caromP2 = 0 Then 
		Return
	End If
	CheckGamePaused
	Dim tag As String = Sender.As(B4XView).tag
'	Dim lbl As Label = Sender
	Dim multiplier As Int = tag'lbl.Tag
	Dim scorePlayerValue, scoreOppnentValue As Int
	
	If EventData.PrimaryButtonPressed Then
		scorePlayerValue = multiplier*1
		scoreOppnentValue = -Abs(scorePlayerValue)
	Else
		scoreOppnentValue = multiplier*1
		scorePlayerValue = -Abs(scoreOppnentValue)
	End If
	
	caromP1 = caromP1 + scoreOppnentValue
	caromP2 = caromP2 + scorePlayerValue
	caromP3 = caromP3 + scoreOppnentValue
	caromP4 = caromP4 + scoreOppnentValue
		
	ShowPlayerCarom
	
End Sub

Private Sub p3Clicked_MouseClicked (EventData As MouseEvent)
	If caromP3 = 0 Then 
		Return
	End If
	CheckGamePaused
	Dim lbl As Label = Sender
	Dim multiplier As Int = lbl.Tag
	Dim scorePlayerValue, scoreOppnentValue As Int
	
	If EventData.PrimaryButtonPressed Then
		scorePlayerValue = multiplier*1
		scoreOppnentValue = -Abs(scorePlayerValue)
	Else
		scoreOppnentValue = multiplier*1
		scorePlayerValue = -Abs(scoreOppnentValue)
	End If
	
	caromP1 = caromP1 + scoreOppnentValue
	caromP2 = caromP2 + scoreOppnentValue
	caromP3 = caromP3 + scorePlayerValue
	caromP4 = caromP4 + scoreOppnentValue
		
	ShowPlayerCarom
	
End Sub

Private Sub p4Clicked_MouseClicked (EventData As MouseEvent)
	If caromP4 = 0 Then 
		Return
	End If
	CheckGamePaused
	Dim lbl As Label = Sender
	Dim multiplier As Int = lbl.Tag
	Dim scorePlayerValue, scoreOppnentValue As Int
	
	If EventData.PrimaryButtonPressed Then
		scorePlayerValue = multiplier*1
		scoreOppnentValue = -Abs(scorePlayerValue)
	Else
		scoreOppnentValue = multiplier*1
		scorePlayerValue = -Abs(scoreOppnentValue)
	End If
	
	caromP1 = caromP1 + scoreOppnentValue
	caromP2 = caromP2 + scoreOppnentValue
	caromP3 = caromP3 + scoreOppnentValue
	caromP4 = caromP4 + scorePlayerValue
		
	ShowPlayerCarom
	
End Sub

Private Sub CheckGamePaused
	If lblPause.Visible Then
		lblPause.Text = "PAUSE"
		CSSUtils.SetBackgroundColor(lblPause, fx.Colors.From32Bit(0xFF8F001D))
		gameTimerWorking.Enabled = True
	End If
	
End Sub

Private Sub ShowPlayerCarom
	clsScreenSaverSurvival.SetLastClick
	If caromP1 < 0 Then caromP1 = 0
	If caromP2 < 0 Then	caromP2 = 0
	If caromP3 < 0 Then caromP3 = 0
	If caromP4 < 0 Then caromP4 = 0

	Dim SetCaromP1 As String =  NumberFormat2(caromP1,3,0,0,False)
	Dim SetCaromP2 As String =  NumberFormat2(caromP2,3,0,0,False)
	Dim SetCaromP3 As String =  NumberFormat2(caromP3,3,0,0,False)
	Dim SetCaromP4 As String =  NumberFormat2(caromP4,3,0,0,False)
	
	If caromP1 <> -1 Then
		p1_100.Text = SetCaromP1.SubString2(0,1)
		p1_10.Text = SetCaromP1.SubString2(1,2)
		p1_1.Text = SetCaromP1.SubString2(2,3)
	End If
	If caromP2 <> -1 Then
		p2_100.Text = SetCaromP2.SubString2(0,1)
		p2_10.Text = SetCaromP2.SubString2(1,2)
		p2_1.Text = SetCaromP2.SubString2(2,3)
	End If
	If caromP3 <> -1 Then
		p3_100.Text = SetCaromP3.SubString2(0,1)
		p3_10.Text = SetCaromP3.SubString2(1,2)
		p3_1.Text = SetCaromP3.SubString2(2,3)
	End If
	If caromP4 <> -1 Then
		p4_100.Text = SetCaromP4.SubString2(0,1)
		p4_10.Text = SetCaromP4.SubString2(1,2)
		p4_1.Text = SetCaromP4.SubString2(2,3)
	End If
End Sub

Private Sub InningSet_MouseClicked (EventData As MouseEvent)
	clsScreenSaverSurvival.SetLastClick
	Dim lbl As Label = Sender
	Dim inning As Int = $"${Inning_10.Text}${Inning_1.Text}"$ * 60000 
	Dim value As Int = lbl.Tag*60000
	Dim strInning As String
	
	
	If EventData.SecondaryButtonPressed Then
		If inning - value < 0 Then
			 Return
		End If
	End If
	
	If EventData.PrimaryButtonPressed = False And inning > 0 Then
		inning = inning - value
	Else
		inning = inning + value
	End If
	
	strInning = NumberFormat(inning/60000, 2, 0)
	
	Inning_10.Text = strInning.SubString2(0,1)
	Inning_1.Text = strInning.SubString2(1,2)
	gameDuration = inning
End Sub


Private Sub lblSwitchBord_MouseClicked (EventData As MouseEvent)
	clsScreenSaverSurvival.SetLastClick
	clsListBords.ShowBordList
End Sub

Private Sub lblPause_MouseClicked (EventData As MouseEvent)
	If lblPause.Text = "PAUSE" Then
		gameTimerWorking.Enabled = False
		lblPause.Text = "VERDER"
		CSSUtils.SetBackgroundColor(lblPause, fx.Colors.Green)
	Else
		CSSUtils.SetBackgroundColor(lblPause, fx.Colors.From32Bit(0xFF8F001D))
		gameTimerWorking.Enabled = True
		lblPause.Text = "PAUSE"
	End If
End Sub

Private Sub lblPause_MouseEntered (EventData As MouseEvent)
	If lblPause.Text = "VERDER" Then Return
	
	CSSUtils.SetBackgroundColor(lblPause, fx.Colors.From32Bit(0xFF8F001D))
End Sub

Private Sub lblPause_MouseExited (EventData As MouseEvent)
	If lblPause.Text = "VERDER" Then Return
	CSSUtils.SetBackgroundColor(lblPause, fx.Colors.Red)
	
End Sub

Sub UpdateCfg
	clsScreenSaverSurvival.updatePromote
End Sub

Sub enableScreenSaver(enable As Boolean)
	clsScreenSaverSurvival.enableScreenSaver(enable)
End Sub

Private Sub backupTmr_Tick
	If gameDuration = 0 Or gameTimerWorking.Enabled = False Then Return
	
	Dim strBackup As String = File.ReadString(File.DirAssets, "survivalbackup.json")
	parser.Initialize(strBackup)
	Dim root As Map = parser.NextObject
	Dim score As Map = root.Get("score")
	Dim p1 As Map = score.Get("p1")
	Dim p2 As Map = score.Get("p2")
	Dim p3 As Map = score.Get("p3")
	Dim p4 As Map = score.Get("p4")
	Dim tmr As Map = score.Get("timer")
	Dim gmeduration As Map = score.Get("gameduration")

	p1.Put("caram", caromP1)
	p2.Put("caram", caromP2)
	p3.Put("caram", caromP3)
	p4.Put("caram", caromP4)
	tmr.Put("time",	"")
	gmeduration.Put("duration", gameDuration)
	
	Dim JSONGenerator As JSONGenerator
	JSONGenerator.Initialize(root)
	
	File.WriteString(partijFolder, "survivalbackup.json", JSONGenerator.ToPrettyString(2))
	lblWriteJson.Visible = True
	Sleep(300)
	lblWriteJson.Visible = False
	
End Sub

Private Sub RecoverBord
	If File.Exists(partijFolder, "survivalbackup.json") = False Then Return
	DateTime.TimeFormat = "mm:ss"
	Dim strBackup As String = File.ReadString(partijFolder, "survivalbackup.json")
	parser.Initialize(strBackup)
		
	Dim root As Map = parser.NextObject
	Dim score As Map = root.Get("score")
	Dim p1 As Map = score.Get("p1")
	Dim caramP1 As Int = p1.Get("caram")
'	Dim timer As Map = score.Get("timer")
'	Dim time As String = timer.Get("time")
	Dim p2 As Map = score.Get("p2")
	Dim caramP2 As Int = p2.Get("caram")
	Dim p3 As Map = score.Get("p3")
	Dim caramP3 As Int = p3.Get("caram")
	Dim p4 As Map = score.Get("p4")
	Dim caramP4 As Int = p4.Get("caram")
	Dim gmeDuration As Map = score.Get("gameduration")
	Dim duration As Int = gmeDuration.Get("duration")
	
	caromP1 = caramP1
	caromP2 = caramP2
	caromP3 = caramP3
	caromP4 = caramP4
	ShowPlayerCarom
	
	gameDuration = duration
	
	timeString			= DateTime.Time(gameDuration)
	minutes				= Regex.Split(":", timeString)(0)
	seconds				= Regex.Split(":", timeString)(1)
	Inning_10.Text		= minutes.SubString2(0,1)
	Inning_1.Text		= minutes.SubString2(1,2)
	to_seconds10.Text	= seconds.SubString2(0,1)
	to_seconds1.Text	= seconds.SubString2(1,2)
	
	lblPause.Visible = True
	CSSUtils.SetBackgroundColor(lblPause, fx.Colors.Green)
	lblPause.Text = "VERDER"
	DateTime.TimeFormat = "HH:mm:ss"
End Sub