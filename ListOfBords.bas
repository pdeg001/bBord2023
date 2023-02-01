B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private lbl_base_bord As Label
	Private lbl_retro_bord As Label
	Private lbl_survival_bord As Label
	Private lbl_cancel As Label
	Private pnBase, pnTest As Pane
	Private pnTextBase As Pane
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(forma As Form)
	pnBase.Initialize("pnBase")
	pnTest.Initialize("pnTest")
	pnTextBase.Initialize("pnTextBase")
	lbl_base_bord.Initialize("lblClick")
	lbl_retro_bord.Initialize("lblClick")
	lbl_survival_bord.Initialize("lblClick")
	lbl_cancel.Initialize("lblClick")
	CSSUtils.SetBackgroundColor(pnTest, fx.Colors.Transparent)
	CreateChoiceForm
	forma.RootPane.AddNode(pnTest, 0, 0, 1920, 1080)
	pnTest.Visible = False
	
End Sub

Private Sub CreateChoiceForm
	CSSUtils.SetBackgroundColor(pnTextBase, fx.Colors.Black)
	
	lbl_cancel.Style = "-fx-alignment: center; -fx-padding: 5 ;"
	lbl_cancel.TextColor = fx.Colors.Yellow
	lbl_cancel.TextSize = 120
	lbl_cancel.Text = "Sluit"
	lbl_cancel.Tag = "cancel"
	CSSUtils.SetBackgroundColor(lbl_cancel, fx.Colors.From32Bit(0xFF000050))
	
	lbl_base_bord.Style = "-fx-alignment: center; -fx-padding: 5 ;"
	lbl_base_bord.TextColor = fx.Colors.Yellow
	lbl_base_bord.TextSize = 120
	lbl_base_bord.Text = "Open Basis Bord"
	lbl_base_bord.Tag = "basis"
	CSSUtils.SetBackgroundColor(lbl_base_bord, fx.Colors.From32Bit(0xFF000050))
	
	lbl_retro_bord.Style = "-fx-alignment: center; -fx-padding: 5 ;"
	lbl_retro_bord.TextColor = fx.Colors.Yellow
	lbl_retro_bord.TextSize = 120
	lbl_retro_bord.Text = "Open Retro bord"
	lbl_retro_bord.Tag = "retro"
	CSSUtils.SetBackgroundColor(lbl_retro_bord, fx.Colors.From32Bit(0xFF000050))
	
	lbl_survival_bord.Style = "-fx-alignment: center; -fx-padding: 5 ;"
	lbl_survival_bord.TextColor = fx.Colors.Yellow
	lbl_survival_bord.TextSize = 120
	lbl_survival_bord.Text = "Open survival bord"
	lbl_survival_bord.Tag = "survival"
	CSSUtils.SetBackgroundColor(lbl_survival_bord, fx.Colors.From32Bit(0xFF000050))
	
	pnTextBase.AddNode(lbl_base_bord, 220,70, 1310,80)
	pnTextBase.AddNode(lbl_retro_bord, 220,270, 1310,80)
	pnTextBase.AddNode(lbl_survival_bord, 220,470, 1310,80)
	pnTextBase.AddNode(lbl_cancel, 570,670, 620,80)
	
	pnTest.AddNode(pnTextBase, 90,90,1750,890)
	
	
	
End Sub

Public Sub ShowBordList
	
	pnTest.Visible = True
End Sub


Private Sub CreateJson(retroB As String, survivalB As String)
	Dim strRetro As String = File.ReadString(File.DirAssets, "retro.cnf")
	Dim parser As JSONParser
	
	parser.Initialize(strRetro)
	Dim root As Map = parser.NextObject
	Dim retro As Map = root.Get("retroBord")
	'Dim active As String = retro.Get("active")
	Dim survival As Map = root.Get("survival")
	'Dim sactive As String = survival.Get("sactive")
	
'	retro.Put("active", setActive)
	retro.Put("active", retroB)
	survival.Put("sactive", survivalB)
	
	Dim JSONGenerator As JSONGenerator
	JSONGenerator.Initialize(root)
	
	File.WriteString(func.appPath, "retro.cnf", JSONGenerator.ToPrettyString(2))
	
	
End Sub


Private Sub lblClick_MouseClicked (EventData As MouseEvent)
	Dim lbl As Label = Sender
	If lbl.Tag = "cancel" Then
		pnTest.Visible = False
	Else If lbl.Tag = "basis" Then
		CreateJson("0", "0")
	Else If lbl.Tag = "retro" Then
		CreateJson("1", "0")
	Else if lbl.Tag = "survival" Then
		CreateJson("0", "1")
	End If
	pnTest.Visible = False
End Sub

Private Sub lblClick_MouseEntered (EventData As MouseEvent)
	Dim lbl As Label = Sender
	If lbl.Tag = "cancel" Then
		CSSUtils.SetBackgroundColor(lbl, fx.Colors.Red)
		Else
		CSSUtils.SetBackgroundColor(lbl, fx.Colors.Green)
		lbl.TextColor = fx.Colors.Black
	End If
End Sub

Private Sub lblClick_MouseExited (EventData As MouseEvent)
	Dim lbl As Label = Sender
		CSSUtils.SetBackgroundColor(lbl,  fx.Colors.From32Bit(0xFF000050))
	If lbl.Tag <> "cancel" Then
		lbl.TextColor = fx.Colors.Yellow
'	Else
	End If
End Sub