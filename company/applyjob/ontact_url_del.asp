<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/common/common.asp"--> 
<%
'--------------------------------------------------------------------
'   Comment		: ȭ����� url ����
' 	History		: 2020-07-07, �̻��� 
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

ConnectDB DBCon, Application("DBInfo_FAIR")
	sql = "DELETE FROM ��������_������URL WHERE ȭ�������ȸ����̵�='"&hostId&"' AND URL�ڵ�='"&urlCd&"' " 
	DBCon.Execute(sql)
DisconnectDB DBCon

Response.write "O"
%>
