B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
#IgnoreWarnings:9
Sub Class_Globals
	Private fx As JFX
	Private aForm As Form
	Private odPane, pnOrder As Pane
	Private btnCancelOrder, btnConfirmOrder As Button
	Private tmrHidePane As Timer
	Private clsMqttOrderDrink As mqttOrderDrink
	Private orderRequested As Boolean
	Private parser As JSONParser
End Sub


Public Sub Initialize (frm As Form)
	aForm = frm
	odPane.Initialize("odPane")
	addOrderDrinkToForm
	
	odPane.Visible = False

	tmrHidePane.Initialize("tmrHidePane", 10000)
	tmrHidePane.Enabled = False
		
	InitMqtt
		
End Sub

Private Sub InitMqtt
	clsMqttOrderDrink.Initialize
	clsMqttOrderDrink.SetPub
'	clsMqttOrderDrink.PrepPubName
'	clsMqttOrderDrink.pubName = $"${clsMqttOrderDrink.pubName}/orderdrink"$
	clsMqttOrderDrink.ConnectTo
End Sub

Private Sub addOrderDrinkToForm
	odPane.SetSize(1920, 1080)
	odPane.Top = 0
	odPane.Left = 0
	odPane.LoadLayout("bestelling_plaatsen")
	aForm.RootPane.AddNode(odPane,0,0,1920,1080)
	odPane.Visible = False
End Sub

Private Sub mqttOrderRequest
	clsMqttOrderDrink.SendMessage(CreateJson, $"${clsMqttOrderDrink.pubNameAll}"$)
	orderRequested = True
	
End Sub

Private Sub CreateJson As String
	Dim template As String = File.ReadString(File.DirAssets, "orderdrink.json")
	parser.Initialize(template)
	
	Dim root As Map = parser.NextObject
	Dim od As Map = root.Get("orderdrink")
	
	od.Put("table", funcScorebord.bordName)
	od.Put("ipnumber", func.ipNumber)
	
	Dim JSONGenerator As JSONGenerator
	JSONGenerator.Initialize(root)
	
	Return JSONGenerator.ToPrettyString(2)
End Sub

Private Sub enabledTimer (enable As Boolean)
	tmrHidePane.Enabled = enable
End Sub

Private Sub tmrHidePane_Tick
	HidePane
	enabledTimer(False)
End Sub

Public Sub ShowPane
	odPane.Visible = True
	enabledTimer(True)
End Sub

Public Sub HidePane
	odPane.Visible = False
End Sub

Private Sub btnConfirmOrder_Click
	mqttOrderRequest
	HidePane
	enabledTimer(False)
	
End Sub

Private Sub btnCancelOrder_Click
	HidePane
	enabledTimer(False)
End Sub