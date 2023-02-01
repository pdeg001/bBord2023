B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8.1
@EndOfDesignText@
Sub Class_Globals
	Private client As MqttClient
	Private host As String
	Private pubBordTimer As Timer
	Private serializator As B4XSerializator
	Public connected As Boolean
	Private topicName As String
	Private pubName As String
	Private pubNameAll As String
	Private pubDisconnect As String
	
	
End Sub

Public Sub Initialize
	host = funcScorebord.host
	pubBordTimer.Initialize("pubBordTimer", 6000)
End Sub

public Sub SetPub
	pubName = $"${func.mqttName}${func.mqttbase}"$
	pubNameAll = $"${func.mqttName}${func.mqttbase}pubbord"$
	pubDisconnect = $"${func.mqttName}${func.mqttbase}"$
End Sub

Public Sub PrepTopicName(name As String)
	topicName = name.Replace(" ", "")
End Sub

public Sub EnablePubTimer(enable As Boolean)
	pubBordTimer.Enabled = enable
End Sub

Public Sub ConnectTo
	If connected Then client.Close
	
	Try
		client.Initialize("client", $"${host}"$, topicName & Rnd(1, 10000000))
		Dim mo As MqttConnectOptions
		mo.Initialize("", "")
	
		'this message will be sent if the client is disconnected unexpectedly.
		mo.SetLastWill(pubDisconnect, CreateMessage(topicName&"DIED"), 0, False)
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
			
			EnablePubTimer(True)
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
		EnablePubTimer(False)
		CallSub2(scorebord, "SetBrokerIcon", False)
		client.Close
		Do While client.IsInitialized
			Sleep(200)
		Loop
	End If
	Return True
End Sub

Public Sub SendMessage(Body As String)
	Log($"$Time{DateTime.now} MQTTPUBBORD CONNECTED: ${client.Connected}${CRLF}"$)
	Try
		If connected Then
			CallSub2(scorebord, "SetBrokerIcon", True)
			client.Publish2(pubName,serializator.ConvertObjectToBytes(Body), 0, False)
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

Private Sub CreateMessage(Body As String) As Byte()
	Dim lstData As List = scorebord.mqttGetPlayers
	Dim p1Name, p2Name, strBody, bordName As String
	
	bordName = funcScorebord.bordName.Replace(" ", "").ToLowerCase
	p1Name = lstData.Get(0)
	p2Name = lstData.Get(1)
	
	p1Name = p1Name.Replace(CRLF, "")
	p2Name = p2Name.Replace(CRLF, "")
	strBody = $"${Body}|${p1Name}|${p2Name}|${lstData.Get(2)}|${lstData.Get(3)}|${lstData.Get(4)}|${func.getIpNumber}|${IIf(funcScorebord.gameRunning,"1", "0")}"$
	Dim m As Message
	m.Initialize
	If topicName = bordName Then
		m.Body = strBody
	Else
		m.Body = Body
	End If
	m.from = topicName
	
	Return serializator.ConvertObjectToBytes(m)
End Sub

Private Sub pubBordTimer_Tick
	func.mqttClientConnected = client.Connected
	Try
		If client.Connected Then
			client.Publish2(pubNameAll,CreateMessage(funcScorebord.bordDisplayName), 0, False)
		End If
	Catch
		func.WriteErrorToFile("MQTTpubBordError.txt", LastException)
		pubBordTimer.Enabled = False
		CallSub2(scorebord, "SetBrokerIcon", False)
	End Try
End Sub

Public Sub CLientConnected As Boolean
	Return client.Connected
End Sub
