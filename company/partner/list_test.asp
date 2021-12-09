<%
option Explicit

'------ 페이지 기본정보 셋팅.
g_MenuID = "010001"  '앞 두 숫자는 lnb 페이지명, 맨 뒤 숫자는 메뉴 이미지 파일명에 참조
g_MenuID_Navi = "5,1"  '내비게이션 값
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<%
ConnectDB DBCon, Application("DBInfoTest")
	
	Dim page, pageSize, orderNum, totalCnt, stropt, totalPage, i, ii
	page = CInt(Request("page"))
	pageSize = CInt(Request("pageSize"))
	orderNum = CInt(Request("orderNum"))

	If page = "0" Then page = 1
	If pageSize = "0" Then pageSize = 10
	If orderNum = "0" Then orderNum = 3

	Dim schArea, schKw
	schArea = Request("schArea")
	schArea = Replace(schArea, " ", "")
	schKw = Request("schKw")
	schKw = Replace(schKw, "협력사 기업명을 입력해주세요.", "")

	Dim spName, arrRs
	ReDim param(6)
	spName = "USP_HKPARTNER_COMPANY_LIST"

	param(0) = makeParam("@BizNum", adVarchar, adParamInput, 10, "")
	param(1) = makeParam("@BizName", adVarchar, adParamInput, 200, schKw)
	param(2) = makeParam("@BizArea", adVarchar, adParamInput, 2000, schArea)
	param(3) = makeParam("@OrderNum", adInteger, adParamInput, 4, orderNum)
	param(4) = makeParam("@Page", adInteger, adParamInput, 4 , page)
	param(5) = makeParam("@PageSize", adInteger, adParamInput, 4 , pageSize)
	param(6) = makeParam("@TotalCnt", adInteger, adParamOutput, 4 , 0)

	arrRs = arrGetRsSP(dbCon, spName, param, "", "")
	totalCnt = getParamOutputValue(param, "@TotalCnt")
	totalPage = (totalCnt / pageSize) + 1

	stropt = "schKw=" & schKw & "&schArea=" & schArea
	'Response.write schArea

DisconnectDB DBCon
%>
<script type="text/javascript">
	$(document).ready(function () {
		// 전체를 라디오버튼처럼 사용하기 위해
		$("input:checkbox[name='schArea']").click(function() {
			if ($("input:checkbox[name=schArea][value='']").prop("checked")) {
				$("input:checkbox[name=schArea]").prop("checked",false);
				$(this).prop("checked", true);

				checkboxFnc(); //체크박스
			}
		});

		var r_schArea
		r_schArea = "<%=schArea%>";

		var arr	= new Array();
		arr = r_schArea.split(",");

		for (i = 0; i < arr.length; i++) {
			if (arr[i].indexOf("서울") != -1) {
				arr[i] = "서울,경기,인천";
			}

			$("input:checkbox[name=schArea][value='"+arr[i]+"']").prop("checked",true);
		}
		
		checkboxFnc(); //체크박스
	});
</script>
</head>

<body>
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- 본문 -->
<div id="contents" class="sub_page">
	<div class="sub_visual partner">
		<div class="visual_area">
			<h2><img src="../../images/company/h2_partner.png" alt="협력사"></h2>
		</div>
	</div>
	<div class="content">
		<div class="con_box">
			<div class="partner_area">
				<form id="frm" name="frm" method="get">

				<div class="areaArea">
					<ul>
						<li>
							<label class="checkbox" for="schArea1">
								<input type="checkbox" id="schArea1" class="chk" name="schArea" value="">
									<span>전체</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea2">
								<input type="checkbox" id="schArea2" class="chk" name="schArea" value="서울,경기,인천">
									<span>서울.경기.인천</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea3">
								<input type="checkbox" id="schArea3" class="chk" name="schArea" value="부산">
									<span>부산</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea4">
								<input type="checkbox" id="schArea4" class="chk" name="schArea" value="대구">
									<span>대구</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea5">
								<input type="checkbox" id="schArea5" class="chk" name="schArea" value="대전">
									<span>대전</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea6">
								<input type="checkbox" id="schArea6" class="chk" name="schArea" value="광주">
									<span>광주</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea7">
								<input type="checkbox" id="schArea7" class="chk" name="schArea" value="울산">
									<span>울산</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea8">
								<input type="checkbox" id="schArea8" class="chk" name="schArea" value="세종">
									<span>세종</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea9">
								<input type="checkbox" id="schArea9" class="chk" name="schArea" value="강원">
									<span>강원도</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea10">
								<input type="checkbox" id="schArea10" class="chk" name="schArea" value="경남">
									<span>경상남도</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea11">
								<input type="checkbox" id="schArea11" class="chk" name="schArea" value="경북">
									<span>경상북도</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea12">
								<input type="checkbox" id="schArea12" class="chk" name="schArea" value="전남">
									<span>전라남도<span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea13">
								<input type="checkbox" id="schArea13" class="chk" name="schArea" value="전북">
									<span>전라북도</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea14">
								<input type="checkbox" id="schArea14" class="chk" name="schArea" value="충남">
									<span>충청남도</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea15">
								<input type="checkbox" id="schArea15" class="chk" name="schArea" value="충북">
									<span>충청북도</span>
							</label>
						</li>
						<li>
							<label class="checkbox off" for="schArea16">
								<input type="checkbox" id="schArea16" class="chk" name="schArea" value="제주">
									<span>제주도</span>
							</label>
						</li>
					</ul>
				</div>

				<div class="searchArea">
					<div class="searchInner">
						<div class="fl">
							<p class="total">총 <span><%=FormatNumber(totalCnt, 0)%></span>개의 협력사 정보가 있습니다.</p>
						</div><!--.fl-->

						<div class="fr">
							<div class="searchBox">
								<div class="inp">
									<input class="txt value" id="schKw" name="schKw" type="text" default="협력사 기업명을 입력해주세요." value="<%=schKw%>" style="width:465px;">
									<button type="button" class="btn typegray" onclick="document.frm.submit();"><strong>검색</strong></button>
								</div><!-- .inp -->
							</div><!-- .searchBox -->
						</div><!--.fr-->

					</div><!--.searchInner-->
				</div><!-- //searchArea--->

				</form>

				<div class="list_area">
					<ul>
					<%
					If isArray(arrRs) Then 
						For i=0 To UBound(arrRs, 2)
						Dim bizGubun : bizGubun = ""
						Dim bizIPO : bizIPO = ""

						If arrRs(21, i) = "Y" Then bizGubun = "히든챔피언"
						If arrRs(20, i) = "Y" Then bizGubun = "강소기업"
						If arrRs(19, i) = "Y" Then bizGubun = "중견기업"

						Select Case arrRs(18, i)
							Case "1" : bizGubun = "대기업"
							Case "2" : bizGubun = "공기업"
							Case "3" : bizGubun = "금융권"
						End Select

						Select Case arrRs(5, i)
							Case "10" : bizIPO = "코스피"
							Case "21" : bizIPO = "코스닥"
							Case "30" : bizIPO = "외감"
						End Select
						
						'10=상장
						'15=상장관리
						'20=등록
						'21=코스닥
						'23=코스닥관리, 
						'30=외감
						'40=일반
						'50=중소
						'60=개인
						'70=공기관, 
						'91=피흡수합병
						'92=폐업
						'93=청산
						'99=기타

						Dim intSales_CY
						intSales_CY = CCur(arrRs(15, i)) / 10
						intSales_CY = getCompanyMoney_Text(intSales_CY)
					%>
						<li>
							<div class="info_box">
								<div class="la_logo">
									<div class="logo_box">
										<div class="logo">
											<% If arrRs(17, i) <> "" Then %>
											<a href="./view.asp?bizNum=<%=arrRs(1, i)%>"><img src="<%=arrRs(17, i)%>" alt="협력사 회사 로고"></a>
											<% End If %>
										</div>
									</div>
								</div>
								<div class="la_info">
									<div class="tit">
										<p><a href="./view.asp?bizNum=<%=arrRs(1, i)%>"><%=arrRs(2, i)%></a></p>
										<div class="company_icon">
											<% If bizGubun <> "" Then %>
											<em class="icon i-middle on"><%=bizGubun%></em>
											<% End If %>
											<% If bizIPO <> "" Then %>
											<em class="icon i-kosdaq on"><%=bizIPO%></em>
											<% End If %>
										</div>
									</div>
									<dl>
										<dt>설립년도 :</dt>
										<dd><%=Left(arrRs(4, i), 4)%>년 / 임직원수 : <%=arrRs(7, i)%>명</dd>
										<dt>매출액 :</dt>
										<dd><%=intSales_CY%> (<%=year(date)-1%>년 기준)</dd>
										<dt>주요사업 :</dt>
										<dd><%=arrRs(8, i)%></dd>
									</dl>
								</div>
							</div>
						</li>
					<%
						Next
					End if
					%>
					</ul>
				</div><!-- //list_area -->

				<!--페이징-->
				<% Call putPage(Page, stropt, totalPage) %>

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