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

	Dim rid, step, rtn

	rid = request("rid")
	step = request("step")

	ConnectDB DBCon, Application("DBInfo_FAIR")

	SpName="usp_이력서_삭제"

	ReDim param(3)
	param(0) = makeParam("@rid", adInteger, adParamInput, 10, rid)
	param(1) = makeParam("@step", adTinyInt, adParamInput, 30, step)
	param(2) = makeParam("@userid", adVarChar, adParamInput, 20, user_id)
	param(3) = makeParam("@errMsg", adVarChar, adParamOutput, 64, "")
	
	Call execSP(DBCon, SpName, param, "", "")

	rtn = getParamOutputValue(param, "@errMsg")
	
	If rtn = "" And step = "5" Then
		Call setCookie(site_code & "WKP_F", "CK_ResumeCnt", "career.co.kr", CK_ResumeCnt - 1)
	End If

	Response.write rtn
	
	DisconnectDB DBCon
%>