B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private resetLabel As Label
	Private flashCount As Int = 0
	Dim tmr As Timer
	Dim tmrFlashButton As Timer
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(lblReset As Label)
	resetLabel = lblReset
	tmr.Initialize("tmr", 5000)
	tmrFlashButton.Initialize("tmrFlashButton", 500)
	EnableTimer(True)
End Sub

Public Sub EnableTimer(Enable As Boolean)
	tmr.Enabled = Enable
End Sub

Public Sub tmr_Tick
	Dim chkText As Boolean = CallSub(scorebord, "TestResetButton")
	
	If chkText Then
		tmrFlashButton.Enabled = True
	Else
		tmrFlashButton.Enabled = False
	End If
			
End Sub

Private Sub tmrFlashButton_Tick
	If flashCount = 0 Then
		resetLabel.TextColor = fx.Colors.Red
		flashCount = flashCount + 1
	Else
		resetLabel.TextColor = fx.Colors.White
		flashCount = 0	
	End If
	
End Sub