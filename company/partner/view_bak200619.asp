<%
option Explicit

'------ ������ �⺻���� ����.
g_MenuID = "010001"  '�� �� ���ڴ� lnb ��������, �� �� ���ڴ� �޴� �̹��� ���ϸ� ����
g_MenuID_Navi = "5,1"  '������̼� ��
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<!--#include virtual = "/wwwconf/code/code_function.asp"-->
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
	
	Dim arrNice_0, arrNice_1, arrNice_2, arrNice_3, arrNice_4, arrNice_5, arrNice_6, arrNice_7
	If IsArray(arrNice_info) Then
		arrNice_0	= arrNice_info(0)   '// �⺻����
		arrNice_1	= arrNice_info(1)   '// �繫����
		'arrNice_2   = arrNice_info(2)   '// �濵��
		'arrNice_3   = arrNice_info(3)   '// �ֿ� ������Ȳ
		'arrNice_4   = arrNice_info(4)   '// ����ȸ����Ȳ
		'arrNice_5   = arrNice_info(5)   '// ���������м�
		'arrNice_6   = arrNice_info(6)   '// ����
		arrNice_7	= arrNice_info(7)   '// �������
	End If
	
	If isArray(arrNice_0) = False Then 
		Response.write "<script>alert('�߸��� �����Դϴ�.'); location.href='list.asp';</script>"
		Response.end
	End If

	Dim date_cy, date_ly, date_bly
	date_cy		= year(date) -1
	date_ly		= date_cy -1
	date_bly	= date_ly -1

	Dim capital_cy, capital_ly, capital_bly '�ں���
	Dim sales_cy, sales_ly, sales_bly '�����
	Dim income_cy, income_ly, income_bly '��������
	Dim ranking_cy, ranking_ly, ranking_bly '���������
	capital_cy		= Ccur(arrNice_1(0, 0))
	capital_ly		= Ccur(arrNice_1(1, 0))
	capital_bly		= Ccur(arrNice_1(2, 0))
	sales_cy		= Ccur(arrNice_1(3, 0))
	sales_ly		= Ccur(arrNice_1(4, 0))
	sales_bly		= Ccur(arrNice_1(5, 0))
	income_cy		= Ccur(arrNice_1(6, 0))
	income_ly		= Ccur(arrNice_1(7, 0))
	income_bly		= Ccur(arrNice_1(8, 0))
	ranking_cy		= Ccur(arrNice_1(12, 0))
	ranking_ly		= Ccur(arrNice_1(13, 0))
	ranking_bly		= Ccur(arrNice_1(14, 0))

	Dim capital_rate, sales_rate, income_rate
	If capital_ly <> 0 Then capital_rate = (capital_cy - capital_ly) / capital_ly * 100
	If sales_ly <> 0 Then sales_rate = (sales_cy - sales_ly) / sales_ly * 100
	If income_ly <> 0 Then income_rate = (income_cy - income_ly) / income_ly * 100

	capital_rate = FormatNumber(capital_rate, 2)
	sales_rate = FormatNumber(sales_rate, 2)
	income_rate = FormatNumber(income_rate, 2)
	
	Dim capital_updown, sales_updown, income_updown
	Select Case Sgn(capital_rate)
		Case 0	: capital_updown = "middle"
		Case 1	: capital_updown = "up"
		Case -1 : capital_updown = "down"
	End Select
	Select Case Sgn(sales_rate)
		Case 0	: sales_updown = "middle"
		Case 1	: sales_updown = "up"
		Case -1	: sales_updown = "down"
	End Select
	Select Case Sgn(income_rate)
		Case 0	: income_updown = "middle"
		Case 1	: income_updown = "up"
		Case -1	: income_updown = "down"
	End Select

	Dim bizGubun, bizIPO
	bizGubun = "�Ϲݱ��"
	If IsArray(arrNice_7) Then
		If arrNice_7(2, 0) = "Y" Then bizGubun = "����è�Ǿ�"
		If arrNice_7(1, 0) = "Y" Then bizGubun = "���ұ��"
		If arrNice_7(0, 0) = "Y" Then bizGubun = "�߰߱��"

		Select Case arrNice_7(7, 0)
			Case "1" : bizGubun = "����"
			Case "2" : bizGubun = "�����"
			Case "3" : bizGubun = "������"
		End Select
	Else 
		' ���� �����ڰ� ������ ��� �з��� ���� ��� �ſ��򰡱�� ���� ��� �з��� ��ü
		Select Case arrNice_0(13, 0)
			Case "1" bizGubun = "����"
			Case "2" bizGubun = "�߼ұ��"
			Case "3" bizGubun = "�߰߱��"
			Case "4" bizGubun = "��Ÿ"
			Case "5" bizGubun = "���ƴ�� �߰߱��"
		End Select
	End If

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
					<%If IsArray(arrNice_7) Then%>
					<%If Not isnull(arrNice_7(3, 0)) Then %>
						<div class="ct_logo">
							<div class="ct_img">
								<img src="<%=arrNice_7(3, 0)%>" alt="�������ͺ� ȸ��ΰ�">
							</div>
						</div>
					<%End If%>
					<%End If%>

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
							<button type="button" onclick="fn_attention('<%=g_LoginChk%>', '<%=arrNice_0(1, 0)%>', '<%=arrNice_0(3, 0)%>'); return false;">
								<span><img src="/images/Interest_<%If chk_attention = "Y" Then%>on<%Else%>off<%End If%>.png" alt="���� on/off"></span>
								���ɱ��
							</button>
						</div>

						<div class="ct_name">
							<p><%=arrNice_0(3, 0)%></p>
							<%
							' Ȩ������ URL ��� üũ
							Dim strBizHomePage
							If Not isnull(arrNice_0(31, 0)) Then 
								If InStr(arrNice_0(31, 0),"http") > 0 Then
									strBizHomePage	= arrNice_0(31, 0)
								Else
									strBizHomePage	= "http://"& arrNice_0(31, 0)
								End If
							End If 
							%>
							<a href="<%=strBizHomePage%>" target="_blank"><%=strBizHomePage%></a>
						</div>
						
						<div class="ct_ment" style="display:none;">
							<p>
								(��)����� 1974�� ���� �ڵ��� �輱�� ȿ�÷� ����� �̷�, ���� ������ Wiring Harness ����� �������� ����, Ŀ����, ģȯ�� ��ǰ�� ������ ���� �̷��� ���Ӱ��ɰ濵�� �����ϰ� ������,
								������ �� �� ���¾�ü���� ������°� ��ȸ�� å���� ���Ͽ� �����Ϸ� ������� ������ ���� ���Դϴ�.
							</p>
						</div>
					</div>
				</div><!-- //company_top -->
				
				<div class="company_wrap">
					<div class="company_con">
						<h3>�⺻����</h3>
						<div class="ca_info">
							<ul>
								<li class="i-1">
									<p class="t1">�����</p>
									<p class="t2">
										<strong><%=getCompanyMoney_strongText(sales_cy)%></strong>
									</p>
								</li>
								<li class="i-2">
									<p class="t1">��������</p>
									<p class="t2">
										<strong><%=Left(arrNice_0(9, 0), 4)%></strong>
										<span>��</span>
									</p>
								</li>
								<li class="i-3">
									<p class="t1">�������</p>
									<p class="t2">
										<strong><%=bizGubun%></strong>
										<span><%=getIPOCodeName(arrNice_0(11, 0))%></span>
									</p>
								</li>
								<li class="i-4">
									<p class="t1">��������</p>
									<p class="t2">
										<strong><%=FormatNumber(arrNice_0(14, 0), 0)%></strong>
										<span>��</span>
									</p>
								</li>
							</ul>
							<table class="tb">
								<colgroup>
									<col style="width:150px;">
									<col style="width:400px;">
									<col style="width:150px;">
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
										<td><%=bizGubun%></td>
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
										<td><a href="<%=strBizHomePage%>" target="_blank"><%=strBizHomePage%></a></td>
									</tr>
									<tr>
									<%
									' �ֿ�������(GoodsName, BizField) �� ��� ���� üũ
									Dim strGoodsName : strGoodsName = ""
									If Not isnull(arrNice_0(16, 0)) Then 
										strGoodsName = arrNice_0(16, 0)
									Else 
										If Not isnull(arrNice_0(24, 0)) Then 
											strGoodsName = arrNice_0(24, 0)
										Else 
											strGoodsName = "-"
										End If 
									End If 
									%>
										<th>�ֿ���</th>
										<td colspan="3">
											<%=strGoodsName%>
										</td>
									</tr>
									<tr>
										<th>�ּ�</th>
										<td colspan="3">
											<%=arrNice_0(18, 0)%>
										</td>
									</tr>
									<tr style="display:none;">
										<th>����Ұ�</th>
										<td colspan="3">
											����� 1974�� ���� �ڵ��� �輱�� ȿ�÷� ����� �̷�, ���� ������ Wiring Harness ����� �������� ����, Ŀ����, ģȯ�� ��ǰ�� ������ ���� �̷��� ���Ӱ��ɰ濵�� �����ϰ� ������, ������ �� �� ���¾�ü���� ������°� ��ȸ�� å���� ���Ͽ� �����Ϸ� ������� ������
											���� ���Դϴ�.
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
								<li>
									<div class="chart_box">
										<h4><%=arrNice_0(3, 0)%> ����� ����<br><span>(<%=date_cy%>�� ����� ����)</span></h4>
										<div class="rank_area">
											<dl>
												<dt>�⵵�� ����</dt>
												<dd>
													<ul>
														<li class="first">
															<p class="rank"><span><strong><%=ranking_cy%></strong>��</span></p>
															<p class="year"><%=date_cy%>��</p>
															<p class="amount"><%=getCompanyMoney_strongText(sales_cy)%></p>
														</li>
														<li>
															<p class="rank"><span><strong><%=ranking_ly%></strong>��</span></p>
															<p class="year"><%=date_ly%>��</p>
															<p class="amount"><%=getCompanyMoney_strongText(sales_ly)%></p>
														</li>
														<li>
															<p class="rank"><span><strong><%=ranking_bly%></strong>��</span></p>
															<p class="year"><%=date_bly%>��</p>
															<p class="amount"><%=getCompanyMoney_strongText(sales_bly)%></p>
														</li>
													</ul>
												</dd>
											</dl>
										</div>
									</div>
								</li>

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
											<div id="barChart2"></div>
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
											bindto: "#barChart2"
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
											<div id="barChart"></div>
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
											bindto: "#barChart"
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

					</div><!--//company_con -->

					<div class="board_area" style="display:none;">
						<h3>�������</h3>
						<table class="tb" summary="��ũ���� ���翡 ���� �̸�/����/����,�̷¼� ����/�������,����� �׸��� ��Ÿ�� ǥ">
							<caption>��ũ���� ���� ���</caption>
							<colgroup>
								<col style="width:170px">
								<col>
								<col style="width:185px">
							</colgroup>
							<thead>
								<tr>
									<th>�����</th>
									<th>����</th>
									<th>��ó</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>2020.06.15</td>
									<td>
										<p class="news_tit">
											�����ڵ����׷�, ä��ڶ�ȸ ���� ���»� �η� Ȯ�� ��������ݡ�.. �Ѹ����� �����δ�.
										</p>
									</td>
									<td>�ѱ�����</td>
								</tr>
								<tr>
									<td>2020.06.15</td>
									<td>
										<p class="news_tit">
											�����ڵ����׷�, ä��ڶ�ȸ ���� ���»� �η� Ȯ�� ��������ݡ�.. �Ѹ����� �����δ�.
										</p>
									</td>
									<td>�ѱ�����</td>
								</tr>
								<tr>
									<td>2020.06.15</td>
									<td>
										<p class="news_tit">
											�����ڵ����׷�, ä��ڶ�ȸ ���� ���»� �η� Ȯ�� ��������ݡ�.. �Ѹ����� �����δ�.
										</p>
									</td>
									<td>�ѱ�����</td>
								</tr>
								<tr>
									<td>2020.06.15</td>
									<td>
										<p class="news_tit">
											�����ڵ����׷�, ä��ڶ�ȸ ���� ���»� �η� Ȯ�� ��������ݡ�.. �Ѹ����� �����δ�.
										</p>
									</td>
									<td>�ѱ�����</td>
								</tr>
							</tbody>
						</table>
					</div><!--// board_area-->
					<div class="paging-area" style="display:none;">
						<span class="prev">
							<a href="javaScript:;">
								<img src="http://image.career.co.kr/career_new4/kangso/calendar/btn_paging_prev.gif" alt="����">
							</a>
						</span>
						<strong>1</strong>
						<a href="javaScript:;">2</a>
						<a href="javaScript:;">3</a>
						<a href="javaScript:;">4</a>
						<a href="javaScript:;">5</a>
						<a href="javaScript:;">6</a>
						<a href="javaScript:;">7</a>
						<a href="javaScript:;">8</a>
						<a href="javaScript:;">9</a>
						<a href="javaScript:;">10</a>
						<span class="next">
							<a href="javaScript:;">
								<img src="http://image.career.co.kr/career_new4/kangso/calendar/btn_paging_next.gif" alt="����">
							</a>
						</span>
					</div><!-- //paging-area -->

					<div class="company_loca">
						<h3>ȸ����ġ</h3>
						<ul class="cl_ul">
							<li><%=arrNice_0(3, 0)%></li>
							<!-- <li>������/������</li> -->
							<li>��ȭ��ȣ.  <%=arrNice_0(22, 0)%></li>
							<li>�ѽ�. <%=arrNice_0(23, 0)%></li>
							<li class="map">�ּ�. <%=arrNice_0(18, 0)%>
								<a href="https://map.naver.com/?query=<%=arrNice_0(18, 0)%>" target="_blank">��������</a>
							</li>
						</ul>
					</div>

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