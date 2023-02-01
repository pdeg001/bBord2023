B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
'make sure to call SetLastClick after clicking a carom
'example int retrobord

Sub Class_Globals
	Private fx As JFX
	Private frm As Form
	Private pnScreenSaver As Pane
	Private promoteRunning As Boolean
	Private clsInactive As ScreenSaverInactive
	Private timeOut As Int' = 5000
	Private pn_promote As Pane
	Private lbl_message_1 As Label
	Private lbl_message_2 As Label
	Private lbl_message_3 As Label
	Private lbl_message_4 As Label
	Private lbl_message_5 As Label
	Private bordname As String
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(passedForm As Form, frmObj As Object, frmName As String)
	bordname = frmName
	frm = passedForm
	pnScreenSaver.Initialize("pnScreenSaver")
	addScreenSaverToForm
	clsInactive.Initialize(Me,870, 510, frmName)
	pullConfig
End Sub

Private Sub addScreenSaverToForm
	pnScreenSaver.SetSize(1920, 1080)
	pnScreenSaver.Top = 0
	pnScreenSaver.Left = 0
	pnScreenSaver.LoadLayout("genScreenSaver")
	frm.RootPane.AddNode(pnScreenSaver,0,0,1920,1080)
	pnScreenSaver.Visible = False
End Sub

Private Sub pnScreenSaver_MouseMoved(EventData As MouseEvent)
	SetLastClick
End Sub

Public Sub SetLastClick
	pnScreenSaver.Visible = False
	promoteRunning = False
	pnScreenSaver.Visible = False
	clsInactive.lastClick = DateTime.Now
	clsInactive.enableTime(True)
	clsInactive.enablePromote(False)
	clsInactive.enablePromote(False)
End Sub

Sub DisableTimers
	pnScreenSaver.Visible = False
	clsInactive.enableTime(False)
	clsInactive.enablePromote(False)
End Sub

Sub showPromote
'pnScreenSaver.Visible = True
'	pn_promote.SetLayoutAnimated(0, 50dip, 50dip, pn_promote.Width, pn_promote.Height)
End Sub


Sub drawPromote(x As Double, y As Double)
'	Log($"Retro PROMOTE"$)
	If pnScreenSaver.Visible = False Then
		pnScreenSaver.Visible = True
	End If
	
	pn_promote.SetLayoutAnimated(0, x, y, pn_promote.Width, pn_promote.Height)
	Sleep(0)
End Sub

Sub pullConfig
	Dim msgList As List
	Dim cnf As String
	Dim parser As JSONParser
		
	cnf = File.ReadString(func.appPath, "cnf.44")
	parser.Initialize(cnf)
	msgList.Initialize


	Dim root As Map' = parser.NextObject
	root.Initialize
	root= parser.NextObject

	Dim message As Map = root.Get("message")
	Dim line_1 As String = message.Get("line_1")
	Dim line_2 As String = message.Get("line_2")
	Dim line_5 As String = message.Get("line_5")
	Dim line_3 As String = message.Get("line_3")
	Dim line_4 As String = message.Get("line_4")
	
	lbl_message_1.Text = line_1
	lbl_message_2.Text = line_2
	lbl_message_3.Text = line_3
	lbl_message_4.Text = line_4
	lbl_message_5.Text = line_5
	Dim showPromote_ As Map = root.Get("showPromote")
	Dim timeOut As Int  = showPromote_.Get("timeOut")
	clsInactive.timeOutPeriode = timeOut*(60*1000)
	clsInactive.EnableTimers(showPromote_.Get("active") = "1")
	timeOut = showPromote_.Get("timeOut")
End Sub

Sub updatePromote
	pullConfig
End Sub

Sub enableScreenSaver(enable As Boolean)
	If enable Then clsInactive.lastClick = DateTime.Now
	clsInactive.enableTime(enable)
End Sub