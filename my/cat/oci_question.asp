<%
Option Explicit

Response.Expires = -1
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<!--#include virtual = "/wwwconf/query_lib/my/CAT_Info.asp"-->
<!--#include virtual = "/wwwconf/function/my/CAT_Function.asp"-->

<%
Call FN_LoginLimit("1")

Dim SiteCode
SiteCode = getSiteCode(Request.ServerVariables("SERVER_NAME"))

dim idx
idx = Trim(Request("idx"))
idx = Replace(idx,"#PageTop","")

If idx = "" Then
	%>
	<script language="javascript">
	window.onbeforeunload="";
	alert("�߸��� ȣ���Դϴ�.");
	parent.location.href="default.asp";
	</script>
	<%
	response.End
End If

'response.write idx & "<br>"
'response.End

dbCon.Open Application("DBInfo_FAIR")

'�μ��˻� ���� �ܰ�
Dim ArrNowStepParams
redim ArrNowStepParams(2)
ArrNowStepParams(0) = SiteCode
ArrNowStepParams(1) = idx
ArrNowStepParams(2) = user_id

'response.write ArrNowStepParams(0) & "<br>"
'response.write ArrNowStepParams(1) & "<br>"
'response.write ArrNowStepParams(2) & "<br>"
'response.end

Dim NextManageIdx,NextPage,NextRemainTime
Dim NowStepReturnValue
NowStepReturnValue = execOCITestNowStep(dbCon, ArrNowStepParams, "", "",NextManageIdx,NextPage,NextRemainTime)

If NowStepReturnValue = "-100" Then
	%>
	<script language="javascript">
	alert("���� ������ �����ϴ�.");
	parent.location.href="default.asp";
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-200" Then
	%>
	<script language="javascript">
	alert("�̹� �˻縦 �Ϸ��� �׸��Դϴ�.");
	parent.location.href="oci_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-300" Then
	%>
	<script language="javascript">
	alert("�̹� �˻縦 �Ϸ��� �׸��Դϴ�.");
	parent.location.href="oci_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-400" Then
	%>
	<script language="javascript">
	alert("�˻簡 ������ ����Ǿ����ϴ�.");
	parent.location.href="oci_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
End If

'�μ��˻� ���� ��������
Dim ArrManageParams
redim ArrManageParams(0)
ArrManageParams(0) = NextManageIdx

dim ArrOCIManageInfo
Call getOCIManageInfo(dbCon, ArrManageParams, ArrOCIManageInfo, "", "")

Dim Manage_idx,Manage_Name,Manage_Total_Page,Manage_Total_Question,Manage_Total_Time
If IsArray(ArrOCIManageInfo) = True Then
	Manage_idx = Trim(ArrOCIManageInfo(0,0))
	Manage_Name = Trim(ArrOCIManageInfo(3,0))
	Manage_Total_Page = Trim(ArrOCIManageInfo(4,0))
	Manage_Total_Question = Trim(ArrOCIManageInfo(5,0))
	Manage_Total_Time	 = Trim(ArrOCIManageInfo(6,0))
Else
	%>
	<script language="javascript">
	window.onbeforeunload="";
	alert("�������� �μ��˻簡 �����ϴ�.");
	parent.location.href="default.asp";
	</script>
	<%
	response.end
End If

'�μ��˻� ���� ���
Dim ArrQuestionParams
redim ArrQuestionParams(2)
ArrQuestionParams(0) = SiteCode
ArrQuestionParams(1) = NextManageIdx
ArrQuestionParams(2) = NextPage

dim ArrOCIQuestionList
Call getOCIQuestionList(dbCon, ArrQuestionParams, ArrOCIQuestionList, "", "")

'�μ��˻� ���� ����α�
Dim ArrQuestionLogParams
redim ArrQuestionLogParams(1)
ArrQuestionLogParams(0) = idx
ArrQuestionLogParams(1) = NextPage

Dim ArrOCIQuestionLogList
Call getOCITestLogList(dbCon, ArrQuestionLogParams, ArrOCIQuestionLogList, "", "")

dbCon.Close
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="imagetoolbar" content="no" />
<title>Ŀ���� :: �����̾� ������� Ŀ����</title>

<link href="//old.career.co.kr/css/reset_2015.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/comm_2016.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/my_2017.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/my_2017.js"></script>


<script language="javascript">
//������ ����� üũ�ϴ� �Լ�
window.onbeforeunload=function () {
	return("�μ��˻簡 �������Դϴ�.\n�������� �����ϰų� �ٸ� �������� �̵��Ͻø� ������� �����Ͻ� �κи� ����˴ϴ�.\n�˻縦 �����Ͻðڽ��ϱ�?");
}
function goNextPageFail()
{
	window.onbeforeunload=null;
	document.getElementById('isFail').value = "1";
	document.getElementById('RemainTime').value = "0";
	document.getElementById('page').value = "<%=Manage_Total_Page%>";
	document.form1.submit();
}
function goNextPage()
{
	var f = document.form1;
	<% if IsArray(ArrOCIQuestionList) = True then %>
	var LoopOuterCount = "<%=uBound(ArrOCIQuestionList,2)%>";
	for(var LoopOuter=0;LoopOuter<=LoopOuterCount;LoopOuter++)
	{
		var CheckFlag = false;
		for(var LoopInner=0;LoopInner<document.getElementsByName('ask_'+LoopOuter).length;LoopInner++)
		{
			if(document.getElementsByName('ask_'+LoopOuter)[LoopInner].checked==true)
			{
				CheckFlag = true;
			}
		}
		
		if(CheckFlag == false)
		{
			document.getElementsByName('ask_'+LoopOuter)[0].focus();
			alert(document.getElementById('Question_order_'+LoopOuter).value +"�� ������ ���� ���� ������ �ּ���");
			return false;
		}
	}

	document.getElementById('RemainTime').value = parent.document.getElementById('RemainTime').value;
	window.onbeforeunload=null;
	
	document.form1.submit();

	<% else %>
	alert("�Էµ� ������ �����ϴ�.");
	return;
	<% end if %>
}

function goPrevPage()
{
	var f = document.form1;

	document.getElementById('page').value = document.getElementById('page').value - 2;
	document.getElementById('prevYN').value = "Y";
	document.getElementById('RemainTime').value = parent.document.getElementById('RemainTime').value;
	window.onbeforeunload=null;
	
	document.form1.submit();
}

//���콺 ������ ��ư ��� ����
function click() 
{ 
	/*
	if((document.event.button==2) || (document.event.button==3))
	{
		alert('���콺 ������ ��ư�� ����� �� �����ϴ�.'); 
	}
	*/
}   
document.onmousedown=click;
</script>
</head>
<body>


	<div class="board-area test">

		<form name="form1" method="post" action="oci_Question_process.asp">
		<input type="hidden" name="idx" id="idx" value="<%=idx%>">
		<input type="hidden" name="page" id="page" value="<%=NextPage%>">
		<input type="hidden" name="Manageidx" id="Manageidx" value="<%=NextManageIdx%>">
		<input type="hidden" name="RemainTime" id="RemainTime" value="">
		<input type="hidden" name="isFail" id="isFail" value="0">
		<input type="hidden" name="prevYN" id="prevYN" value="">

		<table class="tb" border="0" cellpadding="0" cellspacing="0" summary="">
			<colgroup>
				<col width="60">
				<col width="*">
				<col width="227">
			</colgroup>
			<thead>
				<tr>
					<th><div>NO</div></th>
					<th><div>�˻��׸�</div></th>
					<th>
						<div>
							<span>��</span>
							<span>��</span>
							<span>��</span>
							<span>��</span>
							<span>��</span>
							<span>��</span>
						</div>
					</th>
				</tr>
			</thead>
			<tbody>
				<%
				if IsArray(ArrOCIQuestionList) = True Then
				%>
				<input type="hidden" name="QuestionTotalCount" id="QuestionTotalCount" value="<%=UBound(ArrOCIQuestionList,2)+1%>">
					<%
					dim LoopCount
					For LoopCount = 0 to uBound(ArrOCIQuestionList,2)
						Dim check1 : check1 = ""
						Dim check2 : check2 = ""
						Dim check3 : check3 = ""
						Dim check4 : check4 = ""
						Dim check5 : check5 = ""
						Dim check6 : check6 = ""
						
						If IsArray(ArrOCIQuestionLogList) Then
							If uBound(ArrOCIQuestionLogList,2) >= LoopCount Then
								Select Case CInt(Trim(ArrOCIQuestionLogList(9, LoopCount)))
									Case 1 check1 = "checked='true'"
									Case 2 check2 = "checked='true'"
									Case 3 check3 = "checked='true'"
									Case 4 check4 = "checked='true'"
									Case 5 check5 = "checked='true'"
									Case 6 check6 = "checked='true'"
								End Select
							End If
						End If

					%>
					<tr>
						<input type="hidden" name="idx_<%=LoopCount%>" id="idx_<%=LoopCount%>" value="<%=trim(ArrOCIQuestionList(0, LoopCount))%>">
						<input type="hidden" name="Question_<%=LoopCount%>" id="Question_<%=LoopCount%>" value="<%=trim(ArrOCIQuestionList(0, LoopCount))%>">
						<input type="hidden" name="Question_order_<%=LoopCount%>" id="Question_order_<%=LoopCount%>" value="<%=trim(ArrOCIQuestionList(4, LoopCount))%>">

						<td class="no"><%=trim(ArrOCIQuestionList(4, LoopCount))%></td>
						<td class="left"><%=trim(ArrOCIQuestionList(6, LoopCount))%></td>
						<td>
							<span><label class="radiobox"><% If CInt(Trim(ArrOCIQuestionList(7,LoopCount))) >= 1 Then %><input class="rdi" id="ask_<%=LoopCount%>" name="ask_<%=LoopCount%>" type="radio" value="1" <%=check1%>><% End If%></label></span>
							<span><label class="radiobox"><% If CInt(Trim(ArrOCIQuestionList(7,LoopCount))) >= 2 Then %><input class="rdi" id="ask_<%=LoopCount%>" name="ask_<%=LoopCount%>" type="radio" value="2" <%=check2%>><% End If%></label></span>
							<span><label class="radiobox"><% If CInt(Trim(ArrOCIQuestionList(7,LoopCount))) >= 3 Then %><input class="rdi" id="ask_<%=LoopCount%>" name="ask_<%=LoopCount%>" type="radio" value="3" <%=check3%>><% End If%></label></span>
							<span><label class="radiobox"><% If CInt(Trim(ArrOCIQuestionList(7,LoopCount))) >= 4 Then %><input class="rdi" id="ask_<%=LoopCount%>" name="ask_<%=LoopCount%>" type="radio" value="4" <%=check4%>><% End If%></label></span>
							<span><label class="radiobox"><% If CInt(Trim(ArrOCIQuestionList(7,LoopCount))) >= 5 Then %><input class="rdi" id="ask_<%=LoopCount%>" name="ask_<%=LoopCount%>" type="radio" value="5" <%=check5%>><% End If%></label></span>
							<span><label class="radiobox"><% If CInt(Trim(ArrOCIQuestionList(7,LoopCount))) >= 6 Then %><input class="rdi" id="ask_<%=LoopCount%>" name="ask_<%=LoopCount%>" type="radio" value="6" <%=check6%>><% End If%></label></span>
						</td>
					</tr>
				<%
					Next
				End If
				%>
			</tbody>
		</table>
	</div>
	<!-- board-area test -->

	<div class="testBtnArea">
		<% If NextPage <> 1 Then %>
		<span class="leftBtn">
			<a href="javascript:;" class="testBtn prev" onclick="return goPrevPage();">���� ������</a>
		</span>
		<% End If %>

		<span class="testPage">
			- <em>
				<strong>
				<%
				If CInt(NextPage) < 10 Then
					Response.write "0" & NextPage
				Else
					Response.write NextPage
				End if
				%>
				</strong>
				/
				<%
				If CInt(Manage_Total_Page) < 10 Then
					Response.write "0" & Manage_Total_Page
				Else
					Response.write Manage_Total_Page
				End if
				%>
			</em> ������ -
		</span>

		<span class="rightBtn">
		<% If CInt(Manage_Total_Page) = CInt(NextPage) Then %>
			<a href="javascript:;" class="testBtn end" onclick="return goNextPage();">�μ��˻� ����</a>
			<!-- <p class="mt_40 tr"><input type="image" src="http://image.career.co.kr/career_new/button/btn_test_oci_finish.gif" alt="�μ� �˻� ����" /></p> -->
		<% ElseIf CInt(Manage_Total_Page) > CInt(NextPage) Then %>
			<a href="javascript:;" class="testBtn next" onclick="return goNextPage();">���� ������</a>
		<% End If %>
		</span>
	</div>
	<!-- testBtnArea -->

	</form>

</div>
</body>
</html>
