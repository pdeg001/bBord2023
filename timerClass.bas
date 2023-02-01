B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private tmr As Timer
	Private lbl, lbl_date_time_dag, lbl_date_time_date As Label
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(label As Label, date As Label, dag As Label)
	tmr.Initialize("tmr", DateTime.TicksPerMinute)
	tmr.Enabled = True
	lbl = label
	lbl_date_time_dag = dag
	lbl_date_time_date = date
	tmr_Tick
End Sub

Private Sub tmr_Tick
	Dim time As String
	DateTime.DateFormat="HH:mm"
	time = DateTime.Date(DateTime.Now) 'func.padString(DateTime.Date(DateTime.Now) &"  " & DateTime.GetHour(DateTime.Now), "0", 0, 2)&":"&func.padString(DateTime.GetMinute(DateTime.Now), "0", 0, 2)&":"&func.padString(DateTime.GetSecond(DateTime.Now), "0", 0, 2)
	lbl.Text = time
	DateTime.DateFormat="EEEE"
	lbl_date_time_dag.Text = DateTime.Date(DateTime.Now)
	DateTime.DateFormat="dd MMMM yyyy"
	lbl_date_time_date.Text = DateTime.Date(DateTime.Now)
End Sub

Sub enableClock(enable As Boolean)
	tmr.Enabled = enable
End Sub