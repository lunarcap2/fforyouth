<%
	Option Explicit

	Response.Clear
	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
	
	Dim datepath, sourcepath
	datepath = Left(replace(FormatDateTime(Now(), 2),"-",""), 6)
	sourcepath = "D:\hkpartner\files\resume\" & datepath & "\"
	
	dim x1, y1, x2, y2, orgnWidth, orgnHeight, dispWidth, dispHeight, cropWidth, cropHeight, oldimgpath
	x1 = request("x1")
	y1 = request("y1")
	x2 = request("x2")
	y2 = request("y2")
	orgnWidth = request("orgnWidth")
	orgnHeight = request("orgnHeight")
	dispWidth = request("dispWidth")
	dispHeight = request("dispHeight")
	cropWidth = request("cropWidth")
	cropHeight = request("cropHeight")
	oldimgpath = request("oldimgpath")
	
	if x1="" or y1="" or x2="" or y2="" or orgnWidth="" or orgnHeight="" or dispWidth="" or dispHeight="" or cropWidth="" or cropHeight="" or oldimgpath="" then
		response.write "<script type='text/javascript'>" & vbcrlf &_
			"	alert('사진 정보가 확실하지 않습니다.');" & vbcrlf &_
			"</script>"
		response.end
	end if
	
	dim nx1, ny1, nx2, ny2	' 실제 좌표값
	nx1 = cint((orgnWidth / dispWidth) * x1)
	ny1 = cint((orgnHeight / dispHeight) * y1)
	nx2 = cint((orgnWidth / dispWidth) * x2)
	ny2 = cint((orgnHeight / dispHeight) * y2)

	Randomize()
	dim randomno : randomno = Int(10000* Rnd())
	randomno = right("0000"&randomno,5)
	dim newFileName : newFileName = "thumb_" & cropWidth & "_" & cropHeight & "_" & replace(FormatDateTime(Now(), 2),"-","") & replace(FormatDateTime(Now(), 4),":","") & right(now(),2) & randomno & ".jpg"
	
	On Error Resume Next

	Response.ContentType = "image/jpeg"
	' Response.ContentType = "application/octet-stream"
	Response.AddHeader "Content-Disposition", "attachment; filename=" & newFileName
	
	dim resizer
	set resizer = Server.CreateObject("ASPPhotoResizer.Resize")
	
	resizer.LoadFromFile sourcepath & oldimgpath
	resizer.JPGQuality = 100
	resizer.CropImage nx1, ny1, nx2, ny2
	resizer.ResizeImage cropWidth, cropHeight
	
	resizer.StreamImage
	
	set resizer = nothing
	
	response.flush
	
	if Err.Number > 0 then
		response.write "<script type='text/javascript'>" & vbcrlf &_
			"	alert('파일 처리 도중 오류가 발생하였습니다.\n움직이는 gif 파일은 지원하지 않으므로 파일을 다시 한 번 확인해주시기 바랍니다.');" & vbcrlf &_
			"</script>"

			'Response.write "11"
	end if
	response.end
	
%>