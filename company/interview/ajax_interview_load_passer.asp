<%Option Explicit%>
<%
response.expires = -1
response.cachecontrol = "no-cache"
response.charset = "euc-kr"
%>
<!--#include virtual = "/inc/function/code_function.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
Dim g_Debug : g_Debug = False
Dim strHtml : strHtml = ""
Dim i
Dim mode, jid
mode = request("mode") 
jid = request("jid")

Dim birth_ymd, user_age, career_str, strFinalSchool, tot_sum

ConnectDB DBCon, Application("DBInfo_FAIR")

	Dim spName, arrRsPopInterview, totalCnt
	ReDim param(12)
	spName = "usp_기업서비스_면접배정_리스트"

	param(0)  = makeParam("@MODE",				adVarchar, adParamInput, 20, mode)
	param(1)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, jid)
	param(2)  = makeParam("@PID",				adVarchar, adParamInput, 1, "3")
	param(3)  = makeParam("@INTERVIEW_N",		adVarchar, adParamInput, 1, "")
	param(4)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, "")
	param(5)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, "")
	param(6)  = makeParam("@INTERVIEW_RESULT",	adVarchar, adParamInput, 1, "")
	param(7)  = makeParam("@CONFIRM_YN",		adVarchar, adParamInput, 1, "")
	param(8)  = makeParam("@KW",				adVarchar, adParamInput, 100, "")
	param(9)  = makeParam("@JOB_PART",			adInteger, adParamInput, 4, "")
	param(10) = makeParam("@PAGE",				adInteger, adParamInput, 4, 1)
	param(11) = makeParam("@PAGE_SIZE",			adInteger, adParamInput, 4, 1000)
	param(12) = makeParam("@TOTAL_CNT",			adInteger, adParamOutput, 4, 0)

	arrRsPopInterview = arrGetRsSP(dbCon, spName, param, "", "")
	totalCnt = getParamOutputValue(param, "@TOTAL_CNT")

DisconnectDB DBCon
%>


<%
If isArray(arrRsPopInterview) Then 
For i=0 To UBound(arrRsPopInterview, 2)
	
	'생년월일 나이
	If arrRsPopInterview(6, i) = "1" Or arrRsPopInterview(6, i) = "2" Then
		birth_ymd = "19" & arrRsPopInterview(5, i)
	Else
		birth_ymd = "20" & arrRsPopInterview(5, i)
	End If
	user_age = Year(now) - Left(birth_ymd, 4) + 1

	'경력표기
	tot_sum = Abs(arrRsPopInterview(11, i))

	If tot_sum = "0" Then 
		career_str = "신입"
	ElseIf tot_sum > 12 Then
		career_str = "경력 " & fix(tot_sum / 12) & "년 "
		
		If tot_sum mod 12 > 0 Then
			career_str = career_str & tot_sum mod 12 & "개월"
		End If
	Else 
		career_str = "경력 " & tot_sum & "개월"
	End If

	'최종학력
	strFinalSchool = ""
	Select Case arrRsPopInterview(9, i)
		Case "3" : strFinalSchool = "고등학교"
		Case "4" : strFinalSchool = "대학(2.3년)"
		Case "5" : strFinalSchool = "대학교(4년)"
		Case "6" : strFinalSchool = "대학원"
	End Select

	Dim pop_interviewYN : pop_interviewYN = False
	If arrRsPopInterview(24, i) <> "" Then pop_interviewYN = True

	Dim pop_confirmYN : pop_confirmYN = false
	If arrRsPopInterview(26, i) = "Y" Then pop_confirmYN = True

	Dim label_class : label_class = ""
	If pop_interviewYN And pop_confirmYN = False Then label_class = "assi"
	If pop_confirmYN Then label_class = "confi"
%>

	<li>
		<label class="checkbox <%=label_class%> off">
			<% If pop_confirmYN = False Then %>
			<input class="chk" name="set_interview_applyno" type="checkbox" value="<%=arrRsPopInterview(14, i)%>" onclick="fn_applyno_max_cnt(this);">
			<% End If %>
			<div class="txt">
				<strong><%=arrRsPopInterview(4, i)%> (<%=user_age%>세)</strong><br>
				<span>
					
					<% If pop_interviewYN And pop_confirmYN = False Then %>
						<%=Split(arrRsPopInterview(24, i), "-")(1)%>월 <%=Split(arrRsPopInterview(24, i), "-")(2)%>일 <%=getInterviewTime(arrRsPopInterview(25, i))%>
						<br><em>면접배정</em>

					<% ElseIf pop_confirmYN Then %>
						<%=Split(arrRsPopInterview(24, i), "-")(1)%>월 <%=Split(arrRsPopInterview(24, i), "-")(2)%>일 <%=getInterviewTime(arrRsPopInterview(25, i))%>
						<br><em>면접확정</em>
					
					<% Else %>
						<%=career_str%>
						<% If arrRsPopInterview(16, i) <> "" Then Response.write " | " & arrRsPopInterview(16, i) %>
						<% If strFinalSchool <> "" Then Response.write "<br>" & strFinalSchool %>

					<% End If %>
				</span>
			</div>
		</label>
	</li>

<%
Next
End If
%>