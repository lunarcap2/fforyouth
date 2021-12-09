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

	Dim apply_num, acco_chk, acco_textarea, acco_textarea_len, jid, rtn_value
	
	apply_num			= Request("_apply_num")
	acco_chk			= Request("_acco_chk")
	acco_textarea		= unescape(Request.form("_acco_textarea"))
	acco_textarea_len	= Replace(Len(acco_textarea),0,4)
	jid					= Request("_jid")

	ConnectDB DBCon, Application("DBInfo_FAIR")

	ReDim param(4)
	param(0) = makeParam("@apply_num", adInteger, adParamInput, 4, apply_num)
	param(1) = makeParam("@acco_chk", adChar, adParamInput, 1, acco_chk)
	param(2) = makeParam("@acco_textarea", adLongVarChar, adParamInput, acco_textarea_len, acco_textarea)
	param(3) = makeParam("@jid", adInteger, adParamInput, 4, jid)
	param(4) = makeParam("@rtn", adInteger, adParamOutput, 4 , 0)

	Call execSP(DBCon, "usp_기업서비스_면접배정_결과등록", param, "", "")

	rtn_value = getParamOutputValue(param, "@rtn")

	Response.write rtn_value										

	DisconnectDB DBCon
%>