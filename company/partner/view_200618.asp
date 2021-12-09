<%
option Explicit

'------ 페이지 기본정보 셋팅.
g_MenuID = "010001"  '앞 두 숫자는 lnb 페이지명, 맨 뒤 숫자는 메뉴 이미지 파일명에 참조
g_MenuID_Navi = "5,1"  '내비게이션 값
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<%
ConnectDB DBCon, Application("DBInfo")

	Dim bizNum, page
	bizNum	= Request("bizNum")

	If bizNum = "" Then
		Response.write "<script>alert('잘못된 접근입니다.'); location.href='list.asp';</script>"
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
		arrNice_0   = arrNice_info(0)   '// 기본정보
		arrNice_1   = arrNice_info(1)   '// 재무정보
		'arrNice_2   = arrNice_info(2)   '// 경영진
		'arrNice_3   = arrNice_info(3)   '// 주요 주주현황
		'arrNice_4   = arrNice_info(4)   '// 관계회사현황
		'arrNice_5   = arrNice_info(5)   '// 산업내경쟁분석
		'arrNice_6   = arrNice_info(6)   '// 연혁
		'arrNice_15  = arrNice_info(15)  '// 주주
	End If
	
	If isArray(arrNice_0) = False Then 
		Response.write "<script>alert('잘못된 접근입니다.'); location.href='list.asp';</script>"
		Response.end
	End If

	Dim date_cy, date_ly, date_bly
	date_cy = year(date) -1
	date_ly = date_cy -1
	date_bly = date_ly -1

	Dim capital_cy, capital_ly, capital_bly '자본금
	Dim sales_cy, sales_ly, sales_bly '매출액
	Dim income_cy, income_ly, income_bly '당기순이익
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
			var result = confirm("로그인 후 관심기업을 추가할 수 있습니다.");

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
						alert("관심기업으로 등록되었습니다.");
						location.href = location.href;
					}
					else if (data == "2") {
						alert("관심기업이 해제되었습니다.");
						location.href = location.href;
					}
					else if (data == "50") {
						alert("관심기업은 최대 50개까지 등록 가능합니다.");
						return false;
					}
					else if (data == "0") {
						alert("관심기업 추가에 실패했습니다.");
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
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- 본문 -->
<div id="contents" class="sub_page">
	<div class="content glay">
		<div class="con_box">
			<div class="partner_area view">
				<div class="company_top">
					<div class="ct_info">
						<div class="ct_logo">
							<div class="ct_img">
								<!--
								<img src="" alt="회사로고">
								-->
							</div>
						</div>
						
						<div class="ct_Interest">
							<%
								Dim chk_scrap, chk_attention, arrRsAttention
								chk_attention = ""
								ConnectDB DBCon, Application("DBInfo_FAIR")

								If user_id <> "" Then 
									'관심기업 여부
									arrRsAttention = arrGetRsSql(DBCon,"SELECT 개인아이디 FROM 개인관심기업 WITH(NOLOCK)  WHERE 개인아이디 = '" & user_id & "' AND 사업자등록번호 = '" & bizNum & "'", "", "")
									
									if isArray(arrRsAttention) then
										chk_attention = "Y"
									end If
								End If

								DisconnectDB DBCon
							%>

							<!--<p>관심기업 추가하고 채용소식 받기</p>-->
							<button type="button" onclick="fn_attention('<%=g_LoginChk%>', '<%=arrNice_0(1, 0)%>', '<%=arrNice_0(3, 0)%>'); return false;">
							<% If chk_attention = "Y" Then %>	
								<span><img src="/images/Interest_on.png" alt="관심 on"></span>
							<% Else %>
								<span><img src="/images/Interest_off.png" alt="관심 off"></span>
							<% End If %>
								관심기업
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
								(주)경신은 1974년 국내 자동차 배선의 효시로 출발한 이래, 국내 제일의 Wiring Harness 기술을 바탕으로 전자, 커넥터, 친환경 제품의 개발을 통해 미래의 지속가능경영을 지향하고 있으며,
								앞으로 고객 및 협력업체와의 상생협력과 사회적 책임을 다하여 세계일류 기업으로 성장해 나갈 것입니다.
								-->
							</p>
						</div>
					</div>
				</div><!-- //company_top -->
				
				<div class="company_wrap">
					<div class="company_con">
						<h3>기본정보</h3>
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
										<th>산업</th>
										<td><%=arrNice_0(24, 0)%></td>
										<th>사원수</th>
										<td><%=FormatNumber(arrNice_0(14, 0), 0)%>명</td>
									</tr>
									<tr>
										<th>기업구분</th>
										<td>대기업 · 코스피 · 주식</td>
										<th>설립일</th>
										<%
										Dim create_date, create_year
										If arrNice_0(9, 0) <> "" Then 
											create_date = Mid(arrNice_0(9, 0), 1, 4) & "." & Mid(arrNice_0(9, 0), 5, 2) & "." & Mid(arrNice_0(9, 0), 7, 2)
											create_year = year(date) - Left(arrNice_0(9, 0), 4)
										End If
										%>
										<td><%=create_date%> (<%=create_year%>년차)</td>
									</tr>
									<tr>
										<th>자본금</th>
										<td><%=getCompanyMoney_Text(capital_cy)%></td>
										<th>매출액</th>
										<td><%=getCompanyMoney_Text(sales_cy)%></td>
									</tr>
									<tr>
										<th>대표자</th>
										<td><%=arrNice_0(5, 0)%></td>
										<th>홈페이지</th>
										<td><%=arrNice_0(31, 0)%></td>
									</tr>
									<tr>
										<th>주요산업</th>
										<td colspan="3">
											?
										</td>
									</tr>
									<tr>
										<th>주소</th>
										<td colspan="3">
											<%=arrNice_0(18, 0)%>
										</td>
									</tr>
									<tr>
										<th>기업소개</th>
										<td colspan="3">
											?
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!--//company_con -->


					<div class="company_con">
						<h3>재무분석</h3>
						<div class="ca_chart">
							<ul>
								
								<!--
								<li>
									<div class="chart_box">
										<h4>전년 대비 매출처 유지현황</h4>
										<div class="chart_sel">
											<span class="selectbox" style="width:110px">
												<span class="">년도</span>
												<select id="sel_year" name="sel_year1" title="년도</ 선택" selected="selected">
													<option value="">2019년</option>
													<option value="">2018년</option>
													<option value="">2017년</option>
												</select>
											</span>
											<div class="quarter">
												<label class="radiobox on" for="quarter1_1">
													<input type="radio" class="rdi" id="quarter1_1" name="quarter1" value="" onclick="">
													<span>1분기</span>
												</label>
												<label class="radiobox on" for="quarter1_2">
													<input type="radio" class="rdi" id="quarter1_2" name="quarter1" value="" onclick="">
													<span>2분기</span>
												</label>
												<label class="radiobox on" for="quarter1_3">
													<input type="radio" class="rdi" id="quarter1_3" name="quarter1" value="" onclick="">
													<span>3분기</span>
												</label>
												<label class="radiobox on" for="quarter1_4">
													<input type="radio" class="rdi" id="quarter1_4" name="quarter1" value="" onclick="">
													<span>4분기</span>
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
													data1: "59% 용역매출",
													data2: "15% 상품매출",
													data3: "12% 상품매출",
													data4: "10% 용역매출",
													data5: "기타",
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
										<h4>자본금</h4>
										<div class="chart_txt">
											<dl>
												<dt><%=date_cy%>년 자본금</dt>
												<dd><%=getCompanyMoney_Text(capital_cy)%></dd>
											</dl>
											<dl>
												<dt>작년대비</dt>
												<dd><span class="<%=capital_updown%>"><%=capital_rate%>%</span></dd>
											</dl>
										</div>

										<div class="chart bar">
											<div id="barChart"></div>
											<span>(단위 : 천만원)</span>
											<script>
											var chart = bb.generate({
											data: {
												x: "x",
												columns: [
													["x", "<%=date_bly%>", "<%=date_ly%>", "<%=date_cy%>"],
													["data1", <%=getCompanyMoney_Graph(capital_bly)%>, <%=getCompanyMoney_Graph(capital_ly)%>, <%=getCompanyMoney_Graph(capital_cy)%>]
												],
												names: {
													data1: "자본금",
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
										<h4>매출액</h4>
										<div class="chart_txt">
											<dl>
												<dt><%=date_cy%>년 매출액</dt>
												<dd><%=getCompanyMoney_Text(sales_cy)%></dd>
											</dl>
											<dl>
												<dt>작년대비</dt>
												<dd><span class="<%=sales_updown%>"><%=sales_rate%>%</span></dd>
											</dl>
										</div>

										<div class="chart bar">
											<div id="barChart2"></div>
											<span>(단위 : 천만원)</span>
											<script>
											var chart = bb.generate({
											data: {
												x: "x",
												columns: [
													["x", "<%=date_bly%>", "<%=date_ly%>", "<%=date_cy%>"],
													["data1", <%=getCompanyMoney_Graph(sales_bly)%>, <%=getCompanyMoney_Graph(sales_ly)%>, <%=getCompanyMoney_Graph(sales_cy)%>]
												],
												names: {
													data1: "매출액",
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
										<h4>당기순이익</h4>
										<div class="chart_txt">
											<dl>
												<dt><%=date_cy%>년 당기순이익</dt>
												<dd><%=getCompanyMoney_Text(income_cy)%></dd>
											</dl>
											<dl>
												<dt>작년대비</dt>
												<dd><span class="<%=income_updown%>"><%=income_rate%>%</span></dd>
											</dl>
										</div>

										<div class="chart bar">
											<div id="barChart3"></div>
											<span>(단위 : 천만원)</span>
											<script>
											var chart = bb.generate({
											data: {
												x: "x",
												columns: [
													["x", "<%=date_bly%>", "<%=date_ly%>", "<%=date_cy%>"],
													["data1", <%=getCompanyMoney_Graph(income_bly)%>, <%=getCompanyMoney_Graph(income_ly)%>, <%=getCompanyMoney_Graph(income_cy)%>]
												],
												names: {
													data1: "당기순이익",
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
							<a class="btn list" href="./list.asp">목록보기</a>
						</div>
					</div><!--//company_con -->

				</div>
				<!--//company_wrap -->
			</div>
		</div>
	</div><!-- .content -->

</div>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->
</body>
</html>