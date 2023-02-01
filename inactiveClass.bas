B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Public tmr, tmr_draw_promote As Timer
	Public timeOutPeriode As Int' = 5000 ' 10*minute
	Public lastClick As Long
	Private timeDiff As Long
	Public frm As Form
	Public pn_promote As Pane
	Private currentX = 10, currentY = 10 As Double
	Public vx = 200, vy = 100 As Double
	Public pnlWidth, pnlHeight As Double
	Private activityName As Object
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(passedForm As Object, promoteWidth As Double, promoteHeight As Double)
	activityName = passedForm
	pnlWidth = promoteWidth
	pnlHeight = promoteHeight
	
	timeOutPeriode = (parseConfig.timeOut*(60*1000))
'	Log($"TIMEOUTE PERIOD: ${timeOutPeriode}"$)
	
	tmr.Initialize("timeOut", timeOutPeriode)
	tmr.Enabled = parseConfig.timeOutActive
	tmr_draw_promote.Initialize("drawPromote", 5000)
End Sub

Sub timeOut_Tick()
	If parseConfig.timeOutActive = False Then
		tmr.Enabled = False
		Return
	End If
	timeDiff = DateTime.Now - lastClick
'	Log($"TIMEFIDD: ${timeDiff}"$)
	If timeDiff > timeOutPeriode Then
		enableTime(False)
		CallSubDelayed(activityName, "showPromote")
		vx = 50
		vy = 50
		enablePromote(True)
		CallSub2(activityName, "setPromoteRunning", True)
	End If
End Sub

Public Sub enableTime(enable As Boolean)
	tmr.Enabled = enable
End Sub

Sub enablePromote(enable As Boolean)
	tmr_draw_promote.Enabled = enable
	
End Sub


Sub drawPromote_Tick()
	getBounds
End Sub

Sub getBounds
	If (currentX+50) + pnlWidth+30 > frm.Width Then
		vx = -Abs(vx)
	Else If currentX < 0 Then
		vx = Abs(vx)
	End If
	
	If (currentY+70) + pnlHeight > frm.Height Then
		vy = -Abs(vy)
	Else If currentY < 0 Then
		vy = Abs(vy)
	End If
	
	currentX = currentX + vx
	currentY = currentY + vy
	
	CallSubDelayed3(activityName, "drawPromote", currentX, currentY)
End Sub


Sub updatePromote
	If parseConfig.timeOutActive = False Then
		tmr.Enabled = False
		Return
	End If
	
	timeOutPeriode = (parseConfig.timeOut*(60*1000))
	
	tmr.Enabled = False
	tmr.Interval = timeOutPeriode
	tmr.Enabled = True
	If parseConfig.useDigitalFont Then
		CallSub2(activityName, "useDigitalFont", parseConfig.useDigitalFont)
	End If
End Sub