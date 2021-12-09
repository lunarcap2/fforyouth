<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
	Call FN_LoginLimit("2")	'기업회원 허용
	Dim jid, applyno
	jid = request("jid")
	applyno = request("applyno")

	If jid = "" Or applyno = "" Then
		Response.write "-1"
		Response.End
	End If

	ConnectDB DBCon, Application("DBInfo_FAIR")
		'면접정보 삭제
		ReDim params(1)
		params(0) = makeParam("@JOBS_ID", adInteger, adParamInput, 4, jid)
		params(1) = makeParam("@APPLY_NO", adVarChar, adParamInput, 20, applyno)
		
		Call execSP(DBCon, "usp_기업서비스_면접배정_삭제", params, "", "")
	DisconnectDB DBCon
	Response.write "1"
%>