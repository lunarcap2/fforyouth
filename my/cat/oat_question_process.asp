<%
Option Explicit

Response.Expires = -1

g_MenuID = "110027"
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/function/common/fn_gnb.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/query_lib/my/CAT_Info.asp"-->
<!--#include virtual = "/wwwconf/function/my/CAT_Function.asp"-->

<!--#include virtual="/wwwconf/code/code_function.asp"-->
<!--#include virtual="/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual="/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual= "/wwwconf/code/codeToHtml.asp"-->
<%
Call FN_LoginLimit("1")

Dim SiteCode
SiteCode = getSiteCode(Request.ServerVariables("SERVER_NAME"))

dim idx,Manageidx,Page,QuestionTotalCount,RemainTime,isFail,prevYN
idx = Trim(Request("idx"))
Manageidx = Trim(Request("Manageidx"))
Page = Trim(Request("Page"))
QuestionTotalCount = Trim(Request("QuestionTotalCount"))
RemainTime = Trim(Request("RemainTime"))
isFail = Trim(Request("isFail")) '시험강제종료된 경우 1, 일반 0
prevYN = Trim(Request("prevYN"))
'if Page = "" then Page = "1" End If

'response.write idx & "<br>"
'response.write Manageidx & "<br>"
'response.write page & "<br>"
'response.write RemainTime & "<br>"
'response.write isFail & "<br>"
'response.end

dbCon.Open Application("DBInfo_FAIR")

'시험로그 추가
Dim ArrTestParams
redim ArrTestParams(8)

'If isFail <> "1" then
	dim LoopCount
	For LoopCount = 0 to QuestionTotalCount - 1
		'response.write "문제번호" & Request("question_"&LoopCount) & "<br>"
		'response.write "문제순서" & Request("question_order_"&LoopCount) & "<br>"
		'response.write "답안번호/순서" & Request("ask_"&LoopCount) & "<br>"
		Dim ArrAsk
		If trim(Request("ask_"&LoopCount)) = "" Then
			ReDim ArrAsk(2)
			ArrAsk(0) = "0"
			ArrAsk(1) = "0"
		Else
			If InStr(Request("ask_"&LoopCount),",") > 0 Then
				ArrAsk = Split(Request("ask_"&LoopCount),",")
			else
				ReDim ArrAsk(2)
				ArrAsk(0) = "0"
				ArrAsk(1) = "0"
			End if
		End If	

		ArrTestParams(0) = SiteCode
		ArrTestParams(1) = idx
		ArrTestParams(2) = Manageidx
		ArrTestParams(3) = user_id
		ArrTestParams(4) = Request("question_"&LoopCount)
		ArrTestParams(5) = Request("question_order_"&LoopCount)
		ArrTestParams(6) = ArrAsk(0)
		ArrTestParams(7) = ArrAsk(1)
		ArrTestParams(8) = Request.ServerVariables("REMOTE_ADDR")

		'response.write ArrTestParams(0) & "<br>"
		'response.write ArrTestParams(1) & "<br>"
		'response.write ArrTestParams(2) & "<br>"
		'response.write ArrTestParams(3) & "<br>"
		'response.write ArrTestParams(4) & "<br>"
		'response.write ArrTestParams(5) & "<br>"
		'response.write ArrTestParams(6) & "<br>"
		'response.write ArrTestParams(7) & "<br>"
		'response.write ArrTestParams(8) & "<br>"
		'response.end
		If ArrAsk(0) <> "" And ArrAsk(1) <> "" then
			Dim AddReturnValue
			AddReturnValue = execOATTestLogInsert(dbCon, ArrTestParams, "", "")
		End if
	Next
'End if
'response.write AddReturnValue
'response.End

Dim ArrPersonalLogParams
redim ArrPersonalLogParams(5)
ArrPersonalLogParams(0) = SiteCode
ArrPersonalLogParams(1) = user_id
ArrPersonalLogParams(2) = idx
ArrPersonalLogParams(3) = Manageidx
ArrPersonalLogParams(4) = Page
ArrPersonalLogParams(5) = RemainTime

'다음단계 진행
Dim TestStatus,CompleteSection,CompleteTest
Dim NextStepReturnValue
If prevYN = "Y" Then
	'이전단계
	NextStepReturnValue = execOATTestPrevStep(dbCon, ArrPersonalLogParams, "", "",TestStatus,CompleteSection,CompleteTest)
Else
	'다음단계
	NextStepReturnValue = execOATTestNextStep(dbCon, ArrPersonalLogParams, "", "",TestStatus,CompleteSection,CompleteTest)
End If

dbCon.Close

'response.write TestStatus & "<br>"
'response.write CompleteSection & "<br>"
'response.write CompleteTest & "<br>"
'response.write NextStepReturnValue & "<br>"
'response.End

If CompleteTest = "100" Then
	'검사 완료
	%>
	<script language="javascript">
	window.onbeforeunload=null;
	parent.location.href="oat_end.asp?idx=<%=idx%>";
	</script>
	<%
	response.end
ElseIf CompleteTest = "-100" Then
	'검사 진행 중
	If CompleteSection = "100" Then
		'섹션이 끝난 경우
		%>
		<script language="javascript">
		window.onbeforeunload=null;
		parent.location.href="oat_step.asp?idx=<%=idx%>";
		</script>
		<%
		response.end
	Else
		'다음 섹션이 있는 경우
		Response.Redirect "oat_question.asp?idx="&idx&"#PageTop"
	End if
End if
%>

