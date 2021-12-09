<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<%
	Call FN_LoginLimit("2")	'기업회원 허용
	Dim mode, jid, interview_day
	mode = request("set_mode") 
	jid = request("set_jid")
	interview_day = request("set_interview_day")


	'Response.write "mode : " & request("set_mode")  & "<br>"
	'Response.write "jid : " & request("set_jid") & "<br>"
	'Response.write "interview_day : " & request("set_interview_day") & "<br>"
	
	Dim result_script
	If jid = "" Or interview_day = "" Or request("result_interview_applyno").count = 0 Then
		result_script = ""
		result_script = result_script & "<script>"
		result_script = result_script & "alert('잘못된 접근입니다.');"
		result_script = result_script & "history.back();"
		result_script = result_script & "</script>"
		Response.write result_script
		Response.End
	End If

	ConnectDB DBCon, Application("DBInfo_FAIR")
	
	'면접정보 삭제(APPLY_NO = 0)
	'ReDim params(4)
	'params(0) = makeParam("@COM_ID", adVarChar, adParamInput, 20, comid)
	'params(1) = makeParam("@JOBS_ID", adInteger, adParamInput, 4, jid)
	'params(2) = makeParam("@INTERVIEW_DAY", adVarChar, adParamInput, 10, interview_day)
	'params(3) = makeParam("@INTERVIEW_TIME", adVarChar, adParamInput, 2, "")
	'params(4) = makeParam("@APPLY_NO", adInteger, adParamInput, 4, 0)
	'Call execSP(DBCon, "usp_기업서비스_면접배정_저장", params, "", "")

	'면접정보 저장
	For i=1 To request("result_interview_applyno").count
		ReDim params(5)
		params(0) = makeParam("@COM_ID", adVarChar, adParamInput, 20, comid)
		params(1) = makeParam("@JOBS_ID", adInteger, adParamInput, 4, jid)
		params(2) = makeParam("@INTERVIEW_DAY", adVarChar, adParamInput, 10, interview_day)
		params(3) = makeParam("@INTERVIEW_TIME", adVarChar, adParamInput, 2, request("result_interview_time")(i))
		params(4) = makeParam("@APPLY_NO", adInteger, adParamInput, 4, request("result_interview_applyno")(i))
		params(5) = makeParam("@ONLINE_YN", adVarChar, adParamInput, 1, request("result_online_yn")(i))
		
		Call execSP(DBCon, "usp_기업서비스_면접배정_저장", params, "", "")
	Next
	DisconnectDB DBCon
%>

<script>
	alert("면접자 배정 저장이 완료되었습니다.");
	location.href = './list_interview.asp?mode=<%=mode%>&jid=<%=jid%>&interview_day=<%=interview_day%>'
</script>