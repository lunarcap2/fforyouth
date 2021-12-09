<%
Option Explicit
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
g_debug= false

Dim jid, apply_gb

jid = request("jid")
apply_gb = request("apply_gb")

If user_id = "" then
	user_id = "unknown"
End If

Dim spName : spName = "usp_apply_click_log_insert"

ReDim paramInfo(3)

paramInfo(0) = makeparam("@user_id",adVarChar,adParamInput,20,user_id)
paramInfo(1) = makeparam("@jid",adInteger,adParamInput,4,jid)
paramInfo(2) = makeparam("@apply_gb",adChar,adParamInput,1,apply_gb)
paramInfo(3) = makeparam("@site_gb",adChar,adParamInput,1,"W")

ConnectDB dbCon, Application("DBInfo_FAIR")
	Call execSP(dbCon, spName, paramInfo, "", "")
DisconnectDB dbCon
%>
