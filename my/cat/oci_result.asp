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
	alert("�߸��� ȣ���Դϴ�.");
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

'�μ��˻� �˻� �Ϸ� ���
dim ArrOCIPersonalLogAfterList
Call getOCIPersonalLogAfterList(dbCon, ArrOCILogParams, ArrOCIPersonalLogAfterList, "", "")


'�μ��˻� ���ηα� ���� ��ȸ
Dim ArrOCIPersonalLogParams
redim ArrOCIPersonalLogParams(1)
ArrOCIPersonalLogParams(0) = idx
ArrOCIPersonalLogParams(1) = user_id

dim ArrOCIPersonalLogInfo
Call getOCIPersonalLogInfo(dbCon, ArrOCIPersonalLogParams, ArrOCIPersonalLogInfo, "", "")

'�μ��˻� �ɷº���� (����)
Dim arrOCIPersonalResultParams
redim arrOCIPersonalResultParams(1)
arrOCIPersonalResultParams(0) = idx
arrOCIPersonalResultParams(1) = user_id

dim ArrOCIPersonalResultList
Call getOCIPersonalResultList(dbCon, arrOCIPersonalResultParams, ArrOCIPersonalResultList, "", "")

'�μ��˻� �ɷº���� (���л�)
dim ArrOCIPersonalResultUniv
Call getOCIPersonalResultUniv(dbCon, ArrOCIPersonalResultUniv, "", "")

'�μ��˻� �ɷº���� (������)
dim ArrOCIPersonalResultCompany
Call getOCIPersonalResultCompany(dbCon, ArrOCIPersonalResultCompany, "", "")

'�μ��˻� �ɷ±������
Dim arrOCIPersonalResultGroupParams
redim arrOCIPersonalResultGroupParams(1)
arrOCIPersonalResultGroupParams(0) = idx
arrOCIPersonalResultGroupParams(1) = user_id

dim ArrOCIPersonalResultGroupList
Call getOCIPersonalResultGroupList(dbCon, arrOCIPersonalResultGroupParams, ArrOCIPersonalResultGroupList, "", "")

'�μ��˻� �ɷ±������ (���л�)
dim ArrOCIPersonalResultGroupUniv
Call getOCIPersonalResultGroupUniv(dbCon, ArrOCIPersonalResultGroupUniv, "", "")

'�μ��˻� �ɷ±������ (������)
dim ArrOCIPersonalResultGroupCompany
Call getOCIPersonalResultGroupCompany(dbCon, ArrOCIPersonalResultGroupCompany, "", "")

dbCon.Close


If IsArray(ArrOCIPersonalLogInfo) = False Then
	%>
	<script language="javascript">
	alert("���� ������ �����ϴ�.");
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
		PersonalLog_ResultCorrect = "����"
	Else
		PersonalLog_ResultCorrect = Trim(ArrOCIPersonalLogInfo(15,0))
	End If
	
	PersonalLog_ResultDate = Trim(ArrOCIPersonalLogInfo(16,0))

	If PersonalLog_Status <> "999" Then
		%>
		<script language="javascript">
		alert("�Ϸ�� ��� ������ Ȯ���Ͻ� �� �ֽ��ϴ�.");
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
			<img src="http://image.career.co.kr/career_new4/my/pop_personality_h3.png" alt="Ŀ���� �μ��˻� OCI ��� �м�ǥ">
			<span>
				�� �μ��˻��� Ư���� �� �˻翡 ���õ� ���л� ��հ� �������� ��� ������ ���� ������ �� �� �����ϴ�. ����θ� Ȱ���� �ֽʽÿ�.
			</span>
		</h1>
		<button type="submit" class="print"  onclick="window.location.href='javascript:window.print();'">�μ��ϱ�</button>
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
							�˻��� <%=UBound(ArrOCIPersonalLogAfterList,2)-LoopCount+1%> : 
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
				<table class="tb info" summary="��������">
					<caption>��������</caption>
					<colgroup>
						<col style="width:25%">
						<col style="width:25%">
						<col style="width:25%">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>����</th>
							<th>�˻�ID</th>
							<th>����</th>
							<th>�˻�����</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><%=PersonalLog_Name%></td>
							<td><em class="taho"><%=PersonalLog_Identity%></em></td>
							<td><%=PersonalLog_Age%>��</td>
							<td><em class="taho"><%=Left(PersonalLog_ResultDate,10)%></em></td>
						</tr>
						<!--
						<tr>
							<td colspan="4">
								<div class="noData">
									<p>���� �̿볻���� �����ϴ�.</p>
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
			<p class="boldTit">�μ��˻� OCI ���</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="ociDl">
				<dl>
					<dt>���հ������</dt>
					<dd class="result"><em class="taho"><%=PersonalLog_ResultAvg%></em></dd>
					<dd class="ment">
						91�� �ʰ� - <em>�ſ�����</em><span>/</span>91~83�� - <em>����</em><span>/</span>83~66�� - <em>����</em><span>/</span>66�� ���� - <em>����</em>
					</dd>
				</dl>
				<dl>
					<dt>���յ� �Ǵܰ��</dt>
					<dd class="result"><em class="txtBlue"><%=PersonalLog_ResultCorrect%></em></dd>
					<%
					Select Case PersonalLog_ResultCorrect
						Case "����" : Response.write "<dd class='ment'>���(����)�� ���ϴ� ����� �������� ����</dd>"
						Case "����" : Response.write "<dd class='ment'>����� ������ �μ������� �����ϰ� ����</dd>"
						Case "����" : Response.write "<dd class='ment'>���(����)�� ���ϴ� ����μ�, ������ �μ������� �����ϰ� ����</dd>"
						Case "�ſ� ����" : Response.write "<dd class='ment'>���(����)�� ���ϴ� �ٽ� ����μ�, �ſ� ������ �μ������� �����ϰ� ����</dd>"
					End Select
					%>
				</dl>
			</div>
		</div>
		<!-- .conArea -->

		<div class="titArea bdrNone">
			<p class="normalTit">������ ������ �׷���</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="chartArea">
				
				<!-- 
				<img src="http://image.career.co.kr/career_new4/my/result_chart.jpg" alt="������ ���ú� �׷���">

				<ul class="legen">
					<li><em class="red"></em><%=PersonalLog_Name%></li>
					<li><em class="green"></em>���л� ���</li>
					<li><em class="blue"></em>������ ���</li>
				</ul>
				-->

				<!-- �׷��� ����(chartjs) -->
				<div>
					<canvas id="myChart" width="800" height="250"></canvas>
				</div>
				<script>
					var color = Chart.helpers.color;
					var ctx = document.getElementById("myChart");
					var myChart = new Chart(ctx, {
						type: 'bar',
						data: {
							labels: ['������ ���','��������','��������','���ΰ���'],
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
									label: '���л� ���',
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
									label: '������ ���',
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
				<!-- //�׷��� ���� -->
				
				<div class="boardArea printT">
					<table class="tb" summary="��������">
						<caption>��������</caption>
						<colgroup>
							<col style="width:100px">
							<col style="width:190px">
							<col style="width:190px">
							<col style="width:190px">
							<col style="width:190px">
						</colgroup>
						<thead>
							<tr>
								<th>����</th>
								<th>������ ���</th>
								<th>��������</th>
								<th>��������</th>
								<th>���ΰ���</th>
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
								<td>���л�</td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,1,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,2,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,3,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupUniv,4,1)%></em></td>
							</tr>
							<tr>
								<td>������</td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,1,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,2,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,3,1)%></em></td>
								<td><em class="taho"><%=printOCIResultGroup(ArrOCIPersonalResultGroupCompany,4,1)%></em></td>
							</tr>
							<!--
							<tr>
								<td colspan="5">
									<div class="noData">
										<p>���� �̿볻���� �����ϴ�.</p>
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
			<p class="boldTit">������ ���� ���պ�</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="compare"">
				<ul>
					<li><em class="taho">91</em>�� �ʰ� - <span class="txtBlue">�ſ�����</span></li>
					<li><em class="taho">91~83</em>�� - <span class="txtBlue">����</span></li>
					<li><em class="taho">83~66</em>�� - <span class="txtBlue">����</span></li>
					<li><em class="taho">66</em>�� ���� - <span class="txtBlue">����</span></li>
				</ul>
			</div>
		</div>
		<!-- .conArea -->
		<div class="titArea bdrNone">
			<p class="normalTit">������ ���� ���õ� ����</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="abilityArea">
				<!-- 
				<img src="http://image.career.co.kr/career_new4/my/ability_img.jpg" alt="������ ���� ���õ� ���� �׷���">
				-->

				<!-- �׷��� ����(chartjs) -->
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
									label: '������ ���',
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
				<!-- //�׷��� ���� -->

				<div class="boardArea">
					<table class="tb" summary="������ ���� ���õ� ���� ���̺�">
						<caption>������ ���� ���õ� ����</caption>
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
								<th>����</th>
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
								<td>���л�</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,1,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,2,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,3,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,4,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,5,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,6,1)%></em></td>
							</tr>
							<tr class="txtGray">
								<td>������</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,1,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,2,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,3,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,4,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,5,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,6,1)%></em></td>
							</tr>
							<tr class="txtOrange">
								<td>���յ�����</td>
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
										<p>���� �̿볻���� �����ϴ�.</p>
									</div>
								</td>
							</tr>
							-->
						</tbody>
					</table>
				</div>
				<!-- boardArea -->

				<div class="titArea bdrNone">
					<p class="normalTit">������ ���� ����</p>
				</div>
				<!-- titArea -->

				<div class="justiArea">
					<dl>
						<dt>�м���</dt>
						<dd>
							<p>
							�־��� ��Ȳ�̳� ������ �ذ��ϱ� ���� ���õ� ����/�̽��� �پ��� ���� �� ������� �м��Ͽ� �߻����ΰ� �ٽ� ������ ��Ȯ�ϰ� �ľ��ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>���������</dt>
						<dd>
							<p>
							������/��ü�� �������� ������ �ٶ󺸰�, ��/�ܱ����� ������ ����/������ ���� �ذ� ������ �����ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>â�Ǽ�</dt>
						<dd>
							<p>
							���ٸ� ȣ��ɰ� ������ ��� �������� ������ ���̵� �����س���, ������ ��ó �������� ���� ����ϰ� ���ο� ���̵� â���ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>��ȭ����</dt>
						<dd>
							<p>
							������ �����̳� ���, ������ �����ϱ� ���ٴ� ��/�ܺ�ȯ�� ��ȭ�� ���߾� �ڽŰ� ������ ��ȭ�� �߱��ϸ�, ���Ӱų� ���� ����, ���� �� �о߿� �źΰ� ���� �����ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>�ڷ�����</dt>
						<dd>
							<p>
							�پ��� ��θ� ���� ������ �ڷ� �� ������ ����/�����ϸ�, �������� ������ ����ȭ�� �ڷḦ Ȱ���� ���� ó���ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>�ڱⰳ��</dt>
						<dd>
							<p>
							�ڽ��� ������ ������ ��Ȯ�� �ľ��Ͽ� ���� ��ȭ�� ���� ������ ���� ����ϸ�, �ڽ��� �����̳� ������ ���õ� �پ��� �������İ� ������ ������ ����/Ȱ���Ͽ� �ڽ��� �����ϰ� ������ ������ ����
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
			<p class="normalTit">���������� ���õ� ����</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="abilityArea">
				<!--
				<img src="http://image.career.co.kr/career_new4/my/ability_img2.jpg" alt="���������� ���õ� ���� �׷���">
				-->

				<!-- �׷��� ����(chartjs) -->
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
									label: '��������',
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
				<!-- //�׷��� ���� -->

				<div class="boardArea">
					<table class="tb" summary="���������� ���õ� ���� ���̺�">
						<caption>���������� ���õ� ����</caption>
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
								<th>����</th>
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
								<td>���л�</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,7,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,8,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,9,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,10,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,11,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,12,1)%></em></td>
							</tr>
							<tr class="txtGray">
								<td>������</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,7,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,8,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,9,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,10,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,11,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,12,1)%></em></td>
							</tr>
							<tr class="txtOrange">
								<td>���յ�����</td>
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
										<p>���� �̿볻���� �����ϴ�.</p>
									</div>
								</td>
							</tr>
							-->
						</tbody>
					</table>
				</div>
				<!-- boardArea -->

				<div class="titArea bdrNone">
					<p class="normalTit">������ ���� ����</p>
				</div>
				<!-- titArea -->

				<div class="justiArea">
					<dl>
						<dt>�ڽŰ�</dt>
						<dd>
							<p>
							�ڽ��� �ɷ��� �ϰ� � ���� �־����� �� �� �ִٴ� �ڽŰ��� �ںν����� �Ż翡 ����� ���ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>������</dt>
						<dd>
							<p>
							������ ���θ� ������ �̷��� ��������� �ٶ󺸴� ���� ����, �׻� �������� ������ ���� ������� �ֺ� ����鵵 �������� ������ ������ �����ָ�, ���п� ������ ���������� �����ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>�ºαټ�</dt>
						<dd>
							<p>
							���ٸ� �ºαټ����� � ���� ��Ȳ������ �̱���� �ϰ�, ���� �� ��ü�� ���� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>��������</dt>
						<dd>
							<p>
							�ڽ��� ���� ������ �ڽ��� ����, �� ���� ������ ���� ������ ����� ������ �����ϰ� �������� ��ǥ ������ �����Ͽ� �����ϴ� ���� 
							</p>
						</dd>
					</dl>
					<dl>
						<dt>���漺</dt>
						<dd>
							<p>
							���ο� ȯ��� ��Ȳ, �������� �����̳� �ܱ��� ��ȭ, �ڽŰ� �ٸ� ������� ��� ���� ���� �������� �޾Ƶ��̰� �̸� �����ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>�����ǽ�</dt>
						<dd>
							<p>
							��Ȳ�� �ƹ��� ������� ������ ����� ���� ������, �ڽ��� �߸��̳� �Ǽ��� �ٷ� �����ϰ�, ������/�������� ������ ������ �־��� ��Ģ�� ��ȸ�Թ��� �°� �ൿ�ϴ� ����
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
			<p class="normalTit">��������� ���õ� ����</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="abilityArea">
				<!--
				<img src="http://image.career.co.kr/career_new4/my/ability_img3.jpg" alt="��������� ���õ� ���� �׷���">
				-->

				<!-- �׷��� ����(chartjs) -->
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
									label: '��������',
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
				<!-- //�׷��� ���� -->

				<div class="boardArea">
					<table class="tb" summary="��������� ���õ� ���� ���̺�">
						<caption>��������� ���õ� ����</caption>
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
								<th>����</th>
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
								<td>���л�</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,13,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,14,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,15,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,16,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,17,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,18,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,19,1)%></em></td>
							</tr>
							<tr class="txtGray">
								<td>������</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,13,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,14,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,15,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,16,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,17,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,18,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,19,1)%></em></td>
							</tr>
							<tr class="txtOrange">
								<td>���յ�����</td>
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
										<p>���� �̿볻���� �����ϴ�.</p>
									</div>
								</td>
							</tr>
							-->
						</tbody>
					</table>
				</div>
				<!-- boardArea -->

				<div class="titArea bdrNone">
					<p class="normalTit">������ ���� ����</p>
				</div>
				<!-- titArea -->

				<div class="justiArea">
					<dl>
						<dt>���ؼ�</dt>
						<dd>
							<p>
							�Ż� ������, �ֵ������� ���� ó���ϸ�, ���� ��Ű�� ���� �ڹ������� ���� ã�� ó���ϰ�, �ֺ��� ������ �ѹ� �ռ� ����/ó���� �����¿���
							</p>
						</dd>
					</dl>
					<dl>
						<dt>������</dt>
						<dd>
							<p>
							��ǥ�� ��ȹ�� �����Ǹ�, � �������̳� ��ֿ��� ������ �ʰ� �����ȹ�� ���� ������ �о� �ٿ� ������ �޼��ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>å�Ӱ�</dt>
						<dd>
							<p>
							�־��� ���ѳ��� ���� ������ ��ƴ���� ö���ϰ� �����ϰ� , ������ ��ġ�ϸ�, ���� �߻��� ������ ���� ����/���ϱ��� å������ ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>��ȹ��</dt>
						<dd>
							<p>
							� ���� �����ϱ⿡ ���� ��/�ܱ� ��ȹ �� ���� ��õ ��ȹ�� �����ϰ�, ö���� �����غ� �������� �켱������ ���� ��ȹ�� �ð��� ������ ���� �ܰ������� �����س����� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>����</dt>
						<dd>
							<p>
							�Ż翡 ���ٸ� ������ �������� ������ ������, �ѹ� ���� ������ ���� ������� ������� ������ ���� �����ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>����</dt>
						<dd>
							<p>
							����� ��Ȳ�� �߻��ϴ��� ���� Ÿ���ϰų� �������� �ʰ�, �ڽ��� �ų�� �ҽſ� ���� ������ �ڽ��� ���� ���� �س����� ����  
							</p>
						</dd>
					</dl>
					<dl>
						<dt>�ż��Ǵܴ���</dt>
						<dd>
							<p>
							�ñ��ϰ� �߿��� �ǻ���� ��, �̷�ų� Ȯ���� �� ������ ��ٸ��⺸�ٴ� �� �������� ���� ȿ�����̶�� �����Ǵ� �����̳� ����� �ż��ϰ� ����/�����Ͽ� �����ϴ� ����
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
			<p class="normalTit">���ΰ���� ���õ� ����</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="abilityArea">
				<!--
				<img src="http://image.career.co.kr/career_new4/my/ability_img4.jpg" alt="���ΰ���� ���õ� ���� �׷���">
				-->

				<!-- �׷��� ����(chartjs) -->
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
									label: '���ΰ���',
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
				<!-- //�׷��� ���� -->

				<div class="boardArea">
					<table class="tb" summary="���ΰ���� ���õ� ���� ���̺�">
						<caption>���ΰ���� ���õ� ���� ���̺�</caption>
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
								<th>����</th>
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
								<td>���л�</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,20,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,21,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,22,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,23,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,24,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,25,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultUniv,26,1)%></em></td>
							</tr>
							<tr class="txtGray">
								<td>������</td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,20,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,21,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,22,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,23,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,24,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,25,1)%></em></td>
								<td><em class="taho"><%=printOCIResult(ArrOCIPersonalResultCompany,26,1)%></em></td>
							</tr>
							<tr class="txtOrange">
								<td>���յ�����</td>
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
										<p>���� �̿볻���� �����ϴ�.</p>
									</div>
								</td>
							</tr>
							-->
						</tbody>
					</table>
				</div>
				<!-- boardArea -->

				<div class="titArea bdrNone">
					<p class="normalTit">������ ���� ����</p>
				</div>
				<!-- titArea -->

				<div class="justiArea">
					<dl>
						<dt>����</dt>
						<dd>
							<p>
							���� ������ ���� ��ġ�� �ΰ� ������ ��ǥ�� �켱�� �ϸ�, ������ ������ ������ ���̵� �����ϰ�, ��ȣ ����/��ġ�ܰ��Ͽ� ���� ������ �⿩�ϴ� ���� 
							</p>
						</dd>
					</dl>
					<dl>
						<dt>ģȭ��</dt>
						<dd>
							<p>
							ó�� ������ �������� ���� ��︮��, �׻� �����⸦ Ȱ������ �ֵ��ϸ�, Ÿ���� ģ���ϰ� ���ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>�ǻ����</dt>
						<dd>
							<p>
							 ��ȭ(��û)�� ���� ������ �����̳� �ǵ��� ��Ȯ�� �ľ��س���, �ڽ��� �ǻ縦 ���̳� ����, �����̰� ����� �ְ� ǥ���ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>�����</dt>
						<dd>
							<p>
							���� ǥ������ �ʾƵ� ������ ������ ���� ������ ����ϰ�,�� ����� ����̳� ������ �˾�ä �������ְų� �����ϰ� �����ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>�ڱ�����</dt>
						<dd>
							<p>
							�ڽ��� ������ ���� �巯���ų� �浿������ ������� ������, ��Ʈ������ ������ �ذ��ϰ�, ������ �޽İ� �, �Ļ� ������ �ڽ��� �ǰ��� �����ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>��ַ�</dt>
						<dd>
							<p>
							� ���ӿ����� �߽����� ������ �ϸ�, ������ ��ǥ�� �޼��ϱ� ���������� �̲��� �ŷڸ� �����ϴ� ����
							</p>
						</dd>
					</dl>
					<dl>
						<dt>����</dt>
						<dd>
							<p>
							�ڽ��� �̷ﳽ ������ �ڸ����� �ʰ� �Բ� �۾��� ����鿡�� ���� ������, ����/���� �ƴ϶� ����/�Ĺ���� �����Ͽ� ���Ǹ� ���߰�,�Ż翡 �ڽ��� ���߰� �׻� ������ ����� �ڼ��� ���ϴ� ���� 
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
			<button type="submit" class="test print" onclick="window.location.href='javascript:window.print();'">�μ��ϱ�</button>
			<button type="reset" class="test closeBtm" onClick="opener.location.reload(); self.close(); ">â�ݱ�</button>
		</div>
		<!-- btnWrap -->
	</div>
	<!-- viewWrap -->
</div>
<!-- popView -->

</body>