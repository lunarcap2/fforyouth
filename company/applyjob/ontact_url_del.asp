<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<%
'--------------------------------------------------------------------
'   Comment		: 화상면접 url 삭제
' 	History		: 2020-07-07, 이샛별 
'---------------------------------------------------------------------
Session.CodePage  = 949			'한글
Response.CharSet  = "euc-kr"	'한글
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1

Dim bizId	: bizId		= Request("bizid")		' 기업회원 아이디
Dim hostId	: hostId	= Request("id")			' 화상면접용 회사 아이디
Dim urlCd	: urlCd		= Request("urlcode")	' 화상면접용 URL 코드	


If hostId = "" Or urlCd = "" Then ' 전달된 정보가 없을 경우(화상면접용 회사아이디/URL코드) 
	Response.write "X"
	Response.End
End If 

ConnectDB DBCon, Application("DBInfo_FAIR")
	sql = "DELETE FROM 면접배정_면접관URL WHERE 화상면접용회사아이디='"&hostId&"' AND URL코드='"&urlCd&"' " 
	DBCon.Execute(sql)
DisconnectDB DBCon

Response.write "O"
%>
