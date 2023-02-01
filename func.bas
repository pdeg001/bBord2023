B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8
@EndOfDesignText@
'Static code module
#IgnoreWarnings: 16, 9,1
Sub Process_Globals
	Private fx As JFX
	Private regexStr As StringBuilder
	Public hasInternetAccess As Boolean = False
	Public os As String
	Public appPath, ipNumber, bordName, partijFolder As String
	Public mqttName As String = "pdeg/"
	Public mqttbase As String
	Public mqttClientConnected As Boolean
	Public mqttHostActive As Boolean
End Sub


Public Sub PrepMqttTopic(topic As String) As String
	Return topic.Replace(" ","")
End Sub

Public Sub setHs(hs As String, leftMouse As Boolean) As String
	Dim value As Int = hs
	
	If leftMouse Then
		value = value + 1
	Else 	
		value = value - 1
	End If
	
	If value < 0 Then value = 0
	If value > 999 Then value = 999
	
	Return padString(value, "0", 0, 3)
End Sub

Public Sub testNumber(oldStringToTest As String, newStringToTest As String) As String
	Dim stringToTest As String
	
	If newStringToTest.Length = 1 Then
		stringToTest = newStringToTest
	Else
		stringToTest = 	newStringToTest.Replace(oldStringToTest, "")
	End If
	
	regexStr.Initialize
	regexStr.Append("[0-9]*\.[0-9]*|[0-9]*")
	
	If Regex.IsMatch(regexStr.ToString,stringToTest) = True Then
		Return newStringToTest	
	Else
		Return oldStringToTest
	End If
End Sub

Public Sub setFont(lbl As Label, size As Int, digital As Boolean)
		Dim jo As JavaObject=lbl
	If digital Then
		jo.runMethod("setFont",Array(fx.LoadFont(File.DirAssets,"digital-7.ttf", size)))
		'jo.runMethod("setFont",Array(fx.LoadFont(File.DirAssets,"dig.otf", size)))
	Else
		lbl.Style = $"-fx-font-family: Arial; -fx-font-size: ${size};"$
'		jo.runMethod("setFont",Array(fx.LoadFont(File.DirAssets,"Crasng.ttf", size)))
	End If
End Sub

Public Sub setFontRetro(lbl As Label, size As Int, digital As Boolean)
	Dim jo As JavaObject=lbl
	If digital Then
		jo.runMethod("setFont",Array(fx.LoadFont(File.DirAssets,"digital-7_italic.ttf", size)))
	Else
		lbl.Style = $"-fx-font-family: Arial; -fx-font-size: ${size};"$
	End If
End Sub

Public Sub setFontRetroList(lst As List, size As Int, digital As Boolean)
	Dim lbl As B4XView
	For i = 0 To lst.Size-1
		lbl = lst.Get(i)
		Dim jo As JavaObject=lbl'lst.Get(i)
		If digital Then
			jo.runMethod("setFont",Array(fx.LoadFont(File.DirAssets,"digital-7_italic.ttf", size)))
		Else
			'lbl.Style = $"-fx-font-family: Arial; -fx-font-size: ${size};"$
		End If
	Next
End Sub

Public Sub setFontColor(lbl As Label, yellow As Boolean)
	If yellow Then
		lbl.Style = "-fx-text-fill: #ffff00;" '= fx.Colors.From32Bit(0xFFFFFF00)
	Else
		lbl.Style = "-fx-text-fill: #ffffff;"
		'lbl.TextColor = fx.Colors.From32Bit(0xFFFFFFFF)
	End If
End Sub

'padText e.g. "9", padChar e.g. "0", padSide 0=left 1=right, padCount e.g. 2
Public Sub padString(padText As String ,padChr As String, padSide As Int, padCount As Int) As String
	Dim padStr As String
	
	If padText.Length = padCount Then
		Return padText
	End If
	
	For i = 1 To padCount-padText.Length
		padStr = padStr&padChr
	Next
	
	If padSide = 0 Then
		Return padStr&padText
	Else
		Return padText&padStr
	End If
	
End Sub

'Dir, 'Filename: Directory and filename of the cursor image.
'hotspotX, hotspotY: X and Y Position of the hotspot of the cursor (where the click happens).
'TargetNode: The node on which the cursor will be changed.
Sub SetCustomCursor1(Dir As String, Filename As String, hotspotX  As Double, hotspotY  As Double, TargetNode As Node)
	Dim img As Image
	img.Initialize(Dir, Filename)
	Dim cursor As JavaObject
	cursor.InitializeNewInstance("javafx.scene.ImageCursor", Array(img, hotspotX, hotspotY))
	Dim joScene As JavaObject = TargetNode
	joScene.RunMethod("setCursor", Array(cursor))
End Sub




Sub caromLabelCss(lbl As Label, style As String)
	lbl.StyleClasses.Add(style)
End Sub

'Sub setNumberCss(lbl As Label)
'	CSSUtils.SetStyleProperty(lbl, "-fx-background-color",  "linear-gradient(to bottom,  #cfe7fa 0%,#6393c1 100%)")
'	CSSUtils.SetStyleProperty(lbl, "-fx-background-radius", "3,2,1")
'End Sub

'Sub getVersion As String
'	Dim version, os, appPath As String
'	os = DetectOS
'	Select os
'		Case "windows"
'			appPath = File.DirApp&"\44\"
'		Case "linux"
'			appPath = File.DirApp&"/44/"
'	End Select
'	
'	version = File.ReadString(appPath, "ver.pdg")
'	
'	Return $" v ${version.Trim}"$
'	
'End Sub

Sub DetectOS As String
	Dim os As String = GetSystemProperty("os.name", "").ToLowerCase
	If os.Contains("win") Then
		Return "windows"
	Else If os.Contains("mac") Then
		Return "mac"
	Else
		Return "linux"
	End If
End Sub

Sub GetAppPath
	os = DetectOS
	Select os
		Case "windows"
			appPath = File.DirApp&"\44\"
		Case "linux"
			appPath = File.DirApp&"/44/"
	End Select
	
End Sub

Sub GetAppPathRotateMedia As String
	Dim rtPath As String
	os = DetectOS
	Select os
		Case "windows"
			rtPath = File.DirApp&"\44\rotatemedia"
		Case "linux"
			rtPath = File.DirApp&"/44/rotatemedia"
	End Select
	
	Return rtPath
End Sub


Sub getIpNumber As String
	Dim Server As ServerSocket
	Dim components As List
	Dim Ip, ipStr As String
	
	ipStr = ""
	Server.Initialize(50000, Me)
	Ip = Server.GetMyIP
	Server.Close
	ipNumber = Ip
	If ipNumber = "127.0.0.1" Then
		hasInternetAccess = False
	Else 
		hasInternetAccess = True	
	End If
	Return Ip
	components.Initialize
	
	For i = 0 To Ip.Length - 1
		If Ip.SubString2(i,i+1) = "." Then
		ipStr = ipStr &	","
			Else
		ipStr = ipStr &	Ip.SubString2(i,i+1)
		End If
	Next
	components = Regex.Split(",", ipStr)
	
	Return components.Get(3)
End Sub

Sub getUnroundedMoyenne(moyenne As String) As String
	Return moyenne.SubString2(0, moyenne.Length-1)
End Sub

Sub alignLabelCenter(lbl As Label)
	Dim jo As JavaObject = lbl
	jo.RunMethod("setTextAlignment", Array("CENTER"))
End Sub

Sub splitNaam(str As String) As String
	Dim lst As List
	Dim spaceIndex As Int = str.IndexOf(" ")
	Dim retStr As String = ""
	If spaceIndex < 0 Then Return str.ToUpperCase
	
	lst.Initialize
	lst = Regex.Split(" ", str)
	
	For i = 0 To lst.Size -1
		If i = 0 Then
			retStr = retStr & lst.Get(i) & CRLF
			Continue
		End If
		retStr = retStr & " " & lst.Get(i)
	Next
		
	
	Return retStr.ToUpperCase
	
	
End Sub

Sub WriteErrorToFile(filename As String, error As Exception)
	File.WriteString(File.DirApp, filename, error.Message)
End Sub

Public Sub TestCurrScoreJsonExists As Boolean
	Dim Scr As String
	
	GetPartijFolder
	If File.Exists(partijFolder, "currscore.json") = False Then
		File.Copy(File.DirAssets, "score.json", partijFolder, "currscore.json")
		Return False
	End If
	
	Scr = File.ReadString(partijFolder, "currscore.json")
	
	If Scr.Length = 0 Then
		File.Copy(File.DirAssets, "score.json", partijFolder, "currscore.json")
		Return False
	End If
	Return True
End Sub

Sub GetPartijFolder
	Dim os As String = parseConfig.DetectOS
	Dim appFolder As String
			
	Select os
		Case "windows"
			appFolder = File.DirApp'&"\44\"
			partijFolder = $"${appFolder}\gespeelde_partijen"$
			'	clsGen.general
		Case "linux"
			appFolder = File.DirApp'&"/44/"
			partijFolder = $"${appFolder}/44/gespeelde_partijen"$
	End Select
	If File.IsDirectory("",partijFolder) = False Then
		File.MakeDir("", partijFolder)
	End If
End Sub