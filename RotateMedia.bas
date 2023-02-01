B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.3
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	
	Private timeDiff As Long
	
	Public rtMediaEnabled, rtMediaRunning As Boolean
	Public lastClick As Long
	Public callBack As Form
	
	Dim rtTimer, rtMediaTimer, rtTestTimer, RtProgressTimer As Timer
	Dim rtTimeOut, mediaCount As Int
	Dim appPath As String
	Dim lstImg, lstImages, lstImgName  As List
	Dim indexMedia = 0 As Int
	Dim mediaShowDuration, mediaShowTickCount As Int
	Dim B4xImg As B4XImageView
	
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
	appPath =  func.GetAppPathRotateMedia
	
	If File.IsDirectory(appPath, "") = False Then
		parseConfig.bRotateMedia = False
	End If
	
	rtTimer.Initialize("rtTimer", 5000)
	rtMediaTimer.Initialize("rtMediaTimer", parseConfig.rtTimeOut * 60*1000)
	rtTestTimer.Initialize("TestTimer", 5000)
	RtProgressTimer.Initialize("RtProgressTimer", 1000)
	RtProgressTimer.Enabled = False
	
	UpdateRotate
	GetMediaFromFolder
	lastClick = DateTime.Now
	mediaShowDuration = parseConfig.rtTimeOut * 60*1000
End Sub

Private Sub TestTimer_Tick
End Sub


Private Sub RtProgressTimer_Tick
	Dim pgValue As Float = (mediaShowTickCount/mediaShowDuration)*100
	mediaShowTickCount = mediaShowTickCount+1000
	CallSub2(scorebord, "SetRotateMediaProgress",pgValue)
End Sub

Private Sub rtMediaTimer_Tick
	Dim duration As Long
	Log($"$Time{DateTime.Now} - rtTimer_Tick"$)
	Try
		mediaShowTickCount = 0
		If indexMedia >= lstImg.Size -1 Then
			indexMedia = 0
		Else
			indexMedia = indexMedia + 1
		End If
		Dim mMedia As MediaList = lstImages.Get(indexMedia)
		Dim bMedia() As Byte = mMedia.byteMedia
	
		duration = DurationReclame(mMedia.name)
	
		mediaShowDuration = duration
		rtMediaTimer.Interval = duration
	
		B4xImg.Clear
		B4xImg.Bitmap =  BytesToImage(bMedia)
	Catch
		Log($"errMediaRotate - $Time{DateTime.Now}"$)
		File.WriteString(func.appPath, "errMediaRotate.txt", LastException.Message)
	End Try
End Sub

'SET IMAGE PERIOD IF RECLAME
Private Sub DurationReclame (mediaName As String) As Long
	If mediaName.ToLowerCase.IndexOf("reclame") > -1 Then
		Return 30*1000
	Else
		Return parseConfig.rtTimeOut * 60*1000
	End If
End Sub

Public Sub enablertMediaTimer(enable As Boolean)
	UpdateLstMedia
	rtMediaTimer.Enabled = enable
End Sub


Private Sub rtTimer_Tick
			
	Try
		timeDiff = DateTime.Now - lastClick
		If timeDiff > rtTimeOut Then
'			Log($"$Time{DateTime.Now} - rtTimer_Tick"$)
			GetMediaFromFolder
			Dim mMedia As MediaList = lstImages.Get(0)
			Dim bMedia() As Byte = mMedia.byteMedia
			Dim duration As Long = DurationReclame(mMedia.name)
		
			CallSub(scorebord, "ShowRotateMedia")
		
			B4xImg.Bitmap =  BytesToImage(bMedia)
			mediaShowDuration = duration
			rtMediaTimer.Interval = duration
			rtMediaTimer.Enabled = True
			rtTimer.Enabled = False
			RtProgressTimer.Enabled = True
		End If
	Catch
		Log($"errMediaRotate - $Time{DateTime.Now}"$)
		File.WriteString(func.appPath, "errMediaRotate.txt", LastException.Message)
	End Try
End Sub

Private Sub GetMediaFromFolder
	UpdateLstMedia
End Sub


Private Sub UpdateLstMedia
	indexMedia = 0
	lstImg = File.ListFiles(appPath)
	lstImgName.Initialize
	If mediaCount = lstImg.Size Then
		Return
	End If

	mediaCount = lstImg.Size
	lstImg.SortCaseInsensitive(True)
	lstImages.Initialize
	
	For Each imgName As String In lstImg
		
		If imgName.IndexOf(".png") <> -1 Then
'			lstImages.Add(File.ReadBytes(appPath, imgName))
			lstImages.Add(CreateMediaList(imgName, File.ReadBytes(appPath, imgName)))
'			lstImgName.Add(imgName)
		End If
	Next
	
End Sub


Public Sub EnableRtTimer(enable As Boolean)
	rtTimer.Interval = 5000 'parseConfig.timeOut*60000'5000
	rtTimer.Enabled = enable
End Sub

Public Sub UpdateRotate
	If parseConfig.bRotateMedia = False Then
		EnableRtTimer(False)
		Return
	End If
	
	rtMediaEnabled = parseConfig.bRotateMedia
	rtTimeOut = (parseConfig.timeOut*(60*1000))
	EnableRtTimer(False)
	rtTimer.Interval = rtTimeOut
	
	EnableRtTimer(rtMediaEnabled)
End Sub

Public Sub BytesToImage(bytes() As Byte) As B4XBitmap
	Dim In As InputStream
	In.InitializeFromBytesArray(bytes, 0, bytes.Length)
	Dim bmp As Image
	bmp.Initialize2(In)
	Return bmp
End Sub

Public Sub CreateMediaList (name As String, media() As Byte) As MediaList
	Dim t1 As MediaList
	t1.Initialize
	t1.name = name
	t1.byteMedia = media
	Return t1
End Sub
