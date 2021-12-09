<%
option Explicit

'------ 페이지 기본정보 셋팅.
g_MenuID = "010001"  '앞 두 숫자는 lnb 페이지명, 맨 뒤 숫자는 메뉴 이미지 파일명에 참조
g_MenuID_Navi = "5,1"  '내비게이션 값
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
		Response.write "<script>alert('잘못된 접근입니다.'); location.href='list.asp';</script>"
		Response.end
	End If

	Dim spName, arrNice_info
	ReDim param(1)
	'spName = "USP_ADMIN_KANGSO_SEARCH_View"
	'spName = "USP_ECRED_COMPANY_SEARCH_View"
	spName = "USP_NICECOMPANY_SEARCH_View"

	param(0) = makeParam("@bizcode", adVarchar, adParamInput, 10, bizNum)
	param(1) = makeParam("@rtnval", adInteger, adParamOutput, 4 , 0)

	arrNice_info = arrGetRsSP(dbCon, spName, param, "", "")
	
	Dim arrNice_0, arrNice_1, arrNice_2, arrNice_3, arrNice_4, arrNice_5, arrNice_6, arrNice_7
	If IsArray(arrNice_info) Then
		arrNice_0	= arrNice_info(0)   '// 기본정보
		arrNice_1	= arrNice_info(1)   '// 재무정보
		'arrNice_2   = arrNice_info(2)   '// 경영진
		'arrNice_3   = arrNice_info(3)   '// 주요 주주현황
		'arrNice_4   = arrNice_info(4)   '// 관계회사현황
		'arrNice_5   = arrNice_info(5)   '// 산업내경쟁분석
		'arrNice_6   = arrNice_info(6)   '// 연혁
		arrNice_7	= arrNice_info(7)   '// 기업정보
	End If
	
	If isArray(arrNice_0) = False Then 
		Response.write "<script>alert('잘못된 접근입니다.'); location.href='list.asp';</script>"
		Response.end
	End If

	Dim date_cy, date_ly, date_bly
	date_cy		= year(date) -1
	date_ly		= date_cy -1
	date_bly	= date_ly -1

	Dim capital_cy, capital_ly, capital_bly '자본금
	Dim sales_cy, sales_ly, sales_bly '매출액
	Dim income_cy, income_ly, income_bly '당기순이익
	Dim ranking_cy, ranking_ly, ranking_bly '산업내순위
	capital_cy		= Ccur(arrNice_1(0, 0)) / 10
	capital_ly		= Ccur(arrNice_1(1, 0)) / 10
	capital_bly		= Ccur(arrNice_1(2, 0)) / 10
	sales_cy		= Ccur(arrNice_1(3, 0)) / 10
	sales_ly		= Ccur(arrNice_1(4, 0)) / 10
	sales_bly		= Ccur(arrNice_1(5, 0)) / 10
	income_cy		= Ccur(arrNice_1(6, 0)) / 10
	income_ly		= Ccur(arrNice_1(7, 0)) / 10
	income_bly		= Ccur(arrNice_1(8, 0)) / 10
	ranking_cy		= Ccur(arrNice_1(12, 0)) / 10
	ranking_ly		= Ccur(arrNice_1(13, 0)) / 10
	ranking_bly		= Ccur(arrNice_1(14, 0)) / 10

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
	bizGubun = "일반기업"
	If IsArray(arrNice_7) Then
		If arrNice_7(2, 0) = "Y" Then bizGubun = "히든챔피언"
		If arrNice_7(1, 0) = "Y" Then bizGubun = "강소기업"
		If arrNice_7(0, 0) = "Y" Then bizGubun = "중견기업"

		Select Case arrNice_7(7, 0)
			Case "1" : bizGubun = "대기업"
			Case "2" : bizGubun = "공기업"
			Case "3" : bizGubun = "금융권"
		End Select
	Else 
		' 내부 관리자가 설정한 기업 분류가 없을 경우 신용평가기관 제공 기업 분류로 대체
		Select Case arrNice_0(13, 0)
			Case "1" bizGubun = "대기업"
			Case "2" bizGubun = "중소기업"
			Case "3" bizGubun = "중견기업"
			Case "4" bizGubun = "기타"
			Case "5" bizGubun = "보훈대상 중견기업"
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
					<%If IsArray(arrNice_7) Then%>
					<%If Not isnull(arrNice_7(3, 0)) Then %>
						<div class="ct_logo">
							<div class="ct_img">
								<img src="<%=arrNice_7(3, 0)%>" alt="직무인터뷰 회사로고">
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
								'관심기업 여부
								arrRsAttention = arrGetRsSql(DBCon,"SELECT 개인아이디 FROM 개인관심기업 WITH(NOLOCK)  WHERE 개인아이디 = '" & user_id & "' AND 사업자등록번호 = '" & bizNum & "'", "", "")
								
								if isArray(arrRsAttention) then
									chk_attention = "Y"
								end If
							End If

							DisconnectDB DBCon
						%>
							<button type="button" onclick="fn_attention('<%=g_LoginChk%>', '<%=arrNice_0(1, 0)%>', '<%=arrNice_0(3, 0)%>'); return false;">
								<span><img src="/images/Interest_<%If chk_attention = "Y" Then%>on<%Else%>off<%End If%>.png" alt="관심 on/off"></span>
								관심기업
							</button>
						</div>

						<div class="ct_name">
							<p><%=arrNice_0(3, 0)%></p>
							<%
							' 홈페이지 URL 경로 체크
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
								(주)경신은 1974년 국내 자동차 배선의 효시로 출발한 이래, 국내 제일의 Wiring Harness 기술을 바탕으로 전자, 커넥터, 친환경 제품의 개발을 통해 미래의 지속가능경영을 지향하고 있으며,
								앞으로 고객 및 협력업체와의 상생협력과 사회적 책임을 다하여 세계일류 기업으로 성장해 나갈 것입니다.
							</p>
						</div>
					</div>
				</div><!-- //company_top -->
				
				<div class="company_wrap">
					<div class="company_con">
						<h3>기본정보</h3>
						<div class="ca_info">
							<ul>
								<li class="i-1">
									<p class="t1">매출액</p>
									<p class="t2">
										<strong><%=getCompanyMoney_strongText(sales_cy)%></strong>
									</p>
								</li>
								<li class="i-2">
									<p class="t1">설립연도</p>
									<p class="t2">
										<strong><%=Left(arrNice_0(9, 0), 4)%></strong>
										<span>년</span>
									</p>
								</li>
								<li class="i-3">
									<p class="t1">기업형태</p>
									<p class="t2">
										<strong><%=bizGubun%></strong>
										<span><%=getIPOCodeName(arrNice_0(11, 0))%></span>
									</p>
								</li>
								<li class="i-4">
									<p class="t1">임직원수</p>
									<p class="t2">
										<strong><%=FormatNumber(arrNice_0(14, 0), 0)%></strong>
										<span>명</span>
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
										<th>산업</th>
										<td><%=arrNice_0(24, 0)%></td>
										<th>사원수</th>
										<td><%=FormatNumber(arrNice_0(14, 0), 0)%>명</td>
									</tr>
									<tr>
										<th>기업구분</th>
										<td><%=bizGubun%></td>
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
										<td><a href="<%=strBizHomePage%>" target="_blank"><%=strBizHomePage%></a></td>
									</tr>
									<tr>
									<%
									' 주요사업내용(GoodsName, BizField) 값 등록 여부 체크
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
										<th>주요산업</th>
										<td colspan="3">
											<%=strGoodsName%>
										</td>
									</tr>
									<tr>
										<th>주소</th>
										<td colspan="3">
											<%=arrNice_0(18, 0)%>
										</td>
									</tr>
									<tr style="display:none;">
										<th>기업소개</th>
										<td colspan="3">
											경신은 1974년 국내 자동차 배선의 효시로 출발한 이래, 국내 제일의 Wiring Harness 기술을 바탕으로 전자, 커넥터, 친환경 제품의 개발을 통해 미래의 지속가능경영을 지향하고 있으며, 앞으로 고객 및 협력업체와의 상생협력과 사회적 책임을 다하여 세계일류 기업으로 성장해
											나갈 것입니다.
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
								<li>
									<div class="chart_box">
										<h4><%=arrNice_0(3, 0)%> 산업내 순위<br><span>(<%=date_cy%>년 매출액 기준)</span></h4>
										<div class="rank_area">
											<dl>
												<dt>년도별 순위</dt>
												<dd>
													<ul>
														<li class="first">
															<p class="rank"><span><strong><%=ranking_cy%></strong>위</span></p>
															<p class="year"><%=date_cy%>년</p>
															<p class="amount"><%=getCompanyMoney_strongText(sales_cy)%></p>
														</li>
														<li>
															<p class="rank"><span><strong><%=ranking_ly%></strong>위</span></p>
															<p class="year"><%=date_ly%>년</p>
															<p class="amount"><%=getCompanyMoney_strongText(sales_ly)%></p>
														</li>
														<li>
															<p class="rank"><span><strong><%=ranking_bly%></strong>위</span></p>
															<p class="year"><%=date_bly%>년</p>
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
											<div id="barChart2"></div>
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
											bindto: "#barChart2"
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
											<div id="barChart"></div>
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
											bindto: "#barChart"
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

					</div><!--//company_con -->

					<div class="board_area" style="display:none;">
						<h3>기업뉴스</h3>
						<table class="tb" summary="스크랩한 인재에 관한 이름/성별/나이,이력서 정보/요약정보,등록일 항목을 나타낸 표">
							<caption>스크랩한 인재 목록</caption>
							<colgroup>
								<col style="width:170px">
								<col>
								<col style="width:185px">
							</colgroup>
							<thead>
								<tr>
									<th>등록일</th>
									<th>제목</th>
									<th>출처</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>2020.06.15</td>
									<td>
										<p class="news_tit">
											현대자동차그룹, 채용박람회 열어 협력사 인력 확보 ‘지원사격’.. 한몸으로 움직인다.
										</p>
									</td>
									<td>한국경제</td>
								</tr>
								<tr>
									<td>2020.06.15</td>
									<td>
										<p class="news_tit">
											현대자동차그룹, 채용박람회 열어 협력사 인력 확보 ‘지원사격’.. 한몸으로 움직인다.
										</p>
									</td>
									<td>한국경제</td>
								</tr>
								<tr>
									<td>2020.06.15</td>
									<td>
										<p class="news_tit">
											현대자동차그룹, 채용박람회 열어 협력사 인력 확보 ‘지원사격’.. 한몸으로 움직인다.
										</p>
									</td>
									<td>한국경제</td>
								</tr>
								<tr>
									<td>2020.06.15</td>
									<td>
										<p class="news_tit">
											현대자동차그룹, 채용박람회 열어 협력사 인력 확보 ‘지원사격’.. 한몸으로 움직인다.
										</p>
									</td>
									<td>한국경제</td>
								</tr>
							</tbody>
						</table>
					</div><!--// board_area-->
					<div class="paging-area" style="display:none;">
						<span class="prev">
							<a href="javaScript:;">
								<img src="http://image.career.co.kr/career_new4/kangso/calendar/btn_paging_prev.gif" alt="다음">
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
								<img src="http://image.career.co.kr/career_new4/kangso/calendar/btn_paging_next.gif" alt="다음">
							</a>
						</span>
					</div><!-- //paging-area -->

					<div class="company_loca">
						<h3>회사위치</h3>
						<ul class="cl_ul">
							<li><%=arrNice_0(3, 0)%></li>
							<!-- <li>본사사옥/연구소</li> -->
							<li>전화번호.  <%=arrNice_0(22, 0)%></li>
							<li>팩스. <%=arrNice_0(23, 0)%></li>
							<li class="map">주소. <%=arrNice_0(18, 0)%>
								<a href="https://map.naver.com/?query=<%=arrNice_0(18, 0)%>" target="_blank">지도보기</a>
							</li>
						</ul>
					</div>

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