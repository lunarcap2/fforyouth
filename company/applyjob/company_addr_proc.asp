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


ConnectDB DBCon, Application("DBInfo_FAIR")

	' 기업 정보 DB 저장
	Dim compId, BizNum, EditType
	compId				= Request("compId")				' 회사 아이디
	BizNum				= Request("BizNum")				' 사업자번호
	EditType			= Request("EditType")			' 기업정보 수정 구분자(addr: 주소 변경)
	hidZipCode			= Request("hidZipCode")			' 회사우편번호
	txtCompAddr			= Request("txtCompAddr")		' 회사주소
	txtCompAddrDetail	= Request("txtCompAddrDetail")	' 회사주소상세

	hidZipCode			= Replace(hidZipCode, "'", "''")		' 회사우편번호
	txtCompAddr			= Replace(txtCompAddr, "'", "''")		' 회사주소
	txtCompAddrDetail	= Replace(txtCompAddrDetail, "'", "''")	' 회사주소상세

	strCompAddrInfo		= txtCompAddr&" "&txtCompAddrDetail


	' 회사주소 변경
	sql = "SET NOCOUNT ON;"
	sql = sql &" UPDATE 회사정보 "
	sql = sql &" SET 우편번호 = '"&hidZipCode&"'"
	sql = sql &" , 주소	= '"&strCompAddrInfo&"'"
	sql = sql &" , 수정일	= getdate()"
	sql = sql &" WHERE 회사아이디 = '"&compId&"' AND 사업자등록번호 = '"&BizNum&"';"
	DBCon.Execute(sql)	
	
	If err.number <> 0 Then 
		Response.Write "<script language=javascript>"&_
		"alert('회사 주소 변경 중 오류가 발생했습니다.\n다시 시도해 주세요.');"&_
		"history.go(-1);"&_
		"</script>"
		Response.End 	
	Else 
		Response.Write "<script language=javascript>"&_
		"alert('회사 주소가 정상 변경되었습니다.');"&_
		"location.replace('/company/applyjob/whole.asp');"&_
		"</script>"
		Response.End
	End If 

DisconnectDB DBCon
%>