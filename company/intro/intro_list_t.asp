<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<%

Dim target		: target		= Request("target")		' 검색구분(제목:1, 내용:2)
Dim schKeyword	: schKeyword	= Request("kw") ' 검색어(제목/내용)
Dim page		: page			= Request("page")
Dim jc1			: jc1			= Request("jc1")		' 업종
Dim ac			: ac			= Request("ac")		' 업종
Dim pageSize	: pageSize		= 20

If page = "" Then page = 1
If jc1 = "" Then jc1 = ""
If ac = "" Then ac = ""
page = CInt(page)

'지역코드 xml
Dim arrListArea1 '1차
arrListArea1 = getAreaList1() '/wwwconf/code/code_function_ac.asp

Dim arrListArea2 '2차
arrListArea2 = getArrJcList("1")

'직종코드 xml
Dim arrListJc1
arrListJc1 = getArrJcList1() '/wwwconf/code/code_function_jc.asp


ConnectDB DBCon, Application("DBInfo_FAIR")

Dim Param(6)
Param(0) = makeparam("@target",adChar,adParamInput,1,"1")
Param(1) = makeparam("@kw",adVarChar,adParamInput,100,schKeyword)
Param(2) = makeparam("@page",adInteger,adParamInput,4,page)
Param(3) = makeparam("@pagesize",adInteger,adParamInput,4,pagesize)
Param(4) = makeparam("@totalcnt",adInteger,adParamOutput,4,"")
Param(5) = makeparam("@Jc1",adVarChar,adParamInput,100,jc1)
Param(6) = makeparam("@Ac1",adVarChar,adParamInput,180,ac)

Dim arrayList(2)
arrayList(0) = arrGetRsSP(DBcon,"usp_company_intro_list",Param,"","")
arrayList(1) = getParamOutputValue(Param,"@totalcnt")

Dim arrRs		: arrRs		= arrayList(0)
Dim Tcnt		: Tcnt		= arrayList(1)
DIm totalPage	: totalPage = Fix(((Tcnt-1)/PageSize) +1)

DisconnectDB DBCon


Dim stropt
stropt = "schKeyword="&schKeyword
%>
<script type="text/javascript">
	$(document).ready(function(){
	//엔터 검색
		$('input').keyup(function(e){
			if(e.keyCode == 13) {
				fn_search();
			}
		});
	});
	function fn_chk_jc1(obj) {
		$('#page').val("1");
		document.frm.submit();
	}
	function fn_chk_area(obj) {
		$('#page').val("1");
		document.frm.submit();
	}
	function fn_reset() {
		$('#page').val("1");
		$('#kw').val("");
		document.frm.submit();
	}
	function fn_search() {
		$("#page").val('1');
		document.frm.submit();
	}
</script>
</head>

<body>

<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<form method="post" id="frm_view" name="frm_view" action="">
	<input type="hidden" id="hdn_biz_code" name="hdn_biz_code" value="">
</form>
<link rel="stylesheet" href="/css/_components.css">
<!-- 본문 -->
<div id="contents" class="sub_page">
	<div class="sub_visual intro">
		<div class="visual_area">
			<h2 style="margin: 0; transform: translate(-50%, -50%);"></h2>
		</div>
	</div>
	<div id="contents">
		<div class="content" style="padding:0px 0 120px;">
			<section>
				<div class="h3_tit_area">
					<h3 class="h3_tit"><img src="/images/intro_list_h3_tit.png" alt="기업홍보관"></h3>
				</div>
				<form id="frm" name="frm" method="get">
				<input type="hidden" id="page" name="page" value="">
				<input type="hidden" id="pageSize" name="pageSize" value="">
				<input type="hidden" id="so1" name="so1" value="">
				<input type="hidden" id="so2" name="so2" value="">
				<input type="hidden" id="so3" name="so3" value="">
				<input type="hidden" id="so4" name="so4" value="">

				<!-- 검색 -->
					<div class="intro_area main">
						<div class="detail_search">
							<dl class="ds duty">
								<dt>산업분류(대분류)</dt>
								<dd>
									<ul>
										<li>
											<label class="checkbox off" for="ds_chk_jc">
												<input type="checkbox" class="chk" id="ds_chk_jc" name="jc1" value="" onclick="fn_chk_jc1(this)">
												<span>전체</span>
											</label>
										</li>
										<%
											For i=0 To UBound(arrListJc1)
										%>
										<li>
											<label class="checkbox off" for="ds_chk_jc_<%=i%>">
												<input type="checkbox" class="chk" id="ds_chk_jc_<%=i%>" name="jc1" value="<%=arrListJc1(i,0)%>" onclick="fn_chk_jc1(this)">
												<span><%=arrListJc1(i,1)%></span>
											</label>
										</li>
										<%
											Next
										%>
									</ul>
								</dd>
							</dl>

							<dl class="ds area">
								<dt>지역분류</dt>
								<dd>
									<ul>
										<%
											For i=0 To UBound(arrListArea1)
												If arrListArea1(i,0) < 20 then
										%>
										<li>
											<label class="checkbox off" for="ds_chk2_01_<%=i%>">
												<input type="checkbox" id="ds_chk2_01_<%=i%>" class="chk" name="ac" value="<%=arrListArea1(i, 0)%>" onclick="fn_chk_area(this);">
													<span><%=arrListArea1(i, 1)%></span>
											</label>
										</li>
										<%
												ElseIf arrListArea1(i,0) = 30 Then		'세종시 코드번호 30
										%>
										<li>
											<label class="checkbox off" for="ds_chk2_01_<%=i%>">
												<input type="checkbox" id="ds_chk2_01_<%=i%>" class="chk" name="ac" value="<%=arrListArea1(i, 0)%>" onclick="fn_chk_area(this);">
													<span><%=arrListArea1(i, 1)%></span>
											</label>
										</li>
										<%
												End if
											Next
										%>
									</ul>
								</dd>
							</dl>
							<div class="search_floatR">
								<input type="text" class="txt" id="kw" name="kw" placeholder="기업명을 입력해 주세요" value="<%=schKeyword%>" style="width:300px;">
								<button type="button" name="button" class="comp_btn org" onclick="fn_search();"><strong>검색</strong></button>
								<button class="comp_btn md navy" onclick="fn_reset();"><span class="incx reload_13_17_fff MR05"></span><span class="intx">초기화</span></button>
							</div>
						</div>
					</div>
				</form>

				<div class="tit">
					<p><em></em></p>
				</div>

				<div class="intro_list">
					<% If IsArray(arrRs) Then %>
					<ul class="hl_ul">
						<%
						For i=0 To UBound(arrRs,2)
							Dim rs_num, rs_idx, rs_com_name, rs_com_subname, rs_logo_url, rs_moddate, rs_regdate, rs_jc1, rs_area1
							rs_num			   = arrRs(0,i)		' 순번
							rs_idx			   = arrRs(1,i)		' idx
							rs_com_name		   = arrRs(2,i)		' 회사명
							rs_com_subname	   = arrRs(3,i)		' 회사세부명
							rs_logo_url		   = arrRs(4,i)		' 로고URL
							rs_moddate		   = arrRs(5,i)		' 수정일
							rs_regdate		   = arrRs(6,i)		' 등록일
							rs_jc1			   = arrRs(7,i)		' 직무
							rs_area1		   = arrRs(8,i)		' 지역
						%>
						<li>
							<a href="./intro_view.asp?idx=<%=rs_idx%>">
								<%If rs_logo_url <> "" then%>
								<img src="/files/intro/<%=rs_logo_url%>" class="hl_logo">
								<%else%>
								<img src="/files/intro/default_logo.png" class="hl_logo">
								<%End if%>
								<div class="hl_name">
									<em><%=rs_com_name%></em>
									<p class="hl_txt"><%=getJobtype(rs_jc1)%></p>
									<span><%=getAcName(rs_area1)%></span>
								</div>
							</a>
						</li>
						<%
						Next
						%>
					</ul>
					<% Call putPage(Page, stropt, totalPage) %>
					<%else%>
					<ul class="hl_ul">
						<li>
							검색 결과가 없습니다.
						</li>
					</ul>

					<% End If %>

				</div>
			</section>
		</div><!-- .content -->
	</div>

	<div class="content">
		<div class="con_box">
			<div class="partner_area">
				<div class="list_area">
					<ul>
						<div id="list1">
							<li>
								<div class="info_box">
									<div class="la_info2">
										<div class="tit">
											<p><a href="#;" onclick=""></a></p>
										</div>
										<dl>
										</dl>
									</div>
								</div>
							</li>
						</div>
					</ul>
				</div><!-- //list_area -->
			</div>
		</div>
	</div><!-- .content -->
</div>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->

</body>
</html>
