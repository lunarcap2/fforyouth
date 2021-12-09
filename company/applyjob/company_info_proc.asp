<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: ���ȸ�� > ä����� ����> ������� ����
' 	History		: 2020-05-11, �̻��� 
'---------------------------------------------------------------------
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
Response.Charset = "euc-kr"


Dim temppath, sourcepath
temppath	= "D:\solution\"& site_title &"\files\temp\"
sourcepath	= "D:\solution\"& site_title &"\files\company\"	' ��� �ΰ� ���� ��ġ


Dim targetpath, datepath
'datepath	= Left(Replace(FormatDateTime(Now(), 2),"-",""), 6)	' ÷������ �� ���� ���� �и� ����
targetpath	= sourcepath '& datepath & "\"


Dim objFS
Set objFS = CreateObject("Scripting.FileSystemObject")


Dim Post, UploadedFile
Dim fileExtension, fileSize, oriFileName
Dim AllowExtension, intIndex
Dim maxFileSize


'-- ÷������ ���ε�
If InStr(Request.ServerVariables("CONTENT_TYPE"), "multipart/form-data") > 0 Then 
	
	' Perform the upload
	Set Post = Server.CreateObject("ActiveFile.Post")
	On Error Resume Next

		Post.Upload temppath ' ÷������ �ӽ� ������ ����
	
		fileExtension	= ""
		fileSize		= 0
		oriFileName		= ""
		maxFileSize		= 1024 * 1024 * 5 ' �ִ� ���� ���� ���� �뷮 - 5MB ����

				
		Set UploadedFile = Post("uploadLogoFile").File	' �ӽ� ���� ���� ���� ��ü ���� ���� ���

		fileExtension	= UploadedFile.FileExtension	' ���� Ȯ����
		fileSize		= UploadedFile.Size				' ���� ũ��
		oriFileName		= UploadedFile.FileName			' ���ϸ�
		
		pre_file_name	= Post.FormInputs("hid_logoUrl").Value	' ���� �ΰ� �̹��� ���ϸ�
		chkLogoDel		= Post.FormInputs("hidLogoDelYn").Value	' ���� �ΰ� �̹��� ���� ������(Y: ����)


		If oriFileName<>"" Then 

			' ÷������ Ȯ���� üũ
			Dim blnAllowExtension : blnAllowExtension = False 
			AllowExtension = Array("gif", "jpg", "png", "GIF", "JPG", "PNG")
			For intIndex=0 To Ubound(AllowExtension)
				If LCase(fileExtension) = AllowExtension(intIndex) Then 
					blnAllowExtension = True
					Exit For
				End If
			Next


			' 1) ��� ���� Ȯ���ڰ� �ƴ� ��� ����
			If blnAllowExtension = False Then 
				UploadedFile.Delete
				Set UploadedFile = Nothing 
				
				Post.Flush
				Set Post = Nothing 

				Response.Write "<script language=javascript>"&_
					"alert('÷������ ���ε� ����\n- ����� �� ���� ���� ���� �Դϴ�.\n���� Ȯ���ڸ� �ٽ� Ȯ���Ͻð� ���ε� �ٶ��ϴ�.');"&_
					"location.href=history.go(-1);"&_
					"</script>"
				Response.End 
			End If

			' 2) ���� ������ �ʰ� �� ����
			If CLng(fileSize) > maxFileSize Then 			
				UploadedFile.Delete
				Set UploadedFile = Nothing
				
				Post.Flush
				Set Post = Nothing
			
				Response.Write "<script language=javascript>"&_
					"alert('÷������ ���ε� ����\n- ���� ũ�Ⱑ �ʰ��Ǿ����ϴ�.\n���� ����� ������ �� ���ε��� �ּ���.\n(�ִ� 5MB ������ ��� ����)');"&_
					"location.href=history.go(-1);"&_
					"</script>"
				Response.End 
			End If

			' 3) ÷�� ���� ����
			Randomize()
			Dim randomno : randomno = Int(10000* Rnd())
			randomno = Right("0000"&randomno,5)

			' ���ϸ� ����Ͻú���+���� ���� ���·� ��ü
			Dim newFileName : newFileName = Replace(FormatDateTime(Now(), 2),"-","") & Replace(FormatDateTime(Now(), 4),":","") & Right(now(),2) & randomno 

			' 3-1) ���� ������ ���� ��� ����
			If objFs.FolderExists(targetpath) = False Then
				objFs.CreateFolder(targetpath)
			End If
			
			' 3-2) ���� ���� ��ο� ���� ����
			UploadedFile.Copy targetpath & newFileName & "." & fileExtension

			' 3-3) ���� ���� ����
			If pre_file_name <> "" Then
				objFs.DeleteFile sourcepath & pre_file_name
			End If

			' 3-4) DB ����� ���� ���� ����		
			newFile = newFileName & "." & fileExtension
			
		Else 	
			If chkLogoDel="Y" And pre_file_name <> "" Then ' ���� ����ΰ� ������ üũ�� ��� �̹��� ����
				objFs.DeleteFile sourcepath & pre_file_name
				newFile = ""
			Else 
				newFile = pre_file_name	
			End If 
		End If 


		' ��� ���� DB ����
		Dim txtBossName, txtHomePage, txtBizInfo, txtCreateDate, txtEmpCnt

		txtBossName			= Post.FormInputs("txtBossName").Value			' ��ǥ�ڸ�
		txtHomePage			= Post.FormInputs("txtHomePage").Value			' Ȩ������ �ּ�
		txtBizInfo			= Post.FormInputs("txtBizInfo").Value			' �ֿ� �������
		txtEmpCnt			= Post.FormInputs("txtEmpCnt").Value			' �����
		selBizScale			= Post.FormInputs("selBizScale").Value			' �������
		txtCreateDate		= Post.FormInputs("BizCreateDate").Value		' ������
		companyId			= Post.FormInputs("companyId").Value			' ȸ�� ���̵�
		BizNumber			= Post.FormInputs("BizNumber").Value			' ����ڹ�ȣ



		compId				= Post.FormInputs("compId").Value				' ȸ�� ���̵�
		BizNum				= Post.FormInputs("BizNum").Value				' ����ڹ�ȣ
		hidZipCode			= Post.FormInputs("hidZipCode").Value			' ������� ���� ������(addr: �ּ� ����)
		txtCompAddr			= Post.FormInputs("txtCompAddr").Value			' ȸ�� ���̵�
		txtCompAddrDetail	= Post.FormInputs("txtCompAddrDetail").Value	' ����ڹ�ȣ


		txtBossName			= Replace(txtBossName, "'", "''")	' ��ǥ�ڸ�
		txtHomePage			= RTrim(LTrim(Replace(Replace(txtHomePage, "'", "''")," ","")))	' Ȩ������ �ּ�	
		txtBizInfo			= Replace(txtBizInfo, "'", "''")	' �ֿ� �������
		txtEmpCnt			= Replace(txtEmpCnt, ",", "")		' �����

		hidZipCode			= Replace(hidZipCode, "'", "''")		' ȸ������ȣ
		txtCompAddr			= Replace(txtCompAddr, "'", "''")		' ȸ���ּ�
		txtCompAddrDetail	= Replace(txtCompAddrDetail, "'", "''")	' ȸ���ּһ�

		strCompAddrInfo		= txtCompAddr&" "&txtCompAddrDetail


		If InStr(txtHomePage,"http")>0 Then
			txtHomePage	= txtHomePage
		Else
			txtHomePage	= "http://"& txtHomePage
		End If


	ConnectDB DBCon, Application("DBInfo_FAIR")

			On Error Resume Next

			' ȸ������ ����
			sql = "SET NOCOUNT ON;"
			sql = sql &" UPDATE ȸ������ "
			sql = sql &" SET ��ǥ�ڼ���	= '"&txtBossName&"'"
		'	sql = sql &" , ��������	= '"&txtCreateDate&"'"
			sql = sql &" , ����		= '"&selBizScale&"'"
			sql = sql &" , �����		= '"&txtEmpCnt&"'"
			sql = sql &" , Ȩ������	= '"&txtHomePage&"'"
			sql = sql &" , �ֿ�������	= '"&txtBizInfo&"'"
			sql = sql &" , �ΰ�URL	= '"&newFile&"'"
			sql = sql &" , ������		= getdate()"
			sql = sql &" WHERE ȸ����̵� = '"&companyId&"' AND ����ڵ�Ϲ�ȣ = '"&BizNumber&"';"
			DBCon.Execute(sql)	
			
			If err.number <> 0 Then 
				Response.Write "<script language=javascript>"&_
				"alert('������� ���� �� ������ �߻��߽��ϴ�.\n�ٽ� �õ��� �ּ���.');"&_
				"history.go(-1);"&_
				"</script>"
				Response.End 	
			Else 
				Response.Write "<script language=javascript>"&_
				"alert('��������� ���� ����Ǿ����ϴ�.');"&_
				"location.replace('/company/applyjob/whole.asp');"&_
				"</script>"
				Response.End
			End If 

	DisconnectDB DBCon

End If 
%>