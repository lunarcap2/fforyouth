<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<%
'--------------------------------------------------------------------
'   Comment		: ȭ����� url ����
' 	History		: 2020-07-06, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1


Dim bizId	: bizId		= Request("bizid")		' ���ȸ�� ���̵�
Dim hostId	: hostId	= Request("id")			' ȭ������� ȸ�� ���̵�
Dim urlCd	: urlCd		= Request("urlcode")	' ȭ������� URL �ڵ�	


If hostId = "" Or urlCd = "" Then ' ���޵� ������ ���� ���(ȭ������� ȸ����̵�/URL�ڵ�) 
	Response.write "X"
	Response.End
End If 


Dim splUrlCd : splUrlCd = Split(urlCd, "sdate")
Dim jid : jid	= splUrlCd(0)

Dim interviewDt		: interviewDt		= splUrlCd(1)
Dim splInterviewDt	: splInterviewDt	= Split(interviewDt, "stime") 
Dim interviewDay	: interviewDay		= splInterviewDt(0)	' ������
Dim interviewTime	: interviewTime		= splInterviewDt(1)	' �����ð��ڵ�

interviewDay = Left(interviewDay,4)&"-"&Mid(interviewDay,5,2)&"-"&Right(interviewDay,2) 


ConnectDB DBCon, Application("DBInfo_FAIR")
	
	' �������� URL ���� ���� ����
	Dim hostUrl : hostUrl = "https://vc.dial070.co.kr/"&urlCd&"?st="&serviceType_maltalk&"&id="&hostId&"&name="&comname
	sql = "SET NOCOUNT ON;"
	sql = sql &" INSERT INTO ��������_������URL ("
	sql = sql &" ä���Ϲ�ȣ, ������, �����ð�, URL�ڵ�, ������URL, ȸ����̵�, ȭ�������ȸ����̵�, API���ۿ��� "
	sql = sql &" ) VALUES ("
	sql = sql &" '"&jid&"', '"&interviewDay&"', '"&interviewTime&"', '"&urlCd&"', '"&hostUrl&"', '"&bizId&"', '"&hostId&"', 'Y'"
	sql = sql &" );"
	DBCon.Execute(sql)

DisconnectDB DBCon

Response.write "O"
%>
