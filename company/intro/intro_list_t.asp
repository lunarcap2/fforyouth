<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<%

Dim target		: target		= Request("target")		' �˻�����(����:1, ����:2)
Dim schKeyword	: schKeyword	= Request("kw") ' �˻���(����/����)
Dim page		: page			= Request("page")
Dim jc1			: jc1			= Request("jc1")		' ����
Dim ac			: ac			= Request("ac")		' ����
Dim pageSize	: pageSize		= 20

If page = "" Then page = 1
If jc1 = "" Then jc1 = ""
If ac = "" Then ac = ""
page = CInt(page)

'�����ڵ� xml
Dim arrListArea1 '1��
arrListArea1 = getAreaList1() '/wwwconf/code/code_function_ac.asp

Dim arrListArea2 '2��
arrListArea2 = getArrJcList("1")

'�����ڵ� xml
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
	//���� �˻�
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

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<form method="post" id="frm_view" name="frm_view" action="">
	<input type="hidden" id="hdn_biz_code" name="hdn_biz_code" value="">
</form>
<link rel="stylesheet" href="/css/_components.css">
<!-- ���� -->
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
					<h3 class="h3_tit"><img src="/images/intro_list_h3_tit.png" alt="���ȫ����"></h3>
				</div>
				<form id="frm" name="frm" method="get">
				<input type="hidden" id="page" name="page" value="">
				<input type="hidden" id="pageSize" name="pageSize" value="">
				<input type="hidden" id="so1" name="so1" value="">
				<input type="hidden" id="so2" name="so2" value="">
				<input type="hidden" id="so3" name="so3" value="">
				<input type="hidden" id="so4" name="so4" value="">

				<!-- �˻� -->
					<div class="intro_area main">
						<div class="detail_search">
							<dl class="ds duty">
								<dt>����з�(��з�)</dt>
								<dd>
									<ul>
										<li>
											<label class="checkbox off" for="ds_chk_jc">
												<input type="checkbox" class="chk" id="ds_chk_jc" name="jc1" value="" onclick="fn_chk_jc1(this)">
												<span>��ü</span>
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
								<dt>�����з�</dt>
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
												ElseIf arrListArea1(i,0) = 30 Then		'������ �ڵ��ȣ 30
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
								<input type="text" class="txt" id="kw" name="kw" placeholder="������� �Է��� �ּ���" value="<%=schKeyword%>" style="width:300px;">
								<button type="button" name="button" class="comp_btn org" onclick="fn_search();"><strong>�˻�</strong></button>
								<button class="comp_btn md navy" onclick="fn_reset();"><span class="incx reload_13_17_fff MR05"></span><span class="intx">�ʱ�ȭ</span></button>
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
							rs_num			   = arrRs(0,i)		' ����
							rs_idx			   = arrRs(1,i)		' idx
							rs_com_name		   = arrRs(2,i)		' ȸ���
							rs_com_subname	   = arrRs(3,i)		' ȸ�缼�θ�
							rs_logo_url		   = arrRs(4,i)		' �ΰ�URL
							rs_moddate		   = arrRs(5,i)		' ������
							rs_regdate		   = arrRs(6,i)		' �����
							rs_jc1			   = arrRs(7,i)		' ����
							rs_area1		   = arrRs(8,i)		' ����
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
							�˻� ����� �����ϴ�.
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
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->

</body>
</html>
