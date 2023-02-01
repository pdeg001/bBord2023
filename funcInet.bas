B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
'	Dim ftp As FTP
	
	Private url As String
	
	Public imgView As ImageView
End Sub


Sub testInet As ResumableSub
	Dim j As HttpJob
	Dim url As String = "https:\\www.google.com"

	Try
	
		j.Initialize(url, Me)
		j.Download(url)
	
		Wait For (j) JobDone(j As HttpJob)
	Catch
		func.WriteErrorToFile("nointernet.txt", LastException)
		Return False
	End Try
	
	If j.Success Then
		Return True
	Else
		Return False
	End If
End Sub

