<%
	session.codepage = "65001"
	response.expires = -1
	response.cachecontrol = "no-cache"
	response.charset = "utf-8"
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim rid

	rid = request("rid")

	ConnectDB DBCon, Application("DBInfo_FAIR")

	SpName="usp_이력서_기본이력서변경"

	ReDim param(2)
	param(0) = makeParam("@rid", adInteger, adParamInput, 10, rid)
	param(1) = makeParam("@userid", adVarChar, adParamInput, 20, user_id)
	param(2) = makeParam("@errMsg", adVarChar, adParamOutput, 64, "")
	
	Call execSP(DBCon, SpName, param, "", "")

	rtn = getParamOutputValue(param, "@errMsg")

	Response.write rtn
	
	DisconnectDB DBCon
%>