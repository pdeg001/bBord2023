B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8.1
@EndOfDesignText@
Sub Class_Globals
	Dim mqttC As MqttClient
	Dim working As Boolean
	Dim host As String
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	host = funcScorebord.host
	working = True
	If File.Exists(func.appPath, "mqtt.conf") Then
		ConnectAndReconnect
	End If
End Sub

Sub ConnectAndReconnect
	Do While working
		Try
			If mqttC.IsInitialized Then mqttC.Close
			Do While mqttC.IsInitialized
				Sleep(200)
			Loop

			mqttC.Initialize("mqtt", host, "B4X" & Rnd(0, 999999999))
			Dim mo As MqttConnectOptions
			mo.Initialize("", "")
			mqttC.Connect2(mo)
		
			Wait For Mqtt_Connected (Success As Boolean)
			func.mqttHostActive = Success
			If Success Then
				CallSubDelayed2(scorebord, "SetBrokerStatus", True)
				CallSubDelayed(scorebord, "EnableMqtt")
				CallSubDelayed(scorebord, "MqttConnected")

				Do While working And mqttC.Connected
					mqttC.Publish2("ping", Array As Byte(0), 1, False) 'change the ping topic as needed
					Sleep(5000)
				Loop

				CallSubDelayed2(scorebord, "SetBrokerStatus", False)
			End If
			
			Sleep(5000)
		Catch
			Log("--")
		End Try
		wait for (scorebord.DisconnectMqtt) Complete (result As Boolean)
	Loop
End Sub




