<%
	session.codepage = "65001"
	response.expires = -1
	response.cachecontrol = "no-cache"
	response.charset = "utf-8"
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim rid, rtn, strSql
	rid = request("rid")

	ConnectDB DBCon, Application("DBInfo_FAIR")

	strSql = "UPDATE 이력서 SET 수정일 = GETDATE() WHERE 등록번호 = ? AND 개인아이디 = ? "

	ReDim param(1)
	param(0) = makeParam("@rid", adInteger, adParamInput, 10, rid)
	param(1) = makeParam("@userid", adVarChar, adParamInput, 20, user_id)
	
	Call execSqlParam(DBCon, strSql, param, "", "")
	Response.write "1"
	
	DisconnectDB DBCon
%>