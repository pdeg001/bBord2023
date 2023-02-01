B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private ptime, gtime As Timer
	Private ballTime, gameTime As Long
	Private playerPos As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(player As String)
	ptime.Initialize("ptime", DateTime.TicksPerSecond)
	gtime.Initialize("gtime", DateTime.TicksPerSecond)
	playerPos = player
	ResetTime
	GetGameTime
End Sub

Sub gtime_Tick
	gameTime = gameTime + 1
	funcScorebord.gameTimeSeconds = gameTime
End Sub

Sub ptime_Tick
	ballTime = ballTime+1
	If playerPos = "p1" Then
		ConvertTimeToSeconds(CallSub(scorebord, "GetPartijTimer"))
	End If
End Sub

Sub ResetTime
	ballTime = 0
	gameTime = 0
End Sub

Sub ConvertTimeToSeconds(strTime As String)
	Dim timeStr() As String
	Dim hour, minute As Int
	Dim timePerc As Float

	timeStr = Regex.Split(":", strTime)
	hour = timeStr(0)
	minute = timeStr(1)
	minute = minute*60
	hour = hour*60*60
	timePerc = (ballTime/funcScorebord.gameTimeSeconds)*100
	CallSub2(scorebord, "setp1Time", timePerc)
End Sub

Sub GetGameTime
	Dim timeStr() As String
	Dim hour, minute, totTime As Int
	Dim currGameTime As String = CallSub(scorebord, "GetPartijTimer")
	
	timeStr = Regex.Split(":", currGameTime)
	hour = timeStr(0)
	minute = timeStr(1)
	
	minute = minute*60
	hour = hour*60*60
	totTime = hour+minute
	
	If totTime > 0 Then
		funcScorebord.gameTimeSeconds = totTime
		gameTime = totTime
	End If
	
End Sub