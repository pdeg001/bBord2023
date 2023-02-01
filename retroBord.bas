B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.1
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Public frm As Form
	Private PartijFolder As String
	Private xui As XUI
	Private clsBordList As ListOfBords
	Private clsScreenSaver As ScreenSaver
	Private backupTmr As Timer
	Private parser As JSONParser
	Private strBackup As String
	
	Dim imgSwaf As ImageView
	
	Private p1_100, p1_10, p1_1 As Label
	Private p1_1_8,  p1_10_8,  p1_100_8 As Label
	Private p2_100, p2_10, p2_1 As Label
	Private p2_1_8,  p2_10_8,  p2_100_8 As Label
	Private Inning_10, Inning_1 As Label
	Private Inning_1_8, Inning_10_8 As Label
	Private LblReset As B4XView
	Private lblCopyright As Label
	Public caromP1R As String, caromP2R As String, inningR As String
	Private Lbl_Beurten As Label
	Private lbl_kraai As Label
	Private lblIpNr As Label
	Private lblSpeler1 As Label
	Private lblSwafBal As Label
	Private lblSwafBal1 As Label
	Private pnSwaf As Pane
	Private pn_promote As Pane
	Private imgScreenSaverLogo As ImageView
	Private pn_message As Pane
	Private lbl_message_1 As Label
	Private lbl_message_2 As Label
	Private lbl_message_3 As Label
	Private lbl_message_4 As Label
	Private lbl_message_5 As Label
	Private p1Moyenne As B4XView
	Private p2Moyenne As B4XView
	Private p1MoyenneDummy As B4XView
	Private pnP2Moyenne As Pane
	Private p2MoyenneDummy As B4XView
	Private pnP1Moyenne As Pane
	Private lblImgSwaf As Label
	Private lblSwitchBord As Label
	Private lblWriteJson As Label
	Private pnlCommercialLarge As Pane
	Private b4xIvComm As B4XImageView
	Private pgBarRotateProgress As B4XProgressBar
End Sub


Public Sub show
	backupTmr.Initialize("backupTmr", 10000)
	strBackup = File.ReadString(File.DirAssets, "retrobackup.json")
	GetPartijFolder
	frm.Initialize("frm", 1920, 1080)
	frm.RootPane.LoadLayout("retrobord")
	clsBordList.Initialize(frm)
	clsScreenSaver.Initialize(frm, Me, "Retro")
	clsScreenSaver.pullConfig
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
'	If funcScorebord.bordDisplayName <> "" Then
'		lblIpNr.Text = $"${func.ipNumber}  -  ${funcScorebord.BordVersion} - ${funcScorebord.bordDisplayName}"$
'	Else
'		lblIpNr.Text = $"${func.ipNumber}  -  ${funcScorebord.BordVersion}"$
'	End If
	
End Sub

Public Sub showBord
	backupTmr.Enabled = True
	func.SetCustomCursor1(File.DirAssets, "mouse.png", 370, 370, frm.RootPane)
	If funcScorebord.bordDisplayName <> "" Then
		lblIpNr.Text = $"${func.ipNumber} - ${funcScorebord.BordVersion} - ${funcScorebord.bordDisplayName}"$
	Else
		lblIpNr.Text = $"${func.ipNumber} - ${funcScorebord.BordVersion}"$
	End If
	frm.Show
'	clsScreenSaver.Initialize(frm, Me)
End Sub

Sub frm_Closed
'	Log("RETRO CLOSE")
	backupTmr.Enabled = False
	clsScreenSaver.DisableTimers
End Sub

Sub frm_Show
'	Log("RETRO SHOW")
	
End Sub

Sub DisableTimers
	clsScreenSaver.DisableTimers
End Sub

Sub SetFrans
	
If File.Exists(parseConfig.getAppImagePath, "swaffie.png") Then
		CSSUtils.SetBackgroundImage(lblImgSwaf, parseConfig.getAppImagePath, "swaffie.png")
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
	func.caromLabelCss(Inning_1, "LabelLed")
	func.caromLabelCss(Inning_10, "LabelLed")
	
End Sub


Sub useDigitalFont(useDigital As Boolean)
'	Dim fsCarom, fsInnings As Int
	Dim fsCarom As Int
	Dim lst As List
	
	fsCarom = 300'350
'	fsInnings = 300'300
	lst.Initialize
	
	lst.AddAll(Array As B4XView(p1_100, p1_10, p1_1, p1_100_8, p1_10_8, p1_1_8, _ 
		p2_100, p2_10, p2_1, p2_100_8, p2_10_8, p2_1_8, Inning_10, Inning_1, _
		Inning_10_8, Inning_1_8))
	func.setFontRetroList(lst, fsCarom, useDigital)
	lst.Initialize
	lst.AddAll(Array As B4XView(p1Moyenne, p2Moyenne, p1MoyenneDummy, p2MoyenneDummy))
	func.setFontRetroList(lst, 180, useDigital)

End Sub

Sub lblCopyright_MouseClicked (EventData As MouseEvent)
'	clsBordList.ShowBordList
	
	'ExitApplication
End Sub

Sub LblReset_MouseReleased (EventData As MouseEvent)
	ResetPartij
End Sub

Sub LblReset_MouseEntered (EventData As MouseEvent)
	LblReset.Color = 0xFFFF0000
End Sub

Sub LblReset_MouseExited (EventData As MouseEvent)
	LblReset.Color = 0xFF001317 '0xFF002529
End Sub

Sub HideShowMoyenne (showMoy As Boolean)
	pnP2Moyenne.Visible = showMoy
	pnP1Moyenne.Visible = showMoy
End Sub

Sub ResetPartij
'	Dim sleepTime As Int = 200
	p1Moyenne.Text = "0.000"
	p2Moyenne.Text = "0.000"
	p1MoyenneDummy.Text = "8.888"
	p2MoyenneDummy.Text = "8.888"

	p1_1.Text = "0"
	p1_10.Text = "0"
	p1_100.Text = "0"
	p2_1.Text = "0"
	p2_10.Text = "0"
	p2_100.Text = "0"
	Inning_1.Text = "0"
	Inning_10.Text = "0"
	
	
	
	
'	Return
'	p1_100.Text = "B"
'	p1_10.Text = "I"
'	p1_1.Text = "E"
'	p2_100.Text = "R"
'	p2_10.Text = "T"
'	p2_1.Text = "J"
'	Inning_10.Text = "E"
'	Inning_1.Text = "?"
'	
'	Sleep(1000)
'	
'	AnimatedReset(p1_100,sleepTime)
'	Sleep(sleepTime)
'	AnimatedReset(p1_10, sleepTime)
'	Sleep(sleepTime)
'	AnimatedReset(p1_1, sleepTime)
'	Sleep(sleepTime)
'	
'	AnimatedReset(p2_100, sleepTime)
'	Sleep(sleepTime)
'	AnimatedReset(p2_10, sleepTime)
'	Sleep(sleepTime)
'	AnimatedReset(p2_1, sleepTime)
'	Sleep(sleepTime)
'	
'	Sleep(sleepTime)
'	AnimatedReset(Inning_10, sleepTime)
'	Sleep(sleepTime)
'	AnimatedReset(Inning_1,sleepTime)
'	Sleep(sleepTime)
End Sub

'Sub AnimatedReset(lbl As Label, st As Int)
'	lbl.TextColor = fx.Colors.From32Bit(0xFFFFFFFF)
'	lbl.Text = 0
'	Sleep(st+10)
'	lbl.TextColor = fx.Colors.From32Bit(0xFFFF0000)
'End Sub

Private Sub P1CalcCarom(leftMouse As Boolean, lbl As Label)
	clsScreenSaver.SetLastClick
	If IsNum($"${p1_100.Text}${p1_10.Text}${p1_1.Text}"$) = False Then Return
	Dim carom As Int = p1_100.Text&p1_10.Text&p1_1.Text
	Dim value As Int = lbl.Tag
	Dim strCarom As String
	
	If leftMouse == False Then
		value = -Abs(value)
	End If
	
	carom = carom + value
	
	If carom > 999 Or carom <= 0 Then
		carom = 0
	End If
	
	strCarom = func.padString(carom, "0", 0, 3)
	p1_100.Text = strCarom.SubString2(0,1)
	p1_10.Text = strCarom.SubString2(1,2)
	p1_1.Text = strCarom.SubString2(2,3)
	
	'CALC MOYENNE
	Dim inn As Int = $"${Inning_10.Text}${Inning_1.Text}"$
	If inn > 0 Then
		p1Moyenne.Text = NumberFormat2((carom/inn),1,3,3,False)
		p1MoyenneDummy.Text =   Regex.Replace("[^.]",p1Moyenne.Text,"8")
	End If
End Sub

Private Sub P2CalcCarom(leftMouse As Boolean, lbl As Label)
	clsScreenSaver.SetLastClick
	If IsNum($"${p2_100.Text}${p2_10.Text}${p2_1.Text}"$) = False Then Return
	Dim carom As Int = p2_100.Text&p2_10.Text&p2_1.Text
	Dim value As Int = lbl.Tag
	Dim strCarom As String
	
	If leftMouse == False Then
		value = -Abs(value)
	End If
	
	carom = carom + value
	
	If carom > 999 Or carom <= 0 Then
		carom = 0
	End If
	
	strCarom = func.padString(carom, "0", 0, 3)
	p2_100.Text = strCarom.SubString2(0,1)
	p2_10.Text = strCarom.SubString2(1,2)
	p2_1.Text = strCarom.SubString2(2,3)
	
	'CALC MOYENNE
	Dim inn As Int = $"${Inning_10.Text}${Inning_1.Text}"$
	If inn > 0 Then
		p2Moyenne.Text = NumberFormat2((carom/inn),1,3,3,False)
		p2MoyenneDummy.Text =   Regex.Replace("[^.]",p2Moyenne.Text,"8")
	End If
End Sub

Private Sub SetInning(leftMouse As Boolean)
	clsScreenSaver.SetLastClick
	If IsNum($"${Inning_10.Text}${Inning_1.Text}"$) = False Then Return
	Dim inning As Int = Inning_10.Text & Inning_1.Text
	Dim strInning As String
	Dim value As Int = 1
	Dim newInning As Int
	
	If leftMouse = False Then
		value = -Abs(value)
	End If
	
	newInning = inning + value
	
	If newInning > 99 Or newInning < 0 Then
		newInning = 0
	End If
	
	strInning = func.padString(newInning, 0, 0,2)
	Inning_10.Text = strInning.SubString2(0,1)
	Inning_1.Text = strInning.SubString2(1,2)
	
	If newInning > 0 Then
		Dim p1Carom As Int = $"${p1_100.Text}${p1_10.Text}${p1_1.Text}"$
		Dim p2Carom As Int = $"${p2_100.Text}${p2_10.Text}${p2_1.Text}"$
		p1MoyenneDummy.Text = "0.000" 
		p1Moyenne.Text = NumberFormat2((p1Carom/newInning),1,3,3,False)
		p2Moyenne.Text = NumberFormat2((p2Carom/newInning),1,3,3,False)
		p1MoyenneDummy.Text =   Regex.Replace("[^.]",p1Moyenne.Text,"8")
		p2MoyenneDummy.Text =   Regex.Replace("[^.]",p2Moyenne.Text,"8")
	Else
		p1Moyenne.Text = "0.000"
		p2Moyenne.Text = "0.000"	
		p1MoyenneDummy.Text = "8.888"	
		p2MoyenneDummy.Text = "8.888"	
	End If
End Sub

Sub p2_1_MouseReleased (EventData As MouseEvent)
	P2CalcCarom(EventData.PrimaryButtonPressed, Sender)
End Sub

Sub p2_10_MouseReleased (EventData As MouseEvent)
	P2CalcCarom(EventData.PrimaryButtonPressed, Sender)
	End Sub

Sub p2_100_MouseReleased (EventData As MouseEvent)
	P2CalcCarom(EventData.PrimaryButtonPressed, Sender)
End Sub

Sub p1_100_MouseReleased (EventData As MouseEvent)
	P1CalcCarom(EventData.PrimaryButtonPressed, Sender)
End Sub

Sub p1_10_MouseReleased (EventData As MouseEvent)
	P1CalcCarom(EventData.PrimaryButtonPressed, Sender)
	
End Sub

Sub p1_1_MouseReleased (EventData As MouseEvent)
	P1CalcCarom(EventData.PrimaryButtonPressed, Sender)
End Sub

Sub Inning_1_MouseReleased (EventData As MouseEvent)
	SetInning(EventData.PrimaryButtonPressed)
End Sub

Sub Inning_10_MouseReleased (EventData As MouseEvent)
	SetInning(EventData.PrimaryButtonPressed)
End Sub



'Return true to allow the default exceptions handler to handle the uncaught exception. 
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	LogError(Error)
	LogError(StackTrace)
	File.WriteString(func.appPath, "errError.txt", Error)
	File.WriteString(func.appPath, "errStackTrace.txt", StackTrace)
	Return True
End Sub

Public Sub SetMirrorScore()
	p1_100.Text = caromP1R.SubString2(0,1)
	p1_10.Text = caromP1R.SubString2(1,2)
	p1_1.Text = caromP1R.SubString2(2,3)
	
	p2_100.Text = caromP2R.SubString2(0,1)
	p2_10.Text = caromP2R.SubString2(1,2)
	p2_1.Text = caromP2R.SubString2(2,3)
	
	Inning_10.Text = inningR.SubString2(1,2)
	Inning_1.Text = inningR.SubString2(2,3)
End Sub

Private Sub Lbl_Beurten_MouseReleased (EventData As MouseEvent)
	If EventData.SecondaryButtonPressed Then
		lbl_kraai.Visible = True
		CSSUtils.SetBackgroundImage(lbl_kraai, File.DirAssets, "ODT0.gif")
		Sleep(3000)
		lbl_kraai.Visible = False
	End If
End Sub

Private Sub IsNum(num As String) As Boolean
	Return IsNumber(num)
End Sub


Private Sub lblSpeler1_MouseClicked (EventData As MouseEvent)
	If EventData.SecondaryButtonPressed Then
		pnSwaf.Visible = True
		Sleep(3000)
		pnSwaf.Visible = False
	End If
End Sub

Sub GetPartijFolder
	Dim os As String = parseConfig.DetectOS
	Dim appFolder As String
			
	Select os
		Case "windows"
			appFolder = File.DirApp'&"\44\"
			PartijFolder = $"${appFolder}\gespeelde_partijen"$
			'	clsGen.general
		Case "linux"
			appFolder = File.DirApp'&"/44/"
			PartijFolder = $"${appFolder}/44/gespeelde_partijen"$
	End Select
	If File.IsDirectory("",PartijFolder) = False Then
		File.MakeDir("", PartijFolder)
	End If
End Sub

Private Sub lblSwitchBord_MouseClicked (EventData As MouseEvent)
	clsBordList.ShowBordList
End Sub

Sub UpdateCfg
	clsScreenSaver.updatePromote
End Sub

Sub enableScreenSaver(enable As Boolean)
	clsScreenSaver.enableScreenSaver(enable)
End Sub

Private Sub backupTmr_Tick
	Dim caramP1, caramP2, strInning As String
	
	caramP1 = $"${p1_100.Text}${p1_10.Text}${p1_1.Text}"$
	caramP2 = $"${p2_100.Text}${p2_10.Text}${p2_1.Text}"$
	strInning = $"${Inning_10.Text}${Inning_1.Text}"$
	
	
	parser.Initialize(strBackup)
	Dim root As Map = parser.NextObject
	Dim score As Map = root.Get("score")
	Dim p1 As Map = score.Get("p1")
	Dim p2 As Map = score.Get("p2")
	Dim inning As Map = score.Get("inning")
	
	inning.Put("inning", strInning)
	p1.Put("caramP1", caramP1)
	p1.Put("moyP1", p1Moyenne.Text)
	p2.Put("caramP2", caramP2)
	p2.Put("moyP2", p2Moyenne.Text)
	
	Dim JSONGenerator As JSONGenerator
	JSONGenerator.Initialize(root)
	
	File.WriteString(PartijFolder, "retrobackup.json", JSONGenerator.ToPrettyString(2))
	lblWriteJson.Visible = True
	Sleep(300)
	lblWriteJson.Visible = False
	
End Sub