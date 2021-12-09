<object runat="server" progid="ADODB.Connection" id="dbCon"></object>
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
	'temppath = "D:\solution\"& site_title &"\files\temp\"
	'sourcepath = "D:\solution\"& site_title &"\files\mypic\"

	temppath = "\\218.145.70.142\files$\files\temp\"
	sourcepath = "\\218.145.70.142\files$\files\fair\mypic\"

	Dim targetpath, datepath
	datepath = Left(replace(FormatDateTime(Now(), 2),"-",""), 6)
	targetpath = sourcepath & datepath & "\"
	
	Dim objFS
	set objFS = CreateObject("Scripting.FileSystemObject")
	
	'Randomize()
	'dim randomno : randomno = Int(10000* Rnd())
	'randomno = right("0000"&randomno,5)
	'dim newFileName : newFileName = replace(FormatDateTime(Now(), 2),"-","") & replace(FormatDateTime(Now(), 4),":","") & right(now(),2) & randomno

	dim Post, UploadedFile
	dim fileName, fileExtension, fileSize, filefullName
	dim user_photo, gubun, frmnm
    Dim rtnDomain, rtnCallFn
	dim strsql, strResult
	Dim uid

    Dim maxFileSize

    '-- 이미지 올리기
	if inStr(Request.ServerVariables("CONTENT_TYPE"), "multipart/form-data") > 0 then

		' Perform the upload
		set Post = Server.CreateObject("ActiveFile.Post")

		On Error Resume Next

		''''Post.Upload sourcepath
		Post.upload temppath

		user_photo = Post.FormInputs("imgurl").Value
		
		set UploadedFile = Post("uploadFile").File
		fileExtension = UploadedFile.FileExtension
		fileSize = UploadedFile.Size
		fileName = UploadedFile.FileName

		'Response.write "Extension : " & fileExtension & "<br>"
		'Response.write "fileSize : " & fileSize & "<br>"
		'Response.write "fileName : " & fileName & "<br>"
		
		maxFileSize = 1024000

		if CLng(fileSize) > maxFileSize then	' 파일 사이즈 체크
			strResult = "<script type='text/javascript'>" & vbCrLf &_
				"	alert('등록되지 않았습니다!!!\n\n등록할 수 있는 이미지 파일 사이즈는 최대 "& (maxFileSize/1024) &"Kb입니다.');" & vbCrLf
			strResult = strResult & "</script>"
			
			UploadedFile.Delete
			set UploadedFile=Nothing
			
			Post.Flush
			set Post=Nothing
			
			Response.Write "0|등록되지 않았습니다. 등록할 수 있는 이미지 파일 사이즈는 최대 "& (maxFileSize/1024) &"Kb입니다."
			Response.End

		else
			'폴더없을시 생성
			If objFs.FolderExists(targetpath) = False Then
				objFs.CreateFolder(targetpath)
			End If

			uid = Post.FormInputs("uid").Value
			dim newFileName : newFileName = replace(uid,"_wk","")

			UploadedFile.Copy targetpath & newFileName & "." & fileExtension
			UploadedFile.Delete

			Post.Flush

			set UploadedFile=Nothing
			set Post=Nothing


			Dim strDBCon
			strDBCon = "DBInfo_FAIR"
			
			strsql = "UPDATE 개인회원정보 SET 사진파일 = '" & datepath & "/" & newFileName & "." & fileExtension & "'"
			strsql = strsql & " WHERE 개인아이디 = '" & uid & "'"
			strsql = strsql & " ; UPDATE 이력서 SET 사진유무 = '1', 사진파일='" & datepath & "/" & newFileName & "." & fileExtension & "'"
			strsql = strsql & " WHERE 개인아이디 = '" & uid & "'"
			strsql = strsql & " ; UPDATE 이력서공통정보 SET 사진유무 = '1', 사진파일='" & datepath & "/" & newFileName & "." & fileExtension & "'"
			strsql = strsql & " WHERE 개인아이디 = '" & uid & "'"

			dbCon.Open Application(strDBCon)
			dbCon.Execute (strsql)
			dbCon.Close
			
			Dim SetPhotoPath
			SetPhotoPath = "http://" & Request.ServerVariables("SERVER_NAME") & "/files/mypic/" & datepath & "/" & newFileName & "." & fileExtension

			'Call setCookie(site_code & "WKP_F", "photo", "career.co.kr", SetPhotoPath)


			'dim imgfiledomain
			'response.write "<script type='text/javascript'>" & vbcrlf &_
			'	"try { " & vbcrlf
			'
			'response.write " top.fn_set_img('http://" & Request.ServerVariables("SERVER_NAME") & "/files/resume/" & datepath & "/" & newFileName & "." & fileExtension & "');" & vbcrlf &_
			'	"} catch(e) { alert(e.description); }" & vbcrlf &_
			'	"</script>"
			
			Response.write "1|" & datepath & "/" & newFileName & "." & fileExtension
			response.End

			end If
	end if
%>