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

Dim idx
idx = Request("idx")

If idx = "" Then
	%>
	<script language="javascript">
	alert("잘못된 호출입니다.");
	location.href="default.asp";
	</script>
	<%
	response.end
End If

If user_id = "" Then
	user_id = Request("user_id")
	If Len(user_id) > 20 Then
		user_id = objEncrypter.Decrypt(user_id)
	End If
End If

dbCon.Open Application("DBInfo_FAIR")

Dim ArrOCILogParams
redim ArrOCILogParams(1)
ArrOCILogParams(0) = SiteCode
ArrOCILogParams(1) = user_id

'인성검사 검사 완료 목록
dim ArrOCIPersonalLogAfterList
Call getOCIPersonalLogAfterList(dbCon, ArrOCILogParams, ArrOCIPersonalLogAfterList, "", "")


'인성검사 개인로그 정보 조회
Dim ArrOCIPersonalLogParams
redim ArrOCIPersonalLogParams(1)
ArrOCIPersonalLogParams(0) = idx
ArrOCIPersonalLogParams(1) = user_id

dim ArrOCIPersonalLogInfo
Call getOCIPersonalLogInfo(dbCon, ArrOCIPersonalLogParams, ArrOCIPersonalLogInfo, "", "")

'인성검사 능력별결과 (본인)
Dim arrOCIPersonalResultParams
redim arrOCIPersonalResultParams(1)
arrOCIPersonalResultParams(0) = idx
arrOCIPersonalResultParams(1) = user_id

dim ArrOCIPersonalResultList
Call getOCIPersonalResultList(dbCon, arrOCIPersonalResultParams, ArrOCIPersonalResultList, "", "")

'인성검사 능력별결과 (대학생)
dim ArrOCIPersonalResultUniv
Call getOCIPersonalResultUniv(dbCon, ArrOCIPersonalResultUniv, "", "")

'인성검사 능력별결과 (직장인)
dim ArrOCIPersonalResultCompany
Call getOCIPersonalResultCompany(dbCon, ArrOCIPersonalResultCompany, "", "")

'인성검사 능력군별결과
Dim arrOCIPersonalResultGroupParams
redim arrOCIPersonalResultGroupParams(1)
arrOCIPersonalResultGroupParams(0) = idx
arrOCIPersonalResultGroupParams(1) = user_id

dim ArrOCIPersonalResultGroupList
Call getOCIPersonalResultGroupList(dbCon, arrOCIPersonalResultGroupParams, ArrOCIPersonalResultGroupList, "", "")

'인성검사 능력군별결과 (대학생)
dim ArrOCIPersonalResultGroupUniv
Call getOCIPersonalResultGroupUniv(dbCon, ArrOCIPersonalResultGroupUniv, "", "")

'인성검사 능력군별결과 (직장인)
dim ArrOCIPersonalResultGroupCompany
Call getOCIPersonalResultGroupCompany(dbCon, ArrOCIPersonalResultGroupCompany, "", "")

dbCon.Close


If IsArray(ArrOCIPersonalLogInfo) = False Then
	%>
	<script language="javascript">
	alert("결제 내역이 없습니다.");
	window.close();
	</script>
	<%
	response.End
Else
	
	Dim PersonalLog_Identity,PersonalLog_Status,PersonalLog_Name,PersonalLog_Age,PersonalLog_ResultScore,PersonalLog_ResultAvg,PersonalLog_ResultCorrect,PersonalLog_ResultDate
	PersonalLog_Identity  =Trim(ArrOCIPersonalLogInfo(3,0))
	PersonalLog_Status  = Trim(ArrOCIPersonalLogInfo(6,0)) 
	PersonalLog_Name = Trim(ArrOCIPersonalLogInfo(11,0)) 
	PersonalLog_Age = Trim(ArrOCIPersonalLogInfo(12,0))	
	PersonalLog_ResultScore = Trim(ArrOCIPersonalLogInfo(13,0))
	If isNull(ArrOCIPersonalLogInfo(14,0)) = True Then
		PersonalLog_ResultAvg = "0.00"
	Else
		PersonalLog_ResultAvg = FormatNumber(Trim(ArrOCIPersonalLogInfo(14,0)),2)
	End If
	If IsNull(Trim(ArrOCIPersonalLogInfo(15,0))) = True Then
		PersonalLog_ResultCorrect = "미흡"
	Else
		PersonalLog_ResultCorrect = Trim(ArrOCIPersonalLogInfo(15,0))
	End If
	
	PersonalLog_ResultDate = Trim(ArrOCIPersonalLogInfo(16,0))

	If PersonalLog_Status <> "999" Then
		%>
		<script language="javascript">
		alert("완료된 결과 내역만 확인하실 수 있습니다.");
		window.close();
		</script>
		<%
		response.End
	End if
End If

%>
<script>
function ChangeIdx()
{
	$('#frm_oat').attr("action", "/my/cat/oci_result.asp?idx=" + document.getElementById("idx").value);
    $('#frm_oat').submit();
	//location.href="oci_result.asp?idx="+document.getElementById("idx").value;
}
</script>

<body class="myTest">

<form method="post" id="frm_oat" name="frm_oat">
	<input type="hidden" id="oat_user_id" name="user_id" value="<%=user_id%>" />
</form>

<div class="popView">
	<div class="inner">
		<h1>
			<img src="http://image.career.co.kr/career_new4/my/pop_personality_h3.png" alt="커리어 인성검사 OCI 결과 분석표">
			<span>
				※ 인성검사의 특성상 본 검사에 제시된 대학생 평균과 현직장인 평균 점수는 절대 기준이 될 수 없습니다. 참고로만 활용해 주십시오.
			</span>
		</h1>
		<button type="submit" class="print"  onclick="window.location.href='javascript:window.print();'">인쇄하기</button>
	</div>
	<!-- inner -->

	<div id="contents" class="resumeWrap viewWrap">
		
		<% If IsArray(ArrOCIPersonalLogAfterList) Then %>
		<div class="titArea">
			<span class="selectbox">
				<span class=""></span>
				<select name="idx" id="idx" onchange="ChangeIdx();">
					<%
					Dim LoopCount
					For LoopCount = 0 To UBound(ArrOCIPersonalLogAfterList,2)
					%>
						<option value="<%=Trim(ArrOCIPersonalLogAfterList(0,LoopCount))%>" <% If idx = Trim(ArrOCIPersonalLogAfterList(0,LoopCount)) Then %>selected<% End If %>>
							검사결과 <%=UBound(ArrOCIPersonalLogAfterList,2)-LoopCount+1%> : 
							<%
							If IsNull(Trim(ArrOCIPersonalLogAfterList(16,LoopCount))) = True Then
								Response.write Trim(ArrOCIPersonalLogAfterList(16,LoopCount))
							Else
								Response.write FormatDateTime(Trim(ArrOCIPersonalLogAfterList(16,LoopCount)),2)
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
						<tr>
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
			<p class="boldTit">인성검사 OCI 결과</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="ociDl">
				<dl>
					<dt>종합결과점수</dt>
					<dd class="result"><em class="taho"><%=PersonalLog_ResultAvg%></em></dd>
					<dd class="ment">
						91점 초과 - <em>매우적합</em><span>/</span>91~83점 - <em>적합</em><span>/</span>83~66점 - <em>보통</em><span>/</span>66점 이하 - <em>미흡</em>
					</dd>
				</dl>
				<dl>
					<dt>적합도 판단결과</dt>
					<dd class="result"><em class="txtBlue"><%=PersonalLog_ResultCorrect%></em></dd>
					<%
					Select Case PersonalLog_ResultCorrect
						Case "미흡" : Response.write "<dd class='ment'>기업(조직)이 원하는 인재상에 적합하지 않음</dd>"
						Case "보통" : Response.write "<dd class='ment'>평범한 수준의 인성역량을 보유하고 있음</dd>"
						Case "적합" : Response.write "<dd class='ment'>기업(조직)이 원하는 인재로서, 적합한 인성역량을 보유하고 있음</dd>"
						Case "매우 적합" : Response.write "<dd class='ment'>기업(조직)이 원하는 핵심 인재로서, 매우 적합한 인성역량을 보유하고 있음</dd>"
					End Select
					%>
				</dl>
			</div>
		</div>
		<!-- .conArea -->

		<div class="titArea bdrNone">
			<p class="normalTit">역량별 점수비교 그래프</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="chartArea">
				
				<!-- 
				<img src="http://image.career.co.kr/career_new4/my/result_chart.jpg" alt="역량별 점시비교 그래프">

				<ul class="legen">
					<li><em class="red"></em><%=PersonalLog_Name%></li>
					<li><em class="green"></em>대학생 평균</li>
					<li><em class="blue"></em>직장인 평균</li>
				</ul>
				-->

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
							labels: ['인지적 사고','마음가짐','업무실행','대인관계'],
							datasets: [
								{
									label: '<%=PersonalLog_Name%>',
									data: [
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupList,1,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupList,2,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupList,3,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupList,4,1)%>
									],
									backgroundColor: color(window.chartColors.red).alpha(0.5).rgbString(),
									borderColor: window.chartColors.red,
									borderWidth: 1
								},
								{
									label: '대학생 평균',
									data: [
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,1,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,2,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,3,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,4,1)%>
									],
									backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),
									borderColor: window.chartColors.blue,
									borderWidth: 1
								},
								{
									label: '직장인 평균',
									data: [
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,1,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,2,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,3,1)%>,
										<%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,4,1)%>
									],
									backgroundColor: color(window.chartColors.yellow).alpha(0.5).rgbString(),
									borderColor: window.chartColors.yellow,
									borderWidth: 1
								}
							]
						},
						options: {
							responsive: true,
							legend: {
								position: 'top',
							},
							scales: {
								yAxes: [{
									ticks: {
										suggestedMax: 100,
										suggestedMin: 0
									}
								}]
							}
						}
					});
				</script>
				<!-- //그래프 영역 -->
				
				<div class="boardArea printT">
					<table class="tb" summary="인적사항">
						<caption>인적사항</caption>
						<colgroup>
							<col style="width:100px">
							<col style="width:190px">
							<col style="width:190px">
							<col style="width:190px">
							<col style="width:190px">
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th>인지적 사고</th>
								<th>마음가짐</th>
								<th>업무실행</th>
								<th>대인관계</th>
							</tr>
						</thead>
						<tbody>
							<tr class="txtOrange">
								<td><%=PersonalLog_Name%></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupList,1,1)%></em>(<%=printOCIResultGroup(ArrOCIPersonalResultGroupList,1,2)%>)</td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupList,2,1)%></em>(<%=printOCIResultGroup(ArrOCIPersonalResultGroupList,2,2)%>)</td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupList,3,1)%></em>(<%=printOCIResultGroup(ArrOCIPersonalResultGroupList,3,2)%>)</td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupList,4,1)%></em>(<%=printOCIResultGroup(ArrOCIPersonalResultGroupList,4,2)%>)</td>
							</tr>
							<tr>
								<td>대학생</td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,1,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,2,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,3,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,4,1)%></em></td>
							</tr>
							<tr>
								<td>직장인</td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,1,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,2,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,3,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,4,1)%></em></td>
							</tr>
							<!--
							<tr>
								<td colspan="5">
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
		
		<section class="break"></section>
		<div class="titArea bdrNone">
			<p class="boldTit">역량별 점수 종합비교</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="compare"">
				<ul>
					<li><em class="taho">91</em>점 초과 - <span class="txtBlue">매우적합</span></li>
					<li><em class="taho">91~83</em>점 - <span class="txtBlue">적합</span></li>
					<li><em class="taho">83~66</em>점 - <span class="txtBlue">보통</span></li>
					<li><em class="taho">66</em>점 이하 - <span class="txtBlue">미흡</span></li>
				</ul>
			</div>
		</div>
		<!-- .conArea -->
		<div class="titArea bdrNone">
			<p class="normalTit">인지적 사고와 관련된 역량</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="abilityArea">
				<!-- 
				<img src="http://image.career.co.kr/career_new4/my/ability_img.jpg" alt="인지적 사고와 관련된 역량 그래프">
				-->

				<!-- 그래프 영역(chartjs) -->
				<div>
					<canvas id="myChart_1" height="100"></canvas>
				</div>
				<script>
					var color = Chart.helpers.color;
					var ctx = document.getElementById("myChart_1");
					var myChart_1 = new Chart(ctx, {
						type: 'radar',
						data: {
							labels: [
								'<%=ArrOCIPersonalResultList(6,0)%>',
								'<%=ArrOCIPersonalResultList(6,1)%>',
								'<%=ArrOCIPersonalResultList(6,2)%>',
								'<%=ArrOCIPersonalResultList(6,3)%>',
								'<%=ArrOCIPersonalResultList(6,4)%>',
								'<%=ArrOCIPersonalResultList(6,5)%>'
							],
							datasets: [
								{
									label: '인지적 사고',
									data: [
										<%=printOCIResult(ArrOCIPersonalResultList,1,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,2,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,3,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,4,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,5,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,6,1)%>
									],
									backgroundColor: color(window.chartColors.yellow).alpha(0.5).rgbString(),
									borderColor: window.chartColors.yellow,
									pointBackgroundColor: window.chartColors.yellow,
									borderWidth: 1,
									pointRadius: 2
								}
							]
						},
						options: {
							legend: {
								position: 'top',
							},
							scale: {
								ticks: {
									beginAtZero: true,
									suggestedMax: 100
								}
							}
						}
					});
				</script>
				<!-- //그래프 영역 -->

				<div class="boardArea">
					<table class="tb" summary="인지적 사고와 관련된 역량 테이블">
						<caption>인지적 사고와 관련된 역량</caption>
						<colgroup>
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th><%=ArrOCIPersonalResultList(6,0)%></th>
								<th><%=ArrOCIPersonalResultList(6,1)%></th>
								<th><%=ArrOCIPersonalResultList(6,2)%></th>
								<th><%=ArrOCIPersonalResultList(6,3)%></th>
								<th><%=ArrOCIPersonalResultList(6,4)%></th>
								<th><%=ArrOCIPersonalResultList(6,5)%></th>
							</tr>
						</thead>
						<tbody>
							<tr class="txtOrange">
								<td><%=PersonalLog_Name%></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,1,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,2,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,3,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,4,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,5,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,6,1)%></strong></em></td>
							</tr>
							<tr class="txtGray">
								<td>대학생</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,1,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,2,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,3,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,4,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,5,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,6,1)%></em></td>
							</tr>
							<tr class="txtGray">
								<td>직장인</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,1,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,2,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,3,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,4,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,5,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,6,1)%></em></td>
							</tr>
							<tr class="txtOrange">
								<td>적합도판정</td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,1,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,2,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,3,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,4,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,5,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,6,2)%></em></td>
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
				<!-- boardArea -->

				<div class="titArea bdrNone">
					<p class="normalTit">역량별 정의 내용</p>
				</div>
				<!-- titArea -->

				<div class="justiArea">
					<dl>
						<dt>분석력</dt>
						<dd>
							<p>
							주어진 상황이나 문제를 해결하기 위해 관련된 정보/이슈를 다양한 관점 및 방법으로 분석하여 발생원인과 핵심 내용을 정확하게 파악하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>전략적사고</dt>
						<dd>
							<p>
							통합적/전체적 관점에서 문제를 바라보고, 장/단기적인 예측과 선택/집중을 통해 해결 방향을 제시하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>창의성</dt>
						<dd>
							<p>
							남다른 호기심과 유연한 사고를 바탕으로 적절한 아이디어를 생각해내고, 남들이 미처 생각하지 못한 기발하고 새로운 아이디어를 창출하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>변화지향</dt>
						<dd>
							<p>
							기존의 형식이나 방식, 제도에 안주하기 보다는 내/외부환경 변화에 맞추어 자신과 조직의 변화를 추구하며, 새롭거나 낯선 형식, 제도 및 분야에 거부감 없이 적응하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>자료지향</dt>
						<dd>
							<p>
							다양한 경로를 통해 유용한 자료 및 정보를 수집/관리하며, 객관적인 정보나 수량화된 자료를 활용해 일을 처리하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>자기개발</dt>
						<dd>
							<p>
							자신의 강점과 단점을 정확히 파악하여 강점 강화와 단점 보완을 위해 노력하며, 자신의 전공이나 업무와 관련된 다양한 전문지식과 역량을 꾸준히 습득/활용하여 자신을 개발하고 성장해 나가는 역량
							</p>
						</dd>
					</dl>
				</div>
				<!-- justiArea -->

			</div>
			<!-- abilityArea -->
		</div>
		
		
		<!-- .conArea -->
		<div class="titArea bdrNone">
			<p class="normalTit">마음가짐과 관련된 역량</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="abilityArea">
				<!--
				<img src="http://image.career.co.kr/career_new4/my/ability_img2.jpg" alt="마음가짐과 관련된 역량 그래프">
				-->

				<!-- 그래프 영역(chartjs) -->
				<div>
					<canvas id="myChart_2" height="100"></canvas>
				</div>
				<script>
					var color = Chart.helpers.color;
					var ctx = document.getElementById("myChart_2");
					var myChart_2 = new Chart(ctx, {
						type: 'radar',
						data: {
							labels: [
								'<%=ArrOCIPersonalResultList(6,6)%>',
								'<%=ArrOCIPersonalResultList(6,7)%>',
								'<%=ArrOCIPersonalResultList(6,8)%>',
								'<%=ArrOCIPersonalResultList(6,9)%>',
								'<%=ArrOCIPersonalResultList(6,10)%>',
								'<%=ArrOCIPersonalResultList(6,11)%>'
							],
							datasets: [
								{
									label: '마음가짐',
									data: [
										<%=printOCIResult(ArrOCIPersonalResultList,7,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,8,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,9,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,10,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,11,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,12,1)%>
									],
									backgroundColor: color(window.chartColors.blue).alpha(0.5).rgbString(),
									borderColor: window.chartColors.blue,
									pointBackgroundColor: window.chartColors.blue,
									borderWidth: 1,
									pointRadius: 2
								}
							]
						},
						options: {
							legend: {
								position: 'top',
							},
							scale: {
								ticks: {
									beginAtZero: true,
									suggestedMax: 100
								}
							}
						}
					});
				</script>
				<!-- //그래프 영역 -->

				<div class="boardArea">
					<table class="tb" summary="마음가짐과 관련된 역량 테이블">
						<caption>마음가짐과 관련된 역량</caption>
						<colgroup>
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
							<col style="width:14.28%">
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th><%=ArrOCIPersonalResultList(6,6)%></th>
								<th><%=ArrOCIPersonalResultList(6,7)%></th>
								<th><%=ArrOCIPersonalResultList(6,8)%></th>
								<th><%=ArrOCIPersonalResultList(6,9)%></th>
								<th><%=ArrOCIPersonalResultList(6,10)%></th>
								<th><%=ArrOCIPersonalResultList(6,11)%></th>
							</tr>
						</thead>
						<tbody>
							<tr class="txtOrange">
								<td><%=PersonalLog_Name%></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,7,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,8,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,9,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,10,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,11,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,12,1)%></strong></em></td>
							</tr>
							<tr class="txtGray">
								<td>대학생</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,7,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,8,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,9,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,10,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,11,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,12,1)%></em></td>
							</tr>
							<tr class="txtGray">
								<td>직장인</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,7,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,8,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,9,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,10,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,11,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,12,1)%></em></td>
							</tr>
							<tr class="txtOrange">
								<td>적합도판정</td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,7,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,8,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,9,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,10,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,11,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,12,2)%></em></td>
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
				<!-- boardArea -->

				<div class="titArea bdrNone">
					<p class="normalTit">역량별 정의 내용</p>
				</div>
				<!-- titArea -->

				<div class="justiArea">
					<dl>
						<dt>자신감</dt>
						<dd>
							<p>
							자신의 능력을 믿고 어떤 일이 주어져도 할 수 있다는 자신감과 자부심으로 매사에 당당히 임하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>긍정성</dt>
						<dd>
							<p>
							원대한 포부를 가지고 미래를 희망적으로 바라보는 것은 물론, 항상 긍정적인 생각과 밝은 모습으로 주변 사람들도 긍정적인 마음을 갖도록 도와주며, 실패와 비판을 긍정적으로 수용하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>승부근성</dt>
						<dd>
							<p>
							남다른 승부근성으로 어떤 경쟁 상황에서도 이기려고 하고, 경쟁 그 자체를 즐기는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>도전정신</dt>
						<dd>
							<p>
							자신이 속한 조직과 자신의 발전, 더 나은 성과를 위해 과감히 모험과 위험을 감수하고 도전적인 목표 수준을 설정하여 성취하는 역량 
							</p>
						</dd>
					</dl>
					<dl>
						<dt>개방성</dt>
						<dd>
							<p>
							새로운 환경과 상황, 이질적인 조직이나 외국의 문화, 자신과 다른 사고방식의 사람 등을 열린 마음으로 받아들이고 이를 수용하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>윤리의식</dt>
						<dd>
							<p>
							상황이 아무리 어려워도 거짓과 편법을 쓰지 않으며, 자신의 잘못이나 실수는 바로 인정하고, 도덕적/윤리적인 기준을 가지고 주어진 원칙과 사회규범에 맞게 행동하는 역량
							</p>
						</dd>
					</dl>
					
				</div>
				<!-- justiArea -->

			</div>
			<!-- abilityArea -->
		</div>
		<!-- .conArea -->
		
		<div class="titArea bdrNone">
			<p class="normalTit">업무실행과 관련된 역량</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="abilityArea">
				<!--
				<img src="http://image.career.co.kr/career_new4/my/ability_img3.jpg" alt="업무실행과 관련된 역량 그래프">
				-->

				<!-- 그래프 영역(chartjs) -->
				<div>
					<canvas id="myChart_3" height="100"></canvas>
				</div>
				<script>
					var color = Chart.helpers.color;
					var ctx = document.getElementById("myChart_3");
					var myChart_3 = new Chart(ctx, {
						type: 'radar',
						data: {
							labels: [
								'<%=ArrOCIPersonalResultList(6,12)%>',
								'<%=ArrOCIPersonalResultList(6,13)%>',
								'<%=ArrOCIPersonalResultList(6,14)%>',
								'<%=ArrOCIPersonalResultList(6,15)%>',
								'<%=ArrOCIPersonalResultList(6,16)%>',
								'<%=ArrOCIPersonalResultList(6,17)%>',
								'<%=ArrOCIPersonalResultList(6,18)%>'
							],
							datasets: [
								{
									label: '업무실행',
									data: [
										<%=printOCIResult(ArrOCIPersonalResultList,13,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,14,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,15,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,16,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,17,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,18,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,19,1)%>
									],
									backgroundColor: color(window.chartColors.green).alpha(0.5).rgbString(),
									borderColor: window.chartColors.green,
									pointBackgroundColor: window.chartColors.green,
									borderWidth: 1,
									pointRadius: 2
								}
							]
						},
						options: {
							legend: {
								position: 'top',
							},
							scale: {
								ticks: {
									beginAtZero: true,
									suggestedMax: 100
								}
							}
						}
					});
				</script>
				<!-- //그래프 영역 -->

				<div class="boardArea">
					<table class="tb" summary="업무실행과 관련된 역량 테이블">
						<caption>업무실행과 관련된 역량</caption>
						<colgroup>
							<col>
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th><%=ArrOCIPersonalResultList(6,12)%></th>
								<th><%=ArrOCIPersonalResultList(6,13)%></th>
								<th><%=ArrOCIPersonalResultList(6,14)%></th>
								<th><%=ArrOCIPersonalResultList(6,15)%></th>
								<th><%=ArrOCIPersonalResultList(6,16)%></th>
								<th><%=ArrOCIPersonalResultList(6,17)%></th>
								<th><%=ArrOCIPersonalResultList(6,18)%></th>
							</tr>
						</thead>
						<tbody>
							<tr class="txtOrange">
								<td><%=PersonalLog_Name%></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,13,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,14,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,15,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,16,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,17,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,18,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,19,1)%></strong></em></td>
							</tr>
							<tr class="txtGray">
								<td>대학생</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,13,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,14,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,15,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,16,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,17,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,18,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,19,1)%></em></td>
							</tr>
							<tr class="txtGray">
								<td>직장인</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,13,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,14,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,15,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,16,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,17,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,18,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,19,1)%></em></td>
							</tr>
							<tr class="txtOrange">
								<td>적합도판정</td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,13,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,14,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,15,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,16,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,17,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,18,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,19,2)%></em></td>
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
				<!-- boardArea -->

				<div class="titArea bdrNone">
					<p class="normalTit">역량별 정의 내용</p>
				</div>
				<!-- titArea -->

				<div class="justiArea">
					<dl>
						<dt>적극성</dt>
						<dd>
							<p>
							매사 적극적, 주도적으로 일을 처리하며, 남이 시키기 전에 자발적으로 일을 찾아 처리하고, 주변의 문제에 한발 앞서 대응/처리해 나가는역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>추진력</dt>
						<dd>
							<p>
							목표나 계획이 수립되면, 어떤 악조건이나 장애에도 굴하지 않고 실행계획에 따라 끝까지 밀어 붙여 성과를 달성하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>책임감</dt>
						<dd>
							<p>
							주어진 기한내에 맡은 업무를 빈틈없이 철저하게 수행하고 , 언행이 일치하며, 사후 발생한 문제에 대한 수정/보완까지 책임지는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>계획성</dt>
						<dd>
							<p>
							어떤 일을 시작하기에 전에 장/단기 계획 및 세부 실천 계획을 수립하고, 철저한 사전준비를 바탕으로 우선순위를 정해 계획된 시간과 절차에 따라 단계적으로 진행해나가는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>열정</dt>
						<dd>
							<p>
							매사에 남다른 열정과 에너지를 가지고 있으며, 한번 일을 맡으면 외적 보상과는 상관없이 전력을 다해 몰입하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>끈기</dt>
						<dd>
							<p>
							어려운 상황이 발생하더라도 쉽게 타협하거나 불평하지 않고, 자신의 신념과 소신에 따라 묵묵히 자신이 맡은 일을 해나가는 역량  
							</p>
						</dd>
					</dl>
					<dl>
						<dt>신속판단대응</dt>
						<dd>
							<p>
							시급하고 중요한 의사결정 시, 미루거나 확신이 들 때까지 기다리기보다는 그 시점에서 가장 효율적이라고 생각되는 방향이나 대안을 신속하게 선택/결정하여 대응하는 역량
							</p>
						</dd>
					</dl>
				</div>
				<!-- justiArea -->

			</div>
			<!-- abilityArea -->
		</div>
		<!-- .conArea -->

		<div class="titArea bdrNone">
			<p class="normalTit">대인관계와 관련된 역량</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="abilityArea">
				<!--
				<img src="http://image.career.co.kr/career_new4/my/ability_img4.jpg" alt="대인관계와 관련된 역량 그래프">
				-->

				<!-- 그래프 영역(chartjs) -->
				<div>
					<canvas id="myChart_4" height="100"></canvas>
				</div>
				<script>
					var color = Chart.helpers.color;
					var ctx = document.getElementById("myChart_4");
					var myChart_4 = new Chart(ctx, {
						type: 'radar',
						data: {
							labels: [
								'<%=ArrOCIPersonalResultList(6,19)%>',
								'<%=ArrOCIPersonalResultList(6,20)%>',
								'<%=ArrOCIPersonalResultList(6,21)%>',
								'<%=ArrOCIPersonalResultList(6,22)%>',
								'<%=ArrOCIPersonalResultList(6,23)%>',
								'<%=ArrOCIPersonalResultList(6,24)%>',
								'<%=ArrOCIPersonalResultList(6,25)%>'
							],
							datasets: [
								{
									label: '대인관계',
									data: [
										<%=printOCIResult(ArrOCIPersonalResultList,20,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,21,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,22,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,23,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,24,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,25,1)%>,
										<%=printOCIResult(ArrOCIPersonalResultList,26,1)%>
									],
									backgroundColor: color(window.chartColors.orange).alpha(0.5).rgbString(),
									borderColor: window.chartColors.orange,
									pointBackgroundColor: window.chartColors.orange,
									borderWidth: 1,
									pointRadius: 2
								}
							]
						},
						options: {
							legend: {
								position: 'top',
							},
							scale: {
								ticks: {
									beginAtZero: true,
									suggestedMax: 100
								}
							}
						}
					});
				</script>
				<!-- //그래프 영역 -->

				<div class="boardArea">
					<table class="tb" summary="대인관계와 관련된 역량 테이블">
						<caption>대인관계와 관련된 역량 테이블</caption>
						<colgroup>
							<col>
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
							<col style="width:12.5%">
						</colgroup>
						<thead>
							<tr>
								<th>구분</th>
								<th><%=ArrOCIPersonalResultList(6,19)%></th>
								<th><%=ArrOCIPersonalResultList(6,20)%></th>
								<th><%=ArrOCIPersonalResultList(6,21)%></th>
								<th><%=ArrOCIPersonalResultList(6,22)%></th>
								<th><%=ArrOCIPersonalResultList(6,23)%></th>
								<th><%=ArrOCIPersonalResultList(6,24)%></th>
								<th><%=ArrOCIPersonalResultList(6,25)%></th>
							</tr>
						</thead>
						<tbody>
							<tr class="txtOrange">
								<td><%=PersonalLog_Name%></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,20,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,21,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,22,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,23,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,24,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,25,1)%></strong></em></td>
								<td><em class="taho"><strong><%=printOCIResult(ArrOCIPersonalResultList,26,1)%></strong></em></td>
							</tr>
							<tr class="txtGray">
								<td>대학생</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,20,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,21,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,22,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,23,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,24,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,25,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,26,1)%></em></td>
							</tr>
							<tr class="txtGray">
								<td>직장인</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,20,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,21,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,22,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,23,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,24,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,25,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,26,1)%></em></td>
							</tr>
							<tr class="txtOrange">
								<td>적합도판정</td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,20,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,21,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,22,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,23,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,24,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,25,2)%></em></td>
								<td><em><%=printOCIResult(ArrOCIPersonalResultList,26,2)%></em></td>
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
				<!-- boardArea -->

				<div class="titArea bdrNone">
					<p class="normalTit">역량별 정의 내용</p>
				</div>
				<!-- titArea -->

				<div class="justiArea">
					<dl>
						<dt>팀웍</dt>
						<dd>
							<p>
							팀의 성과에 높은 가치를 두고 조직의 목표를 우선시 하며, 팀원간 유용한 정보와 아이디어를 공유하고, 상호 협조/일치단결하여 팀의 성과에 기여하는 역량 
							</p>
						</dd>
					</dl>
					<dl>
						<dt>친화성</dt>
						<dd>
							<p>
							처음 만나는 사람들과도 쉽게 어울리고, 항상 분위기를 활기차게 주도하며, 타인을 친절하게 대하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>의사소통</dt>
						<dd>
							<p>
							 대화(경청)를 통해 상대방의 감정이나 의도를 정확히 파악해내고, 자신의 의사를 글이나 말로, 논리적이고 설득력 있게 표현하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>배려성</dt>
						<dd>
							<p>
							말로 표현하지 않아도 상대방의 입장을 먼저 생각해 배려하고,그 사람의 기분이나 감정을 알아채 공감해주거나 적절하게 대응하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>자기조절</dt>
						<dd>
							<p>
							자신의 감정을 쉽게 드러내거나 충동적으로 흥분하지 않으며, 스트레스를 스스로 해결하고, 적절한 휴식과 운동, 식사 등으로 자신의 건강을 관리하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>통솔력</dt>
						<dd>
							<p>
							어떤 모임에서든 중심적인 역할을 하며, 공동의 목표를 달성하기 구성원들을 이끌고 신뢰를 형성하는 역량
							</p>
						</dd>
					</dl>
					<dl>
						<dt>겸양심</dt>
						<dd>
							<p>
							자신이 이뤄낸 성과에 자만하지 않고 함께 작업한 사람들에게 공을 돌리며, 선배/상사뿐 아니라 동료/후배까지 존중하여 예의를 갖추고,매사에 자신을 낮추고 항상 배우려는 겸손한 자세로 임하는 역량 
							</p>
						</dd>
					</dl>
				</div>
				<!-- justiArea -->
			</div>
			<!-- abilityArea -->
		</div>
		<!-- .conArea -->
		<div class="btnWrap">
			<button type="submit" class="test print" onclick="window.location.href='javascript:window.print();'">인쇄하기</button>
			<button type="reset" class="test closeBtm" onClick="opener.location.reload(); self.close(); ">창닫기</button>
		</div>
		<!-- btnWrap -->
	</div>
	<!-- viewWrap -->
</div>
<!-- popView -->

</body>