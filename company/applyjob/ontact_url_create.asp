<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<%
'--------------------------------------------------------------------
'   Comment		: 화상면접 url 생성
' 	History		: 2020-07-06, 이샛별 
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


Dim splUrlCd : splUrlCd = Split(urlCd, "sdate")
Dim jid : jid	= splUrlCd(0)

Dim interviewDt		: interviewDt		= splUrlCd(1)
Dim splInterviewDt	: splInterviewDt	= Split(interviewDt, "stime") 
Dim interviewDay	: interviewDay		= splInterviewDt(0)	' 면접일
Dim interviewTime	: interviewTime		= splInterviewDt(1)	' 면접시간코드

interviewDay = Left(interviewDay,4)&"-"&Mid(interviewDay,5,2)&"-"&Right(interviewDay,2) 


ConnectDB DBCon, Application("DBInfo_FAIR")
	
	' 면접관용 URL 생성 정보 저장
	Dim hostUrl : hostUrl = "https://vc.dial070.co.kr/"&urlCd&"?st="&serviceType_maltalk&"&id="&hostId&"&name="&comname
	sql = "SET NOCOUNT ON;"
	sql = sql &" INSERT INTO 면접배정_면접관URL ("
	sql = sql &" 채용등록번호, 면접일, 면접시간, URL코드, 면접관URL, 회사아이디, 화상면접용회사아이디, API전송여부 "
	sql = sql &" ) VALUES ("
	sql = sql &" '"&jid&"', '"&interviewDay&"', '"&interviewTime&"', '"&urlCd&"', '"&hostUrl&"', '"&bizId&"', '"&hostId&"', 'Y'"
	sql = sql &" );"
	DBCon.Execute(sql)

DisconnectDB DBCon

Response.write "O"
%>
