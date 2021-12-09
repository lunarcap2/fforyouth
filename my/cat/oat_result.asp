<%
Option Explicit
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->

<!--#include virtual = "/wwwconf/query_lib/my/CAT_Info.asp"-->
<!--#include virtual = "/wwwconf/function/my/CAT_Function.asp"-->

<link href="//old.career.co.kr/css/reset_2015.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/comm_2016.css" rel="stylesheet" type="text/css" />
<link href="//old.career.co.kr/css/my_2017.css" rel="stylesheet" type="text/css" />

<script type="text/javascript" src="/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/my_2017.js"></script>

<script type="text/javascript" src="//old.career.co.kr/js/chartjs/Chart.min.js"></script>
<script type="text/javascript" src="//old.career.co.kr/js/chartjs/Chart.use.strict.js"></script>

<%
Call FN_LoginLimit("1234")

Dim SiteCode
SiteCode = getSiteCode(Request.ServerVariables("SERVER_NAME"))

dim idx
idx = Trim(Request("idx"))

If idx = "" Or idx="undefined" Then
	%>
	<script language="javascript">
	alert("잘못된 호출입니다.");
	window.close();
	</script>
	<%
	response.End
End If

If user_id = "" Then
	user_id = Request("user_id")
	If Len(user_id) > 20 Then
		user_id = objEncrypter.Decrypt(user_id)
	End If
End If

dbCon.Open Application("DBInfo_FAIR")

Dim ArrOATLogParams
redim ArrOATLogParams(1)
ArrOATLogParams(0) = SiteCode
ArrOATLogParams(1) = user_id

'적성검사 검사 완료 목록
dim ArrOATPersonalLogAfterList
Call getOATPersonalLogAfterList(dbCon, ArrOATLogParams, ArrOATPersonalLogAfterList, "", "")

'개인로그 정보 조회
Dim ArrOATPersonalLogParams
redim ArrOATPersonalLogParams(1)
ArrOATPersonalLogParams(0) = idx
ArrOATPersonalLogParams(1) = user_id

dim ArrOATPersonalLogInfo
Call getOATPersonalLogInfo(dbCon, ArrOATPersonalLogParams, ArrOATPersonalLogInfo, "", "")

'섹션별 결과 정보 조회
Dim ArrOATSectionResultParams
redim ArrOATSectionResultParams(1)
ArrOATSectionResultParams(0) = idx
ArrOATSectionResultParams(1) = user_id

dim ArrOATResultSection
Call getOATSectionResultInfo(dbCon, ArrOATSectionResultParams, ArrOATResultSection, "", "")

'최고 점수 섹션 찾기
If IsArray(ArrOATResultSection) = True Then
	Dim MaxSectionScore,MaxSectionOrder
	MaxSectionScore = 0
	Dim LoopCountSection
	For LoopCountSection = 0 To UBound(ArrOATResultSection,2)
		If LoopCountSection = 0 Then
			MaxSectionScore = CInt(Trim(ArrOATResultSection(7,0)))
			MaxSectionOrder = Trim(ArrOATResultSection(3,0))
		End if
		If MaxSectionScore < CInt(Trim(ArrOATResultSection(7,LoopCountSection))) then
			MaxSectionScore = CInt(Trim(ArrOATResultSection(7,LoopCountSection)))
			MaxSectionOrder = Trim(ArrOATResultSection(3,LoopCountSection))
		ElseIf MaxSectionScore = CInt(Trim(ArrOATResultSection(7,LoopCountSection))) Then
			MaxSectionScore = CInt(Trim(ArrOATResultSection(7,LoopCountSection)))
			MaxSectionOrder = MaxSectionOrder & "," & Trim(ArrOATResultSection(3,LoopCountSection))
		End If
	Next
End If

'직종별 결과 정보 조회
Dim ArrOATJobResultParams
redim ArrOATJobResultParams(1)
ArrOATJobResultParams(0) = idx
ArrOATJobResultParams(1) = user_id

dim ArrOATResultJob
Call getOATJobResultInfo(dbCon, ArrOATJobResultParams, ArrOATResultJob, "", "")

'최고 점수 직종 찾기
If IsArray(ArrOATResultJob) = True Then
	Dim MaxJobScore,MaxJobOrder
	MaxJobScore = 0
	Dim LoopCountJob
	For LoopCountJob = 0 To UBound(ArrOATResultJob,2)
		If LoopCountJob = 0 Then
			MaxJobScore = CInt(Trim(ArrOATResultJob(7,0)))
			MaxJobOrder = Trim(ArrOATResultJob(3,0))
		End if
		If MaxJobScore < CInt(Trim(ArrOATResultJob(7,LoopCountJob))) then
			MaxJobScore = CInt(Trim(ArrOATResultJob(7,LoopCountJob)))
			MaxJobOrder = Trim(ArrOATResultJob(3,LoopCountJob))
		ElseIf MaxJobScore = CInt(Trim(ArrOATResultJob(7,LoopCountJob))) Then
			MaxJobScore = CInt(Trim(ArrOATResultJob(7,LoopCountJob)))
			MaxJobOrder = MaxJobOrder & "," & Trim(ArrOATResultJob(3,LoopCountJob))
		End If
	Next
End If

dbCon.Close


If IsArray(ArrOATResultSection) = False Then
	%>
	<script language="javascript">
	alert("완료된 결과 내역만 확인하실 수 있습니다.");
	window.close();
	</script>
	<%
	response.End
End If


If IsArray(ArrOATPersonalLogInfo) = False Then
	%>
	<script language="javascript">
	alert("결제 내역이 없습니다.");
	window.close();
	</script>
	<%
	response.End
Else
	Dim PersonalLog_Identity,PersonalLog_Status,PersonalLog_Name,PersonalLog_Age,PersonalLog_ResultScore,PersonalLog_ResultAvg,PersonalLog_ResultRate,PersonalLog_ResultGrade,PersonalLog_ResultExplain,PersonalLog_ResultDate
	PersonalLog_Identity  = Trim(ArrOATPersonalLogInfo(3,0)) 
	PersonalLog_Status  = Trim(ArrOATPersonalLogInfo(6,0)) 
	PersonalLog_Name = Trim(ArrOATPersonalLogInfo(11,0)) 
	PersonalLog_Age = Trim(ArrOATPersonalLogInfo(12,0))	
	PersonalLog_ResultScore = Trim(ArrOATPersonalLogInfo(13,0))
	PersonalLog_ResultAvg = Trim(ArrOATPersonalLogInfo(14,0))
	PersonalLog_ResultRate = Trim(ArrOATPersonalLogInfo(15,0))
	PersonalLog_ResultGrade = Trim(ArrOATPersonalLogInfo(16,0))
	PersonalLog_ResultExplain = Trim(ArrOATPersonalLogInfo(17,0))
	PersonalLog_ResultDate = Trim(ArrOATPersonalLogInfo(18,0))

	If PersonalLog_Status <> "999" Then
		%>
		<script language="javascript">
		alert("완료된 결과 내역만 확인하실 수 있습니다.");
		window.close();
		</script>
		<%
		response.End
	End if
End if


%>
<script>
function ChangeIdx()
{
	$('#frm_oat').attr("action", "/my/cat/oat_result.asp?idx=" + document.getElementById("idx").value);
    $('#frm_oat').submit();
	//location.href="oat_result.asp?idx="+document.getElementById("idx").value;
}
</script>

<body class="myTest">

<form method="post" id="frm_oat" name="frm_oat">
	<input type="hidden" id="oat_user_id" name="user_id" value="<%=user_id%>" />
</form>
	
<div class="popView">
	<div class="inner">
		<h1>
			<img src="http://image.career.co.kr/career_new4/my/pop_aptitude_h3.png" alt="커리어 인성검사 OCI 결과 분석표">
			<span>
				※ 적성검사에는 언어, 수리, 추리, 공간지각능력 등 각 적성영역에서 우수한 능력을 보이는 사람을 선발하는데 활용됩니다.
			</span>
		</h1>
		<button type="submit" class="print"  onclick="window.location.href='javascript:window.print();'">인쇄하기</button>
	</div>
	<!-- inner -->

	<div id="contents" class="resumeWrap viewWrap">
		<% If IsArray(ArrOATPersonalLogAfterList) Then %>
		<div class="titArea">
			<span class="selectbox">
				<span class=""></span>
				<select name="idx" id="idx" onchange="ChangeIdx();">
					<%
					Dim LoopCount
					For LoopCount = 0 To UBound(ArrOATPersonalLogAfterList,2)
					%>
						<option value="<%=Trim(ArrOATPersonalLogAfterList(0,LoopCount))%>" <% If idx = Trim(ArrOATPersonalLogAfterList(0,LoopCount)) Then %>selected<% End If %>>
							검사결과 <%=UBound(ArrOATPersonalLogAfterList,2)-LoopCount+1%> : 
							<% 
							If IsNull(Trim(ArrOATPersonalLogAfterList(18,LoopCount))) Then 
								Response.write Trim(ArrOATPersonalLogAfterList(18,LoopCount))
							Else
								Response.write FormatDateTime(Trim(ArrOATPersonalLogAfterList(18,LoopCount)),2)
							End If
							%>
						</option>
					<%
					Next
					%>
				</select>
			</span>
		</div>
		<% End If %>

		<div class="conArea">
			<div class="boardArea first">
				<table class="tb info" summary="인적사항">
					<caption>인적사항</caption>
					<colgroup>
						<col style="width:25%">
						<col style="width:25%">
						<col style="width:25%">
						<col>
					</colgroup>
					<thead>
						<tr class="">
							<th>성명</th>
							<th>검사ID</th>
							<th>연령</th>
							<th>검사일자</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><%=PersonalLog_Name%></td>
							<td><em class="taho"><%=PersonalLog_Identity%></em></td>
							<td><%=PersonalLog_Age%>세</td>
							<td><em class="taho"><%=Left(PersonalLog_ResultDate,10)%></em></td>
						</tr>
						<!--
						<tr>
							<td colspan="4">
								<div class="noData">
									<p>서비스 이용내역이 없습니다.</p>
								</div>
							</td>
						</tr>
						-->
					</tbody>
				</table>
			</div>
			<!-- .boardArea -->
		</div>
		<!-- .conArea -->

		<div class="titArea bdrNone">
			<p class="boldTit">적성검사 OAT 결과</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="oatDl">
				<dl>
					<dt>백분위</dt>
					<dd class="result"><em class="taho"><%=FormatNumber(PersonalLog_ResultRate,2)%></em></dd>
					<dd class="ment">
						01~10 - <em>10등급</em>  <span>/</span>  11~20 - <em>9등급</em>  <span>/</span>  21~30 - <em>8등급</em>  <span>/</span>..<span>/</span>  91~100 - <em>1등급</em>
					</dd>
				</dl>
				<dl>
					<dt>등급</dt>
					<dd class="result"><em class="taho"><%=Trim(Left(PersonalLog_ResultGrade, 2))%></em> (등급)</dd>
					<dd class="ment"><%=PersonalLog_ResultExplain%></dd>
				</dl>
			</div>
		</div>
		<!-- .conArea -->

		<div class="titArea bdrNone">
			<p class="normalTit">적성별 점수비교 그래프</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="chartArea">

				<!-- 그래프 영역(chartjs) -->
				<div>
					<canvas id="myChart" width="800" height="250"></canvas>
				</div>
				<script>
					var color = Chart.helpers.color;
					var ctx = document.getElementById("myChart");
					var myChart = new Chart(ctx, {
						type: 'bar',
						data: {
							labels: ['언어이해','언어추리','자료해석','수리추리','응용계산','공간지각'],
							datasets: [{
								label: '적성별 점수',
								data: [
									<%=printOATResult(ArrOATResultSection,1,3)%>,
									<%=printOATResult(ArrOATResultSection,2,3)%>,
									<%=printOATResult(ArrOATResultSection,3,3)%>,
									<%=printOATResult(ArrOATResultSection,4,3)%>,
									<%=printOATResult(ArrOATResultSection,5,3)%>,
									<%=printOATResult(ArrOATResultSection,6,3)%>
								],
								backgroundColor: [
									color(window.chartColors.red).alpha(0.5).rgbString(),
									color(window.chartColors.blue).alpha(0.5).rgbString(),
									color(window.chartColors.yellow).alpha(0.5).rgbString(),
									color(window.chartColors.green).alpha(0.5).rgbString(),
									color(window.chartColors.purple).alpha(0.5).rgbString(),
									color(window.chartColors.orange).alpha(0.5).rgbString()
								],
								borderColor: [
									window.chartColors.red,
									window.chartColors.blue,
									window.chartColors.yellow,
									window.chartColors.green,
									window.chartColors.purple,
									window.chartColors.orange
								],
								borderWidth: 1
							}]
						},
						options: {
							responsive: true,
							legend: {
								position: 'top',
							},
							scales: {
								yAxes: [{
									ticks: {
										suggestedMax: 100
									}
								}]
							}
						}
					});
				</script>
				<!-- //그래프 영역 -->

				<div class="boardArea">
					<table class="tb" summary="적성별 점수비교 테이블">
						<caption>적성별 점수비교 테이블</caption>
						<colgroup>
							<col style="width:110px">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
							<col style="width:125px">
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>언어이해</th>
								<th>언어추리</th>
								<th>자료해석</th>
								<th>수리추리</th>
								<th>응용계산</th>
								<th>공간지각</th>
							</tr>
						</thead>
						<tbody>
							<tr class="txtOrange">
								<td>적성등급</td>
								<td><%=printOATResult(ArrOATResultSection,1,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,2,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,3,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,4,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,5,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,6,4)%></td>
							</tr>
							<tr>
								<td>점수</td>
								<td><em class="taho"><%=printOATResult(ArrOATResultSection,1,3)%></em></td>
								<td><em class="taho"><%=printOATResult(ArrOATResultSection,2,3)%></em></td>
								<td><em class="taho"><%=printOATResult(ArrOATResultSection,3,3)%></em></td>
								<td><em class="taho"><%=printOATResult(ArrOATResultSection,4,3)%></em></td>
								<td><em class="taho"><%=printOATResult(ArrOATResultSection,5,3)%></em></td>
								<td><em class="taho"><%=printOATResult(ArrOATResultSection,6,3)%></em></td>
							</tr>
							<!--
							<tr>
								<td colspan="7">
									<div class="noData">
										<p>서비스 이용내역이 없습니다.</p>
									</div>
								</td>
							</tr>
							-->
						</tbody>
					</table>
				</div>
				<!-- .boardArea -->
			</div>
			<!-- chartArea -->
		</div>
		<!-- .conArea -->

		<div class="titArea bdrNone">
			<p class="boldTit">직종별 적성적합도</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="boardArea">
				<table class="tb" summary="직종별 적성적합도 테이블">
					<caption>직종별 적성적합도 테이블</caption>
					<colgroup>
						<col style="width:110px">
						<col style="width:125px">
						<col style="width:125px">
						<col style="width:125px">
						<col style="width:125px">
						<col style="width:125px">
						<col style="width:125px">
					</colgroup>
					<thead>
						<tr>
							<th>구분</th>
							<th <% If InStr(MaxJobOrder,"1") > 0 Then %> class="on" <% End If %>>대졸 사무직</th>
							<th <% If InStr(MaxJobOrder,"2") > 0 Then %> class="on" <% End If %>>재무/금융</th>
							<th <% If InStr(MaxJobOrder,"3") > 0 Then %> class="on" <% End If %>>IT/컴퓨터</th>
							<th <% If InStr(MaxJobOrder,"4") > 0 Then %> class="on" <% End If %>>기술/엔지니어</th>
							<th <% If InStr(MaxJobOrder,"5") > 0 Then %> class="on" <% End If %>>영업/서비스</th>
							<th <% If InStr(MaxJobOrder,"6") > 0 Then %> class="on" <% End If %>>생산/제조</th>
						</tr>
					</thead>
					<tbody>
						<tr class="txtOrange">
							<td>적성등급</td>
							<td <% If InStr(MaxJobOrder,"1") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,1,4)%></td>
							<td <% If InStr(MaxJobOrder,"2") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,2,4)%></td>
							<td <% If InStr(MaxJobOrder,"3") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,3,4)%></td>
							<td <% If InStr(MaxJobOrder,"4") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,4,4)%></td>
							<td <% If InStr(MaxJobOrder,"5") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,5,4)%></td>
							<td <% If InStr(MaxJobOrder,"6") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,6,4)%></td>
						</tr>
						<tr>
							<td>백분위 점수</td>
							<td <% If InStr(MaxJobOrder,"1") > 0 Then %> class="on" <% End If %>><em class="taho"><%=FormatNumber(printOATResultJob(ArrOATResultJob,1,3),2)%></em></td>
							<td <% If InStr(MaxJobOrder,"2") > 0 Then %> class="on" <% End If %>><em class="taho"><%=FormatNumber(printOATResultJob(ArrOATResultJob,2,3),2)%></em></td>
							<td <% If InStr(MaxJobOrder,"3") > 0 Then %> class="on" <% End If %>><em class="taho"><%=FormatNumber(printOATResultJob(ArrOATResultJob,3,3),2)%></em></td>
							<td <% If InStr(MaxJobOrder,"4") > 0 Then %> class="on" <% End If %>><em class="taho"><%=FormatNumber(printOATResultJob(ArrOATResultJob,4,3),2)%></em></td>
							<td <% If InStr(MaxJobOrder,"5") > 0 Then %> class="on" <% End If %>><em class="taho"><%=FormatNumber(printOATResultJob(ArrOATResultJob,5,3),2)%></em></td>
							<td <% If InStr(MaxJobOrder,"6") > 0 Then %> class="on" <% End If %>><em class="taho"><%=FormatNumber(printOATResultJob(ArrOATResultJob,6,3),2)%></em></td>
						</tr>
						<!--
						<tr>
							<td colspan="7">
								<div class="noData">
									<p>서비스 이용내역이 없습니다.</p>
								</div>
							</td>
						</tr>
						-->
					</tbody>
				</table>
				<ul class="baUl">
					<li>
						<em>1.</em> 직종별 적성 적합도 점수에서는 <strong>자신의 적성이 어느 직종에 보다 더 적합한지를 확인</strong>할 수 있습니다.
					</li>
					<li>
						<em>2.</em> 각 직종별 점수는 해당 직종과 관련된 적성 영역에서의 검사 점수들을 계산공식에 의해 산출한 것입니다.<br>
					</li>
					<li>
					<em>3.</em> 직종별 적성등급에서 보다 <strong>고순위(1등급이 가장 높음) 일수록, 점수가 더 높을 수록(100점 만점) 자신의 적성에 적합한 직종</strong>이라 할 수 있습니다.
					</li>
					<li>
					   (예 : 백분위 점수 75 = 자신보다 낮은 점수인 사람들이 75% 있음)
					</li>
					<li>
					   (단, 본 검사 결과는 각 직종을 단순 분류한 것으로, 세부적인 직무에 적용할 경우 결과가 달라질 수 있습니다.)
					</li>
				</ul>
			</div>
			<!-- .boardArea -->
		</div>
		<!-- .conArea -->
		
		<div class="titArea bdrNone">
			<p class="boldTit">등급 환산표</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="boardArea">
				<table class="tb rating" summary="등급 환산표 테이블">
					<caption>등급 환산표 테이블</caption>
					<colgroup>
						<col style="width:90px">
						<col style="width:105px">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>구분</th>
							<th>점수</th>
							<th>내용</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1등급</td>
							<td><em class="taho">91~100</em></td>
							<td rowspan="2">
								<span>탁월한 능력을 보유하고 있으며 적합도 수준 매우 높음</span>
							</td>
						</tr>
						<tr>
							<td>2등급</td>
							<td><em class="taho">81~90</em></td>
						</tr>
						<tr>
							<td>3등급</td>
							<td><em class="taho">71~80</em></td>
							<td rowspan="2">
								<span>우수한 수준의 능력을 보유하고 있거나, 개발 가능성이 있음. 적합도 수준 높음</span>
							</td>
						</tr>
						<tr>
							<td>4등급</td>
							<td><em class="taho">61~70</em></td>
						</tr>
						<tr>
							<td>5등급</td>
							<td><em class="taho">51~60</em></td>
							<td rowspan="2">
								<span>보통 수준의 능력을 보유하고 있거나, 특별히 개발되어 있지 않음. 적합도 수준 보통</span>
							</td>
						</tr>
						<tr>
							<td>6등급</td>
							<td><em class="taho">41~50</em></td>
						</tr>
						<tr>
							<td>7등급</td>
							<td><em class="taho">31~40</em></td>
							<td rowspan="2">
								<span>미흡한 수준의 능력을 보유하고 있으며, 개발되어 있지 않음. 적합도 수준 부적합</span>
							</td>
						</tr>
						<tr>
							<td>8등급</td>
							<td><em class="taho">21~30</em></td>
						</tr>
						<tr>
							<td>9등급</td>
							<td><em class="taho">11~20</em></td>
							<td rowspan="2">
								<span>매우 미흡한 수준의 능력을 보유하고 있으며, 전혀 개발되어 있지 않음. 적합도 수준 매우 부적합</span>
							</td>
						</tr>
						<tr>
							<td>10등급</td>
							<td><em class="taho">0~10</em></td>
						</tr>
						
						<!--
						<tr>
							<td colspan="3">
								<div class="noData">
									<p>서비스 이용내역이 없습니다.</p>
								</div>
							</td>
						</tr>
						-->
					</tbody>
				</table>
			</div>
			<!-- .boardArea -->
		</div>
		<!-- .conArea -->

		<%
		If IsArray(ArrOATResultSection) = True Then

			Dim WeakTopFlag
			WeakTopFlag = False

			Dim LoopCountWeak
			For LoopCountWeak = 0 To UBound(ArrOATResultSection,2)
				If Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 Then
					WeakTopFlag = True
				End If
			Next
			

			If WeakTopFlag = True Then
		%>
				<div class="titArea bdrNone">
					<p class="boldTit">약점에 대한 권고사항<span>(Recommendation)</span></p>
				</div><!-- .titArea -->

				<div class="conArea">
					<div class="boardArea">
						<table class="tb recom" summary="약점에 대한 권고사항 테이블">
							<caption>약점에 대한 권고사항 테이블</caption>
							<colgroup>
								<col style="width:105px">
								<col>
							</colgroup>
							
							<thead>
								<tr>
									<th>적성영역</th>
									<th><em class="taho">Recommendation</em></th>
								</tr>
							</thead>

							<tbody>
								<%
								For LoopCountWeak = 0 To UBound(ArrOATResultSection,2)
								%>
								
									<% If Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "1" Then %>
									<tr>
										<td>언어이해</td>
										<td>
											<span>머리속에 사물을 돌려 보거나, 사물의 뒷면이 어떤 모양일지에 대해서 상상하는 연습을 하십시오</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "2" Then %>
									<tr>
										<td>언어추리</td>
										<td>
											<span>주어진 정보들을 도식화 하고, 그 중 불충분한 정보가 무엇인지를 찾아내는 연습을 하십시오</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "3" Then %>
									<tr>
										<td>자료해석</td>
										<td>
											<span>신문이나 통계자료들을 자주 보고, 그것이 의미하는 바가 무엇인지에 대해서 이해하기 위한 연습을 하십시오</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "4" Then %>
									<tr>
										<td>수리추리</td>
										<td>
											<span>일상 생활에서 계산해야 할 일들이 있을 때, 그것들을 머리속에서 수식으로 개념화 하는 연습을 하십시오</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "5" Then %>
									<tr>
										<td>응용계산</td>
										<td>
											<span>평소에 계산 할 때 도구(컴퓨터, 계산기)를 사용하기보다 암산이나, 손으로 계산하는 연습을 하십시오</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "6" Then %>
									<tr>
										<td>공간지각</td>
										<td>
											<span>머리속에서 사물을 돌려 보거나, 사물의 뒷면이 어떤 모양일지에 대해서 상상하는 연습을 하십시오</span>
										</td>
									</tr>
									<% End If %>

								<%
								Next '-- (For LoopCountWeak = 0 To UBound(ArrOATResultSection,2))
								%>
							</tbody>
						</table>
						
						<p>
							<em class="taho">Recommendation</em>을 통해 약점 적성의 개발 방향을 확인하십시오. 한번 보고 잊어버리기 보다는 아무리 사소한 방법이라도 기억하고 실천해 보십시오. <br>적성능력은 노력여하에 따라 개선/개발이 가능합니다.	
						</p>
					</div>
					<!-- .boardArea -->
				</div>
				<!-- .conArea -->
		<%
			End If '-- (If WeakTopFlag = True Then)
		End If '-- (If IsArray(ArrOATResultSection) = True Then)
		%>

		<div class="btnWrap">
			<button type="submit" class="test print" onclick="window.location.href='javascript:window.print();'">인쇄하기</button>
			<button type="reset" class="test closeBtm" onClick="opener.location.reload(); self.close();">창닫기</button>
		</div>
	</div>
	<!-- viewWrap -->

</div>
<!-- popView -->
</body>