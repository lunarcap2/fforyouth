<%
option Explicit

'------ ������ �⺻���� ����.
g_MenuID = "010001"  '�� �� ���ڴ� lnb ��������, �� �� ���ڴ� �޴� �̹��� ���ϸ� ����
g_MenuID_Navi = "5,1"  '������̼� ��
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
ConnectDB DBCon, Application("DBInfo")

	Dim bizNum, page
	bizNum	= Request("bizNum")

	If bizNum = "" Then
		Response.write "<script>alert('�߸��� �����Դϴ�.'); location.href='list.asp';</script>"
		Response.end
	End If

	Dim spName, arrNice_info
	ReDim param(1)
	'spName = "USP_ADMIN_KANGSO_SEARCH_View"
	spName = "USP_ECRED_COMPANY_SEARCH_View"

	param(0) = makeParam("@bizcode", adVarchar, adParamInput, 10, bizNum)
	param(1) = makeParam("@rtnval", adInteger, adParamOutput, 4 , 0)

	arrNice_info = arrGetRsSP(dbCon, spName, param, "", "")
	
	Dim arrNice_0, arrNice_1, arrNice_2, arrNice_3, arrNice_4, arrNice_5, arrNice_6, arrNice_15
	If IsArray(arrNice_info) Then
		arrNice_0   = arrNice_info(0)   '// �⺻����
		arrNice_1   = arrNice_info(1)   '// �繫����
		'arrNice_2   = arrNice_info(2)   '// �濵��
		'arrNice_3   = arrNice_info(3)   '// �ֿ� ������Ȳ
		'arrNice_4   = arrNice_info(4)   '// ����ȸ����Ȳ
		'arrNice_5   = arrNice_info(5)   '// ���������м�
		'arrNice_6   = arrNice_info(6)   '// ����
		'arrNice_15  = arrNice_info(15)  '// ����
	End If
	
	If isArray(arrNice_0) = False Then 
		Response.write "<script>alert('�߸��� �����Դϴ�.'); location.href='list.asp';</script>"
		Response.end
	End If

	Dim date_cy, date_ly, date_bly
	date_cy = year(date) -1
	date_ly = date_cy -1
	date_bly = date_ly -1

	Dim capital_cy, capital_ly, capital_bly '�ں���
	Dim sales_cy, sales_ly, sales_bly '�����
	Dim income_cy, income_ly, income_bly '��������
	capital_cy		= Ccur(arrNice_1(0, 0))
	capital_ly		= Ccur(arrNice_1(1, 0))
	capital_bly		= Ccur(arrNice_1(2, 0))
	sales_cy		= Ccur(arrNice_1(3, 0))
	sales_ly		= Ccur(arrNice_1(4, 0))
	sales_bly		= Ccur(arrNice_1(5, 0))
	income_cy		= Ccur(arrNice_1(6, 0))
	income_ly		= Ccur(arrNice_1(7, 0))
	income_bly		= Ccur(arrNice_1(8, 0))

	Dim capital_rate, sales_rate, income_rate
	If capital_ly > 0 Then capital_rate = (capital_cy - capital_ly) / capital_ly * 100
	If sales_ly > 0 Then sales_rate = (sales_cy - sales_ly) / sales_ly * 100
	If income_ly > 0 Then income_rate = (income_cy - income_ly) / income_ly * 100

	capital_rate = FormatNumber(capital_rate, 2)
	sales_rate = FormatNumber(sales_rate, 2)
	income_rate = FormatNumber(income_rate, 2)
	
	Dim capital_updown, sales_updown, income_updown
	Select Case Sgn(capital_rate)
		Case 0 : capital_updown = "-"
		Case 1 : capital_updown = "up"
		Case -1 : capital_updown = "down"
	End Select
	Select Case Sgn(sales_rate)
		Case 0 : sales_updown = "-"
		Case 1 : sales_updown = "up"
		Case -1 : sales_updown = "down"
	End Select
	Select Case Sgn(income_rate)
		Case 0 : income_updown = "-"
		Case 1 : income_updown = "up"
		Case -1 : income_updown = "down"
	End Select

DisconnectDB DBCon
%>
<link rel="stylesheet" type="text/css" href="/css/billboard.css" />
<script type="text/javascript" src="/js/jquery.bxSlider.min.js"></script>
<script type="text/javascript" src="/js/billboard.js"></script>
<script type="text/javascript" src="/js/billboard.pkgd.min.js"></script>

<script type="text/javascript">
	function fn_attention(loginChk, com_idnum, company_name) {
		if (loginChk != "1") {
			var result = confirm("�α��� �� ���ɱ���� �߰��� �� �ֽ��ϴ�.");

			if(result) {
				location.href = '/my/login.asp?redir=' + location.pathname;
			}
		}
		else {
			$.ajax({
				type: "POST"
				, url: "/company/partner/attention.asp"
				, data: { com_idnum: com_idnum, company_name: escape(company_name) }
				, dataType: "html"
				, async: true
				, success: function (data) {
					if (data == "1") {
						alert("���ɱ������ ��ϵǾ����ϴ�.");
						location.href = location.href;
					}
					else if (data == "2") {
						alert("���ɱ���� �����Ǿ����ϴ�.");
						location.href = location.href;
					}
					else if (data == "50") {
						alert("���ɱ���� �ִ� 50������ ��� �����մϴ�.");
						return false;
					}
					else if (data == "0") {
						alert("���ɱ�� �߰��� �����߽��ϴ�.");
						return false;
					}
				}
				, error:function(request,status,error){
					alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
				}
			});
		}
	}
</script>
</head>

<body>
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- ���� -->
<div id="contents" class="sub_page">
	<div class="content glay">
		<div class="con_box">
			<div class="partner_area view">
				<div class="company_top">
					<div class="ct_info">
						<div class="ct_logo">
							<div class="ct_img">
								<!--
								<img src="" alt="ȸ��ΰ�">
								-->
							</div>
						</div>
						
						<div class="ct_Interest">
							<%
								Dim chk_scrap, chk_attention, arrRsAttention
								chk_attention = ""
								ConnectDB DBCon, Application("DBInfo_FAIR")

								If user_id <> "" Then 
									'���ɱ�� ����
									arrRsAttention = arrGetRsSql(DBCon,"SELECT ���ξ��̵� FROM ���ΰ��ɱ�� WITH(NOLOCK)  WHERE ���ξ��̵� = '" & user_id & "' AND ����ڵ�Ϲ�ȣ = '" & bizNum & "'", "", "")
									
									if isArray(arrRsAttention) then
										chk_attention = "Y"
									end If
								End If

								DisconnectDB DBCon
							%>

							<!--<p>���ɱ�� �߰��ϰ� ä��ҽ� �ޱ�</p>-->
							<button type="button" onclick="fn_attention('<%=g_LoginChk%>', '<%=arrNice_0(1, 0)%>', '<%=arrNice_0(3, 0)%>'); return false;">
							<% If chk_attention = "Y" Then %>	
								<span><img src="/images/Interest_on.png" alt="���� on"></span>
							<% Else %>
								<span><img src="/images/Interest_off.png" alt="���� off"></span>
							<% End If %>
								���ɱ��
							</button>
						</div>
						<div class="ct_name">
							<p><%=arrNice_0(3, 0)%></p>
							<a href="<%=arrNice_0(31, 0)%>" target="_blank"><%=arrNice_0(31, 0)%></a>
						</div>
						<div class="ct_ment">
							<p>
							?
								<!--
								(��)����� 1974�� ���� �ڵ��� �輱�� ȿ�÷� ����� �̷�, ���� ������ Wiring Harness ����� �������� ����, Ŀ����, ģȯ�� ��ǰ�� ������ ���� �̷��� ���Ӱ��ɰ濵�� �����ϰ� ������,
								������ �� �� ���¾�ü���� ������°� ��ȸ�� å���� ���Ͽ� �����Ϸ� ������� ������ ���� ���Դϴ�.
								-->
							</p>
						</div>
					</div>
				</div><!-- //company_top -->
				
				<div class="company_wrap">
					<div class="company_con">
						<h3>�⺻����</h3>
						<div class="ca_info">
							<table class="tb">
								<colgroup>
									<col style="width:90px;">
									<col style="width:400px;">
									<col style="width:90px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th>���</th>
										<td><%=arrNice_0(24, 0)%></td>
										<th>�����</th>
										<td><%=FormatNumber(arrNice_0(14, 0), 0)%>��</td>
									</tr>
									<tr>
										<th>�������</th>
										<td>���� �� �ڽ��� �� �ֽ�</td>
										<th>������</th>
										<%
										Dim create_date, create_year
										If arrNice_0(9, 0) <> "" Then 
											create_date = Mid(arrNice_0(9, 0), 1, 4) & "." & Mid(arrNice_0(9, 0), 5, 2) & "." & Mid(arrNice_0(9, 0), 7, 2)
											create_year = year(date) - Left(arrNice_0(9, 0), 4)
										End If
										%>
										<td><%=create_date%> (<%=create_year%>����)</td>
									</tr>
									<tr>
										<th>�ں���</th>
										<td><%=getCompanyMoney_Text(capital_cy)%></td>
										<th>�����</th>
										<td><%=getCompanyMoney_Text(sales_cy)%></td>
									</tr>
									<tr>
										<th>��ǥ��</th>
										<td><%=arrNice_0(5, 0)%></td>
										<th>Ȩ������</th>
										<td><%=arrNice_0(31, 0)%></td>
									</tr>
									<tr>
										<th>�ֿ���</th>
										<td colspan="3">
											?
										</td>
									</tr>
									<tr>
										<th>�ּ�</th>
										<td colspan="3">
											<%=arrNice_0(18, 0)%>
										</td>
									</tr>
									<tr>
										<th>����Ұ�</th>
										<td colspan="3">
											?
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!--//company_con -->


					<div class="company_con">
						<h3>�繫�м�</h3>
						<div class="ca_chart">
							<ul>
								
								<!--
								<li>
									<div class="chart_box">
										<h4>���� ��� ����ó ������Ȳ</h4>
										<div class="chart_sel">
											<span class="selectbox" style="width:110px">
												<span class="">�⵵</span>
												<select id="sel_year" name="sel_year1" title="�⵵</ ����" selected="selected">
													<option value="">2019��</option>
													<option value="">2018��</option>
													<option value="">2017��</option>
												</select>
											</span>
											<div class="quarter">
												<label class="radiobox on" for="quarter1_1">
													<input type="radio" class="rdi" id="quarter1_1" name="quarter1" value="" onclick="">
													<span>1�б�</span>
												</label>
												<label class="radiobox on" for="quarter1_2">
													<input type="radio" class="rdi" id="quarter1_2" name="quarter1" value="" onclick="">
													<span>2�б�</span>
												</label>
												<label class="radiobox on" for="quarter1_3">
													<input type="radio" class="rdi" id="quarter1_3" name="quarter1" value="" onclick="">
													<span>3�б�</span>
												</label>
												<label class="radiobox on" for="quarter1_4">
													<input type="radio" class="rdi" id="quarter1_4" name="quarter1" value="" onclick="">
													<span>4�б�</span>
												</label>
											</div>
										</div>

										<div class="chart">
											
											<div id="gaugeStackData"></div>
											<script>
											var chart = bb.generate({
											data: {
												columns: [
													["data1", 59],
													["data2", 15],
													["data3", 12],
													["data4", 10],
													["data5", 4]
												],
												names: {
													data1: "59% �뿪����",
													data2: "15% ��ǰ����",
													data3: "12% ��ǰ����",
													data4: "10% �뿪����",
													data5: "��Ÿ",
												},
												type: "donut",
												colors: {
													data1: "#48adfb",
													data2: "#fc6767",
													data3: "#fbb63f",
													data4: "#b5bec7",
													data5: "#c5d2db"
												},
											},
											legend: {
												"position": "right",
												item: {
												onclick: function(id) {}
												}
											},
											donut: {
												max: 100,
												label: {
												  format: function(value, ratio) {
														return value +"%";
												   }
												},
												width: 50
											},
											bindto: "#gaugeStackData"
											});
											</script>
										</div>
									</div>
								</li>
								-->

								<li>
									<div class="chart_box">
										<h4>�ں���</h4>
										<div class="chart_txt">
											<dl>
												<dt><%=date_cy%>�� �ں���</dt>
												<dd><%=getCompanyMoney_Text(capital_cy)%></dd>
											</dl>
											<dl>
												<dt>�۳���</dt>
												<dd><span class="<%=capital_updown%>"><%=capital_rate%>%</span></dd>
											</dl>
										</div>

										<div class="chart bar">
											<div id="barChart"></div>
											<span>(���� : õ����)</span>
											<script>
											var chart = bb.generate({
											data: {
												x: "x",
												columns: [
													["x", "<%=date_bly%>", "<%=date_ly%>", "<%=date_cy%>"],
													["data1", <%=getCompanyMoney_Graph(capital_bly)%>, <%=getCompanyMoney_Graph(capital_ly)%>, <%=getCompanyMoney_Graph(capital_cy)%>]
												],
												names: {
													data1: "�ں���",
												},
												type: "bar",
												colors: {
												  data1: "#a6a6a6"
												},
												labels: true
												},
												bar: {
													width: {
													ratio: 0.5
												}
											},
											axis: {
												y: {
													tick: {
														culling: {
															max: 2
														}
													}
												}
											},
											grid: {
												y: {
													lines: [
														{
														  value: 0
														}
													]	
												}
											},
											legend: {
												"hide": true
											},
											bindto: "#barChart"
											});
											</script>
										</div>
									</div>
								</li>

								<li>
									<div class="chart_box">
										<h4>�����</h4>
										<div class="chart_txt">
											<dl>
												<dt><%=date_cy%>�� �����</dt>
												<dd><%=getCompanyMoney_Text(sales_cy)%></dd>
											</dl>
											<dl>
												<dt>�۳���</dt>
												<dd><span class="<%=sales_updown%>"><%=sales_rate%>%</span></dd>
											</dl>
										</div>

										<div class="chart bar">
											<div id="barChart2"></div>
											<span>(���� : õ����)</span>
											<script>
											var chart = bb.generate({
											data: {
												x: "x",
												columns: [
													["x", "<%=date_bly%>", "<%=date_ly%>", "<%=date_cy%>"],
													["data1", <%=getCompanyMoney_Graph(sales_bly)%>, <%=getCompanyMoney_Graph(sales_ly)%>, <%=getCompanyMoney_Graph(sales_cy)%>]
												],
												names: {
													data1: "�����",
												},
												type: "bar",
												colors: {
												  data1: "#a6a6a6"
												},
												labels: true
												},
												bar: {
													width: {
													ratio: 0.5
												}
											},
											axis: {
												y: {
													tick: {
														culling: {
															max: 2
														}
													}
												}
											},
											grid: {
												y: {
													lines: [
														{
														  value: 0

														}
													]	
												}
											},
											legend: {
												"hide": true
											},
											bindto: "#barChart2"
											});
											</script>
										</div>
									</div>
								</li>

								<li>
									<div class="chart_box">
										<h4>��������</h4>
										<div class="chart_txt">
											<dl>
												<dt><%=date_cy%>�� ��������</dt>
												<dd><%=getCompanyMoney_Text(income_cy)%></dd>
											</dl>
											<dl>
												<dt>�۳���</dt>
												<dd><span class="<%=income_updown%>"><%=income_rate%>%</span></dd>
											</dl>
										</div>

										<div class="chart bar">
											<div id="barChart3"></div>
											<span>(���� : õ����)</span>
											<script>
											var chart = bb.generate({
											data: {
												x: "x",
												columns: [
													["x", "<%=date_bly%>", "<%=date_ly%>", "<%=date_cy%>"],
													["data1", <%=getCompanyMoney_Graph(income_bly)%>, <%=getCompanyMoney_Graph(income_ly)%>, <%=getCompanyMoney_Graph(income_cy)%>]
												],
												names: {
													data1: "��������",
												},
												type: "bar",
												colors: {
												  data1: "#a6a6a6"
												},
												labels: true
												},
												bar: {
													width: {
													ratio: 0.5
												}
											},
											axis: {
												y: {
													tick: {
														culling: {
															max: 2
														}
													}
												}
											},
											grid: {
												y: {
													lines: [
														{
														  value: 0

														}
													]	
												}
											},
											legend: {
												"hide": true
											},
											bindto: "#barChart3"
											});
											</script>
										</div>
									</div>
								</li>
							</ul>
						</div><!--//ca_chart-->

						<div class="list_btn">
							<a class="btn list" href="./list.asp">��Ϻ���</a>
						</div>
					</div><!--//company_con -->

				</div>
				<!--//company_wrap -->
			</div>
		</div>
	</div><!-- .content -->

</div>
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->
</body>
</html>