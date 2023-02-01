B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8.5
@EndOfDesignText@
'--------------------------
'KEEPS TRACK OF POINTS MADE DURING INNING
'--------------------------

Sub Class_Globals
	Private xui As XUI
	Private actualHS, playerAtTable As Int
	Public lblP1Hs, lblP2Hs, lbl_p1hs_header, lbl_p2hs_header As B4XView
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize (lblHsP1 As B4XView, lblHsP2 As Label, lbl_p1_hs_header As Label, lbl_p2_hs_header As Label)
	lblP1Hs = lblHsP1
	lblP2Hs = lblHsP2
	lbl_p1hs_header = lbl_p1_hs_header
	lbl_p2hs_header = lbl_p2_hs_header
	
	ResetPoints
End Sub

Public Sub SetPlayerAtTable(player As Int)
	playerAtTable = player
'	Log($"PLAYER AT TABLE: ${playerAtTable}"$)
End Sub

Public Sub GetCurrHs As String
	Return actualHS
End Sub

public Sub SetCurrHs(hs As Int)
	actualHS = hs
End Sub

Public Sub ResetPoints
	playerAtTable = 1
	actualHS = 0
	lblP1Hs.Color = 0xFF000053
	lblP2Hs.Color = 0xFF000053
	lbl_p1hs_header.Color= 0xFF0172CA
	lbl_p2hs_header.Color= 0xFF0172CA
	lbl_p1hs_header.TextColor = 0xFFFFFFFF
	lbl_p2hs_header.TextColor = 0xFFFFFFFF
End Sub

Public Sub AddToHs(points As Int)
	actualHS = actualHS + points
	
	If actualHS < 0 Then
		actualHS = 0
	End If
	
	If playerAtTable = 1 Then
		SetP1HighCarom
	Else
		SetP2HighCarom
	End If
	
End Sub


Private Sub SetP1HighCarom
	Dim currHs As Int = lblP1Hs.text
	
	If actualHS > currHs Then
		lblP1Hs.Text = NumberFormat(actualHS, 3 ,0)
'		lblP1Hs.Color = xui.Color_Cyan
'		lbl_p1hs_header.Color = 0xFF7CFC00
'		lbl_p1hs_header.TextColor = 0xFF000000
	End If
	
End Sub

Private Sub SetP2HighCarom
	Dim currHs As Int = lblP2Hs.text
	
	If actualHS <> currHs Then
		lblP2Hs.Text = NumberFormat(actualHS, 3 ,0)
		
'		lbl_p2hs_header.Color = 0xFF7CFC00
'		lbl_p2hs_header.TextColor = 0xFF000000
	End If
End Sub