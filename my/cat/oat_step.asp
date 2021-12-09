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

dim idx
idx = Trim(Request("idx"))

If idx = "" Then
	%>
	<script language="javascript">
	alert("잘못된 호출입니다.");
	location.href="default.asp";
	</script>
	<%
	response.End
End If

'개인로그 정보 조회
Dim ArrOATLogParams
redim ArrOATLogParams(1)
ArrOATLogParams(0) = idx
ArrOATLogParams(1) = user_id

dbCon.Open Application("DBInfo_FAIR")

dim ArrOATPersonalLogInfo
Call getOATPersonalLogInfo(dbCon, ArrOATLogParams, ArrOATPersonalLogInfo, "", "")

dbCon.Close

If IsArray(ArrOATPersonalLogInfo) = False Then
	%>
	<script language="javascript">
	alert("잘못된 호출입니다.");
	location.href="default.asp";
	</script>
	<%
	response.End
End If


Dim stepNum, stepInfo
If IsArray(ArrOATPersonalLogInfo) = True Then
	stepNum = Trim(ArrOATPersonalLogInfo(6,0))
	If stepNum = "0" Or stepNum = "10" Then
		stepInfo = 1
	ElseIf stepNum = "11" Or stepNum = "20" Then
		stepInfo = 2
	ElseIf stepNum = "21" Or stepNum = "30" Then
		stepInfo = 3
	ElseIf stepNum = "31" Or stepNum = "40" Then
		stepInfo = 4
	ElseIf stepNum = "41" Or stepNum = "50" Then
		stepInfo = 5
	ElseIf stepNum = "51" Or stepNum = "60" Then
		stepInfo = 6
	End If
End If
%>

<link href="//old.career.co.kr/css/reset_2015.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/comm_2016.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/my_2017.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/my_2017.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/user/cat.js"></script>

<body id="myWrap" class="myTest">

	<!-- HEADER -->
	<div id="header-id">
		<div class="header test">
			<h1>
				<img src="http://image.career.co.kr/career_new4/my/aptitude_test_h1.png" alt="커리어 적성검사">
				<span><strong>- 108 </strong>(문항)</span>
			</h1>
			<p>총 6개 적성을 진단할 수 있으며 자기 적성의 강/약점을 확인할 수 있습니다.</p>

		</div>
	</div><!-- #header-id -->
	<!--// HEADER -->

	<!-- CONTENTS 2017 -->
    <div id="career_container"  class="aptitudeTestWrap"><!-- 2017/03/02/hjyu -->

        <div id="career_contents">
			<div class="titArea ready">
				<h2>
					<% Select case stepInfo %>
					<% Case 1 %> <em class="round">STEP. 1</em>언어이해<span>(Verbal Comprehension)</span>
					<% Case 2 %> <em class="round">STEP. 2</em>언어추리<span>(Verbal Reasoning)</span>
					<% Case 3 %> <em class="round">STEP. 3</em>자료해석<span>(Data Analyzing)</span>
					<% Case 4 %> <em class="round">STEP. 4</em>수리추리<span>(Quantitative Reasoning)</span>
					<% Case 5 %> <em class="round">STEP. 5</em>응용계산<span>(Numerical Operation)</span>
					<% Case 6 %> <em class="round">STEP. 6</em>공간지각<span>(Special Perception)</span>
					<% End Select %>
				</h2>

				<div class="testItemBox">
					<ul>
						<li <% If stepInfo = 1 Then %>class="on"<% End If %>>
							<em class="round">언어이해</em>
							<p class="value"><strong class="num">20</strong> (분)</p>
						</li>
						<li <% If stepInfo = 2 Then %>class="on"<% End If %>>
							<em class="round">언어추리</em>
							<p class="value"><strong class="num">20</strong> (분)</p>
						</li>
						<li <% If stepInfo = 3 Then %>class="on"<% End If %>>
							<em class="round">자료해석</em>
							<p class="value"><strong class="num">20</strong> (분)</p>
						</li>
						<li <% If stepInfo = 4 Then %>class="on"<% End If %>>
							<em class="round">수리추리</em>
							<p class="value"><strong class="num">20</strong> (분)</p>
						</li>
						<li <% If stepInfo = 5 Then %>class="on"<% End If %>>
							<em class="round">응용계산</em>
							<p class="value"><strong class="num">20</strong> (분)</p>
						</li>
						<li <% If stepInfo = 6 Then %>class="on"<% End If %>>
							<em class="round">공간지각</em>
							<p class="value"><strong class="num">20</strong> (분)</p>
						</li>
						<li class="equals">
							<em class="round">총검사시간</em>
							<p class="value"><strong class="num">115</strong> (분)</p>
						</li>
					</ul>
				</div>
				<!-- //testItemBox -->
			</div>
			<!-- //titArea -->
			
			<div class="timeName">
				<p>
				<% Select case stepInfo %>
					<% Case 1 %>
						적성검사 첫 시간은 <strong>언어이해</strong>입니다.
						<span>시험이 끝나고 다음 단계로 넘어갈 때 바로 넘어가지 마시고, 잠시 심호흡을 하신 후에 다음단계 테스트를 진행하세요.</span>
					<% Case 2 %>
						이번 시간은 <strong>언어추리</strong>입니다.
						<span>시험이 끝나고 다음 단계로 넘어갈 때 바로 넘어가지 마시고, 잠시 심호흡을 하신 후에 다음단계 테스트를 진행하세요.</span>
					<% Case 3 %>
						이번 시간은 <strong>자료해석</strong>입니다.
						<span>시험이 끝나고 다음 단계로 넘어갈 때 바로 넘어가지 마시고, 잠시 심호흡을 하신 후에 다음단계 테스트를 진행하세요.</span>
					<% Case 4 %>
						이번 시간은 <strong>수리추리</strong>입니다.
						<span>시험이 끝나고 다음 단계로 넘어갈 때 바로 넘어가지 마시고, 잠시 심호흡을 하신 후에 다음단계 테스트를 진행하세요.</span>
					<% Case 5 %>
						이번 시간은 <strong>응용계산</strong>입니다.
						<span>시험이 끝나고 다음 단계로 넘어갈 때 바로 넘어가지 마시고, 잠시 심호흡을 하신 후에 다음단계 테스트를 진행하세요.</span>
					<% Case 6 %>
						이번 시간은 <strong>공간지각</strong>입니다.
						<span>마지막 시간인 만큼 유종의 미를 거둘 수 있도록 최선을 다하시기 바랍니다. 긴장 풀고 침착하게 진행하세요.</span>
				<% End Select %>
				</p>
				<div class="btnWrap">
					<button type="submit" class="btn typeOrange" onclick="javascript:location.href='oat_frame.asp?idx=<%=idx%>'">검사 시작하기</button>
				</div>
			</div>
			<div class="testCare">
				<p>
					※ 문제를 모두 풀고 다음페이지로 넘어가면 <strong>이전 문제는 다시 풀이 할 수 없습니다.</strong>
					<span>신중하게 검사에 응하시기 바랍니다.</span>
				</p>
			</div>

		</div><!--#career_contents-->
    </div><!-- #career_container -->
    <!-- //CONTENTS 2016 -->

</body>