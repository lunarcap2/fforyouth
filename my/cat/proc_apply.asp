<%
	Option Explicit

	Response.CacheControl = "no-cache"
	Response.AddHeader "Pragma", "no-cache"
	Response.Expires = -1
	Response.Charset = "euc-kr"
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/inc/db/DBConnection.asp"-->

<%
Dim hdnGubun, hdnSiteGubun, hdnUserId, hdnUserIp
hdnGubun		= Request("hdnGubun")		'OCI:�μ� / OAT:����
hdnSiteGubun	= Request("hdnSiteGubun")	'CAREER
hdnUserId		= Request("hdnUserId")
hdnUserIp		= Request("hdnUserIp")


ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim tableNm, strSql, rtn

	ReDim parameter(2)
	parameter(0)    = makeParam("@����Ʈ����", adVarChar, adParamInput, 20, hdnSiteGubun)
	parameter(1)    = makeParam("@���ξ��̵�", adVarChar, adParamInput, 20, hdnUserId)
	parameter(2)    = makeParam("@��Ͼ�����", adVarChar, adParamInput, 23, hdnUserIp)
	
	If hdnGubun = "OCI" Then
		Call execSP(DBCon,"usp_�����μ��˻�_�����߰�",parameter, "", "")

		tableNm	= "tbl_�����μ��˻�_���ηα�"
	Else
		Call execSP(DBCon,"usp_���������˻�_�����߰�",parameter, "", "")

		tableNm	= "tbl_���������˻�_���ηα�"
	End If

	strSql = "SELECT COUNT(���ηα׹�ȣ) FROM " & tableNm & " WITH(NOLOCK)"
	rtn = arrGetRsSql(DBCon, strSql, "", "")(0,0)

	If rtn > 0 Then
		Response.write "<script type='text/javascript'>"
		Response.write "alert('��û�� �Ϸ�Ǿ����ϴ�.\n�˻���Ȳ���� Ȯ���Ͻ� �� �ֽ��ϴ�.');"
		Response.write "location.href='./cat_info.asp';"
		Response.write "</script>"
		Response.end
	Else
		Response.write "<script type='text/javascript'>"
		Response.write "alert('�ٽ� �õ��� �ֽñ� �ٶ��ϴ�.');"
		Response.write "location.href='./cat_info.asp';"
		Response.write "</script>"
		Response.end
	End If

DisconnectDB DBCon
%>