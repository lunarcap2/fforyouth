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
isFail = Trim(Request("isFail")) '���谭������� ��� 1, �Ϲ� 0
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

'����α� �߰�
Dim ArrTestParams
redim ArrTestParams(7)

'If isFail <> "1" then
	dim LoopCount
	For LoopCount = 0 to QuestionTotalCount - 1
		'response.write "������ȣ" & Request("question_"&LoopCount) & "<br>"
		'response.write "��������" & Request("question_order_"&LoopCount) & "<br>"
		'response.write "��ȹ�ȣ/����" & Request("ask_"&LoopCount) & "<br>"
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


'���� ��������� �� Ǯ������ ���� 0������ ����α�����
If isFail = "1" Then
	redim ArrTestParams(0)
	ArrTestParams(0) = SiteCode

	Dim ArrManageList '���� ����������
	Call getOCIManageList(dbCon, ArrTestParams, ArrManageList, "", "")
	
	For LoopCount = 1 To ArrManageList(1,0) '1������ ~ ����������

		ReDim ArrTestParams(2)
		ArrTestParams(0) = idx
		ArrTestParams(1) = LoopCount
		Dim ArrTestLogList '����α� ���
		Call getOCITestLogList(dbCon, ArrTestParams, ArrTestLogList, "", "")
		
		'�ش�(Ư��) �������� ����αװ� ������� ����α�����
		If isArray(ArrTestLogList) = False Then	
			ReDim ArrTestParams(2)
			ArrTestParams(0) = SiteCode
			ArrTestParams(1) = Manageidx
			ArrTestParams(2) = LoopCount

			Dim ArrQuestionList '�������
			Call getOCIQuestionList(dbCon, ArrTestParams, ArrQuestionList, "", "")

			Dim LoopCount2
			For LoopCount2 = 0 To UBound(ArrQuestionList, 2)
				redim ArrTestParams(7)
				ArrTestParams(0) = SiteCode
				ArrTestParams(1) = idx
				ArrTestParams(2) = Manageidx
				ArrTestParams(3) = user_id
				ArrTestParams(4) = ArrQuestionList(0,LoopCount2) '������ȣ
				ArrTestParams(5) = ArrQuestionList(4,LoopCount2) '��������
				ArrTestParams(6) = "0" '��(ask) 0���� ����
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

'�����ܰ� ����
Dim TestStatus,CompleteSection,CompleteTest
Dim NextStepReturnValue
If prevYN = "Y" Then
	'�����ܰ�
	NextStepReturnValue = execOCITestPrevStep(dbCon, ArrPersonalLogParams, "", "",TestStatus,CompleteSection,CompleteTest)
Else
	'�����ܰ�
	NextStepReturnValue = execOCITestNextStep(dbCon, ArrPersonalLogParams, "", "",TestStatus,CompleteSection,CompleteTest)
End If

dbCon.Close

'response.write TestStatus & "<br>"
'response.write CompleteSection & "<br>"
'response.write CompleteTest & "<br>"
'response.write NextStepReturnValue & "<br>"
'response.End

If CompleteTest = "100" Then
	'�˻� �Ϸ�
	%>
	<script language="javascript">
	window.onbeforeunload=null;
	parent.location.href="oci_end.asp?idx=<%=idx%>";
	</script>
	<%
	response.end
ElseIf CompleteTest = "-100" Then
	'�˻� ���� ��
	If CompleteSection = "100" Then
		'������ ���� ���
		%>
		<script language="javascript">
		window.onbeforeunload=null;
		parent.location.href="oci_frame.asp?idx=<%=idx%>";
		</script>
		<%
		response.end
	Else
		'���� ������ �ִ� ���
		Response.Redirect "oci_question.asp?idx="&idx&"#PageTop"
	End if
End if
%>

