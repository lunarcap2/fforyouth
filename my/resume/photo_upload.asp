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

    '-- �̹��� �ø���
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
				"	alert('��ϵ��� �ʾҽ��ϴ�!!!\n\n����� �� ���� ���� Ȯ���ڸ� ����ϼ̽��ϴ�');" & vbCrLf &_
				"	history.back();" & vbCrLf &_
				"</script>"

			UploadedFile.Delete
			set UploadedFile=Nothing
			
			Post.Flush
			set Post=Nothing

			Response.End
		end If

		if CLng(fileSize) > maxFileSize then	' ���� ������ üũ
			str = "<script type='text/javascript'>" & vbCrLf &_
				"	alert('��ϵ��� �ʾҽ��ϴ�!!!\n\n����� �� �ִ� �̹��� ���� ������� �ִ� "& (maxFileSize/1024) &"Kb�Դϴ�.');" & vbCrLf
			str = str & "</script>"

			Response.Write str
			
			UploadedFile.Delete
			set UploadedFile=Nothing
			
			Post.Flush
			set Post=Nothing

			Response.End
		elseif Instr(1,"jpg/jpeg/gif/JPG/JPEG/GIF",fileExtension,1) <= 0 Then ' Ȯ���� üũ
			str = "<script type='text/javascript'>" & vbCrLf &_
				"	alert('��ϵ��� �ʾҽ��ϴ�!!!\n\n��û�Ͻ� ���� ���� " & fileExtension & "�� �������� �ʴ� �̹��� �����Դϴ�.\n��� ������ �̹��� ������ GIF �Ǵ� JPG �Դϴ�.');" & vbCrLf
			str = str & "</script>"

			Response.Write str

			UploadedFile.Delete
			set UploadedFile=Nothing
			
			Post.Flush
			set Post=Nothing

			Response.End
		else
			'���������� ����
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