<%Option Explicit%>
<%
response.expires = -1
response.cachecontrol = "no-cache"
response.charset = "euc-kr"
%>
<!--#include virtual="/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual="/wwwconf/query_lib/user/ResumeInfo.asp"-->
<%
Dim g_Debug : g_Debug = False

Dim strType
Dim strHtml : strHtml = ""
'
Dim i,j
Dim kw : kw = unescape(Request("kw"))
Dim sGubun : sGubun = Request("sGubun")
Dim idx : idx = Request("idx")
Dim result_obj_id : result_obj_id = Request("result_obj_id")

ConnectDB DBCon, Application("DBInfo")

Dim ArrRs : ArrRs = getSchoolSearch(DBCon, kw, sGubun, "","")
Dim kw_em


strHtml = strHtml & "<div class=""sb_area"" style=""display:block;"">"
strHtml = strHtml & "	<div class=""sb_list"">"
strHtml = strHtml & "		<ul>"

If isArray(ArrRs) Then
	If sGubun = "univ" Then
		For i=0 To UBound(ArrRs,2)
			kw_em = Replace(ArrRs(1,i), kw, "<span>"& kw &"</span>")

			If ArrRs(2,i) = "" Or isNull(ArrRs(2,i)) Then
				strHtml = strHtml & "			<li>"
				strHtml = strHtml & "				<a href=""javascript:;"" onclick=""javascript:textIn(this, '" & ArrRs(1,i) & "', '" & result_obj_id & "');"">" & kw_em & "</a>"
				strHtml = strHtml & "			</li>"
			Else
				strHtml = strHtml & "			<li>"
				strHtml = strHtml & "				<a href=""javascript:;"" onclick=""javascript:textIn(this, '" & ArrRs(1,i) & "', '" & result_obj_id & "');"">" & kw_em & "(" & ArrRs(2,i) & ") " & "</a>"
				strHtml = strHtml & "			</li>"
			End If
		Next
	Else
		For i=0 To UBound(ArrRs,2)
			kw_em = Replace(ArrRs(1,i), kw, "<span>"& kw &"</span>")

			strHtml = strHtml & "			<li>"
			strHtml = strHtml & "				<a href=""javascript:;"" onclick=""javascript:textIn(this, '" & ArrRs(1,i) & "', '" & result_obj_id & "', '');"">" & kw_em & "</a>"
			strHtml = strHtml & "			</li>"
	    Next
	End If	
End If

strHtml = strHtml & "		</ul>"
strHtml = strHtml & "	</div>"
strHtml = strHtml & "	<div class=""sb_btm"">"
strHtml = strHtml & "		<div class=""direct"">"
strHtml = strHtml & "			<span>" & kw & "</span>"
strHtml = strHtml & "			<button type=""button"" class=""btn_direct"" onclick=""javascript:$('.sb_area').hide();"">직접입력</button>"
strHtml = strHtml & "		</div>"
strHtml = strHtml & "		<button type=""button"" class=""sch_close"" onclick=""javascript:$('.sb_area').hide();"">닫기</button>"
strHtml = strHtml & "	</div>"	
strHtml = strHtml & "</div>"


DisconnectDB DBCon

Response.Write strHtml
%>
