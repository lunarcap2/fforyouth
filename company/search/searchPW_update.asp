<%
	session.codepage = "65001"
	response.expires = -1
	response.cachecontrol = "no-cache"
	response.charset = "utf-8"
%>

<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/wwwconf/function/library/KISA_SHA256.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim comp_type, com_id, newpw, rtn_value
	
	comp_type	= Request("comp_type")
    com_id		= Request("com_id")
    newpw		= Request("newpw")
	
	If com_id = "" Then 
		Response.write "<script language=""javascript"">location.href='/company/search/searchPW.asp';</script>"
	Else		
		ConnectDB DBCon, Application("DBInfo_FAIR")

		SpName="USP_COMPANY_PW_UPDATE"
		
		ReDim param(3)
		param(0) = makeParam("@Type", adVarChar, adParamInput, 2, comp_type)
        param(1) = makeParam("@NewPW", adVarChar, adParamInput, 100, SHA256_Encrypt(newpw))
		param(2) = makeParam("@BizID", adVarChar, adParamInput, 50, com_id)        
        param(3) = makeParam("@RTN", adInteger, adParamOutput, 1, "")

		Call execSP(DBCon, SpName, param, "", "")

		rtn_value = getParamOutputValue(param, "@RTN")

		Response.write rtn_value		
	End If
	
	DisconnectDB DBCon
%>