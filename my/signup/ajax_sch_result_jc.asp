<%Option Explicit%>
<%
response.expires = -1
response.cachecontrol = "no-cache"
response.charset = "euc-kr"
%>

<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->

<%
Dim g_Debug : g_Debug = False

Dim strType
Dim strHtml : strHtml = ""
'
Dim i,j
Dim kw : kw = unescape(Request("kw"))
Dim idx : idx = Request("idx")
Dim result_obj_id : result_obj_id = Request("result_obj_id")

ConnectDB DBCon, Application("DBInfo_FAIR")



	Dim ArrRs, kw_em1, kw_em2, kw_em3

	Dim param(1)
	param(0)=makeParam("@KW", adVarChar, adParamInput, 100, kw)

	ArrRs = arrGetRsSP(DBCon, "usp_jc_search", param, "", "")

	strHtml = strHtml & "<div class=""sb_area"" style=""display:block;"">"
	strHtml = strHtml & "	<div class=""sb_list"">"
	strHtml = strHtml & "		<ul>"

	If isArray(ArrRs) Then	
		For i=0 To UBound(ArrRs,2)
			kw_em1 = Replace(ArrRs(1,i), kw, "<span>"& kw &"</span>")
			kw_em2 = Replace(ArrRs(3,i), kw, "<span>"& kw &"</span>")
			kw_em3 = Replace(ArrRs(5,i), kw, "<span>"& kw &"</span>")

			strHtml = strHtml & "			<li>"
			strHtml = strHtml & "				<a href=""javascript:;"" onclick=""javascript:textIn(this, '" & ArrRs(5,i) & "', '" & result_obj_id & "', '" & ArrRs(4,i) & "');"">" & kw_em1 & " > " & kw_em2 & " > " & kw_em3 & "</a>"
			strHtml = strHtml & "			</li>"
		Next
	End If

	strHtml = strHtml & "		</ul>"
	strHtml = strHtml & "	</div>"
	strHtml = strHtml & "	<div class=""sb_btm"">"
	strHtml = strHtml & "		<button type=""button"" class=""sch_close"" onclick=""javascript:$('.sb_area').hide();"">´Ý±â</button>"
	strHtml = strHtml & "	</div>"	
	strHtml = strHtml & "</div>"



DisconnectDB DBCon

Response.Write strHtml
%>