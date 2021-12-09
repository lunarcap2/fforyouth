<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: 기업회원 > 채용공고 관리> 기업정보 수정
' 	History		: 2020-05-11, 이샛별 
'---------------------------------------------------------------------
Response.CacheControl = "no-cache"
Response.AddHeader "Pragma", "no-cache"
Response.Expires = -1
Response.Charset = "euc-kr"


Dim temppath, sourcepath
temppath	= "D:\solution\"& site_title &"\files\temp\"
sourcepath	= "D:\solution\"& site_title &"\files\company\"	' 기업 로고 저장 위치


Dim targetpath, datepath
'datepath	= Left(Replace(FormatDateTime(Now(), 2),"-",""), 6)	' 첨부파일 월 단위 폴더 분리 저장
targetpath	= sourcepath '& datepath & "\"


Dim objFS
Set objFS = CreateObject("Scripting.FileSystemObject")


Dim Post, UploadedFile
Dim fileExtension, fileSize, oriFileName
Dim AllowExtension, intIndex
Dim maxFileSize


'-- 첨부파일 업로드
If InStr(Request.ServerVariables("CONTENT_TYPE"), "multipart/form-data") > 0 Then 
	
	' Perform the upload
	Set Post = Server.CreateObject("ActiveFile.Post")
	On Error Resume Next

		Post.Upload temppath ' 첨부파일 임시 폴더에 저장
	
		fileExtension	= ""
		fileSize		= 0
		oriFileName		= ""
		maxFileSize		= 1024 * 1024 * 5 ' 최대 저장 가능 파일 용량 - 5MB 제한

				
		Set UploadedFile = Post("uploadLogoFile").File	' 임시 저장 폴더 포함 전체 파일 저장 경로

		fileExtension	= UploadedFile.FileExtension	' 파일 확장자
		fileSize		= UploadedFile.Size				' 파일 크기
		oriFileName		= UploadedFile.FileName			' 파일명
		
		pre_file_name	= Post.FormInputs("hid_logoUrl").Value	' 기존 로고 이미지 파일명
		chkLogoDel		= Post.FormInputs("hidLogoDelYn").Value	' 기존 로고 이미지 삭제 구분자(Y: 제거)


		If oriFileName<>"" Then 

			' 첨부파일 확장자 체크
			Dim blnAllowExtension : blnAllowExtension = False 
			AllowExtension = Array("gif", "jpg", "png", "GIF", "JPG", "PNG")
			For intIndex=0 To Ubound(AllowExtension)
				If LCase(fileExtension) = AllowExtension(intIndex) Then 
					blnAllowExtension = True
					Exit For
				End If
			Next


			' 1) 등록 가능 확장자가 아닐 경우 리턴
			If blnAllowExtension = False Then 
				UploadedFile.Delete
				Set UploadedFile = Nothing 
				
				Post.Flush
				Set Post = Nothing 

				Response.Write "<script language=javascript>"&_
					"alert('첨부파일 업로드 실패\n- 등록할 수 없는 파일 형식 입니다.\n파일 확장자를 다시 확인하시고 업로드 바랍니다.');"&_
					"location.href=history.go(-1);"&_
					"</script>"
				Response.End 
			End If

			' 2) 파일 사이즈 초과 시 리턴
			If CLng(fileSize) > maxFileSize Then 			
				UploadedFile.Delete
				Set UploadedFile = Nothing
				
				Post.Flush
				Set Post = Nothing
			
				Response.Write "<script language=javascript>"&_
					"alert('첨부파일 업로드 실패\n- 파일 크기가 초과되었습니다.\n파일 사이즈를 조정한 후 업로드해 주세요.\n(최대 5MB 까지만 등록 가능)');"&_
					"location.href=history.go(-1);"&_
					"</script>"
				Response.End 
			End If

			' 3) 첨부 파일 저장
			Randomize()
			Dim randomno : randomno = Int(10000* Rnd())
			randomno = Right("0000"&randomno,5)

			' 파일명 등록일시분초+랜덤 숫자 형태로 교체
			Dim newFileName : newFileName = Replace(FormatDateTime(Now(), 2),"-","") & Replace(FormatDateTime(Now(), 4),":","") & Right(now(),2) & randomno 

			' 3-1) 저장 폴더가 없을 경우 생성
			If objFs.FolderExists(targetpath) = False Then
				objFs.CreateFolder(targetpath)
			End If
			
			' 3-2) 연관 폴더 경로에 파일 저장
			UploadedFile.Copy targetpath & newFileName & "." & fileExtension

			' 3-3) 기존 파일 삭제
			If pre_file_name <> "" Then
				objFs.DeleteFile sourcepath & pre_file_name
			End If

			' 3-4) DB 저장용 파일 정보 설정		
			newFile = newFileName & "." & fileExtension
			
		Else 	
			If chkLogoDel="Y" And pre_file_name <> "" Then ' 기존 기업로고 삭제를 체크한 경우 이미지 제거
				objFs.DeleteFile sourcepath & pre_file_name
				newFile = ""
			Else 
				newFile = pre_file_name	
			End If 
		End If 


		' 기업 정보 DB 저장
		Dim txtBossName, txtHomePage, txtBizInfo, txtCreateDate, txtEmpCnt

		txtBossName			= Post.FormInputs("txtBossName").Value			' 대표자명
		txtHomePage			= Post.FormInputs("txtHomePage").Value			' 홈페이지 주소
		txtBizInfo			= Post.FormInputs("txtBizInfo").Value			' 주요 사업내용
		txtEmpCnt			= Post.FormInputs("txtEmpCnt").Value			' 사원수
		selBizScale			= Post.FormInputs("selBizScale").Value			' 기업형태
		txtCreateDate		= Post.FormInputs("BizCreateDate").Value		' 설립일
		companyId			= Post.FormInputs("companyId").Value			' 회사 아이디
		BizNumber			= Post.FormInputs("BizNumber").Value			' 사업자번호



		compId				= Post.FormInputs("compId").Value				' 회사 아이디
		BizNum				= Post.FormInputs("BizNum").Value				' 사업자번호
		hidZipCode			= Post.FormInputs("hidZipCode").Value			' 기업정보 수정 구분자(addr: 주소 변경)
		txtCompAddr			= Post.FormInputs("txtCompAddr").Value			' 회사 아이디
		txtCompAddrDetail	= Post.FormInputs("txtCompAddrDetail").Value	' 사업자번호


		txtBossName			= Replace(txtBossName, "'", "''")	' 대표자명
		txtHomePage			= RTrim(LTrim(Replace(Replace(txtHomePage, "'", "''")," ","")))	' 홈페이지 주소	
		txtBizInfo			= Replace(txtBizInfo, "'", "''")	' 주요 사업내용
		txtEmpCnt			= Replace(txtEmpCnt, ",", "")		' 사원수

		hidZipCode			= Replace(hidZipCode, "'", "''")		' 회사우편번호
		txtCompAddr			= Replace(txtCompAddr, "'", "''")		' 회사주소
		txtCompAddrDetail	= Replace(txtCompAddrDetail, "'", "''")	' 회사주소상세

		strCompAddrInfo		= txtCompAddr&" "&txtCompAddrDetail


		If InStr(txtHomePage,"http")>0 Then
			txtHomePage	= txtHomePage
		Else
			txtHomePage	= "http://"& txtHomePage
		End If


	ConnectDB DBCon, Application("DBInfo_FAIR")

			On Error Resume Next

			' 회사정보 수정
			sql = "SET NOCOUNT ON;"
			sql = sql &" UPDATE 회사정보 "
			sql = sql &" SET 대표자성명	= '"&txtBossName&"'"
		'	sql = sql &" , 설립연도	= '"&txtCreateDate&"'"
			sql = sql &" , 형태		= '"&selBizScale&"'"
			sql = sql &" , 사원수		= '"&txtEmpCnt&"'"
			sql = sql &" , 홈페이지	= '"&txtHomePage&"'"
			sql = sql &" , 주요사업내용	= '"&txtBizInfo&"'"
			sql = sql &" , 로고URL	= '"&newFile&"'"
			sql = sql &" , 수정일		= getdate()"
			sql = sql &" WHERE 회사아이디 = '"&companyId&"' AND 사업자등록번호 = '"&BizNumber&"';"
			DBCon.Execute(sql)	
			
			If err.number <> 0 Then 
				Response.Write "<script language=javascript>"&_
				"alert('기업정보 수정 중 오류가 발생했습니다.\n다시 시도해 주세요.');"&_
				"history.go(-1);"&_
				"</script>"
				Response.End 	
			Else 
				Response.Write "<script language=javascript>"&_
				"alert('기업정보가 정상 변경되었습니다.');"&_
				"location.replace('/company/applyjob/whole.asp');"&_
				"</script>"
				Response.End
			End If 

	DisconnectDB DBCon

End If 
%>