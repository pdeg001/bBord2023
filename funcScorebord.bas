B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Public timeLastClick As Long = 0
	Public setNieuwePartij, checkGameFinish As Boolean = True
	Public autoInnings As Boolean = True
	Public beurtenPartij, gameStarted As Boolean = False
	Public beurtenPartijBeurten As Int
	Public kraai As Int = 0
	Public useDigitalFont, isBordClient, bordIsRetro, bordIsSurvival, bordIsMain As Boolean
	Public useYellowFont As Boolean
	Public error, bordName, bordDisplayName As String
	Public host As String
	Public BordVersion As String = "v1.9.9"
	Public gameRunning As Boolean
	
	Public newGameInitialized As Boolean = False
	Public scorePlayerOne, scorePlayerTwo As Int
	
	Public p1Innings, p2Innings As Int = 0
	
	Public innings, prevInnings = 1, inningSet, make, p1Hs = 0, p2Hs = 0, score As Int
	Public p1ToMake = 0, p2ToMake = 0, p1HsTemp = 0, p2HsTemp = 0, playerHoogsteSerie = 0 As Int
	Public lblInnings, lbl_player_one_hs, lbl_player_two_hs As Label
	Public p1_1, p1_10, p1_100,  p1_moyenne, p1_hs As Label
	Public p2_1, p2_10, p2_100, p2_moyenne, p2_hs As Label
	Public p1_progress, p2_progress As Float
	Public p1_progressBar, p2_progressBar As B4XProgressBar
	Public loc As String = "/home/pi/.config/"
	Public ext As String = ".conf"
	Public ixt As String = "pi"
	Dim txtScore As String
	Public gameTimeSeconds As Double
End Sub


'SET REFERENCE TO SCOREBORD VIEWS
Public Sub setP1CaromLables(lst As List)
	p1_100		= lst.Get(2)
	p1_10		= lst.Get(1)
	p1_1		= lst.Get(0)
	p1_moyenne	= lst.Get(3)
	p1_progressBar = lst.Get(4)
	p1_hs = lst.Get(5)
	
End Sub

Public Sub setP2CaromLables(lst As List)
	p2_100		= lst.Get(2)
	p2_10		= lst.Get(1)
	p2_1		= lst.Get(0)
	p2_moyenne	= lst.Get(3)
	p2_progressBar	= lst.Get(4)
	p1_hs = lst.Get(5)
End Sub
'SET REFERENCE TO SCOREBORD VIEWS

Private Sub CheckIsNum(num As String) As Boolean
	Return IsNumber(num)
End Sub

'HANDLE P1 SCORE
Sub calcScorePlayerOne(points As Int, leftMouse As Boolean)
	
	If CheckIsNum(p1_100.Text&p1_10.Text&p1_1.Text) = False Then Return
	If leftMouse = False Then
		points = -Abs(points)
	End If
	
	Dim P1Score As Int
	CallSubDelayed(scorebord, "lastClick")
	
	P1Score		= p1_100.Text&p1_10.Text&p1_1.Text
	P1Score		= P1Score+points
	CallSub2(scorebord, "SetHSerie", points)
	
	'NO SCORE BELOW 0
	If P1Score < 0 Then
		P1Score = p1_100.Text&p1_10.Text&p1_1.Text
	End If
	
	If P1Score > 9999 Then
		Return
	End If
	
	If P1Score < 0 Then
		p1Hs = 0
		p1HsTemp = 0
		Return
	End If
	
	p1HsTemp = p1HsTemp + points
	scorePlayerOne = P1Score
	txtScore = func.padString(P1Score, "0", 0, 4)

	p1_100.Text		= txtScore.SubString2(1,2)
	p1_10.Text		= txtScore.SubString2(2,3)
	p1_1.Text		= txtScore.SubString2(3,4)

	If innings >= 1 And innings = prevInnings And autoInnings = True Then
		p1_moyenne.Text = func.getUnroundedMoyenne(NumberFormat2((scorePlayerOne/innings),1,4,4,False))
		Else
		p1_moyenne.Text = func.getUnroundedMoyenne(NumberFormat2((scorePlayerOne/innings),1,4,4,False))
			
	End If
	
	If p1ToMake > 0 Then
		CallSub2(scorebord, "playerOnePerc", NumberFormat2((scorePlayerOne/p1ToMake)*100,1,2,2,False)&"%")
		p1_progress = (scorePlayerOne/p1ToMake)*100
	End If
	setProgress(p1_progressBar, p1_progress)
'	CallSub2(scorebord, "SetHSerie", points)
	
End Sub
'HANDLE P1 SCORE

'CALC MOYENNE P1
Sub calcMoyenneP1
	If innings < 1 Then
		p1_moyenne.Text = "0.000"
		Return
	End If

	p1_moyenne.Text = func.getUnroundedMoyenne(NumberFormat2((scorePlayerOne/innings),1,4,4,False))
	If p1ToMake > 0 Then
		CallSub2(scorebord, "playerOnePerc", NumberFormat2((scorePlayerOne/p1ToMake)*100,1,2,2,False)&"%")
		p1_progress = (scorePlayerOne/p1ToMake)*100
	End If

	setProgress(p1_progressBar, p1_progress)
End Sub

'P1 MAKE
Sub playerOneMake(lbl100 As Label, lbl10 As Label, lbl1 As Label, leftButton As Boolean, number As Int)
	Dim strMaker As String
	make = $"${lbl100.Text}${lbl10.Text}${lbl1.Text}"$
	
	If leftButton Then
		make = make+number
		If make > 999 Then
			Return
		End If
	Else
		make = make-number
		If make < 0 Then
			Return
		End If
	End If
	
	strMaker	= func.padString(make, "0", 0, 3)
	lbl100.Text = strMaker.SubString2(0,1)
	lbl10.Text	= strMaker.SubString2(1,2)
	lbl1.Text	= strMaker.SubString2(2,3)
	
	p1ToMake = make
	If p1ToMake > 0 Then
		p1_progress = (scorePlayerOne/p1ToMake)*100
		CallSub2(scorebord, "playerOnePerc", NumberFormat2((scorePlayerOne/p1ToMake)*100,1,2,2,False)&"%")
	Else
		p1_progress = 0
		CallSub2(scorebord, "playerOnePerc", "n.v.t.")
	End If
	setProgress(p1_progressBar, p1_progress)
End Sub
'P1 MAKE


'HANDLE SCORE P2
Sub calcScorePlayerTwo(points As Int, leftMouse As Boolean)
	
	If CheckIsNum(p2_100.Text&p2_10.Text&p2_1.Text) = False Then Return
	If leftMouse = False Then
		points = -Abs(points)
	End If
	
	Dim P2Score As Int
	CallSubDelayed(scorebord, "lastClick")
	
	P2Score		= p2_100.Text&p2_10.Text&p2_1.Text
	P2Score		= P2Score+points
	CallSub2(scorebord, "SetHSerie", points)
	playerHoogsteSerie = playerHoogsteSerie +points

	If P2Score < p2Hs And p2Hs > 0 Then
		p2Hs = p2Hs -1
'		lbl_player_two_hs.Text = func.padString(p2Hs, "0", 0, 3)
	End If
	'NO SCORE BELOW 0
	If P2Score < 0 Then
		P2Score = p2_100.Text&p2_10.Text&p2_1.Text
	End If
	
	If P2Score > 9999 Then
		Return
	End If
	
	If P2Score < 0 Then
		p2Hs = 0
		p2HsTemp = 0
		Return
	End If
	
	p2HsTemp	= p2HsTemp + points
'	CallSub2(scorebord, "SetHoogsteSerie", p2HsTemp)
	
	If lblInnings.Text = "000" And autoInnings = True Then
		lblInnings.Text	= "001"
		innings	= 1
		inningSet = 1
	End If
	
	scorePlayerTwo = P2Score
	txtScore = func.padString(P2Score, "0", 0, 4)

	p2_100.Text		= txtScore.SubString2(1,2)
	p2_10.Text		= txtScore.SubString2(2,3)
	p2_1.Text		= txtScore.SubString2(3,4)

	If innings >= 1 Then
		p2_moyenne.Text =  func.getUnroundedMoyenne(NumberFormat2((scorePlayerTwo/innings),1,4,4,False))
	End If

	If p2ToMake > 0 Then
		CallSub2(scorebord, "playerTwoPerc", NumberFormat2((scorePlayerTwo/p2ToMake)*100,1,2,2,False)&"%")
		p2_progress = (scorePlayerTwo/p2ToMake)*100
	End If
	setProgress(p2_progressBar, p2_progress)
'	CallSub2(scorebord, "SetHSerie", points)
'	checkMatchWon("p2")
	
End Sub
'HANDLE SCORE P2

'CALC MOYENNE P2
Sub calcMoyenneP2
	If innings > 0 Then
		
		p2_moyenne.Text = func.getUnroundedMoyenne(NumberFormat2((scorePlayerTwo/innings),1,4,4,False))
	End If
	If p2ToMake > 0 Then
		CallSub2(scorebord, "playertwoPerc", NumberFormat2((scorePlayerTwo/p2ToMake)*100,1,2,2,False)&"%")
		p2_progress = (scorePlayerTwo/p2ToMake)*100
	End If
	setProgress(p2_progressBar, p2_progress)
End Sub
'CALC MOYENNE P2

'P2 MAKE
Sub playerTwoMake(lbl100 As Label, lbl10 As Label, lbl1 As Label, leftButton As Boolean, number As Int)
	Dim strMaker As String
	make = $"${lbl100.Text}${lbl10.Text}${lbl1.Text}"$
	
	If leftButton Then
		make = make+number
		If make > 999 Then
			Return
		End If
	Else
		make = make-number
		If make < 0 Then
			Return
		End If
	End If
	
	
	strMaker	= func.padString(make, "0", 0, 3)
	lbl100.Text = strMaker.SubString2(0,1)
	lbl10.Text	= strMaker.SubString2(1,2)
	lbl1.Text	= strMaker.SubString2(2,3)
	
	p2ToMake = make
	If p2ToMake > 0 Then
		p2_progress = (scorePlayerTwo/p2ToMake)*100
		setProgress(p2_progressBar, p2_progress)
		CallSub2(scorebord, "playerTwoPerc", NumberFormat2((scorePlayerTwo/p2ToMake)*100,1,2,2,False)&"%")
	Else
		p2_progress = 0
		setProgress(p2_progressBar, p2_progress)
		CallSub2(scorebord, "playerTwoPerc", "n.v.t")
	End If
End Sub
'P2 MAKE

'SET PLAYER PROGRESSBAR
Sub setProgress(v As B4XProgressBar, progress As Float)
	v.Progress = progress
End Sub
'SET PLAYER PROGRESSBAR

'USED FROM LBL_INNIING MOUSE RELEASED FROM SCOREBORD
Sub calcMoyenne(mPlayerOne As Label, mPlayerTwo As Label)
	If innings < 1 Then
		mPlayerOne.Text = "0.000"	
		mPlayerTwo.Text = "0.000"	
		Return
	End If
	
	mPlayerOne.Text = NumberFormat2((scorePlayerOne/innings),1,3,3,False)
	mPlayerTwo.Text = NumberFormat2((scorePlayerTwo/innings),1,3,3,False)
End Sub

Public Sub SetProgressBarForMirror
	setProgress(p1_progressBar, p1_progress)
	setProgress(p2_progressBar, p2_progress)
End Sub

Public Sub PlayCrow(dir As String, fileName As String)
	Dim js As  Shell
	js.Initialize("", "omxplayer", Array As String(dir & fileName))
	js.Run(-1)
End Sub

Sub resetBoard
	scorebord.lbl_player_one_name.Text = "SPELER"&CRLF&"1"
	scorebord.lbl_player_two_name.Text = "SPELER"&CRLF&"2"
	scorebord.lbl_p1_hs.Text = "000"
	scorebord.lbl_p2_hs.Text = "000"
	scorebord.lbl_partij_duur.Text = "00:00"
	
	scorebord.lbl_player_one_1.Text = "0"
	scorebord.lbl_player_one_10.Text = "0"
	scorebord.lbl_player_one_100.Text = "0"
	scorebord.lbl_player_one_make_100.Text = "0"
	scorebord.lbl_player_one_make_10.Text = "0"
	scorebord.lbl_player_one_make_1.Text = "0"
	scorebord.lbl_player_one_moyenne.Text = "0.000"
	scorebord.lbl_player_one_perc.Text = "0.00%"
	
	scorebord.lbl_innings.Text = "000"
	
	scorebord.lbl_player_two_100.Text = "0"
	scorebord.lbl_player_two_10.Text = "0"
	scorebord.lbl_player_two_1.Text = "0"
	scorebord.lbl_player_two_make_100.Text = "0"
	scorebord.lbl_player_two_make_10.Text = "0"
	scorebord.lbl_player_two_make_1.Text = "0"
	scorebord.lbl_player_two_perc.Text = "0.00%"
	scorebord.lbl_player_two_moyenne.Text = "0.000"
	scorebord.lbl_player_one_hs.Text = "000"
	scorebord.lbl_player_two_hs.Text = "000"

	scorebord.hoogsteSeriePlayer = 0
	scorebord.hoogsteSerieP1 = 0
	scorebord.hoogsteSerieP2 = 0
	scorebord.lbl_p1_hs.Text = "000"
	scorebord.lbl_p2_hs.Text = "000"
	
	If autoInnings Then
		scorebord.lbl_innings.Text = "001"
		inningSet = 1
		innings = 1
	Else
		inningSet = 0
		innings = 0
		prevInnings = 1
	End If
	
	If autoInnings Then
		scorebord.lbl_beurten_header.Style ="-fx-background-color: transparent; -fx-text-fill: #dadada;"
	Else
		scorebord.lbl_beurten_header.Style ="-fx-background-color: White; -fx-text-fill: #000000;"
	End If
	
	scorePlayerOne = 0
	scorePlayerTwo = 0
	p1ToMake = 0
	p2ToMake = 0
	p1Hs = 0
	p2Hs = 0
	p1HsTemp = 0
	p2HsTemp = 0
	
	
	scorebord.B4XProgressBarP1.Progress = 0
	scorebord.B4XProgressBarP2.Progress = 0
	scorebord.clsCheckCfg.enabledTimer(True)
	gameRunning = False
End Sub
'aanstoot bekijken
Sub setP1Name
	scorebord.lbl_player_one_name.Color = 0xffFFFFFF'0xff3455db'0xFF69D79A
	
	scorebord.lbl_player_one_name.TextColor = 0xff000000
	scorebord.lbl_player_two_name.Color = 0xFF001A01'0xFF313030' 0xFF001A01
	scorebord.lbl_player_two_name.TextColor = 0xffffffff '0xFF81CFE0
	
	scorebord.p1Points1Disabled.Enabled = False
	scorebord.p1Points10Disabled.Enabled = False
	scorebord.p1Points100Disabled.Enabled = False
	
	scorebord.p2Points1Disabled.Enabled = False
	scorebord.p2Points10Disabled.Enabled = True
	scorebord.p2Points100Disabled.Enabled = True
	
	scorebord.lbl_player_one_100.Enabled = True
	scorebord.lbl_player_one_10.Enabled = True
	scorebord.lbl_player_one_1.Enabled = True
	scorebord.lbl_player_one_make_100.Enabled = True
	scorebord.lbl_player_one_make_10.Enabled = True
	scorebord.lbl_player_one_make_1.Enabled = True
	lbl_player_one_hs.Enabled = True
	
	
	scorebord.lbl_player_two_100.Enabled = True
	scorebord.lbl_player_two_10.Enabled = True
	scorebord.lbl_player_two_1.Enabled = True
	scorebord.lbl_player_two_make_100.Enabled = False
	scorebord.lbl_player_two_make_10.Enabled = False
	scorebord.lbl_player_two_make_1.Enabled = False
	scorebord.lbl_player_two_hs.Enabled = False
	
	scorebord.lbl_p1_inning.Visible = True
	scorebord.lbl_p2_inning.Visible = False
	scorebord.aanStoot = 1
	
End Sub

Sub setP2Name
	scorebord.lbl_player_two_name.Color = 0xffFFFFFF'0xff3455db'0xFF69D79A
	scorebord.lbl_player_two_name.TextColor = 0xff000000
	scorebord.lbl_player_one_name.Color = 0xFF001A01 '0xFF313030 '0xFF001A01
	scorebord.lbl_player_one_name.TextColor = 0xffffffff '0xFF81CFE0
	
	scorebord.p1Points1Disabled.Enabled = False
	scorebord.p1Points10Disabled.Enabled = True
	scorebord.p1Points100Disabled.Enabled = True
	
	scorebord.p2Points1Disabled.Enabled = False
	scorebord.p2Points10Disabled.Enabled = False
	scorebord.p2Points100Disabled.Enabled = False
	
	
	scorebord.lbl_player_one_100.Enabled = True
	scorebord.lbl_player_one_10.Enabled = True
	scorebord.lbl_player_one_1.Enabled = True
	scorebord.lbl_player_one_make_100.Enabled = False
	scorebord.lbl_player_one_make_10.Enabled = False
	scorebord.lbl_player_one_make_1.Enabled = False
	scorebord.lbl_player_one_hs.Enabled = False
	
	scorebord.lbl_player_two_100.Enabled = True
	scorebord.lbl_player_two_10.Enabled = True
	scorebord.lbl_player_two_1.Enabled = True
	scorebord.lbl_player_two_make_100.Enabled = True
	scorebord.lbl_player_two_make_10.Enabled = True
	scorebord.lbl_player_two_make_1.Enabled = True
	scorebord.lbl_player_two_hs.Enabled = True
	
	scorebord.lbl_p1_inning.Visible = False
	scorebord.lbl_p2_inning.Visible = True
	scorebord.aanStoot = 2
End Sub

Sub disableControls
	scorebord.lbl_player_one_name.Enabled = False
	scorebord.lbl_player_two_name.Enabled = False
	
	scorebord.lbl_innings.Enabled = False
	scorebord.lbl_player_one_100.Enabled = False
	scorebord.lbl_player_one_10.Enabled = False
	scorebord.lbl_player_one_1.Enabled = False
	scorebord.lbl_player_one_make_100.Enabled = False
	scorebord.lbl_player_one_make_10.Enabled = False
	scorebord.lbl_player_one_make_1.Enabled = False
	scorebord.lbl_player_one_hs.Enabled = False
	
	
	scorebord.lbl_player_two_100.Enabled = False
	scorebord.lbl_player_two_10.Enabled = False
	scorebord.lbl_player_two_1.Enabled = False
	scorebord.lbl_player_two_make_100.Enabled = False
	scorebord.lbl_player_two_make_10.Enabled = False
	scorebord.lbl_player_two_make_1.Enabled = False
	scorebord.lbl_player_two_hs.Enabled = False
	
	scorebord.lbl_p1_inning.Visible = True
	scorebord.lbl_p2_inning.Visible = False
	
End Sub