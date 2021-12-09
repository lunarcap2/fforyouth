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
	alert("잘못된 호출입니다.");
	parent.location.href="default.asp";
	</script>
	<%
	response.End
End If

'response.write idx & "<br>"
'response.End

dbCon.Open Application("DBInfo_FAIR")

'인성검사 현재 단계
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
	alert("결제 내역이 없습니다.");
	parent.location.href="default.asp";
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-200" Then
	%>
	<script language="javascript">
	alert("이미 검사를 완료한 항목입니다.");
	parent.location.href="oci_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-300" Then
	%>
	<script language="javascript">
	alert("이미 검사를 완료한 항목입니다.");
	parent.location.href="oci_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-400" Then
	%>
	<script language="javascript">
	alert("검사가 강제로 종료되었습니다.");
	parent.location.href="oci_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
End If

'인성검사 관리 진행정보
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
	alert("진행중인 인성검사가 없습니다.");
	parent.location.href="default.asp";
	</script>
	<%
	response.end
End If

'인성검사 문제 목록
Dim ArrQuestionParams
redim ArrQuestionParams(2)
ArrQuestionParams(0) = SiteCode
ArrQuestionParams(1) = NextManageIdx
ArrQuestionParams(2) = NextPage

dim ArrOCIQuestionList
Call getOCIQuestionList(dbCon, ArrQuestionParams, ArrOCIQuestionList, "", "")

'인성검사 개인 시험로그
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
<title>커리어 :: 프리미엄 취업포털 커리어</title>

<link href="//old.career.co.kr/css/reset_2015.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/comm_2016.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/my_2017.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/my_2017.js"></script>


<script language="javascript">
//페이지 벗어날때 체크하는 함수
window.onbeforeunload=function () {
	return("인성검사가 진행중입니다.\n페이지를 종료하거나 다른 페이지로 이동하시면 현재까지 진행하신 부분만 저장됩니다.\n검사를 중지하시겠습니까?");
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
			alert(document.getElementById('Question_order_'+LoopOuter).value +"번 문제에 대한 답을 선택해 주세요");
			return false;
		}
	}

	document.getElementById('RemainTime').value = parent.document.getElementById('RemainTime').value;
	window.onbeforeunload=null;
	
	document.form1.submit();

	<% else %>
	alert("입력된 문제가 없습니다.");
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

//마우스 오른쪽 버튼 기능 제한
function click() 
{ 
	/*
	if((document.event.button==2) || (document.event.button==3))
	{
		alert('마우스 오른쪽 버튼은 사용할 수 없습니다.'); 
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
					<th><div>검사항목</div></th>
					<th>
						<div>
							<span>①</span>
							<span>②</span>
							<span>③</span>
							<span>④</span>
							<span>⑤</span>
							<span>⑥</span>
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
			<a href="javascript:;" class="testBtn prev" onclick="return goPrevPage();">이전 페이지</a>
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
			</em> 페이지 -
		</span>

		<span class="rightBtn">
		<% If CInt(Manage_Total_Page) = CInt(NextPage) Then %>
			<a href="javascript:;" class="testBtn end" onclick="return goNextPage();">인성검사 종료</a>
			<!-- <p class="mt_40 tr"><input type="image" src="http://image.career.co.kr/career_new/button/btn_test_oci_finish.gif" alt="인성 검사 종료" /></p> -->
		<% ElseIf CInt(Manage_Total_Page) > CInt(NextPage) Then %>
			<a href="javascript:;" class="testBtn next" onclick="return goNextPage();">다음 페이지</a>
		<% End If %>
		</span>
	</div>
	<!-- testBtnArea -->

	</form>

</div>
</body>
</html>
