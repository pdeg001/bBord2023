B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8
@EndOfDesignText@
#IgnoreWarnings: 16, 9, 12
Sub Class_Globals
	Private fx As JFX
	Dim tmr As Timer
	Dim appPath As String
	Dim cfgTimeStamp, cfgCurrTimeStamp, retroCurrTimeStamp, retroTimeStamp, mqttTimeStamp, mqttCurrTimeStamp As Long
	Dim retroLastRead As Long
	Dim playerconfig, currPlayerconfig As Long
	Dim sh As Shell
	Dim activeForm As String
	Dim retroVisible As Boolean = False
	Dim survivalActive As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
'	appPath = parseConfig.getAppPath
	cfgTimeStamp	= File.LastModified(func.appPath, "cnf.44")
	retroTimeStamp	= File.LastModified(func.appPath, "retro.cnf")
	mqttTimeStamp	= File.LastModified(func.appPath, "mqtt.conf")
	playerconfig	= File.LastModified(func.appPath, "player-config")
	tmr.Initialize("chkConfig", 5000)
	enabledTimer(True)
End Sub


Public Sub enabledTimer(enable As Boolean)
	tmr.Enabled = enable
End Sub

Sub chkConfig_Tick
	cfgCurrTimeStamp = File.LastModified(func.appPath, "cnf.44")
	
	If cfgCurrTimeStamp <> cfgTimeStamp Then
		parseConfig.pullConfig
		cfgTimeStamp = cfgCurrTimeStamp
		CallSub(scorebord, "updateCfg") 'THIS FUNC HANDLES THE SCREENSAVER/ROTATEMEDIA
		CallSub2(scorebord, "useDigitalFont", parseConfig.useDigitalFont)
		CallSub(retroBord, "UpdateCfg")
		CallSub(survivalbord, "UpdateCfg")
		
	End If

	retroCurrTimeStamp = File.LastModified(func.appPath, "retro.cnf")
	If retroCurrTimeStamp <> retroLastRead Then
		retroLastRead = File.LastModified(func.appPath, "retro.cnf")
		Dim strRetro As String = File.ReadString(func.appPath, "retro.cnf")
		ProcessRetro(strRetro)
	End If
	
	If File.Exists(func.appPath, "mqtt.conf") Then
		mqttCurrTimeStamp = File.LastModified(func.appPath, "mqtt.conf")
		If mqttTimeStamp <> mqttCurrTimeStamp Then
			mqttTimeStamp = mqttCurrTimeStamp
			CallSub(scorebord, "EnableMqtt")
		End If
	End If
	
	If File.Exists(func.appPath, "player-config") Then
		currPlayerconfig = File.LastModified(func.appPath, "player-config")
		CallSub2(scorebord, "btnResetGameReset_MouseReleased", Null)
		CallSub(scorebord, "SetPlayerNames")
	End If
	
	If File.Exists(func.appPath, "resetbord.brd") Then
		CallSub2(scorebord, "btnResetGameReset_MouseReleased", Null)
		File.Delete(func.appPath, "resetbord.brd")
	End If
	
	If File.Exists(func.appPath, "endgame.brd") Then
		CallSub(scorebord, "eindePartij")
		File.Delete(func.appPath, "endgame.brd")
	End If
	
	If File.Exists(func.appPath, "newgame.brd") Then
		CallSub2(scorebord, "SetNewGameFromPc", True)
		File.Delete(func.appPath, "newgame.brd")
	End If
	
	If File.Exists(func.appPath, "gametype.cnf") Then
		CallSub(scorebord, "ProcessGameType")
		File.Delete(func.appPath, "gametype.cnf")
	End If
	
End Sub


public Sub ProcessRetro(strRetro As String)
	
	Dim parser As JSONParser
	parser.Initialize(strRetro)
	Dim root As Map = parser.NextObject
	Dim retro As Map = root.Get("retroBord")
	Dim active As String = retro.Get("active")
	Dim survival As Map = root.Get("survival")
	Dim sactive As String = survival.Get("sactive")
	
	CloseActiveForm
	
	If active = "1" Then
		funcScorebord.bordIsMain = False
		funcScorebord.bordIsRetro = True
		funcScorebord.bordIsSurvival = False
		survivalbord.enableScreenSaver(False)
		survivalbord.frm.Close
		
		retroVisible = False
		scorebord.enableScreenSaver(False)
		scorebord.frm.Close

		scorebord.DisableTimerIfRetro(False)
		retroBord.enableScreenSaver(True)
		retroBord.showBord
	Else If sactive = "1" Then
		funcScorebord.bordIsMain = False
		funcScorebord.bordIsRetro = False
		retroBord.DisableTimers
		
		retroBord.frm.Close
		scorebord.DisableTimerIfRetro(False)
		funcScorebord.bordIsSurvival = True
		survivalbord.showBord
		survivalbord.enableScreenSaver(True)
		scorebord.enableScreenSaver(False)
		scorebord.frm.Close
	Else
		funcScorebord.bordIsRetro = False
		retroBord.enableScreenSaver(False)
		retroVisible = False
		retroBord.frm.Close
		funcScorebord.bordIsSurvival = False
		survivalbord.disableTimers
		survivalbord.frm.Close
		CallSub2(scorebord, "DisableTimerIfRetro", True)
		
		funcScorebord.bordIsMain = True
		scorebord.frm.Show
		scorebord.frm_Showing
	End If
End Sub

Private Sub CloseActiveForm
	If activeForm = "retro" Then
		
	Else If activeForm = "survival" Then
		
	Else If activeForm = "score" Then
		
	Else	
'		Log("Nothing to close")	
	End If
End Sub


Sub checkIfUpdated
'	Dim appPath As String = parseConfig.getAppPath
	Dim os As String = parseConfig.DetectOS
	Dim appFolder As String
	Select os
		Case "windows"
			appFolder = File.DirApp&"\44\"
		Case "linux"
			appFolder = File.DirApp&"/44/"
	End Select
	If File.Exists(appFolder, "upd.pdg") Then
	
		'Log("UPDATING")
		File.Delete(func.appPath, "upd.pdg")
		'sh.Initialize("sh /home/pi/44/restart_bord.sh", Null, Null)
		'sh.Initialize("sh", "sh", Array("/home/pi/44/restart_bord.sh"))
		sh.Initialize("sh", "sh", Array("restart_bord.sh"))
		sh.Run(5000)
		ExitApplication
	End If
End Sub

Sub SetGameRunning
	If File.Exists(func.appPath, "gamerunning.brd") Then
		File.Copy(File.DirAssets, "gamerunning.brd", func.appPath, "gamerunning.brd")
	Else
		File.WriteString(func.appPath, "gamerunning.brd", "")
	End If
End Sub

Sub SetEndedGame
	If File.Exists(func.appPath, "gamerunning.brd") Then
		File.Delete(func.appPath, "gamerunning.brd")
	End If
	File.WriteString(func.appPath, "endgame.brd", "")
End Sub