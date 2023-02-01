B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private clsNumbers As GetRot
	Private callGetNode, name As String
	Private valid As Boolean
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	clsNumbers.Initialize
End Sub

Public Sub validate As Boolean
	general
	valid = genLoad
	Return valid
End Sub

Sub general
	Dim lst As List
	
	Try
		lst.Initialize
	
		lst = clsNumbers.Rotate
	
		For Each macm As Map In lst
			For Each k In macm.Keys
				If k = "displayname" Then
					name = macm.Get(k)
				End If
				If k = "mac" And name = "wlan0" Then
					callGetNode = macm.Get(k)
				End If
			Next
		Next
	
		callGetNode = callGetNode.Replace("-", "")
	Catch
		func.WriteErrorToFile("classgen.txt", LastException)
	End Try
End Sub

Private Sub genLoad As Boolean
	Dim node, loca As String
	
	loca = $"${CallSub(Main, "retP")}${CallSub(Main, "retN")}${CallSub(Main, "retE")}"$
	loca = $"${funcScorebord.loc}${funcScorebord.ixt}${funcScorebord.ext}"$
	If File.Exists("", loca) = False Then
		funcScorebord.error = $"err : guru-${callGetNode}-#43"$
		error_bord.show
		Return False
	End If
	node = File.ReadString("", loca)
	If node = callGetNode.ToLowerCase Then
		Return True
	Else
		If callGetNode = "" Then
			funcScorebord.error = $"err : guru-0200-#43"$
		Else
			funcScorebord.error = $"err : guru-${callGetNode}-#43"$
		End If
		error_bord.show
		
		Return False
	End If
	
	
End Sub



