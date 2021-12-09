<%
Option Explicit
Response.Expires = -1

g_MenuID = "110027"
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/query_lib/my/CAT_Info.asp"-->
<!--#include virtual = "/wwwconf/function/my/CAT_Function.asp"-->

<!--#include virtual = "/wwwconf/code/code_function.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/code/codeToHtml.asp"-->
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

'response.write "idx : " & idx & "<br>"
'response.write "Manageidx : " & Manageidx & "<br>"
'response.write "page : " & page & "<br>"
'response.write "QuestionTotalCount : " & QuestionTotalCount & "<br>"
'response.write "RemainTime : " & RemainTime & "<br>"
'response.write "isFail : " & isFail & "<br>"
'response.write "prevYN : " & prevYN & "<br>"
'response.end

dbCon.Open Application("DBInfo_FAIR")

'시험로그 추가
Dim ArrTestParams
redim ArrTestParams(7)

'If isFail <> "1" then
	dim LoopCount
	For LoopCount = 0 to QuestionTotalCount - 1
		'response.write "문제번호" & Request("question_"&LoopCount) & "<br>"
		'response.write "문제순서" & Request("question_order_"&LoopCount) & "<br>"
		'response.write "답안번호/순서" & Request("ask_"&LoopCount) & "<br>"
		ArrTestParams(0) = SiteCode
		ArrTestParams(1) = idx
		ArrTestParams(2) = Manageidx
		ArrTestParams(3) = user_id
		ArrTestParams(4) = Request("question_"&LoopCount)
		ArrTestParams(5) = Request("question_order_"&LoopCount)
		If trim(Request("ask_"&LoopCount)) = "" Then
			ArrTestParams(6) = "0"
		Else
			ArrTestParams(6) = Request("ask_"&LoopCount)
		End If		
		ArrTestParams(7) = Request.ServerVariables("REMOTE_ADDR")

		'response.write ArrTestParams(0) & "<br>"
		'response.write ArrTestParams(1) & "<br>"
		'response.write ArrTestParams(2) & "<br>"
		'response.write ArrTestParams(3) & "<br>"
		'response.write ArrTestParams(4) & "<br>"
		'response.write ArrTestParams(5) & "<br>"
		'response.write ArrTestParams(6) & "<br>"
		'response.write ArrTestParams(7) & "<br>"
		'response.end
		Dim AddReturnValue
		AddReturnValue = execOCITestLogInsert(dbCon, ArrTestParams, "", "")
	Next
'End if
'response.write AddReturnValue
'response.End


'시험 강제종료시 다 풀지못한 문제 0값으로 시험로그저장
If isFail = "1" Then
	redim ArrTestParams(0)
	ArrTestParams(0) = SiteCode

	Dim ArrManageList '문제 총페이지수
	Call getOCIManageList(dbCon, ArrTestParams, ArrManageList, "", "")
	
	For LoopCount = 1 To ArrManageList(1,0) '1페이지 ~ 총페이지수

		ReDim ArrTestParams(2)
		ArrTestParams(0) = idx
		ArrTestParams(1) = LoopCount
		Dim ArrTestLogList '시험로그 목록
		Call getOCITestLogList(dbCon, ArrTestParams, ArrTestLogList, "", "")
		
		'해당(특정) 페이지의 시험로그가 없을경우 시험로그저장
		If isArray(ArrTestLogList) = False Then	
			ReDim ArrTestParams(2)
			ArrTestParams(0) = SiteCode
			ArrTestParams(1) = Manageidx
			ArrTestParams(2) = LoopCount

			Dim ArrQuestionList '문제목록
			Call getOCIQuestionList(dbCon, ArrTestParams, ArrQuestionList, "", "")

			Dim LoopCount2
			For LoopCount2 = 0 To UBound(ArrQuestionList, 2)
				redim ArrTestParams(7)
				ArrTestParams(0) = SiteCode
				ArrTestParams(1) = idx
				ArrTestParams(2) = Manageidx
				ArrTestParams(3) = user_id
				ArrTestParams(4) = ArrQuestionList(0,LoopCount2) '문제번호
				ArrTestParams(5) = ArrQuestionList(4,LoopCount2) '문제순서
				ArrTestParams(6) = "0" '답(ask) 0으로 고정
				ArrTestParams(7) = Request.ServerVariables("REMOTE_ADDR")
				Call execOCITestLogInsert(dbCon, ArrTestParams, "", "")
			Next
		End If

	Next
End If



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
	NextStepReturnValue = execOCITestPrevStep(dbCon, ArrPersonalLogParams, "", "",TestStatus,CompleteSection,CompleteTest)
Else
	'다음단계
	NextStepReturnValue = execOCITestNextStep(dbCon, ArrPersonalLogParams, "", "",TestStatus,CompleteSection,CompleteTest)
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
	parent.location.href="oci_end.asp?idx=<%=idx%>";
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
		parent.location.href="oci_frame.asp?idx=<%=idx%>";
		</script>
		<%
		response.end
	Else
		'다음 섹션이 있는 경우
		Response.Redirect "oci_question.asp?idx="&idx&"#PageTop"
	End if
End if
%>

