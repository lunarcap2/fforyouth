<%
	 Response.CharSet="euc-kr"
     Session.codepage="949"
     Response.codepage="949"
     Response.ContentType="text/html;charset=euc-kr"
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim rid, rtn_value

	rid		= Request("rid")

	ConnectDB DBCon, Application("DBInfo_FAIR")

	SpName="USP_BIZSERVICE_SCRAP_RESUME_DELETE"

	ReDim param(3)
	param(0) = makeParam("@BizID", adVarChar, adParamInput, 20, comid)
	param(1) = makeParam("@Gubun", adVarChar, adParamInput, 1, "1")
	param(2) = makeParam("@Rids", adVarChar, adParamInput, 500, rid)
	param(3) = makeParam("@Rtn", adInteger, adParamOutput, 4, 0)

	Call execSP(DBCon, SpName, param, "", "")

	rtn_value = getParamOutputValue(param, "@Rtn")

	Response.write rtn_value	

	DisconnectDB DBCon
%>