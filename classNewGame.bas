B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8
@EndOfDesignText@
#IgnoreWarnings: 16, 9, 1, 12
Sub Class_Globals
	Private tmr As Timer
	Private lblReset As Label
	Private value As Double = 1.0
	Public gameStarted As Boolean = False
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(lbl As Label)
	tmr.Initialize("tmr", 1000)
	lblReset = lbl
End Sub

Sub tmrEnable(enabled As Boolean)
	tmr.Enabled = enabled
	If enabled = False Then
		lblReset.SetAlphaAnimated(0, 1)
	End If
End Sub

Sub tmr_Tick
	Return
	If value = 1.0 Then
		value = 0.3
		lblReset.SetAlphaAnimated(200, value)
		
	Else
		value = 1.0	
		lblReset.SetAlphaAnimated(0, value)
	End If
	
End Sub

Sub getTmrEnabled As Boolean
	Return tmr.Enabled
End Sub

Sub getGameStarted As Boolean
	Return gameStarted
End Sub