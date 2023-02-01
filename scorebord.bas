B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8
@EndOfDesignText@
'#IgnoreWarnings: 16, 9
'SCREENSAVER FUNC IS HANDLED BY THE FUNC updateCFG
'Static code module
Sub Process_Globals
	Private fx As JFX
	Public frm As Form
	Private xui As XUI
	Private endGameTimer As Timer
	Private parser As JSONParser
	Private PartijFolder As String
	Private inactivecls As inactiveClass
	Public clsCheckCfg As classCheckConfig
'	Private clsUpdate As classUpdate
	Private clsTmr As timerClass
	Private clsNewGame As classNewGame
	Private clsGameTime As classGameTimer
	Private clsOrderDrink As ClassOrderDrink
	Private clsRotateMedia As RotateMedia
	Private clsHSerie As ClassHoogsteSerie
	
	
	Public hoogsteSeriePlayer, hoogsteSerieP1, hoogsteSerieP2 As Int = 0
	Public aanStoot As Int
	Private clsListBord As ListOfBords
	Private strBackup As String
	Private pn_promote_top, pn_promote_left As Double
	Dim mqttBordPub As mqttPubBord
	Dim mqttPubDataBord As mqttPubData
	Dim starterMqttConnected As Starter
	
	
	Private imgBeginPartij, imgStartPartij, imgSponsor, imgLogo As B4XBitmap
'	Private bKraai() As Byte
	
	Private mqttEnabled, brokerConnected, resetBordVisible, reclameFound, allowPlayerSwap As Boolean
	Private newGame, promoteRunning As Boolean = False

	Public lbl_player_one_moyenne, lbl_player_two_moyenne As Label
	Public lbl_player_two_100, lbl_player_two_10, lbl_player_two_1 As Label
	Public lbl_player_one_make_100, lbl_player_one_make_10, lbl_player_one_make_1 As Label
	Public lbl_player_two_make_100, lbl_player_two_make_10, lbl_player_two_make_1 As Label
	Public lbl_player_one_perc, lbl_player_two_perc As Label
	Public lbl_player_one_hs, lbl_player_two_hs, lbl_innings As Label
	Public lbl_config_update As Label
	Public lbl_player_one_1, lbl_player_one_10, lbl_player_one_100 As Label
	Public lbl_message_1, lbl_message_2, lbl_message_3, lbl_message_4, lbl_message_5 As Label
	Public lbl_ip, lbl_p1_inning, lbl_p2_inning, Label7, Label6, lbl_version As Label 'lbl_game_text,
	Public lbl_img_sponsore, lbl_date_time_dag, lbl_date_time_date, lbl_partij_duur As Label
	Public lbl_spel_soort, lbl_partij_duur_header, lbl_has_inet, lbl_beurten_header As Label
	Public lblBroker, lblBrokerDead, lblTmpTimer, lblCloseApp, lbl_beurten_automatisch As Label
	Public lblSwitchBord, lblOrderDrink As Label
	
	Public B4XProgressBarP1, B4XProgressBarP2, pBarTimeP1 As B4XProgressBar

	Private btnResetGameCancel, btnResetGameReset, btnCancelEndGame, btnConfirmEndGame As Button
	Private btnStartP1, btnStartP2, btnStartPartij, btnAnnuleerNieuwePartij, btnStartNieuwePartij As Button
	Private btnCancelStartPartij As Button

	Private pn_a, pnBlockReset, pnEndGame, pnPlayerStart, pnForPromote, pn_nieuwe_partij As Pane
	Private pn_p1_carom, pn_promote, pn_sponsore As Pane ', pn_game

	Public p1Points10Disabled, p1Points100Disabled, p1Points1Disabled As B4XView
	Public p2Points1Disabled, p2Points10Disabled, p2Points100Disabled As B4XView
	Private lbl_reset, lbl_clock, lbl_close, lbl_clearBord As B4XView
	Public lbl_player_one_name, lbl_player_two_name, lblWriteJson As B4XView

	Private imgScreenSaverLogo, iv_img_sponsore As ImageView

	Private chk_autoInning As CheckBox
	
	Private pnlCommercialLarge As Pane
'	Private ivLargeCommercial As ImageView
'	Private lblImgCommercial As Label
	Private lblRotateMediaActive As Label
	Private b4xIvComm As B4XImageView
	Private pnConfirmPlayerStarts As Pane
	Private lblConfirmPlayerNameStarts As Label
	Private btnConfirmPlayerCancel As Button
	Private btnConfirmPlayerStarts As Button
	Private pgBarRotateProgress As B4XProgressBar
	
'	Public lblHsP1 As Label
'	Public lblHsP2 As Label
	Private pn_hserie_p1 As Pane
	Private pn_hserie_p2 As Pane
	Public lbl_p1_hs As Label
	Public lbl_p2_hs As Label
	Private lbl_hoogsteSerie As Label
	Private lbl_p1_hs_header As Label
	Private lbl_p2_hs_header As Label
End Sub

'Return true to allow the default exceptions handler to handle the uncaught exception.
Sub Application_Error (Error As Exception, StackTrace As String) As Boolean
	LogError("ERR" & Error)
	LogError(StackTrace)
	File.WriteString(File.DirApp, "errStackTrace.txt", StackTrace)
	File.WriteString(File.DirApp, "errError.txt", Error)
	Return True
End Sub

Public Sub show
	func.GetAppPath
	strBackup = File.ReadString(File.DirAssets, "score.json")
	frm.Initialize("frm", 1920, 1080)
	frm.RootPane.LoadLayout("scorebord")
	clsListBord.Initialize(frm)
	
	frm.BackColor  =   fx.Colors.From32Bit(0xFF001A01)
	'''	pnEndGame.Visible = False
	endGameTimer.Initialize("hideEndGameDialog", 10000)
	endGameTimer.Enabled = False
	lbl_ip.Text = func.getIpNumber
	Dim bmpLogo As B4XBitmap = xui.LoadBitmap(parseConfig.getAppImagePath, "logo.png")
	
	If func.DetectOS.IndexOf("win") > -1 Then
		frm.SetFormStyle("DECORATED")
	Else
		frm.SetFormStyle("UNDECORATED")
	End If

	imgScreenSaverLogo.SetImage(bmpLogo)
	frm.Stylesheets.Add(File.GetUri(File.DirAssets, "n205.css"))
	
	parseConfig.pullConfig
	
	func.SetCustomCursor1(File.DirAssets, "mouse.png", 370, 370, frm.RootPane)
	
	'TIJDELIJK
	InitHs
	'TIJDELIJK
	
	clsTmr.Initialize(lbl_clock, lbl_date_time_date, lbl_date_time_dag)
	inactivecls.Initialize(Me,870, 510)
	clsCheckCfg.Initialize
	clsNewGame.Initialize(lbl_reset)
	clsGameTime.Initialize(lbl_partij_duur)
	clsRotateMedia.Initialize
	clsRotateMedia.B4xImg = b4xIvComm
	If parseConfig.bRotateMedia Then
		clsRotateMedia.EnableRtTimer(True)
	End If
	lblRotateMediaActive.Visible = parseConfig.bRotateMedia
		
	mqttBordPub.Initialize
	mqttPubDataBord.Initialize
	funcScorebord.lblInnings = lbl_innings
	funcScorebord.lbl_player_one_hs = lbl_player_one_hs
	funcScorebord.lbl_player_two_hs = lbl_player_two_hs
	
	funcScorebord.setP1CaromLables(lstPlayerOneScoreLbl)
	funcScorebord.setP2CaromLables(lstPlayerTwoScoreLbl)

	lbl_has_inet.Visible = False
	lblBrokerDead.Visible = False
	lblBroker.Visible = False
	
	If func.ipNumber <> "127.0.0.1" Then
		Wait For (funcInet.testInet) Complete (result As Boolean)
		If result Then
			func.hasInternetAccess = True
		Else
			func.hasInternetAccess = False
		End If
		lblBroker.Visible = result
		lblBrokerDead.Visible = result
		lbl_has_inet.Visible = result
	End If
	frm.Show
	
	
	initPanels
	SetSponsorImg
	setFontStyle
'	disableControls
	funcScorebord.disableControls
	GetPartijFolder
	EnableClockFunction(False)
	func.alignLabelCenter(lbl_player_one_name)
	func.alignLabelCenter(lbl_player_two_name)
	CheckGameStop
	
	If func.hasInternetAccess Then
		starterMqttConnected.Initialize
		PubBord
	End If
	
	If funcScorebord.bordDisplayName <> "" Then
		lbl_version.Text =$"${funcScorebord.BordVersion} - ${funcScorebord.bordDisplayName}"$
	Else
		lbl_version.Text =$"${funcScorebord.BordVersion}"$
	End If

	Dim strRetro As String = File.ReadString(func.appPath, "retro.cnf")
	clsCheckCfg.ProcessRetro(strRetro)
	clsOrderDrink.Initialize(frm)
	
End Sub

Public Sub InitHs
	clsHSerie.Initialize(lbl_p1_hs, lbl_p2_hs, lbl_p1_hs_header, lbl_p2_hs_header)
End Sub

Public Sub frm_Showing
	func.SetCustomCursor1(File.DirAssets, "mouse.png", 370, 370, frm.RootPane)
	enableScreenSaver(True)
End Sub

Sub setp1Time(timePerc As Double)
	pBarTimeP1.Progress=timePerc
	Sleep(0)
End Sub

Sub GetPartijTimer As String
	Return lbl_partij_duur.Text
End Sub

public Sub ShowScoreBord
	frm.Show
End Sub

Sub EnableMqtt
	PubBord
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

Public Sub setClearBoard(clear As Boolean)
	funcScorebord.setNieuwePartij = clear
End Sub

Sub SetBrokerStatus(status As Boolean)
	brokerConnected = status
End Sub

Sub DisconnectMqtt As ResumableSub
	wait for (mqttBordPub.StopServer) Complete (result As Boolean)
	wait for (mqttPubDataBord.StopServer) Complete (result As Boolean)
	Return True
End Sub


Sub MqttConnected
	'CHECK IF MQTT HOST CAN BE REACHED
	If mqttEnabled = False Then
		func.mqttClientConnected = False
		SetBrokerIcon(False)
		mqttBordPub.StopServer
		mqttPubDataBord.StopServer
		Return
	End If
	
	If brokerConnected = False Or mqttEnabled = False Then
		func.mqttClientConnected = False
		SetBrokerIcon(False)
		mqttBordPub.StopServer
		mqttPubDataBord.StopServer
		Return
	End If
	
	If brokerConnected Then 'And Not(func.mqttClientConnected) Then
		func.mqttClientConnected = brokerConnected
		SetBrokerIcon(True)
		
		CallSubDelayed(mqttBordPub, "ConnectTo")
		CallSubDelayed(mqttPubDataBord, "ConnectTo")
	End If
End Sub

Sub PubBord
	If func.hasInternetAccess Then
		StartStopClientServer
	End If
End Sub

Sub initPanels
	pn_promote_top = 1130 'pn_promote.Top
	pn_promote_left = 20 'pn_promote.Left
	
	inactivecls.frm = frm
	inactivecls.pn_promote = pn_promote
	
	
	
	imgBeginPartij = xui.LoadBitmap(parseConfig.getAppImagePath, "begin_partij.png")
	imgStartPartij = xui.LoadBitmap(parseConfig.getAppImagePath, "start_partij.png")
	If File.Exists(parseConfig.getAppImagePath, "reclame.png") Then
		imgSponsor = xui.LoadBitmap(parseConfig.getAppImagePath, "reclame.png")
		reclameFound = True
	End If
	imgLogo = xui.LoadBitmap(parseConfig.getAppImagePath, "biljarter.png")
End Sub

Sub setFontStyle
	func.caromLabelCss(lbl_player_one_100, "labelCarom")
	func.caromLabelCss(lbl_player_one_10, "labelCarom")
	func.caromLabelCss(lbl_player_one_1, "labelCarom")
	
	func.caromLabelCss(lbl_player_one_make_100, "labelCarom")
	func.caromLabelCss(lbl_player_one_make_10, "labelCarom")
	func.caromLabelCss(lbl_player_one_make_1, "labelCarom")
		
	func.caromLabelCss(lbl_player_two_100, "labelCarom")
	func.caromLabelCss(lbl_player_two_10, "labelCarom")
	func.caromLabelCss(lbl_player_two_1, "labelCarom")
	
	func.caromLabelCss(lbl_player_two_make_100, "labelCarom")
	func.caromLabelCss(lbl_player_two_make_10, "labelCarom")
	func.caromLabelCss(lbl_player_two_make_1, "labelCarom")
	
'	resetBoard
	funcScorebord.resetBoard
End Sub

Sub lstPlayerOneScoreLbl As List
	Dim List As List
	List.Initialize
	List.AddAll(Array As Object(lbl_player_one_1, lbl_player_one_10, lbl_player_one_100, lbl_player_one_moyenne, B4XProgressBarP1, lbl_p1_hs, lbl_p1_hs_header))
	Return List
End Sub

Sub lstPlayerTwoScoreLbl As List
	Dim List As List
	List.Initialize
	List.AddAll(Array As Object(lbl_player_two_1, lbl_player_two_10, lbl_player_two_100, lbl_player_two_moyenne, B4XProgressBarP2, lbl_p2_hs, lbl_p1_hs_header))
	Return List
End Sub

Sub lastClick
	If allowPlayerSwap Then
		allowPlayerSwap = False
		lbl_spel_soort.Visible = False
		CSSUtils.SetBackgroundColor(lbl_spel_soort, fx.Colors.Transparent)
	End If
	
	If parseConfig.timeOutActive Then
		inactivecls.lastClick = DateTime.Now
	Else If parseConfig.bRotateMedia Then
		clsRotateMedia.lastClick = DateTime.Now
	End If
End Sub

'PROCESS SCORE P1
Sub p1Points_MouseClicked (EventData As MouseEvent)
	If resetBordVisible Then 
		Sleep(500)
		Return
	End If
	Dim lbl As Label = Sender
	funcScorebord.calcScorePlayerOne(lbl.Tag, EventData.PrimaryButtonPressed)
'	setP1Name
	
''	lbl_player_one_name_MouseClicked(EventData)
	lastClick
	WriteScoreJson
End Sub

'PROCESS SCORE P2
Sub p2Points_MouseClicked (EventData As MouseEvent)
	If resetBordVisible Then 
		Sleep(500)
		Return
	End If
	Dim lbl As Label = Sender
	funcScorebord.calcScorePlayertwo(lbl.Tag, EventData.PrimaryButtonPressed)
'	setP2Name
	
''	lbl_player_two_name_MouseClicked(EventData)
	lastClick
	WriteScoreJson
End Sub

Public Sub SetHSerie(points As Int)
	clsHSerie.AddToHs(points)
End Sub

Public Sub SetHoogsteSerieP2(points As Int)
	'lbl_p2_hs.Text = NumberFormat(points, 3, 0)
'	lbl_hoogsteSerie.Text = NumberFormat(points, 3, 0)
'	Log($"POINTS: ${points} HOOGSTESERIE: ${hoogsteSeriePlayer}"$)
End Sub

'PROCESS P1 TO MAKE
Sub p1ToMake_MouseClicked (EventData As MouseEvent)
	If resetBordVisible Then 
		Sleep(500)
		Return
	End If
	Dim lbl As Label = Sender
	funcScorebord.playerOneMake(lbl_player_one_make_100, lbl_player_one_make_10, lbl_player_one_make_1, EventData.PrimaryButtonPressed, lbl.Tag)
	lastClick
	WriteScoreJson
End Sub

'PROCESS P2 TO MAKE
Sub p2ToMake_MouseClicked (EventData As MouseEvent)
	If resetBordVisible Then
		Sleep(500)
		 Return
	End If
	Dim lbl As Label = Sender
	funcScorebord.playerTwoMake(lbl_player_two_make_100, lbl_player_two_make_10, lbl_player_two_make_1, EventData.PrimaryButtonPressed, lbl.Tag)
	lastClick
	WriteScoreJson
End Sub

Sub lbl_innings_MouseClicked (EventData As MouseEvent)
	If IsNumber(lbl_innings.Text) = False Then Return
	If resetBordVisible Then 
		Sleep(500)
		Return
	End If
	
	Dim points As Int = lbl_innings.Text
	If EventData.PrimaryButtonPressed Then
		points = points + 1
	Else
		points = points - 1
	End If
	If points = -1 Then
		Return
	End If

	funcScorebord.innings = points
	funcScorebord.prevInnings = funcScorebord.prevInnings+1'points
	lbl_innings.Text = func.padString(points, "0", 0, 3)
	funcScorebord.calcMoyenne(lbl_player_one_moyenne, lbl_player_two_moyenne)
	funcScorebord.inningSet = 1
	lastClick
	WriteScoreJson
End Sub


'NOTE TO SELF aanstoot bekijken in funcScoreBord
Sub lbl_player_one_name_MouseClicked (EventData As MouseEvent)
	If resetBordVisible Then
		Sleep(500)
		Return
	End If
	funcScorebord.calcMoyenneP2
	
	clsHSerie.ResetPoints
	clsHSerie.SetPlayerAtTable(1)
'	setP1Name
	funcScorebord.setP1Name
	If funcScorebord.inningSet = 0 And funcScorebord.autoInnings = True Then
		funcScorebord.inningSet = 1
		funcScorebord.innings = funcScorebord.innings+1
		lbl_innings.Text = func.padString(funcScorebord.innings, "0", 0, 3)
	End If
	
	'CHECK HIGH INNGING
'	If hoogsteSeriePlayer <> 0 And hoogsteSeriePlayer > hoogsteSerieP1 Then
'	If funcScorebord.playerHoogsteSerie > 0 Then
'		Dim iHS As Int = lbl_p2_hs.Text
'		If iHS > funcScorebord.playerHoogsteSerie Then
'			lbl_p2_hs.Text = NumberFormat(funcScorebord.playerHoogsteSerie, 3, 0)
'		End If
'		funcScorebord.playerHoogsteSerie = 0
'		lbl_hoogsteSerie.Text = "000"
'	End If
	
	Sleep(100)
	WriteScoreJson
	lastClick
End Sub

Sub lbl_player_two_name_MouseClicked (EventData As MouseEvent)
	If resetBordVisible Then
		Sleep(500)
		Return
	End If
'	setP2Name
	funcScorebord.setP2Name
	funcScorebord.inningSet = 0
	funcScorebord.calcMoyenneP1
	clsHSerie.ResetPoints
	clsHSerie.SetPlayerAtTable(2)
	
	'CHECK HIGH INNGING
	If hoogsteSeriePlayer <> 0 And hoogsteSeriePlayer > hoogsteSerieP2 Then
'		Dim iHS As Int = lbl_p1_hs.Text
'		If iHS > hoogsteSeriePlayer Then
'			lbl_p2_hs.Text = NumberFormat(hoogsteSeriePlayer, 3, 0)
'		End If
		funcScorebord.playerHoogsteSerie = 0
		lbl_hoogsteSerie.Text = "000"
	End If
	
	Sleep(100)
	WriteScoreJson
	lastClick
End Sub

Sub playerOnePerc(perc As String)
	
	lbl_player_one_perc.Text = perc
End Sub

Sub playerTwoPerc(perc As String)
	lbl_player_two_perc.Text = perc
End Sub

Sub setNewGame(set As Boolean)
	iv_img_sponsore.SetImage(imgStartPartij)
	newGame = set
'	disableControls
	funcScorebord.disableControls
	enableScoreAndMake(True)
End Sub

Sub setNewGameFromPc(set As Boolean)
	EndCommercialRotate
'	CSSUtils.SetBackgroundImage(lbl_img_sponsore, "",parseConfig.getAppImagePath & "start_partij.png")
	iv_img_sponsore.SetImage(imgStartPartij)
	newGame = set
	
'	disableControls
	funcScorebord.disableControls
	
	enableScoreAndMake(False)
	btnStartP1.Text = lbl_player_one_name.Text.Replace(CRLF, " ")
	btnStartP2.Text = lbl_player_two_name.Text.Replace(CRLF, " ")
	funcScorebord.gameRunning = True
	pnPlayerStart.SetLayoutAnimated(0, 0, 0, pnPlayerStart.Width, pnPlayerStart.Height)
	If mqttPubDataBord.connected Then
		mqttPubDataBord.SendMessage($"game-started|${func.getIpNumber}"$, "game-started")
	End If
End Sub

Sub enableScoreAndMake(enable As Boolean)
'	disableControls
	funcScorebord.disableControls
	
	lbl_player_one_make_100.Enabled = enable
	lbl_player_one_make_10.Enabled = enable
	lbl_player_one_make_1.Enabled = enable
	
	lbl_player_two_make_100.Enabled = enable
	lbl_player_two_make_10.Enabled = enable
	lbl_player_two_make_1.Enabled = enable
End Sub


Sub hideForm
	frm.show
End Sub

Public Sub HideMainForRetro(showForm As Boolean)
	frm.RootPane.Visible = showForm
End Sub

Sub lbl_clearBord_MouseEntered (EventData As MouseEvent)
	lbl_clearBord.Color = 0xFFFF0000
End Sub

Sub lbl_clearBord_MouseExited (EventData As MouseEvent)
	lbl_clearBord.Color = 0xFF088F00
End Sub

Sub lbl_reset_MouseEntered (EventData As MouseEvent)
	lbl_reset.Color =  0xFF69D79A
	lbl_reset.TextColor = 0xFFFFFF00
End Sub

Sub lbl_reset_MouseExited (EventData As MouseEvent)
	If lbl_reset.Text = "Nieuwe Partij" Then
		lbl_reset.Color = 0xFFFF0000
		lbl_reset.Color = 0xFF205502
		lbl_reset.TextColor = 0xFFFFFFFF
	Else
		lbl_reset.Color = 0xFFFF0000
		lbl_reset.TextColor = 0xFFFFFFFF
	End If
End Sub

Sub lbl_reset_MouseReleased (EventData As MouseEvent)
	If resetBordVisible Then 
		Sleep(500)
		Return
	End If
'	inactivecls.lastClick = DateTime.Now
	lastClick
	If lbl_reset.Text = "Nieuwe Partij" Then
		funcScorebord.autoInnings = True
'		resetBoard
		funcScorebord.resetBoard
		setNewGame(True)
''''		pn_nieuwe_partij.Visible = True
''''		pn_nieuwe_partij.SetLayoutAnimated(0, 0, 0, pnPlayerStart.Width, pnPlayerStart.Height)
'		If nieuwe_partij = Null Then
'			nieuwe_partij.show
'		End If
'		nieuwe_partij.showForm
'		frm.Close
	else If lbl_reset.Text = "Partij Beëindigen" Then
''''		pnEndGame.Visible = True
		pnEndGame.SetLayoutAnimated(0, 0, 0, pnPlayerStart.Width, pnPlayerStart.Height)
		endGameTimer.Enabled = True
	End If
	
End Sub

Sub eindePartij
	EndCommercialRotate
	clsGameTime.tmrEnable(False)
	lbl_reset.Text = "Nieuwe Partij"
	lbl_reset.Color = 0xFF205502
'	resetBoard
'	If File.Exists(PartijFolder, "currscore.json")  Then
'		File.Delete(PartijFolder, "currscore.json")
'		Sleep(300)
'	End If
	
'	disableControls
	funcScorebord.disableControls
	
	clsCheckCfg.SetEndedGame
	If mqttPubDataBord.connected Then
		mqttPubDataBord.SendMessage($"game-ended|${func.getIpNumber}"$, "game-ended")
	End If
	funcScorebord.gameRunning = False
	pnPlayerStart.SetLayoutAnimated(0, 0, 1200, pnPlayerStart.Width, pnPlayerStart.Height)
	pnBlockReset.SetLayoutAnimated(0, 0, 1200, pnBlockReset.Width, pnBlockReset.Height)
End Sub

Sub lbl_close_MouseReleased (EventData As MouseEvent)
	'ExitApplication
End Sub

Sub showPromote
	pnForPromote.SetLayoutAnimated(0, 0dip, 50dip, pnForPromote.Width, pnForPromote.Height)
	pn_promote.SetLayoutAnimated(0, 50dip, 50dip, pn_promote.Width, pn_promote.Height)
End Sub

Sub drawPromote(x As Double, y As Double)
'	Log($"SCOREBORD PROMOTE"$)
	pn_promote.SetLayoutAnimated(0, x, y, pn_promote.Width, pn_promote.Height)
	Sleep(0)
End Sub

Sub setPromoteRunning(running As Boolean)
	promoteRunning = running
End Sub

Sub updateCfg
	inactivecls.updatePromote
	clsRotateMedia.UpdateRotate
	'lbl_config_update.Visible = True
	lbl_config_update.SetAlphaAnimated(0, 1)
	Sleep(3000)
	lbl_config_update.SetAlphaAnimated(0, 0)
	lblRotateMediaActive.Visible = parseConfig.bRotateMedia
	'lbl_config_update.Visible = False
End Sub

Sub useDigitalFont(useDigital As Boolean)
	Dim fsCarom, fsMake, fsInnings As Int
	
	If useDigital Then
		fsCarom = 300'350
		fsMake = 200'225
		fsInnings = 250'300
	Else 
		fsCarom = 225
		fsMake = 150
		fsInnings = 200	
	End If
	
	func.setFont(lbl_player_one_1, fsCarom, useDigital)
	func.setFont(lbl_player_one_10, fsCarom, useDigital)
	func.setFont(lbl_player_one_100, fsCarom, useDigital)
	func.setFont(lbl_player_two_1, fsCarom, useDigital)
	func.setFont(lbl_player_two_10, fsCarom, useDigital)
	func.setFont(lbl_player_two_100, fsCarom, useDigital)
	func.setFont(lbl_innings, fsInnings, useDigital)
	func.setFont(lbl_player_one_make_100, fsMake, useDigital)
	func.setFont(lbl_player_one_make_10, fsMake, useDigital)
	func.setFont(lbl_player_one_make_1, fsMake, useDigital)
	func.setFont(lbl_player_two_make_100,fsMake, useDigital)
	func.setFont(lbl_player_two_make_10,fsMake, useDigital)
	func.setFont(lbl_player_two_make_1,fsMake, useDigital)
	
End Sub

Sub useFontYellow(useYellow As Boolean)
	
	func.setFontColor(lbl_innings, useYellow)
		
	func.setFontColor(lbl_player_one_1, useYellow)
	func.setFontColor(lbl_player_one_10, useYellow)
	func.setFontColor(lbl_player_one_100, useYellow)
	
	func.setFontColor(lbl_player_two_1, useYellow)
	func.setFontColor(lbl_player_two_10, useYellow)
	func.setFontColor(lbl_player_two_100, useYellow)
	
	func.setFontColor(lbl_player_one_make_100, useYellow)
	func.setFontColor(lbl_player_one_make_10, useYellow)
	func.setFontColor(lbl_player_one_make_1, useYellow)
	
	func.setFontColor(lbl_player_two_make_100, useYellow)
	func.setFontColor(lbl_player_two_make_10, useYellow)
	func.setFontColor(lbl_player_two_make_1, useYellow)
	
End Sub

Sub showSponor(enabled As Boolean)
	pn_sponsore.Visible = enabled
End Sub

Sub setMessage(msgList As List)
	lbl_message_1.Text = msgList.get(0)
	lbl_message_2.Text = msgList.get(1)
	lbl_message_3.Text = msgList.get(2)
	lbl_message_4.Text = msgList.get(3)
	lbl_message_5.Text = msgList.Get(4)
End Sub

Sub setSpelerData(data As List)
'	resetBoard
	funcScorebord.resetBoard
	
	Dim teMaken As String
	lbl_player_one_name.Text = data.Get(0)
	funcScorebord.p1ToMake = data.Get(1)
	teMaken =  func.padString(data.Get(1), "0", 0, 3)
	lbl_player_one_make_100.Text	= teMaken.SubString2(0,1)
	lbl_player_one_make_10.Text		= teMaken.SubString2(1,2)
	lbl_player_one_make_1.Text		= teMaken.SubString2(2,3)
		
	lbl_player_two_name.Text = data.Get(2)
	teMaken =  func.padString(data.Get(3), "0", 0, 3)
	funcScorebord.p2ToMake = data.Get(3)
	lbl_player_two_make_100.Text	= teMaken.SubString2(0,1)
	lbl_player_two_make_10.Text		= teMaken.SubString2(1,2)
	lbl_player_two_make_1.Text		= teMaken.SubString2(2,3)
	
	lbl_spel_soort.Text = data.get(4)
End Sub


Sub lbl_player_two_hs_MouseReleased (EventData As MouseEvent)
	lbl_player_two_hs.Text = func.setHs(lbl_player_two_hs.Text, EventData.PrimaryButtonPressed)
End Sub

Sub lbl_player_one_hs_MouseReleased (EventData As MouseEvent)
	lbl_player_one_hs.Text = func.setHs(lbl_player_one_hs.Text, EventData.PrimaryButtonPressed)
End Sub

Sub iv_img_sponsore_MouseReleased (EventData As MouseEvent)
	If newGame = False Then Return
	
	clsHSerie.ResetPoints
	SetSponsorImg
	
	lbl_player_two_name.Enabled = True
	lbl_player_one_name.Enabled = True
	lbl_innings.Enabled = True
	lbl_player_one_hs.Enabled = True
	lbl_player_two_hs.Enabled = True
	
	clsGameTime.setGameStart
	clsGameTime.tmrEnable(True)
	If lbl_player_one_make_1.Text+lbl_player_one_make_10.Text+lbl_player_one_make_100.Text = 0 Then
		lbl_player_one_perc.Text = "n.v.t."
	End If
	If lbl_player_two_make_1.Text+lbl_player_two_make_10.Text+lbl_player_two_make_100.Text = 0 Then
		lbl_player_two_perc.Text = "n.v.t."
	End If

'	setP1Name
	funcScorebord.setP1Name
	newGame = False
	lbl_reset.Text = "Partij Beëindigen"
	lbl_reset.Color = 0xFFFF0000
	
	If File.Exists(PartijFolder, "currscore.json")  Then
		File.Delete(PartijFolder, "currscore.json")
		Sleep(200)
	End If
	
	clsCheckCfg.SetGameRunning
	funcScorebord.gameRunning = True
	File.Copy(File.DirAssets, "score.json", PartijFolder, "currscore.json")
	If mqttPubDataBord.connected Then
		mqttPubDataBord.SendMessage($"game-started|${func.getIpNumber}"$, "game-started")
	End If
	Sleep(200)
End Sub

Sub iv_img_sponsore_MouseMoved (EventData As MouseEvent)
	If newGame Then
		iv_img_sponsore.SetImage(imgBeginPartij)
	End If
End Sub

Sub iv_img_sponsore_MouseExited (EventData As MouseEvent)
	If newGame Then
		iv_img_sponsore.SetImage(imgStartPartij)
	End If
End Sub

Sub showHideGameTime(enable As Boolean)
	Dim op As Double
	frm.RootPane.MouseCursor = fx.Cursors.NONE
	If enable = True Then
		op = 1.0
	Else
		op = 0.0
	End If
	
	lbl_partij_duur_header.SetAlphaAnimated(2500, op)
	lbl_partij_duur.SetAlphaAnimated(2500, op)
	Sleep(2500)
	func.SetCustomCursor1(File.DirAssets, "mouse.png", 370, 370, frm.RootPane)
	
End Sub

Sub lbl_player_one_name_MouseEntered (EventData As MouseEvent)
	Dim lbl As B4XView = Sender
	lbl.SetColorAndBorder(lbl.Color, 10dip, 0xFFff0000, 0dip)
End Sub

Sub lbl_player_one_name_MouseExited (EventData As MouseEvent)
	Dim lbl As B4XView = Sender
	lbl.SetColorAndBorder(lbl.Color, 0dip, 0xFFFF0000, 0dip)
End Sub

Sub lbl_player_two_name_MouseEntered (EventData As MouseEvent)
	lbl_player_two_name.SetColorAndBorder(lbl_player_two_name.Color, 10dip, 0xFFff0000, 0dip)
End Sub

Sub lbl_player_two_name_MouseExited (EventData As MouseEvent)
	lbl_player_two_name.SetColorAndBorder(lbl_player_two_name.Color, 0dip, 0xFFFF0000, 0dip)
End Sub

Sub EnableClockFunction(enable As Boolean)
	lbl_clock.Visible = enable
	lbl_date_time_dag.Visible = enable
	lbl_date_time_date.Visible = enable
	clsTmr.enableClock(enable)
End Sub

Sub lbl_player_two_moyenne_MouseReleased (EventData As MouseEvent)
	If funcScorebord.kraai = 1 Then
		funcScorebord.kraai = 0
		Else
		funcScorebord.kraai = 1
			
	End If
End Sub

Sub WriteScoreJson
	If PartijFolder.Length < 5 Then
		Return
	End If
	
	If promoteRunning Then 
		CreateJsonFormMqttClient
		Return
	End If
	
	Dim strAanStoot As String
	Try
'		lblWriteJson.Visible = True
		
		strAanStoot = aanStoot
		parser.Initialize(strBackup)

		Dim root As Map = parser.NextObject
		Dim score As Map = root.Get("score")
		Dim p1 As Map = score.Get("p1")
		Dim p2 As Map = score.Get("p2")
		Dim aan_stoot As Map = score.Get("aan_stoot")
		Dim beurten As Map = score.Get("beurten")
		Dim spelduur As Map = score.Get("spelduur")
		Dim autoInnings As Map = score.Get("autoinnings")
		Dim hsP1 As Map = score.Get("hsP1")
		Dim hsP2 As Map = score.Get("hsP2")
		Dim currHS As Map = score.Get("currhoogsteserie")
	
	
		p1.Put("caram", $"${lbl_player_one_100.Text}${lbl_player_one_10.Text}${lbl_player_one_1.Text}"$)
		p1.Put("naam", lbl_player_one_name.Text)
		p1.Put("maken", $"${lbl_player_one_make_100.Text}${lbl_player_one_make_10.Text}${lbl_player_one_make_1.Text}"$)
		hsP1.Put("aantal",lbl_p1_hs.Text)
		
		p2.Put("caram", $"${lbl_player_two_100.Text}${lbl_player_two_10.Text}${lbl_player_two_1.Text}"$)
		p2.Put("naam", lbl_player_two_name.Text)
		p2.Put("maken", $"${lbl_player_two_make_100.Text}${lbl_player_two_make_10.Text}${lbl_player_two_make_1.Text}"$)
		hsP2.Put("aantal",lbl_p2_hs.Text)
	
		currHS.Put("aantal", clsHSerie.GetCurrHs)
		beurten.Put("aantal", lbl_innings.Text)
		aan_stoot.Put("speler", strAanStoot)
		spelduur.Put("tijd", lbl_partij_duur.Text)
		If funcScorebord.autoInnings = True Then
			autoInnings.Put("value", "1")
		Else
			autoInnings.Put("value", "0")
		End If
	
		Dim JSONGenerator As JSONGenerator
		JSONGenerator.Initialize(root)
	
		File.WriteString(PartijFolder, "currscore.json", JSONGenerator.ToPrettyString(2))
		
		Sleep(100)

		If mqttPubDataBord.connected Then
			CreateJsonFormMqttClient
		End If
	Catch
		func.WriteErrorToFile("errLastException.txt", LastException)
	End Try
'		lblWriteJson.Visible = False
End Sub

Sub CreateJsonFormMqttClient
	Dim template, strAanStoot As String
	Try
		strAanStoot = aanStoot
	
		template = File.ReadString(File.DirAssets, "share_score.json")
		parser.Initialize(template)
	
		Dim root As Map = parser.NextObject
		Dim score As Map = root.Get("score")
		Dim p1 As Map = score.Get("p1")
		Dim p2 As Map = score.Get("p2")
		Dim aan_stoot As Map = score.Get("aan_stoot")
		Dim beurten As Map = score.Get("beurten")
		Dim spelduur As Map = score.Get("spelduur")
		Dim autoInnings As Map = score.Get("autoinnings")
	
		p1.Put("caram", $"${lbl_player_one_100.Text}${lbl_player_one_10.Text}${lbl_player_one_1.Text}"$)
		p1.Put("naam", lbl_player_one_name.Text)
		p1.Put("maken", $"${lbl_player_one_make_100.Text}${lbl_player_one_make_10.Text}${lbl_player_one_make_1.Text}"$)
		p1.Put("moyenne", lbl_player_one_moyenne.Text)
		p1.Put("percentage", lbl_player_one_perc.Text)
	
		p2.Put("caram", $"${lbl_player_two_100.Text}${lbl_player_two_10.Text}${lbl_player_two_1.Text}"$)
		p2.Put("naam", lbl_player_two_name.Text)
		p2.Put("maken", $"${lbl_player_two_make_100.Text}${lbl_player_two_make_10.Text}${lbl_player_two_make_1.Text}"$)
		p2.Put("moyenne", lbl_player_two_moyenne.Text)
		p2.Put("percentage", lbl_player_two_perc.Text)
	
		beurten.Put("aantal", lbl_innings.Text)
		aan_stoot.Put("speler", strAanStoot)
		spelduur.Put("tijd", lbl_partij_duur.Text)
		autoInnings.Put("value", $"${funcScorebord.bordDisplayName}|${func.getIpNumber}"$)
		
		Dim JSONGenerator As JSONGenerator
		JSONGenerator.Initialize(root)
		If mqttPubDataBord.connected Then
			mqttPubDataBord.SendMessage(JSONGenerator.ToPrettyString(2), mqttPubDataBord.pubName)
			Sleep(200)
		End If
	Catch
		func.WriteErrorToFile("errLastExceptionJSON.txt", LastException)
	End Try
End Sub

'WHEN THE APPLICATION STARTS CHECK IF THERE IS A PREVIOUS GAME FILE PRESENT (IN CASE OF CRASH)
Sub CheckGameStop
	Dim CsJValid As Boolean = func.TestCurrScoreJsonExists
	If File.Exists(PartijFolder, "currscore.json") And CsJValid Then
		Try
			Dim Scr, maken, caram="" As String
			Scr = File.ReadString(PartijFolder, "currscore.json")
		
			parser.Initialize(Scr)

			Dim root As Map = parser.NextObject
			Dim score As Map = root.Get("score")
			Dim p1 As Map = score.Get("p1")
			Dim p2 As Map = score.Get("p2")
			Dim aan_stoot As Map = score.Get("aan_stoot")
			Dim beurten As Map = score.Get("beurten")
			Dim spelduur As Map = score.Get("spelduur")
			Dim autoInnings As Map = score.Get("autoinnings")
			Dim hsP1 As Map = score.Get("hsP1")
			Dim hsP2 As Map = score.Get("hsP2")
			Dim currHS As Map = score.Get("currhoogsteserie")
			If p1.Get("naam") = Null Then
				Return
			End If
			
			clsHSerie.SetCurrHs(currHS.Get("aantal"))
			
			funcScorebord.innings = beurten.Get("aantal")
		
			maken = p1.Get("maken")
			caram = p1.Get("caram")
			funcScorebord.scorePlayerOne = caram
			funcScorebord.p1ToMake = maken
			lbl_player_one_name.Text = p1.Get("naam")
			lbl_player_one_make_100.Text = maken.SubString2(0,1)
			lbl_player_one_make_10.Text = maken.SubString2(1,2)
			lbl_player_one_make_1.Text = maken.SubString2(2,3)
			lbl_player_one_100.Text = caram.SubString2(0,1)
			lbl_player_one_10.Text = caram.SubString2(1,2)
			lbl_player_one_1.Text = caram.SubString2(2,3)
		
			maken = p2.Get("maken")
			caram = p2.Get("caram")
			funcScorebord.scorePlayerTwo = caram
			funcScorebord.p2ToMake = maken
			lbl_player_two_name.Text = p2.Get("naam")
			lbl_player_two_make_100.Text = maken.SubString2(0,1)
			lbl_player_two_make_10.Text = maken.SubString2(1,2)
			lbl_player_two_make_1.Text = maken.SubString2(2,3)
			lbl_player_two_100.Text = caram.SubString2(0,1)
			lbl_player_two_10.Text = caram.SubString2(1,2)
			lbl_player_two_1.Text = caram.SubString2(2,3)
		
			lbl_innings.Text = beurten.Get("aantal")
			lbl_partij_duur.Text = spelduur.Get("tijd")
			lbl_p1_hs.Text = hsP1.Get("aantal")
			lbl_p2_hs.Text = hsP2.Get("aantal")
			Log(hsP2.Get("aantal"))
		
			'SPLIT DUUR AT : !!!!
			Dim splitDuur() As String = Regex.Split(":", lbl_partij_duur.Text)
			Dim duurHrs As String = splitDuur(0)
			Dim duurMin As String = splitDuur(1)
		
			clsGameTime.hours = duurHrs 'lbl_partij_duur.Text.SubString2(0,2)
			clsGameTime.minutes = duurMin 'lbl_partij_duur.Text.SubString2(3,5)
			Log(lbl_p2_hs.Text)
			If aan_stoot.Get("speler") = "1" Then
'				setP1Name
				funcScorebord.setP1Name
				clsHSerie.SetPlayerAtTable(1)
			Else
'				setP2Name
				funcScorebord.setP2Name
				clsHSerie.SetPlayerAtTable(2)
			End If
			Log(lbl_p2_hs.Text)
			funcScorebord.inningSet = 0
			lbl_player_one_name.Enabled = True
			lbl_player_two_name.Enabled = True
			lbl_innings.Enabled = True
		
			If autoInnings.Get("value") = "1" Then
				funcScorebord.autoInnings = True
			Else
				funcScorebord.autoInnings = False
			End If
		
			funcScorebord.calcScorePlayerOne(0, True)
			funcScorebord.calcScorePlayerTwo(0, True)
			Log(lbl_p2_hs.Text)
			lbl_reset.Text = "Partij Beëindigen"
			lbl_reset.Color = 0xFFFF0000
			lbl_reset.TextColor = 0xFFFFFFFF
			clsGameTime.tmrEnable(True)
			funcScorebord.gameRunning = True
			funcScorebord.checkGameFinish = True
			
		Catch
			Log(LastException)
'			resetBoard
			funcScorebord.resetBoard
		End Try
	Else
'		resetBoard
		funcScorebord.resetBoard
	End If
End Sub

Public Sub DisablePromoTimer(enable As Boolean)
	inactivecls.enablePromote(enable)
End Sub

Sub lbl_innings_MouseEntered (EventData As MouseEvent)
	lbl_innings.Style ="-fx-background-color: #FF00FF; -fx-text-fill: yellow;"
End Sub

Sub lbl_innings_MouseExited (EventData As MouseEvent)
	lbl_innings.Style ="-fx-background-color: #000053; -fx-text-fill: yellow;"
End Sub


Sub SetBrokerIcon(brokerAlive As Boolean)
	
	If brokerAlive Then
		lblBroker.Visible = True
		lblBrokerDead.Visible = False
	Else
		lblBrokerDead.Visible = True
		lblBroker.Visible = False	
	End If
End Sub

Sub StartStopClientServer
	Dim parser As JSONParser
	parser.Initialize(File.ReadString(func.appPath, "mqtt.conf"))
	
	Dim root As Map = parser.NextObject
	Dim mqttClients As List = root.Get("mqttClients")
	For Each colmqttClients As Map In mqttClients
		Dim name As String = colmqttClients.Get("name")
		Dim enabled As String = colmqttClients.Get("enabled")
		Dim base As String = colmqttClients.Get("base")
	Next
	
	mqttEnabled = enabled = "1"
	func.bordName = name.ToLowerCase
	func.mqttbase = $"${base}/"$
	funcScorebord.bordName = name.ToLowerCase
	funcScorebord.bordDisplayName = name
	mqttPubDataBord.PrepPubName
	mqttBordPub.SetPub
	mqttBordPub.PrepTopicName(name.ToLowerCase)
	
	MqttConnected
End Sub

Sub enableScreenSaver(enable As Boolean)
	inactivecls.enableTime(enable)
End Sub

Sub StartedFromCheckConfig
'	inactivecls.lastClick = DateTime.Now
	lastClick
	inactivecls.enableTime(True)
	inactivecls.enablePromote(False)
End Sub

Sub pn_promote_MouseClicked (EventData As MouseEvent)
	Try
		If promoteRunning = True Then
			pn_promote.Top = pn_promote_top
			pn_promote.left = pn_promote_left
			Sleep(0)
			
'			inactivecls.lastClick = DateTime.Now
			lastClick
			inactivecls.enableTime(True)
			inactivecls.enablePromote(False)
			promoteRunning = False
			Sleep(300)
		End If
	Catch
		File.WriteString(File.DirApp,"lastErr.txt", LastException.Message)
	End Try
End Sub

Sub mqttGetPlayers As List
	Dim lstPlayer As List
	Dim p1Carom As String = $"${lbl_player_one_100.Text}${lbl_player_one_10.Text}${lbl_player_one_1.Text}"$
	Dim p2Carom As String = $"${lbl_player_two_100.Text}${lbl_player_two_10.Text}${lbl_player_two_1.Text}"$
	
	lstPlayer.Initialize
	
	lstPlayer.AddAll(Array As String(lbl_player_one_name.Text, lbl_player_two_name.Text, p1Carom, p2Carom, aanStoot))
	Return lstPlayer
End Sub

Sub SetPlayerNames
	Dim ser As B4XSerializator
	Dim playerData As String =ser.ConvertBytesToObject(File.ReadBytes(func.appPath, "player-config"))
'	Log(playerData)
	'return
	Dim parser As JSONParser
	parser.Initialize(playerData)
	Dim root As Map = parser.NextObject
	Dim player As Map = root.Get("player")
	Dim p2Make As String = player.Get("p2Make")
	Dim p2Name As String = player.Get("p2Name")
	Dim p1Name As String = player.Get("p1Name")
	Dim p1Make As String = player.Get("p1Make")
	
	lbl_player_one_name.Text = func.splitNaam(p1Name)
	lbl_player_two_name.Text = func.splitNaam(p2Name)
	
	lbl_player_one_make_100.Text = p1Make.SubString2(0,1)
	lbl_player_one_make_10.Text = p1Make.SubString2(1,2)
	lbl_player_one_make_1.Text = p1Make.SubString2(2,3)
	
	lbl_player_two_make_100.Text = p2Make.SubString2(0,1)
	lbl_player_two_make_10.Text = p2Make.SubString2(1,2)
	lbl_player_two_make_1.Text = p2Make.SubString2(2,3)
	
'----
	funcScorebord.p2ToMake = p2Make
	funcScorebord.p1ToMake = p1Make
'----	
	If File.Exists(func.appPath, "player-config") Then
		File.Delete(func.appPath, "player-config")
	End If
'	WriteScoreJson
	Sleep(100)
End Sub

Sub lbl_clearBord_MouseReleased (EventData As MouseEvent)
	If resetBordVisible Then 
		Sleep(500)
		Return
	End If
	resetBordVisible = True
	'pn_a.SetLayoutAnimated(0, 343, 200, pn_a.Width, pn_a.Height)
	pnBlockReset.SetLayoutAnimated(0, 0, 0, pnBlockReset.Width, pnBlockReset.Height)
	endGameTimer.Enabled = True
End Sub

Sub btnResetGameCancel_MouseReleased (EventData As MouseEvent)
	resetBordVisible = False
	HideResetPanel
End Sub

public Sub btnResetGameReset_MouseReleased (EventData As MouseEvent)
	EndCommercialRotate
	resetBordVisible = False
	HideResetPanel
	clsGameTime.tmrEnable(False)
	clsGameTime.hours = 0
	clsGameTime.minutes = 0
'	resetBoard
	funcScorebord.resetBoard
	clsCheckCfg.SetEndedGame
	setNewGame(True)
'	WriteScoreJson
	pnPlayerStart.SetLayoutAnimated(0, 0, 1200, pnPlayerStart.Width, pnPlayerStart.Height)
	pnBlockReset.SetLayoutAnimated(0, 0, 1200, pnBlockReset.Width, pnBlockReset.Height)
End Sub

Sub DisableTimerIfRetro(enable As Boolean)
	clsGameTime.tmrEnable(enable)
'	inactivecls.enableTime(enable)
End Sub

Sub HideResetPanel
	pnBlockReset.SetLayoutAnimated(0, 0, 1200, pnBlockReset.Width, pnBlockReset.Height)
End Sub

Sub SetSponsorImg
	If reclameFound Then
		iv_img_sponsore.SetImage(imgSponsor)
	Else
		iv_img_sponsore.SetImage(imgLogo)	
	End If
End Sub

'TEST IF THE RESET BUTTON TEXT IS Nieuwe Partij
Sub TestResetButton As Boolean
	If lbl_reset.Text = "Nieuwe Partij" Then
		Return True
	Else 
		Return False	
	End If
	
End Sub

Private Sub hideEndGameDialog_Tick
	pnEndGame.SetLayoutAnimated(0, 0, 1200, pnPlayerStart.Width, pnPlayerStart.Height)
	pnBlockReset.SetLayoutAnimated(0, 0, 1200, pnPlayerStart.Width, pnPlayerStart.Height)
	resetBordVisible = False
	endGameTimer.Enabled = False
End Sub

Private Sub btnCancelEndGame_MouseReleased (EventData As MouseEvent)
	pnEndGame.SetLayoutAnimated(0, 0, 1200, pnPlayerStart.Width, pnPlayerStart.Height)
End Sub

Private Sub btnConfirmEndGame_MouseReleased (EventData As MouseEvent)
	eindePartij
	pnEndGame.SetLayoutAnimated(0, 0, 1200, pnPlayerStart.Width, pnPlayerStart.Height)
End Sub

Private Sub lblCloseApp_MouseReleased (EventData As MouseEvent)
	If EventData.SecondaryButtonPressed Then
		ExitApplication
	End If
End Sub

Private Sub btnStartP1_Click
	Dim p1Name, p1Make, p2Name, p2Make As String
	Dim splitStr() As String
	p1Name = lbl_player_one_name.Text
	p1Make = $"${lbl_player_one_make_100}-${lbl_player_one_make_10}-${lbl_player_one_make_1}"$
	p2Name = lbl_player_two_name.Text
	p2Make = $"${lbl_player_two_make_100}-${lbl_player_two_make_10}-${lbl_player_two_make_1}"$
	
	lbl_player_one_name.Text = p2Name
	splitStr = Regex.Split("-", p2Make)
	lbl_player_one_make_100.Text = splitStr(0)
	lbl_player_one_make_10.Text = splitStr(1)
	lbl_player_one_make_1.Text = splitStr(2)
	
	
	lbl_player_two_name.Text = p1Name
	splitStr = Regex.Split("-", p1Make)
	lbl_player_two_make_100.Text = splitStr(0)
	lbl_player_two_make_10.Text = splitStr(1)
	lbl_player_two_make_1.Text = splitStr(2)
	
	btnStartP1.Text = p2Name.Replace(CRLF, " ")
	btnStartP2.Text = p1Name.Replace(CRLF, " ")
	
End Sub

Private Sub btnStartP2_Click
	Dim p1Name, p1Make, p2Name, p2Make As String
	Dim splitStr() As String
	
	p1Name = lbl_player_one_name.Text
	p1Make = $"${lbl_player_one_make_100.Text}-${lbl_player_one_make_10.text}-${lbl_player_one_make_1.text}"$
	p2Name = lbl_player_two_name.Text
	p2Make = $"${lbl_player_two_make_100.Text}-${lbl_player_two_make_10.Text}-${lbl_player_two_make_1.Text}"$
	
	lbl_player_one_name.Text = p2Name
	splitStr = Regex.Split("-", p2Make)
	
	lbl_player_one_make_100.Text = splitStr(0)
	lbl_player_one_make_10.Text = splitStr(1)
	lbl_player_one_make_1.Text = splitStr(2)
	funcScorebord.p1ToMake = $"${splitStr(0)}${splitStr(1)}${splitStr(2)}"$
	
	
	lbl_player_two_name.Text = p1Name
	splitStr = Regex.Split("-", p1Make)
	lbl_player_two_make_100.Text = splitStr(0)
	lbl_player_two_make_10.Text = splitStr(1)
	lbl_player_two_make_1.Text = splitStr(2)
	funcScorebord.p2ToMake = $"${splitStr(0)}${splitStr(1)}${splitStr(2)}"$
	
	btnStartP1.Text = p2Name.Replace(CRLF, " ")
	btnStartP2.Text = p1Name.Replace(CRLF, " ")
	
End Sub

Private Sub btnStartPartij_Click
	Dim pName As String = lbl_player_one_name.Text.Replace(CRLF, " ")
	lblConfirmPlayerNameStarts.Text = pName
	pnConfirmPlayerStarts.Visible = True
'	btnCancelStartPartij_Click
End Sub

Private Sub btnCancelStartPartij_Click
	allowPlayerSwap = True
	lbl_spel_soort.Text = "Wissel spelers"
	CSSUtils.SetBackgroundColor(lbl_spel_soort, fx.Colors.Red)
	lbl_spel_soort.Visible = True
	pnPlayerStart.SetLayoutAnimated(0, 0, 2200, pnPlayerStart.Width, pnPlayerStart.Height)
	iv_img_sponsore_MouseReleased (Null)
End Sub

Private Sub pnForPromote_MouseMoved (EventData As MouseEvent)
	pnForPromote.Top = 1200
	pnForPromote.Left = 0
	Sleep(0)
'	inactivecls.lastClick = DateTime.Now
	lastClick
	inactivecls.enableTime(True)
	inactivecls.enablePromote(False)
	promoteRunning = False
	Sleep(300)
End Sub

Private Sub chk_autoInning_CheckedChange(Checked As Boolean)
	
End Sub

Private Sub btnAnnuleerNieuwePartij_MouseReleased (EventData As MouseEvent)
	pn_nieuwe_partij.SetLayoutAnimated(0, 0, 1200, pnPlayerStart.Width, pnPlayerStart.Height)
End Sub

Private Sub btnStartNieuwePartij_MouseReleased (EventData As MouseEvent)
	funcScorebord.autoInnings = chk_autoInning.Checked
'	resetBoard
	funcScorebord.resetBoard
	setNewGame(True)
	pn_nieuwe_partij.SetLayoutAnimated(0, 0, 1200, pnPlayerStart.Width, pnPlayerStart.Height)
	InitHs
	clsHSerie.SetPlayerAtTable(1)
End Sub

Private Sub lbl_beurten_automatisch_MouseReleased (EventData As MouseEvent)
	chk_autoInning.Checked = chk_autoInning.Checked <> True
End Sub

Public Sub ProcessGameType
	Dim gameType As String = File.ReadString(func.appPath, "gametype.cnf")
	Dim parser As JSONParser
	parser.Initialize(gameType)
	
	Dim jroot As Map = parser.NextObject
	Dim gameTypeStr As Map = jroot.Get("gametype")
	Dim TypeStr As String = gameTypeStr.Get("type")
	lbl_spel_soort.Text = TypeStr
End Sub

Private Sub lblSwitchBord_MouseClicked (EventData As MouseEvent)
	clsListBord.ShowBordList
End Sub

Private Sub lblCloseApp_MouseEntered (EventData As MouseEvent)
	CSSUtils.SetBorder(lblCloseApp, 1, fx.Colors.Red, 0)
End Sub

Private Sub lblCloseApp_MouseExited (EventData As MouseEvent)
	CSSUtils.SetBorder(lblCloseApp, 0, fx.Colors.red, 0)
End Sub

Private Sub lblOrderDrink_MouseClicked (EventData As MouseEvent)
	clsOrderDrink.ShowPane
End Sub

Public Sub OrderDrinkConfirm(msg As String)
	Log($"ORDERDRINK: ${msg}"$)
End Sub

Private Sub lblOrderDrink_MouseEntered (EventData As MouseEvent)
	CSSUtils.SetBorder(Sender, 10, fx.Colors.Red, 4)
End Sub

Private Sub lblOrderDrink_MouseExited (EventData As MouseEvent)
	CSSUtils.SetBorder(Sender, 0, fx.Colors.Red, 4)
End Sub

Public Sub ShowRotateMedia
	'ROTATE RUNNING NO NEED FOR TIMER
	clsRotateMedia.rtMediaRunning = True
	clsRotateMedia.EnableRtTimer(False)
	pnlCommercialLarge.SetLayoutAnimated(0, 0, 0, 1920, 1060)
End Sub

Public Sub SetRotateMediaProgress(value As Float)
	pgBarRotateProgress.Progress = value
End Sub

Private Sub pnlCommercialLarge_MouseMoved (EventData As MouseEvent)
	EndCommercialRotate

End Sub

Public Sub EndCommercialRotate
	If pnlCommercialLarge.Top > 0 Then Return
	
	pnlCommercialLarge.Left = 0
	pnlCommercialLarge.Top = 1200
	clsRotateMedia.EnableRtTimer(True)
	clsRotateMedia.enablertMediaTimer(False)
	clsRotateMedia.rtMediaRunning = False
	clsRotateMedia.RtProgressTimer.Enabled = False
	clsRotateMedia.mediaShowTickCount = 0
	pgBarRotateProgress.Progress = 0
	b4xIvComm.Clear
	lastClick
End Sub




Public Sub ShowHideCommercialRunning(visible As Boolean)
	lastClick
'	lblImgCommercial.Visible = visible
End Sub

Private Sub btnConfirmPlayerStarts_MouseReleased (EventData As MouseEvent)
	pnConfirmPlayerStarts.Visible = False
	btnCancelStartPartij_Click
End Sub

Private Sub btnConfirmPlayerCancel_MouseReleased (EventData As MouseEvent)
	pnConfirmPlayerStarts.Visible = False
End Sub

Private Sub lbl_spel_soort_MouseReleased (EventData As MouseEvent)
	btnStartP2_Click
End Sub