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
	
	Dim rtn, rtn_msg
	Dim mode, jid
	mode = Request("mode")
	jid = Request("jid")

	If mode = "" Or jid = "" Then
		Response.write "0|잘못된 접근입니다."
		Response.End
	End If 

	ConnectDB DBCon, Application("DBInfo_FAIR")
		Dim SpName
		SpName = "USP_BIZSERVICE_JOBPOST_END"

		ReDim param(3)
		param(0) = makeParam("@id_num", adInteger, adParamInput, 4, jid)
		param(1) = makeParam("@adm_id", adVarChar, adParamInput, 20, "")
		param(2) = makeParam("@rtn", adInteger, adParamOutput, 4, "")
		param(3) = makeParam("@rtn_msg", adVarChar, adParamOutput, 200, "")

		Call execSP(DBCon, SpName, param, "", "")
		rtn = getParamOutputValue(param, "@rtn")
		rtn_msg = getParamOutputValue(param, "@rtn_msg")

		If rtn = "1" Then 
			Call setCookie(site_code & "WKC_F", "COMMON1", "career.co.kr", comJobCnt - 1)
		End If 

		Response.write rtn & "|" & rtn_msg
	DisconnectDB DBCon
%>