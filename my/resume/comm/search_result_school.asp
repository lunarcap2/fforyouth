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

Dim i,j
Dim kw : kw = unescape(Request("kw"))
Dim sGubun : sGubun = Request("sGubun")
Dim idx : idx = Request("idx")
Dim result_obj_id : result_obj_id = Request("result_obj_id")

ConnectDB DBCon, Application("DBInfo")

Dim ArrRs : ArrRs = getSchoolSearch(DBCon, kw, sGubun, "","")
Dim kw_em

If IsArray(ArrRs) Then
	strHtml = strHtml & "<ul class='rb_ul'>"
    if sGubun = "univ" then
	    For i=0 To UBound(ArrRs,2)
			kw_em = Replace(ArrRs(1,i), kw, "<em>"& kw &"</em>")
            if ArrRs(2,i) = "" Or isNull(ArrRs(2,i)) then 
		        strHtml = strHtml & "<li>"
				strHtml = strHtml & "<a class='rb_a' href=""javascript:;"" onclick=""javascript:textIn(this, '" & ArrRs(1,i) & "', '" & result_obj_id & "');"">"
				strHtml = strHtml & "<p>" & kw_em & "</p>"
				strHtml = strHtml & "</a>"
				strHtml = strHtml & "</li>"
            else
                strHtml = strHtml & "<li>"
				strHtml = strHtml & "<a class='rb_a' href=""javascript:;"" onclick=""javascript:textIn(this, '" & ArrRs(1,i) & "', '" & result_obj_id & "');"">"
				strHtml = strHtml & "<p>" & kw_em & "(" & ArrRs(2,i) & ")</p>"
				strHtml = strHtml & "</a>"
				strHtml = strHtml & "</li>"
            end if 
	    Next
    else
        For i=0 To UBound(ArrRs,2)
			kw_em = Replace(ArrRs(1,i), kw, "<em>"& kw &"</em>")
		    strHtml = strHtml & "<li>"
'			strHtml = strHtml & "<a class='rb_a' href=""javascript:textIn(this, '" & ArrRs(1,i) & "');"">"
			strHtml = strHtml & "<a class='rb_a' href=""javascript:;"" onclick=""textIn(this, '" & ArrRs(1,i) & "', '" & result_obj_id & "');"">"
			strHtml = strHtml & "<p>" & kw_em & "</p>"
			strHtml = strHtml & "</a>"
			strHtml = strHtml & "</li>"
	    Next
    end If
	strHtml = strHtml & "</ul>"
Else
		strHtml = strHtml & "<a href='javaScript:;' class='rb_direct'><span>"& kw &"</span> 직접입력</a>"
End If

'strHtml = ""
'strHtml = strHtml & "<ul class='rb_ul'>"
'strHtml = strHtml & "	<li>"
'strHtml = strHtml & "		<a href='javaScript:;' class='rb_a'>"
'strHtml = strHtml & "			<p>커리어넷</p>"
'strHtml = strHtml & "			<span>보호대상중견기업</span><span>고용알선업</span>"
'strHtml = strHtml & "		</a>"
'strHtml = strHtml & "	</li>"
'strHtml = strHtml & "	<li>"
'strHtml = strHtml & "		<a href='javaScript:;' class='rb_a'>"
'strHtml = strHtml & "			<p>커리어넷22</p>"
'strHtml = strHtml & "			<span>보호대상중견기업</span><span>고용알선업</span>"
'strHtml = strHtml & "		</a>"
'strHtml = strHtml & "	</li>"
'strHtml = strHtml & "</ul>"
'strHtml = strHtml & "<a href='javaScript:;' class='rb_direct'><span>커리어넷</span> 직접입력</a>"


DisconnectDB DBCon

Response.Write strHtml
%>
