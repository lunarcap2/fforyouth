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
hdnGubun		= Request("hdnGubun")		'OCI:인성 / OAT:적성
hdnSiteGubun	= Request("hdnSiteGubun")	'CAREER
hdnUserId		= Request("hdnUserId")
hdnUserIp		= Request("hdnUserIp")


ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim tableNm, strSql, rtn

	ReDim parameter(2)
	parameter(0)    = makeParam("@사이트구분", adVarChar, adParamInput, 20, hdnSiteGubun)
	parameter(1)    = makeParam("@개인아이디", adVarChar, adParamInput, 20, hdnUserId)
	parameter(2)    = makeParam("@등록아이피", adVarChar, adParamInput, 23, hdnUserIp)
	
	If hdnGubun = "OCI" Then
		Call execSP(DBCon,"usp_개인인성검사_서비스추가",parameter, "", "")

		tableNm	= "tbl_개인인성검사_개인로그"
	Else
		Call execSP(DBCon,"usp_개인적성검사_서비스추가",parameter, "", "")

		tableNm	= "tbl_개인적성검사_개인로그"
	End If

	strSql = "SELECT COUNT(개인로그번호) FROM " & tableNm & " WITH(NOLOCK)"
	rtn = arrGetRsSql(DBCon, strSql, "", "")(0,0)

	If rtn > 0 Then
		Response.write "<script type='text/javascript'>"
		Response.write "alert('신청이 완료되었습니다.\n검사현황에서 확인하실 수 있습니다.');"
		Response.write "location.href='./cat_info.asp';"
		Response.write "</script>"
		Response.end
	Else
		Response.write "<script type='text/javascript'>"
		Response.write "alert('다시 시도해 주시기 바랍니다.');"
		Response.write "location.href='./cat_info.asp';"
		Response.write "</script>"
		Response.end
	End If

DisconnectDB DBCon
%>