B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8.1
@EndOfDesignText@
Sub Class_Globals
	Private client As MqttClient
	Private host As String
	Private serializator As B4XSerializator
	Public connected As Boolean
	Public pubName As String
End Sub


Public Sub Initialize
	host = funcScorebord.host
End Sub

Sub PrepPubName
	pubName = $"${func.mqttName}${func.mqttbase}recvdata_${funcScorebord.bordName.Replace(" ", "")}"$  'funcScorebord.bordName.Replace(" ", "")
	
End Sub

Public Sub ConnectTo
	If pubName = "" Then
		Log($"$Time{DateTime.now} PUBNAME EMPTY"$)
		Return
	End If
	
	Try
		If connected Then client.Close
	
		client.Initialize("client", $"${host}"$, pubName & Rnd(1, 10000000))
		Dim mo As MqttConnectOptions
		mo.Initialize("", "")
	
		'this message will be sent if the client is disconnected unexpectedly.
		'mo.SetLastWill(pubName, serializator.ConvertObjectToBytes(pubName&" DIED"), 0, False)
		mo.SetLastWill(pubName, CreateMessage(pubName, "recvdied"), 0, False)
		
		client.Connect2(mo)
	Catch
		func.WriteErrorToFile("connecttopubdata.txt", LastException)
		func.mqttClientConnected = False
		CallSub2(scorebord, "SetBrokerIcon", False)
	End Try
End Sub

Private Sub client_Connected (Success As Boolean)
	Try
		If Success Then
			connected = True
			CallSub2(scorebord, "SetBrokerIcon", True)
			client.Subscribe(pubName, 0)
		Else
			func.mqttClientConnected = False
		End If
	Catch
		CallSub2(scorebord, "SetBrokerIcon", False)
		func.WriteErrorToFile("clientconnectedpubdata.txt", LastException)
	End Try
End Sub

Private Sub client_MessageArrived (Topic As String, Payload() As Byte)
	Try
		Dim receivedObject As Object = serializator.ConvertBytesToObject(Payload)
		Dim m As Message = receivedObject
		If m.Body.IndexOf("data please") > -1 Then
			CallSubDelayed(scorebord, "CreateJsonFormMqttClient")
		End If
		If m.Body.IndexOf("players please") > -1 Then
			CallSubDelayed(scorebord, "CreateJsonFormMqttClient")
		End If
	Catch
		func.WriteErrorToFile("mqttLastException.txt", LastException)
	End Try
End Sub

Public Sub StopServer As ResumableSub
	If client.IsInitialized Then
		connected = False
		client.Close
		Do While client.IsInitialized
			Sleep(200)
		Loop
	End If
	Return True
End Sub

Public Sub SendMessage(Body As String, From As String)
'	Log(From)
	Try
		If client.Connected Then
			client.Publish2(pubName, CreateMessage(Body, From), 0, False)
			Sleep(500)
		Else If func.mqttHostActive Then
			ConnectTo	
		End If
	Catch
		func.WriteErrorToFile("MQTTpubdataError.txt", LastException)
		
		StopServer
		Log("Mqtt broker lost")
	End Try
	
End Sub

Private Sub CreateMessage(Body As String, From As String) As Byte()
	Dim m As Message
	m.Initialize
	m.Body = Body
	m.From = From
	Return serializator.ConvertObjectToBytes(m)
End Sub
