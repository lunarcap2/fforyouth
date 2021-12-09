<%
	session.codepage = "65001"
	response.expires = -1
	response.cachecontrol = "no-cache"
	response.charset = "utf-8"
%>

<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
	Response.AddHeader "P3P", "CP='ALL CURa ADMa DEVa TAIa OUR BUS IND PHY ONL UNI PUR FIN COM NAV INT DEM CNT STA POL HEA PRE LOC OTC'"

	Dim comp_type, comp_num, comp_nm, authType, AuthValue, rtn_value
	
	comp_type	= Request("comp_type")
    comp_num	= Request("comp_num")
    comp_nm		= Request("comp_nm")
    authType	= Request("authType")
    AuthValue	= Request("AuthValue")

	
	If comp_nm = "" Then 
		Response.write "<script language=""javascript"">location.href='/company/search/searchID.asp';</script>"
	Else
		ConnectDB DBCon, Application("DBInfo_FAIR")

		SpName="USP_COMPANY_FIND_ID"

		ReDim param(4)
		param(0) = makeParam("@Type", adVarChar, adParamInput, 2, comp_type)
        param(1) = makeParam("@BizNum", adChar, adParamInput, 10, comp_num)
        param(2) = makeParam("@ManagerName", adVarChar, adParamInput, 30, comp_nm)
        param(3) = makeParam("@AuthType", adTinyInt, adParamInput, 1, authType)
        param(4) = makeParam("@AuthValue", adVarChar, adParamInput, 100, AuthValue)
	
		rtn_value = arrGetRsSP(DBCon, SpName, param, "", "")

		If isArray(rtn_value) Then
			Dim i, search_id, reg_date 
			
			For i = 0 to ubound(rtn_value, 2)
				comp_id = rtn_value(0,i)
				reg_date = rtn_value(1,i)

				Response.write "<li><em>" & comp_id & "</em> (가입일 : <span class='num'>" & Left(reg_date, 10) & "</span>)</li>"
			Next
		Else
			Response.write "<li>가입된 아이디가 없습니다.</li>"
		End If
	End If
	
	DisconnectDB DBCon
%>