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


ConnectDB DBCon, Application("DBInfo_FAIR")

	' ��� ���� DB ����
	Dim compId, BizNum, EditType
	compId				= Request("compId")				' ȸ�� ���̵�
	BizNum				= Request("BizNum")				' ����ڹ�ȣ
	EditType			= Request("EditType")			' ������� ���� ������(addr: �ּ� ����)
	hidZipCode			= Request("hidZipCode")			' ȸ������ȣ
	txtCompAddr			= Request("txtCompAddr")		' ȸ���ּ�
	txtCompAddrDetail	= Request("txtCompAddrDetail")	' ȸ���ּһ�

	hidZipCode			= Replace(hidZipCode, "'", "''")		' ȸ������ȣ
	txtCompAddr			= Replace(txtCompAddr, "'", "''")		' ȸ���ּ�
	txtCompAddrDetail	= Replace(txtCompAddrDetail, "'", "''")	' ȸ���ּһ�

	strCompAddrInfo		= txtCompAddr&" "&txtCompAddrDetail


	' ȸ���ּ� ����
	sql = "SET NOCOUNT ON;"
	sql = sql &" UPDATE ȸ������ "
	sql = sql &" SET �����ȣ = '"&hidZipCode&"'"
	sql = sql &" , �ּ�	= '"&strCompAddrInfo&"'"
	sql = sql &" , ������	= getdate()"
	sql = sql &" WHERE ȸ����̵� = '"&compId&"' AND ����ڵ�Ϲ�ȣ = '"&BizNum&"';"
	DBCon.Execute(sql)	
	
	If err.number <> 0 Then 
		Response.Write "<script language=javascript>"&_
		"alert('ȸ�� �ּ� ���� �� ������ �߻��߽��ϴ�.\n�ٽ� �õ��� �ּ���.');"&_
		"history.go(-1);"&_
		"</script>"
		Response.End 	
	Else 
		Response.Write "<script language=javascript>"&_
		"alert('ȸ�� �ּҰ� ���� ����Ǿ����ϴ�.');"&_
		"location.replace('/company/applyjob/whole.asp');"&_
		"</script>"
		Response.End
	End If 

DisconnectDB DBCon
%>