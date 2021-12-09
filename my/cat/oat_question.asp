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
	//부모 > 팝업 > iframe(현재페이지)
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

'적성검사 현재 단계
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
NowStepReturnValue = execOATTestNowStep(dbCon, ArrNowStepParams, "", "",NextManageIdx,NextPage,NextRemainTime)

If NowStepReturnValue = "-100" Then
	%>
	<script language="javascript">
	alert("결제 내역이 없습니다.");
	parent.opener.location.href = "default.asp";
	parent.close();
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-200" Then
	%>
	<script language="javascript">
	alert("이미 검사를 완료한 항목입니다.");
	parent.location.href="oat_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-300" Then
	%>
	<script language="javascript">
	alert("이미 검사를 완료한 항목입니다.");
	parent.location.href="oat_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
ElseIf NowStepReturnValue = "-400" Then
	%>
	<script language="javascript">
	alert("검사가 강제로 종료되었습니다.");
	parent.location.href="oat_result.asp?idx=<%=idx%>";
	</script>
	<%
	response.End
End If

'적성검사 관리 진행정보
Dim ArrManageParams
redim ArrManageParams(0)
ArrManageParams(0) = NextManageIdx

dim ArrOATManageInfo
Call getOATManageInfo(dbCon, ArrManageParams, ArrOATManageInfo, "", "")

Dim Manage_idx,Manage_Name,Manage_Total_Page,Manage_Total_Question,Manage_Total_Time
If IsArray(ArrOATManageInfo) = True Then
	Manage_idx = Trim(ArrOATManageInfo(0,0))
	Manage_Name = Trim(ArrOATManageInfo(3,0))
	Manage_Total_Page = Trim(ArrOATManageInfo(4,0))
	Manage_Total_Question = Trim(ArrOATManageInfo(5,0))
	Manage_Total_Time	 = Trim(ArrOATManageInfo(6,0))
Else
	%>
	<script language="javascript">
	alert("진행중인 적성검사가 없습니다.");
	parent.location.href="default.asp";
	</script>
	<%
	response.end
End If


'적성검사 개인 시험로그
Dim ArrQuestionLogParams
redim ArrQuestionLogParams(2)
ArrQuestionLogParams(0) = idx
ArrQuestionLogParams(1) = Manage_idx
ArrQuestionLogParams(2) = NextPage

'response.write "idx : " & idx & "<br>"
'response.write "Manage_idx : " & Manage_idx & "<br>"
'response.write "NextPage : " & NextPage & "<br>"

Dim ArrOATQuestionLogList
Call getOATTestLogList(dbCon, ArrQuestionLogParams, ArrOATQuestionLogList, "", "")


'적성검사 문제 목록
Dim ArrQuestionParams
redim ArrQuestionParams(2)
ArrQuestionParams(0) = SiteCode
ArrQuestionParams(1) = NextManageIdx
ArrQuestionParams(2) = NextPage

dim ArrOATQuestionList
Call getOATQuestionList(dbCon, ArrQuestionParams, ArrOATQuestionList, "", "")

'적성검사 답안 목록
Dim ArrAskParams
redim ArrAskParams(0)
ArrAskParams(0) = SiteCode

dim ArrOATAskList
Call getOATAskList(dbCon, ArrAskParams, ArrOATAskList, "", "")

dbCon.Close

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<meta http-equiv="imagetoolbar" content="no" />

<body class="myTest">

<link href="//old.career.co.kr/css/reset_2015.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/comm_2016.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/my_2017.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/my_2017.js"></script>

<script language="javascript">

//페이지 벗어날때 체크하는 함수
window.onbeforeunload=function (){
	return("적성검사가 진행중입니다.\n페이지를 종료하거나 다른 페이지로 이동하시면 현재까지 진행하신 부분만 저장됩니다.\n검사를 중지하시겠습니까?");
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
	<% if IsArray(ArrOATQuestionList) = True then %>
	var LoopOuterCount = "<%=uBound(ArrOATQuestionList,2)%>";
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
			alert(document.getElementById('question_order_'+LoopOuter).value +"번 문제에 대한 답을 선택해 주세요");
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
	if((event.button==2) || (event.button==3)) {
		alert('마우스 오른쪽 버튼은 사용할 수 없습니다.'); 
	}
}
document.onmousedown=click;

</script>

<!-- CONTENTS 2017 -->
<div id="career_container" class="aptitudeTestWrap"><!-- 2017/03/02/hjyu -->
	<div id="career_contents">
		<div class="titArea">
			<h2>
				<% Select case Manage_idx %>
				<% Case "1" %> <em class="round">STEP. 1</em>언어이해<span>(Verbal Comprehension)</span>
				<% Case "2" %> <em class="round">STEP. 2</em>언어추리<span>(Verbal Reasoning)</span>
				<% Case "3" %> <em class="round">STEP. 3</em>자료해석<span>(Data Analyzing)</span>
				<% Case "4" %> <em class="round">STEP. 4</em>수리추리<span>(Quantitative Reasoning)</span>
				<% Case "5" %> <em class="round">STEP. 5</em>응용계산<span>(Numerical Operation)</span>
				<% Case "6" %> <em class="round">STEP. 6</em>공간지각<span>(Special Perception)</span>
				<% End Select %>
			</h2>
		</div>
		<!-- //titArea -->

		<div class="questionArea">

			<form name="form1" method="post" action="oat_question_process.asp">
			<input type="hidden" name="idx" id="idx" value="<%=idx%>">
			<input type="hidden" name="page" id="page" value="<%=NextPage%>">
			<input type="hidden" name="Manageidx" id="Manageidx" value="<%=NextManageIdx%>">
			<input type="hidden" name="RemainTime" id="RemainTime" value="">
			<input type="hidden" name="isFail" id="isFail" value="0">
			<input type="hidden" name="prevYN" id="prevYN" value="">

			<% if IsArray(ArrOATQuestionList) = True Then %>
				<input type="hidden" name="QuestionTotalCount" id="QuestionTotalCount" value="<%=UBound(ArrOATQuestionList,2)+1%>">
				<%=printOATQuestion(ArrOATQuestionList,ArrOATAskList,ArrOATQuestionLogList)%>
			<% Else	%>
				<input type="hidden" name="QuestionTotalCount" id="QuestionTotalCount" value="0">
				입력된 문제가 없습니다.
			<% End If %>

			</form>

		</div>
		<!-- //questionArea -->

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
					<% Select case Manage_idx %>
					<% Case "1" %> <a href="javascript:;" class="testBtn next" onclick="return goNextPage();">언어추리 검사 이동</a>
					<% Case "2" %> <a href="javascript:;" class="testBtn next" onclick="return goNextPage();">자료해석 검사 이동</a>
					<% Case "3" %> <a href="javascript:;" class="testBtn next" onclick="return goNextPage();">수리추리 검사 이동</a>
					<% Case "4" %> <a href="javascript:;" class="testBtn next" onclick="return goNextPage();">응용계산 검사 이동</a>
					<% Case "5" %> <a href="javascript:;" class="testBtn next" onclick="return goNextPage();">공간지각 검사 이동</a>
					<% Case "6" %> <a href="javascript:;" class="testBtn end" onclick="return goNextPage();">적성검사 종료</a>
					<% End Select %>
				<% ElseIf CInt(Manage_Total_Page) > CInt(NextPage) Then %>
					<a href="javascript:;" class="testBtn next" onclick="return goNextPage();">다음 페이지</a>
				<% End If %>
			</span>
		</div>
		<!-- testBtnArea -->
	</div><!--#career_contents-->
</div>