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
Dim ii, jj
Dim mode, jid, interview_day, interview_day_text
mode = request("mode") 
jid = request("jid")
interview_day = request("interview_day")


interview_day_text = Split(interview_day, "-")(1) & "�� " & Split(interview_day, "-")(2) & "��"

ConnectDB DBCon, Application("DBInfo_FAIR")

	Dim spName, arrRs, totalCnt
	ReDim param(12)
	spName = "usp_�������_��������_����Ʈ"

	param(0)  = makeParam("@MODE",				adVarchar, adParamInput, 20, mode)
	param(1)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, jid)
	param(2)  = makeParam("@PID",				adVarchar, adParamInput, 1, "3")
	param(3)  = makeParam("@INTERVIEW_N",		adVarchar, adParamInput, 1, "")
	param(4)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, interview_day)
	param(5)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, "")
	param(6)  = makeParam("@INTERVIEW_RESULT",	adVarchar, adParamInput, 1, "")
	param(7)  = makeParam("@CONFIRM_YN",		adVarchar, adParamInput, 1, "")
	param(8)  = makeParam("@KW",				adVarchar, adParamInput, 100, "")
	param(9)  = makeParam("@JOB_PART",			adInteger, adParamInput, 4, "")
	param(10) = makeParam("@PAGE",				adInteger, adParamInput, 4, 1)
	param(11) = makeParam("@PAGE_SIZE",			adInteger, adParamInput, 4, 1000)
	param(12) = makeParam("@TOTAL_CNT",			adInteger, adParamOutput, 4, 0)

	arrRs = arrGetRsSP(dbCon, spName, param, "", "")
	totalCnt = getParamOutputValue(param, "@TOTAL_CNT")

DisconnectDB DBCon
%>




<!--
<li>
	<p class="p_ment">
		��������, �ð�, �����հ��ڸ� ���� ��<br>
		<span>�̸����� ��ư�� Ŭ��</span>�� �ּ���.<br><br>
		�����ð� �� �ִ� 4�� ������ <br>
		������ �� �ֽ��ϴ�.
	</p>
</li>
-->





<% 
ReDim chk_time(16)
If isArray(arrRs) Then 
	For ii=0 To UBound(arrRs, 2)

	Select Case arrRs(25, ii)
		Case "1" chk_time(1) = "1"
		Case "2" chk_time(2) = "1"
		Case "3" chk_time(3) = "1"
		Case "4" chk_time(4) = "1"
		Case "5" chk_time(5) = "1"
		Case "6" chk_time(6) = "1"
		Case "7" chk_time(7) = "1"
		Case "8" chk_time(8) = "1"
		Case "9" chk_time(9) = "1"
		Case "10" chk_time(10) = "1"
		Case "11" chk_time(11) = "1"
		Case "12" chk_time(12) = "1"
		Case "13" chk_time(13) = "1"
		Case "14" chk_time(14) = "1"
		Case "15" chk_time(15) = "1"
		Case "16" chk_time(16) = "1"
	End Select

	Next
End If

For ii=1 To 16
	If chk_time(ii) = "1" Then
%>
	<li id="<%=interview_day%>_<%=ii%>">
		<div class="preview_info">
			<p>
				<%=interview_day_text%>&nbsp;<%=getInterviewTime(ii)%>
				<button type="button" onclick="fn_interview_applyno_del_all(this, 1)">����</button>
			</p>
			<ul class="pi_ul">
				<% 
				For jj=0 To UBound(arrRs, 2) 
				If arrRs(24, jj) = interview_day And arrRs(25, jj) = ii Then

				'������� ����
				Dim birth_ymd
				If arrRs(6, jj) = "1" Or arrRs(6, jj) = "2" Then
					birth_ymd = "19" & arrRs(5, jj)
				Else
					birth_ymd = "20" & arrRs(5, jj)
				End If
				Dim user_age : user_age = Year(now) - Left(birth_ymd, 4) + 1

				'���ǥ��
				Dim career_str, tot_sum
				tot_sum = Abs(arrRs(11, jj))

				If tot_sum = "0" Then 
					career_str = "����"
				ElseIf tot_sum > 12 Then
					career_str = "��� " & fix(tot_sum / 12) & "�� "

					If tot_sum mod 12 > 0 Then
						career_str = career_str & tot_sum mod 12 & "����"
					End If
				Else 
					career_str = "��� " & tot_sum & "����"
				End If

				'�����з�
				Dim strFinalSchool
				Select Case arrRs(9, jj)
					Case "3" : strFinalSchool = "����б�"
					Case "4" : strFinalSchool = "����(2,3��)"
					Case "5" : strFinalSchool = "���б�(4��)"
					Case "6" : strFinalSchool = "���п�"
				End Select

				Dim pop_confirmYN : pop_confirmYN = false
				If arrRs(26, jj) = "Y" Then pop_confirmYN = True

				%>
				<li>
					<input type="hidden" name="result_interview_time" value="<%=ii%>">
					<input type="hidden" name="result_interview_applyno" value="<%=arrRs(14, jj)%>">
					<strong><%=arrRs(4, jj)%> (<%=user_age%>��)</strong>
					<span>
						<%=career_str%>
						<% If arrRs(16, jj) <> "" Then Response.write " | " & arrRs(16, jj) %>
						<% If strFinalSchool <> "" Then Response.write "<br>" & strFinalSchool %>
					</span>
					<% If pop_confirmYN = False Then %>
					<button type="button" onclick="fn_interview_applyno_del(this, 1)">����</button>
					<% End If %>
				</li>
				<% 
				End If
				Next 
				%>
			</ul>
		</div>
	</li>
<%
	Else
%>
	<li id="<%=interview_day%>_<%=ii%>" style="display:none;">
		<div class="preview_info">
			<p>
				<%=interview_day_text%>&nbsp;<%=getInterviewTime(ii)%>
				<button type="button" onclick="fn_interview_applyno_del_all(this, 0)">����</button>
			</p>
			<ul class="pi_ul">
			</ul>
		</div>
	</li>
<%
	End If
Next
%>

<% If IsArray(arrRs) = False Then %>
<p class="p_ment">
	��������, �ð�, �����հ��ڸ� ���� ��<br>
	<span>�̸����� ��ư�� Ŭ��</span>�� �ּ���.<br><br>
	�����ð� �� �ִ� 4�� ������ <br>
	������ �� �ֽ��ϴ�.
</p>
<% End If %>