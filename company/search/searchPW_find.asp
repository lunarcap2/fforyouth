<%
	session.codepage = "65001"
	response.expires = -1
	response.cachecontrol = "no-cache"
	response.charset = "utf-8"
%>

<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim comp_type, comp_num, comp_nm, authType, AuthValue, com_id, rtn_value
	
	comp_type	= Request("comp_type")
    comp_num	= Request("comp_num")
    comp_nm		= Request("comp_nm")
    authType	= Request("authType")
    AuthValue	= Request("AuthValue")
    com_id		= Request("com_id")
	
	If comp_nm = "" Then 
		Response.write "<script language=""javascript"">location.href='/company/search/searchPW.asp';</script>"
	Else		
		ConnectDB DBCon, Application("DBInfo_FAIR")

		SpName="USP_COMPANY_FIND_PW"

		ReDim param(5)
		param(0) = makeParam("@Type", adVarChar, adParamInput, 2, comp_type)
		param(1) = makeParam("@BizNum", adChar, adParamInput, 10, comp_num)
		param(2) = makeParam("@ManagerName", adVarChar, adParamInput, 30, comp_nm)
		param(3) = makeParam("@AuthType", adTinyInt, adParamInput, 1, authType)
		param(4) = makeParam("@AuthValue", adVarChar, adParamInput, 100, authValue)
		param(5) = makeParam("@BizID", adVarChar, adParamInput, 50, com_id)

		rtn_value = arrGetRsSP(DBCon, SpName, param, "", "")
		
		If isArray(rtn_value) Then
			Dim i, search_id
			
			For i = 0 to ubound(rtn_value, 2)
				search_id = rtn_value(0,i)
			Next
		End If

		Response.write search_id
	End If
	
	DisconnectDB DBCon
%>