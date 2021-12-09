<%
	Option Explicit

	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
	Response.Charset = "euc-kr"
%>
<!--#include virtual = "/common/constant.asp"-->
<%
	dim temppath, sourcepath
	temppath = "D:\solution\"& site_title &"\files\temp\"
	sourcepath = "D:\solution\"& site_title &"\files\resume\"

	Dim targetpath, datepath
	datepath = Left(replace(FormatDateTime(Now(), 2),"-",""), 6)
	targetpath = sourcepath & datepath & "\"
	
	Dim objFS
	set objFS = CreateObject("Scripting.FileSystemObject")
	
	Randomize()
	dim randomno : randomno = Int(10000* Rnd())
	randomno = right("0000"&randomno,5)
	dim newFileName : newFileName = replace(FormatDateTime(Now(), 2),"-","") & replace(FormatDateTime(Now(), 4),":","") & right(now(),2) & randomno

	dim Post, UploadedFile
	dim fileName, fileExtension, fileSize, filefullName
	dim user_photo, gubun, frmnm
    Dim rtnDomain, rtnCallFn
	dim strsql, str, strDBCon

    Dim maxFileSize

    '-- 이미지 올리기
	if inStr(Request.ServerVariables("CONTENT_TYPE"), "multipart/form-data") > 0 then

		' Perform the upload
		set Post = Server.CreateObject("ActiveFile.Post")
		'Post.MaxFileSize=150000

		On Error Resume Next

		Post.Upload sourcepath

		user_photo = Post.FormInputs("imgurl").Value
		
		set UploadedFile = Post("uploadFile").File
		fileExtension = UploadedFile.FileExtension
		fileSize = UploadedFile.Size
		fileName = UploadedFile.FileName
		
		maxFileSize = 1024000

		dim AllowExtension : AllowExtension = Array("gif", "jpg", "jpeg", "GIF", "JPG", "JPEG")
		dim blnAllowExtension : blnAllowExtension = false
		dim intIndex
		For intIndex=0 to Ubound(AllowExtension)
			If fileExtension = AllowExtension(intIndex) then
				blnAllowExtension = true
				Exit For
			End If
		Next

		If blnAllowExtension = false then
			Response.Write "<script type='text/javascript'>" & vbCrLf &_
				"	alert('등록되지 않았습니다!!!\n\n등록할 수 없는 파일 확장자를 사용하셨습니다');" & vbCrLf &_
				"	history.back();" & vbCrLf &_
				"</script>"

			UploadedFile.Delete
			set UploadedFile=Nothing
			
			Post.Flush
			set Post=Nothing

			Response.End
		end If

		if CLng(fileSize) > maxFileSize then	' 파일 사이즈 체크
			str = "<script type='text/javascript'>" & vbCrLf &_
				"	alert('등록되지 않았습니다!!!\n\n등록할 수 있는 이미지 파일 사이즈는 최대 "& (maxFileSize/1024) &"Kb입니다.');" & vbCrLf
			str = str & "</script>"

			Response.Write str
			
			UploadedFile.Delete
			set UploadedFile=Nothing
			
			Post.Flush
			set Post=Nothing

			Response.End
		elseif Instr(1,"jpg/jpeg/gif/JPG/JPEG/GIF",fileExtension,1) <= 0 Then ' 확장자 체크
			str = "<script type='text/javascript'>" & vbCrLf &_
				"	alert('등록되지 않았습니다!!!\n\n요청하신 파일 형식 " & fileExtension & "은 지원하지 않는 이미지 형식입니다.\n등록 가능한 이미지 포멧은 GIF 또는 JPG 입니다.');" & vbCrLf
			str = str & "</script>"

			Response.Write str

			UploadedFile.Delete
			set UploadedFile=Nothing
			
			Post.Flush
			set Post=Nothing

			Response.End
		else
			'폴더없을시 생성
			If objFs.FolderExists(targetpath) = False Then
				objFs.CreateFolder(targetpath)
			End If

			UploadedFile.Copy targetpath & newFileName & "." & fileExtension
			UploadedFile.Delete
			
			Post.Flush

			set UploadedFile=Nothing
			set Post=Nothing

			dim imgfiledomain
			response.write "<script type='text/javascript'>" & vbcrlf &_
				"try { " & vbcrlf
			
			response.write " top.fn_set_img('http://" & Request.ServerVariables("SERVER_NAME") & "/files/resume/" & datepath & "/" & newFileName & "." & fileExtension & "');" & vbcrlf &_
				"} catch(e) { alert(e.description); }" & vbcrlf &_
				"</script>"
            
            'response.write "<script type='text/javascript'>top.fn_set_img('" & imgfiledomain & "/files/resume/" & datepath & "/" & newFileName & "." & fileExtension & "');</script>"
			response.end

			end If
	end if
%>