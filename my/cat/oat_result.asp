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
	alert("�߸��� ȣ���Դϴ�.");
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

'�����˻� �˻� �Ϸ� ���
dim ArrOATPersonalLogAfterList
Call getOATPersonalLogAfterList(dbCon, ArrOATLogParams, ArrOATPersonalLogAfterList, "", "")

'���ηα� ���� ��ȸ
Dim ArrOATPersonalLogParams
redim ArrOATPersonalLogParams(1)
ArrOATPersonalLogParams(0) = idx
ArrOATPersonalLogParams(1) = user_id

dim ArrOATPersonalLogInfo
Call getOATPersonalLogInfo(dbCon, ArrOATPersonalLogParams, ArrOATPersonalLogInfo, "", "")

'���Ǻ� ��� ���� ��ȸ
Dim ArrOATSectionResultParams
redim ArrOATSectionResultParams(1)
ArrOATSectionResultParams(0) = idx
ArrOATSectionResultParams(1) = user_id

dim ArrOATResultSection
Call getOATSectionResultInfo(dbCon, ArrOATSectionResultParams, ArrOATResultSection, "", "")

'�ְ� ���� ���� ã��
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

'������ ��� ���� ��ȸ
Dim ArrOATJobResultParams
redim ArrOATJobResultParams(1)
ArrOATJobResultParams(0) = idx
ArrOATJobResultParams(1) = user_id

dim ArrOATResultJob
Call getOATJobResultInfo(dbCon, ArrOATJobResultParams, ArrOATResultJob, "", "")

'�ְ� ���� ���� ã��
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
	alert("�Ϸ�� ��� ������ Ȯ���Ͻ� �� �ֽ��ϴ�.");
	window.close();
	</script>
	<%
	response.End
End If


If IsArray(ArrOATPersonalLogInfo) = False Then
	%>
	<script language="javascript">
	alert("���� ������ �����ϴ�.");
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
		alert("�Ϸ�� ��� ������ Ȯ���Ͻ� �� �ֽ��ϴ�.");
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
			<img src="http://image.career.co.kr/career_new4/my/pop_aptitude_h3.png" alt="Ŀ���� �μ��˻� OCI ��� �м�ǥ">
			<span>
				�� �����˻翡�� ���, ����, �߸�, ���������ɷ� �� �� ������������ ����� �ɷ��� ���̴� ����� �����ϴµ� Ȱ��˴ϴ�.
			</span>
		</h1>
		<button type="submit" class="print"  onclick="window.location.href='javascript:window.print();'">�μ��ϱ�</button>
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
							�˻��� <%=UBound(ArrOATPersonalLogAfterList,2)-LoopCount+1%> : 
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
				<table class="tb info" summary="��������">
					<caption>��������</caption>
					<colgroup>
						<col style="width:25%">
						<col style="width:25%">
						<col style="width:25%">
						<col>
					</colgroup>
					<thead>
						<tr class="">
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
			<p class="boldTit">�����˻� OAT ���</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="oatDl">
				<dl>
					<dt>�����</dt>
					<dd class="result"><em class="taho"><%=FormatNumber(PersonalLog_ResultRate,2)%></em></dd>
					<dd class="ment">
						01~10 - <em>10���</em>  <span>/</span>  11~20 - <em>9���</em>  <span>/</span>  21~30 - <em>8���</em>  <span>/</span>..<span>/</span>  91~100 - <em>1���</em>
					</dd>
				</dl>
				<dl>
					<dt>���</dt>
					<dd class="result"><em class="taho"><%=Trim(Left(PersonalLog_ResultGrade, 2))%></em> (���)</dd>
					<dd class="ment"><%=PersonalLog_ResultExplain%></dd>
				</dl>
			</div>
		</div>
		<!-- .conArea -->

		<div class="titArea bdrNone">
			<p class="normalTit">������ ������ �׷���</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="chartArea">

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
							labels: ['�������','����߸�','�ڷ��ؼ�','�����߸�','������','��������'],
							datasets: [{
								label: '������ ����',
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
				<!-- //�׷��� ���� -->

				<div class="boardArea">
					<table class="tb" summary="������ ������ ���̺�">
						<caption>������ ������ ���̺�</caption>
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
								<th>����</th>
								<th>�������</th>
								<th>����߸�</th>
								<th>�ڷ��ؼ�</th>
								<th>�����߸�</th>
								<th>������</th>
								<th>��������</th>
							</tr>
						</thead>
						<tbody>
							<tr class="txtOrange">
								<td>�������</td>
								<td><%=printOATResult(ArrOATResultSection,1,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,2,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,3,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,4,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,5,4)%></td>
								<td><%=printOATResult(ArrOATResultSection,6,4)%></td>
							</tr>
							<tr>
								<td>����</td>
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

		<div class="titArea bdrNone">
			<p class="boldTit">������ �������յ�</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="boardArea">
				<table class="tb" summary="������ �������յ� ���̺�">
					<caption>������ �������յ� ���̺�</caption>
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
							<th>����</th>
							<th <% If InStr(MaxJobOrder,"1") > 0 Then %> class="on" <% End If %>>���� �繫��</th>
							<th <% If InStr(MaxJobOrder,"2") > 0 Then %> class="on" <% End If %>>�繫/����</th>
							<th <% If InStr(MaxJobOrder,"3") > 0 Then %> class="on" <% End If %>>IT/��ǻ��</th>
							<th <% If InStr(MaxJobOrder,"4") > 0 Then %> class="on" <% End If %>>���/�����Ͼ�</th>
							<th <% If InStr(MaxJobOrder,"5") > 0 Then %> class="on" <% End If %>>����/����</th>
							<th <% If InStr(MaxJobOrder,"6") > 0 Then %> class="on" <% End If %>>����/����</th>
						</tr>
					</thead>
					<tbody>
						<tr class="txtOrange">
							<td>�������</td>
							<td <% If InStr(MaxJobOrder,"1") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,1,4)%></td>
							<td <% If InStr(MaxJobOrder,"2") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,2,4)%></td>
							<td <% If InStr(MaxJobOrder,"3") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,3,4)%></td>
							<td <% If InStr(MaxJobOrder,"4") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,4,4)%></td>
							<td <% If InStr(MaxJobOrder,"5") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,5,4)%></td>
							<td <% If InStr(MaxJobOrder,"6") > 0 Then %> class="on" <% End If %>><%=printOATResultJob(ArrOATResultJob,6,4)%></td>
						</tr>
						<tr>
							<td>����� ����</td>
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
									<p>���� �̿볻���� �����ϴ�.</p>
								</div>
							</td>
						</tr>
						-->
					</tbody>
				</table>
				<ul class="baUl">
					<li>
						<em>1.</em> ������ ���� ���յ� ���������� <strong>�ڽ��� ������ ��� ������ ���� �� ���������� Ȯ��</strong>�� �� �ֽ��ϴ�.
					</li>
					<li>
						<em>2.</em> �� ������ ������ �ش� ������ ���õ� ���� ���������� �˻� �������� �����Ŀ� ���� ������ ���Դϴ�.<br>
					</li>
					<li>
					<em>3.</em> ������ ������޿��� ���� <strong>�����(1����� ���� ����) �ϼ���, ������ �� ���� ����(100�� ����) �ڽ��� ������ ������ ����</strong>�̶� �� �� �ֽ��ϴ�.
					</li>
					<li>
					   (�� : ����� ���� 75 = �ڽź��� ���� ������ ������� 75% ����)
					</li>
					<li>
					   (��, �� �˻� ����� �� ������ �ܼ� �з��� ������, �������� ������ ������ ��� ����� �޶��� �� �ֽ��ϴ�.)
					</li>
				</ul>
			</div>
			<!-- .boardArea -->
		</div>
		<!-- .conArea -->
		
		<div class="titArea bdrNone">
			<p class="boldTit">��� ȯ��ǥ</p>
		</div><!-- .titArea -->
		<div class="conArea">
			<div class="boardArea">
				<table class="tb rating" summary="��� ȯ��ǥ ���̺�">
					<caption>��� ȯ��ǥ ���̺�</caption>
					<colgroup>
						<col style="width:90px">
						<col style="width:105px">
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>����</th>
							<th>����</th>
							<th>����</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td>1���</td>
							<td><em class="taho">91~100</em></td>
							<td rowspan="2">
								<span>Ź���� �ɷ��� �����ϰ� ������ ���յ� ���� �ſ� ����</span>
							</td>
						</tr>
						<tr>
							<td>2���</td>
							<td><em class="taho">81~90</em></td>
						</tr>
						<tr>
							<td>3���</td>
							<td><em class="taho">71~80</em></td>
							<td rowspan="2">
								<span>����� ������ �ɷ��� �����ϰ� �ְų�, ���� ���ɼ��� ����. ���յ� ���� ����</span>
							</td>
						</tr>
						<tr>
							<td>4���</td>
							<td><em class="taho">61~70</em></td>
						</tr>
						<tr>
							<td>5���</td>
							<td><em class="taho">51~60</em></td>
							<td rowspan="2">
								<span>���� ������ �ɷ��� �����ϰ� �ְų�, Ư���� ���ߵǾ� ���� ����. ���յ� ���� ����</span>
							</td>
						</tr>
						<tr>
							<td>6���</td>
							<td><em class="taho">41~50</em></td>
						</tr>
						<tr>
							<td>7���</td>
							<td><em class="taho">31~40</em></td>
							<td rowspan="2">
								<span>������ ������ �ɷ��� �����ϰ� ������, ���ߵǾ� ���� ����. ���յ� ���� ������</span>
							</td>
						</tr>
						<tr>
							<td>8���</td>
							<td><em class="taho">21~30</em></td>
						</tr>
						<tr>
							<td>9���</td>
							<td><em class="taho">11~20</em></td>
							<td rowspan="2">
								<span>�ſ� ������ ������ �ɷ��� �����ϰ� ������, ���� ���ߵǾ� ���� ����. ���յ� ���� �ſ� ������</span>
							</td>
						</tr>
						<tr>
							<td>10���</td>
							<td><em class="taho">0~10</em></td>
						</tr>
						
						<!--
						<tr>
							<td colspan="3">
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
					<p class="boldTit">������ ���� �ǰ����<span>(Recommendation)</span></p>
				</div><!-- .titArea -->

				<div class="conArea">
					<div class="boardArea">
						<table class="tb recom" summary="������ ���� �ǰ���� ���̺�">
							<caption>������ ���� �ǰ���� ���̺�</caption>
							<colgroup>
								<col style="width:105px">
								<col>
							</colgroup>
							
							<thead>
								<tr>
									<th>��������</th>
									<th><em class="taho">Recommendation</em></th>
								</tr>
							</thead>

							<tbody>
								<%
								For LoopCountWeak = 0 To UBound(ArrOATResultSection,2)
								%>
								
									<% If Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "1" Then %>
									<tr>
										<td>�������</td>
										<td>
											<span>�Ӹ��ӿ� �繰�� ���� ���ų�, �繰�� �޸��� � ��������� ���ؼ� ����ϴ� ������ �Ͻʽÿ�</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "2" Then %>
									<tr>
										<td>����߸�</td>
										<td>
											<span>�־��� �������� ����ȭ �ϰ�, �� �� ������� ������ ���������� ã�Ƴ��� ������ �Ͻʽÿ�</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "3" Then %>
									<tr>
										<td>�ڷ��ؼ�</td>
										<td>
											<span>�Ź��̳� ����ڷ���� ���� ����, �װ��� �ǹ��ϴ� �ٰ� ���������� ���ؼ� �����ϱ� ���� ������ �Ͻʽÿ�</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "4" Then %>
									<tr>
										<td>�����߸�</td>
										<td>
											<span>�ϻ� ��Ȱ���� ����ؾ� �� �ϵ��� ���� ��, �װ͵��� �Ӹ��ӿ��� �������� ����ȭ �ϴ� ������ �Ͻʽÿ�</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "5" Then %>
									<tr>
										<td>������</td>
										<td>
											<span>��ҿ� ��� �� �� ����(��ǻ��, ����)�� ����ϱ⺸�� �ϻ��̳�, ������ ����ϴ� ������ �Ͻʽÿ�</span>
										</td>
									</tr>
									<% ElseIf Trim(ArrOATResultSection(7,LoopCountWeak)) < 70 And Trim(ArrOATResultSection(3,LoopCountWeak)) = "6" Then %>
									<tr>
										<td>��������</td>
										<td>
											<span>�Ӹ��ӿ��� �繰�� ���� ���ų�, �繰�� �޸��� � ��������� ���ؼ� ����ϴ� ������ �Ͻʽÿ�</span>
										</td>
									</tr>
									<% End If %>

								<%
								Next '-- (For LoopCountWeak = 0 To UBound(ArrOATResultSection,2))
								%>
							</tbody>
						</table>
						
						<p>
							<em class="taho">Recommendation</em>�� ���� ���� ������ ���� ������ Ȯ���Ͻʽÿ�. �ѹ� ���� �ؾ������ ���ٴ� �ƹ��� ����� ����̶� ����ϰ� ��õ�� ���ʽÿ�. <br>�����ɷ��� ��¿��Ͽ� ���� ����/������ �����մϴ�.	
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
			<button type="submit" class="test print" onclick="window.location.href='javascript:window.print();'">�μ��ϱ�</button>
			<button type="reset" class="test closeBtm" onClick="opener.location.reload(); self.close();">â�ݱ�</button>
		</div>
	</div>
	<!-- viewWrap -->

</div>
<!-- popView -->
</body>