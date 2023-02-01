B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private tmr As Timer
	Private tmrPcBord As Timer
	
	Private ms As Int = DateTime.TicksPerMinute  '60*1000
	Private lblTimer As Label
	Dim hours, minutes As Int
End Sub

Public Sub Initialize(lbl As Label)
	lblTimer = lbl
	tmr.Initialize("tmr", ms)
	tmrPcBord.Initialize("tmrPcBord", 10*1000)
End Sub


Sub setGameStart
	hours = 0
	minutes = 0	
End Sub

Sub tmrEnable(enabled As Boolean)
	tmr.Enabled = enabled
	tmrPcBord.Enabled = enabled
End Sub


Sub tmrPcBord_Tick
	If funcScorebord.checkGameFinish Then
	CallSub(scorebord, "WriteScoreJson")
	End If
'	CallSub(scorebord, "CreateJsonFormMqttClient")
End Sub

Sub tmr_Tick
	'SET GAME TIME
	minutes = minutes + 1
	If minutes > 59 Then
		minutes = 0
		hours = hours + 1
	End If
	lblTimer.Text = func.padString(hours, "0", 0 ,2)&":"&func.padString(minutes, "0", 0 ,2)	
	
'	CallSub(scorebord, "WriteScoreJson")
End Sub