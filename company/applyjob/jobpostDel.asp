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

	Dim mode, jid
	mode = Request("mode")
	jid = Request("jid")

	If mode = "" Or jid = "" Then
		Response.write "0"
		Response.End
	End If 

	ConnectDB DBCon, Application("DBInfo_FAIR")
		Dim SpName
		
		If mode = "ing" Then 
			SpName = "채용정보_삭제"
			ReDim param(1)
			param(0) = makeParam("@id_num", adInteger, adParamInput, 4, jid)
			param(1) = makeParam("@adm_id", adVarChar, adParamInput, 20, "")

			Call execSP(DBCon, SpName, param, "", "")
		ElseIf mode = "cl" Then 
			SpName = "마감채용정보_삭제"
			ReDim param(0)
			param(0) = makeParam("@id_num", adInteger, adParamInput, 4, jid)

			Call execSP(DBCon, SpName, param, "", "")
		End If 

		If mode = "ing" Then 
			Call setCookie(site_code & "WKC_F", "COMMON1", "career.co.kr", comJobCnt - 1)
		End If 

		Response.write "1"
	DisconnectDB DBCon
%>