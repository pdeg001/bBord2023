B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=8.1
@EndOfDesignText@
Sub Class_Globals
	Private client As MqttClient
	Private host As String
	Private serializator As B4XSerializator
	Public connected As Boolean
	Private topicName As String
	Private pubName As String
	Public pubNameAll As String
	Private pubDisconnect As String
		
End Sub

Public Sub Initialize
	host = funcScorebord.host
End Sub

public Sub SetPub
	pubName = $"${func.mqttName}${func.mqttbase}"$
	pubNameAll = $"${func.mqttName}${func.mqttbase}orderdrink"$
	pubDisconnect = $"${func.mqttName}${func.mqttbase}"$
End Sub

Public Sub PrepTopicName(name As String)
	topicName = name.Replace(" ", "")
	topicName = "orderdrink"
End Sub

Public Sub ConnectTo
	If connected Then client.Close
	
	Try
		client.Initialize("client", $"${host}"$, pubNameAll & Rnd(1, 10000000))
		Dim mo As MqttConnectOptions
		mo.Initialize("", "")
	
		'this message will be sent if the client is disconnected unexpectedly.
		mo.SetLastWill(pubDisconnect, CreateMessage(topicName&"DIED", topicName), 0, False)
		client.Connect2(mo)
	Catch
		func.WriteErrorToFile("mqttconnectto.txt", LastException)
	End Try
End Sub

Private Sub client_Connected (Success As Boolean)

	Try
		If Success Then
			connected = True
			client.Subscribe(pubNameAll, 0)
			
		Else 
			Log("Error connecting: " & LastException)
		End If
	Catch
		func.WriteErrorToFile("clientconnected.txt", LastException)
	End Try
End Sub

Public Sub StopServer As ResumableSub
	If client.IsInitialized Then
		connected = False
		CallSub2(scorebord, "SetBrokerIcon", False)
		client.Close
		Do While client.IsInitialized
			Sleep(200)
		Loop
	End If
	Return True
End Sub

Public Sub SendMessage(Body As String, from As String)
'	Log($"$Time{DateTime.now} MQTTPUBBORD CONNECTED: ${client.Connected}${CRLF}"$)
	Try
		If connected Then
			CallSub2(scorebord, "SetBrokerIcon", True)
			client.Publish2(pubNameAll, CreateMessage(Body, from), 0, False)
		Else if func.mqttHostActive Then
			Log("MqttPubBord Reconnecting")
			ConnectTo
		End If
	Catch
		func.WriteErrorToFile("brokerlost.txt", LastException)
		Log($"$Time{DateTime.now} Mqtt broker lost"$)
'		StopServer
	End Try
End Sub

Private Sub CreateMessage(Body As String, From As String) As Byte()
	Dim m As Message
	m.Initialize
	m.Body = Body
	m.From = From
	Return serializator.ConvertObjectToBytes(m)
End Sub

Public Sub CLientConnected As Boolean
	Return client.Connected
End Sub
