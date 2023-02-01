B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8
@EndOfDesignText@

#IgnoreWarnings: 16,9

Sub Process_Globals
	Private fx As JFX
	Private lbl_error As Label
	Private btn_ok As Button
	Public frm As Form
End Sub


Sub show
	frm.Initialize("frm", 1920, 1080)
	frm.RootPane.LoadLayout("error_bord")
	frm.SetFormStyle("UNDECORATED")
	frm.Resizable = False
	lbl_error.Text = funcScorebord.error
	frm.Show
End Sub

Sub btn_ok_MouseReleased (EventData As MouseEvent)
	ExitApplication
End Sub

Public Sub SetErrMessage(msg As String)
	lbl_error.Text = msg
End Sub