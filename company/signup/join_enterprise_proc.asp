<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"-->
<!--#include virtual="/wwwconf/function/library/KISA_SHA256.asp"-->
<%
'--------------------------------------------------------------------
'   Comment		: 기업회원 가입
' 	History		: 2020-04-24, 이샛별 
'---------------------------------------------------------------------
Session.CodePage  = 949			'한글
Response.CharSet  = "euc-kr"	'한글
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1


Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

Dim txtCompNum, compno_check, txtEmpCnt, selCompType, txtCompName, txtBossName, hidZipCode, txtCompAddr, txtCompAddrDetail
txtId, txtPass, txtName, txtEmail, chkAgrMail, txtPhone, chkAgrSms, encPass, len_txtPhone, strPhone


txtCompNum	= Request("txtCompNum")		' 사업자번호


compno_check		= Request("compno_check")	' 기업정보 수기 등록 체크 구분자(0: 신용평가사 회사정보 존재 X, 1: 신용평가사 회사정보 존재 O)
txtEmpCnt			= Request("txtEmpCnt")		' 사원수
selCompType			= Request("selCompType")	' 기업형태
txtCompName			= Replace(Request("txtCompName"), "'", "''")		' 기업명
txtBossName			= Replace(Request("txtBossName"), "'", "''")		' 대표자명
hidZipCode			= Replace(Request("hidZipCode"), "'", "''")			' 회사우편번호
txtCompAddr			= Replace(Request("txtCompAddr"), "'", "''")		' 회사주소
txtCompAddrDetail	= Replace(Request("txtCompAddrDetail"), "'", "''")	' 회사주소상세

txtId				= Replace(Request("txtId"), "'", "''")		' 아이디
txtPass				= Replace(Request("txtPass"), "'", "''")	' 비밀번호	
txtName				= Replace(Request("txtName"), "'", "''")	' 이름
txtEmail			= RTrim(LTrim(LCase(Replace(Request("txtEmail"), " ", ""))))	' 이메일
chkAgrMail			= Request("chkAgrMail")		' 홍보성 메일 수신 동의
txtPhone			= Request("txtPhone")		' 휴대폰번호
chkAgrSms			= Request("chkAgrSms")		' 홍보성 문자 수신 동의


encPass = SHA256_Encrypt(txtPass)	' 비번 암호화(sha256 방식)

' 연락처에 하이픈 누락된 경우 강제 설정
If InStr(txtPhone,"-")=0 Then 
	len_txtPhone	= Len(txtPhone)
	strPhone		= Left(txtPhone,3)&"-"&Mid(txtPhone,4,len_txtPhone-7)&"-"&Right(txtPhone,4)
Else 
	strPhone		= txtPhone
End If 


' 정상적인 경로로 이동하지 않은 경우 회원가입 화면으로 리턴
If Len(txtId) = 0 Or Len(txtPass) = 0 Or Len(txtCompNum) = 0 Then Response.Write "<meta http-equiv='refresh' content='0; url=http://" & Request.ServerVariables("SERVER_NAME") & "/company/signup/join.asp'>"
	

ConnectDB DBCon, Application("DBInfo_FAIR")


ConnectDB DBCon2, Application("DBInfo")
' 사업자등록번호로 신용평가기관 제공 기업정보 인증이 완료된 경우 연관 값 설정
If compno_check="1" Then 	
    strSql = "SELECT BizName, BossName, ZipCode, AddrKor, Workforce, BizScale, GoodsName, CreateDate " &_
	          "FROM T_NICE_COMVIEW_NEW WITH(NOLOCK) "&_
	          "WHERE BizRegCode='"& txtCompNum &"'"
	Rs.Open strSql, DBCon2, adOpenForwardOnly, adLockReadOnly, adCmdText
	Dim flagRs : flagRs = False 
	If Rs.eof = False And Rs.bof = False Then
		flagRs		= True 
		BizName		= Rs(0)	' 회사명
		BossName	= Rs(1)	' 대표자명
		ZipCode		= Rs(2)	' 회사우편번호
		AddrKor		= Rs(3)	' 회사주소
		Workforce	= Rs(4)	' 사원수
		BizScale	= Rs(5)	' 기업형태
		GoodsName	= Rs(6)	' 주요 사업내용
		CreateDate	= Rs(7) ' 설립일
	End If
	
	txtCompName = BizName
	txtBossName	= BossName
	hidZipCode	= ZipCode
	txtCompAddr	= AddrKor
	txtEmpCnt	= Workforce
	selCompType	= BizScale
Else 
	txtCompName = txtCompName
	txtBossName	= txtBossName
	hidZipCode	= hidZipCode
	txtCompAddr	= txtCompAddr&" "&txtCompAddrDetail
	txtEmpCnt	= txtEmpCnt
	selCompType	= selCompType
End If 
DisconnectDB DBCon2

		

' 입력 아이디 중복 체크
SpName="usp_ID_CheckAll"
	Dim chkparam(1)
	chkparam(0)=makeParam("@user_id", adVarChar, adParamInput, 20, txtId)
	chkparam(1)=makeParam("@rtn", adChar, adParamOutput, 1, "")

	Call execSP(DBCon, SpName, chkparam, "", "")

	rsltCmt = getParamOutputValue(chkparam, "@rtn")



If rsltCmt = "O" Then ' 입력한 아이디로 기존 가입된 정보가 없으면 회원 가입

		' 회사정보 등록
		sql = "SET NOCOUNT ON;"
		sql = sql &" INSERT INTO 회사정보 ("
		sql = sql &" 회사명, 대표자성명, 사업자등록번호, 우편번호, 주소, 주요사업내용, 사원수, 형태, 회사아이디, 암호화_비밀번호, 담당자성명, 전자우편, 담당자휴대폰, 이벤트홍보메일, SMS수신, 설립연도, 사이트구분, 가입사이트구분코드, 회사등급, 등록일, 수정일"
		sql = sql &" ) VALUES ("
		sql = sql &" '"&txtCompName&"', '"&txtBossName&"', '"&txtCompNum&"', '"&hidZipCode&"', '"&txtCompAddr&"', '"&GoodsName&"', '"&txtEmpCnt&"', '"&selCompType&"', '"&txtId&"', '"&encPass&"', '"&txtName&"', '"&txtEmail&"', '"&strPhone&"', '"&chkAgrMail&"', '"&chkAgrSms&"', '" & CreateDate & "', 'W', '2', 'B', getdate(), getdate()"
		sql = sql &" );"
		DBCon.Execute(sql)

		' 신평사 제공 기업정보가 없을 경우 수기 등록 > 기업정보 상세 페이지 관련 이슈로 미사용, 신평사에 등록된 기업정보가 있어야만 회원가입 가능
		If compno_check="0" Then 
			sql2 = "SET NOCOUNT ON;"
			sql2 = sql2 &" INSERT INTO 회사정보_수기등록 ("
			sql2 = sql2 &" 회사명, 대표자명, 사업자등록번호, 우편번호, 회사주소, 사원수, 기업형태"
			sql2 = sql2 &" ) VALUES ("
			sql2 = sql2 &" '"&txtCompName&"', '"&txtBossName&"', '"&txtCompNum&"', '"&hidZipCode&"', '"&txtCompAddr&"', '"&txtEmpCnt&"', '"&selCompType&"'"
			sql2 = sql2 &" );"
			DBCon.Execute(sql2)
		End If 

		DisconnectDB DBCon

	
'	If sp_rtn = "O" Then	' 정상 가입 완료 시 자동로그인 처리
		'#### 기업회원정보 쿠키 할당
		Response.Cookies(site_code & "WKC_F")("comid")		= txtId
		Response.Cookies(site_code & "WKC_F")("comname")	= txtCompName
		Response.Cookies(site_code & "WKC_F")("comemail")	= txtEmail
		Response.Cookies(site_code & "WKC_F").Domain		= "career.co.kr"
		
		' 인트로 유입 경로에 따라 채용관 연결 아이콘 제어(현재위치 - W: 일경험, D: 디지털)
		Dim set_url

		set_url = "location.href='/default.asp';"

		Response.Write "<script language=javascript>"&_
			"alert('기업회원 가입이 완료되었습니다.');"&_
			set_url &_
			"</script>"
		Response.End 
'	Else ' 회원 정보 저장 중 오류 발생 리턴
'		Response.Write "<script language=javascript>"&_
'		 "alert('회원가입 중 오류가 발생했습니다.\n다시 시도해 주세요.');"&_
'		"location.href='http://hkpartner.career.co.kr/company/signup/join.asp';"&_
'		"</script>"
'		response.End 
'	End If

Else	' 입력한 아이디로 가입된 정보가 존재할 경우 회원 가입 페이지 리턴
	Response.Write "<script language=javascript>"&_
		"alert('입력하신 아이디로 가입된 정보가 존재합니다.\n다른 아이디로 다시 시도해 주세요.');"&_
		"location.href='/company/signup/join.asp';"&_
		"</script>"
	Response.End 
End If 
%>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>