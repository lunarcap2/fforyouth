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

	Dim com_id, rece_type, rece_sch, rece_con, rtn_value
	
	com_id		= Request("comid")
	rece_type	= Request("rece_type")
	rece_sch	= Request("rece_sch")
	rece_con	= unescape(Request.form("rece_con"))

	ConnectDB DBCon, Application("DBInfo_FAIR")

	ReDim param(4)
	param(0) = makeParam("@comid", adVarChar, adParamInput, 50, com_id)
	param(1) = makeParam("@rece_type", adVarChar, adParamInput, 50, rece_type)
	param(2) = makeParam("@rece_sch", adChar, adParamInput, 1, rece_sch)
	param(3) = makeParam("@rece_con", adVarChar, adParamInput, 5000, rece_con)
	param(4) = makeParam("@rtn", adInteger, adParamOutput, 4 , 0)

	Call execSP(DBCon, "USP_APPLY_RESULT_SAVECON", param, "", "")

	rtn_value = getParamOutputValue(param, "@rtn")

	Response.write rtn_value										

	DisconnectDB DBCon
%>