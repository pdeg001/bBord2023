B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private tmr_draw_promote As Timer
	Private tmr As Timer
	Private tmrInterval As Int = 5000
	Public timeOutPeriode As Int' = 5000 ' 10*minute
	Public timeOutActive As Boolean
	Public lastClick As Long
	Private timeDiff As Long
	Public frm As Form
	Public pn_promote As Pane
	Private currentX = 10, currentY = 10 As Double
	Public vx = 200, vy = 100 As Double
	Public pnlWidth, pnlHeight As Double
	Private activityName As Object
	Private bordName As String
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(passedForm As Object, promoteWidth As Double, promoteHeight As Double, frmName As String)
	bordName = frmName
	activityName = passedForm
	pnlWidth = promoteWidth
	pnlHeight = promoteHeight
	tmr.Initialize("timeOut", tmrInterval)
	tmr.Enabled = timeOutActive
	tmr_draw_promote.Initialize("drawPromote", 5000)
	lastClick = DateTime.Now
End Sub

Sub EnableTimers(enable As Boolean)
	tmr_draw_promote.Enabled = enable
	tmr.Enabled = enable
End Sub

Sub timeOut_Tick()
'	Log($"${bordName} @ $Time{DateTime.Now}"$)
	timeDiff = DateTime.Now - lastClick
	If timeDiff >= timeOutPeriode Then
		enableTime(False)
		CallSubDelayed(activityName, "showPromote")
		vx = 50
		vy = 50
		enablePromote(True)
		enableTime(False)
'		CallSub2(activityName, "setPromoteRunning", True)
	Else
		tmr_draw_promote.Enabled = False
	End If
End Sub

Public Sub enableTime(enable As Boolean)
	tmr.Enabled = enable
End Sub

Sub enablePromote(enable As Boolean)
	tmr_draw_promote.Enabled = enable
	CallSubDelayed(activityName, "showPromote")
End Sub


Sub drawPromote_Tick()
	getBounds
End Sub

Sub getBounds
	If (currentX+50) + pnlWidth+30 > 1920 Then
		vx = -Abs(vx)
	Else If currentX < 0 Then
		vx = Abs(vx)
	End If
	
	If (currentY+70) + pnlHeight > 1080 Then
		vy = -Abs(vy)
	Else If currentY < 0 Then
		vy = Abs(vy)
	End If
	
	currentX = currentX + vx
	currentY = currentY + vy
	
	CallSubDelayed3(activityName, "drawPromote", currentX, currentY)
End Sub

