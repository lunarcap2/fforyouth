<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ct.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<!--#include virtual = "/inc/function/com_function.asp"-->

<%

Dim idx : idx = request("idx")
Dim page : page = 1
Dim PageSize : PageSize = 10

'�����ڵ� xml
'�����ڵ� xml
Dim arrListArea1 '1��
arrListArea1 = getAreaList1() '/wwwconf/code/code_function_ac.asp

Dim arrListArea2 '2��
arrListArea2 = getArrJcList("1")

'�����ڵ� xml
Dim arrListJc1
arrListJc1 = getArrJcList1() '/wwwconf/code/code_function_jc.asp

'��������ڵ�
Dim arrListScale
arrListScale = FN_arrCode_C2002() '/inc/function/code_function.asp

Dim ArrRs
If idx <> "" then
	ConnectDB DBCon, Application("DBInfo_FAIR")

	ReDim Param(1)
	Param(0) = makeparam("@IDX",adInteger,adParamInput,4,idx)
	Param(1) = makeparam("@TYPE",adChar,adParamInput,1,"u")
	ArrRs = arrGetRsSP(DBcon,"usp_company_intro_view",Param,"","")

	Dim ArrRsIntro,ArrTalentList,ArrProcessList
	ArrRsIntro			= ArrRs(0)
	ArrTalentList		= ArrRs(1)
	ArrProcessList		= ArrRs(2)

	Dim rs_num, rs_idx, rs_com_name, rs_com_subname, rs_logo_url, rs_jc1, rs_area1, rs_area2
	Dim rs_regcode, rs_est_date, rs_sales, rs_workforce, rs_scale, rs_address, rs_intro_video
	Dim rs_welfare, rs_talent, rs_process, rs_period, rs_salary, rs_moddate, rs_regdate
	Dim rs_etc1, rs_etc2, rs_etc3, rs_etc4, rs_etc5, rs_com_id, rs_new_salary

	rs_num			   = ArrRsIntro(0,i)		' ����
	rs_idx			   = ArrRsIntro(1,i)		' idx
	rs_com_name		   = ArrRsIntro(2,i)		' ȸ���
	rs_com_subname	   = ArrRsIntro(3,i)		' ȸ�缼�θ�
	rs_logo_url		   = ArrRsIntro(4,i)		' �ΰ�URL
	rs_jc1			   = ArrRsIntro(5,i)		' ����
	rs_area1		   = ArrRsIntro(6,i)		' ����1
	rs_area2		   = ArrRsIntro(7,i)		' ����2
	rs_regcode		   = ArrRsIntro(8,i)		' ����ڵ�Ϲ�ȣ
	rs_est_date		   = ArrRsIntro(9,i)		' ������
	rs_sales		   = ArrRsIntro(10,i)		' �����
	rs_workforce	   = ArrRsIntro(11,i)		' �����
	rs_scale		   = ArrRsIntro(12,i)		' �������
	rs_address		   = ArrRsIntro(13,i)		' ������
	rs_intro_video	   = ArrRsIntro(14,i)		' �Ұ�����
	rs_welfare		   = ArrRsIntro(15,i)		' �����Ļ�
	rs_talent		   = ArrRsIntro(16,i)		' �����
	rs_process		   = ArrRsIntro(17,i)		' ä����������
	rs_period		   = ArrRsIntro(18,i)		' ä��ñ�
	rs_salary		   = ArrRsIntro(19,i)		' ��տ���
	rs_moddate		   = ArrRsIntro(20,i)		' ������
	rs_regdate		   = ArrRsIntro(21,i)		' �����
	rs_etc1			   = ArrRsIntro(22,i)		' etc1
	rs_etc2			   = ArrRsIntro(23,i)		' etc2
	rs_etc3			   = ArrRsIntro(24,i)		' etc3
	rs_etc4			   = ArrRsIntro(25,i)		' etc4
	rs_etc5			   = ArrRsIntro(26,i)		' etc5
	rs_com_id		   = ArrRsIntro(27,i)		' ȸ����̵�
	rs_new_salary	   = ArrRsIntro(28,i)		' ���Կ���

	ArrRs1 = getListInfo_foryouth(DBcon)

	Tcnt = ArrRs1(0)
	pageCount = ArrRs1(1)
	ArrRs = ArrRs1(2)
	totalpage = pageCount



	DisconnectDB DBCon
Else

	Response.Write "<script language=javascript>"&_
		"alert('���������� �ùٸ��� �ʽ��ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
	response.End
End If
%>
<script type="text/javascript">

</script>
</head>

<body>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<link rel="stylesheet" href="/css/_components.css">
<link rel="stylesheet" href="/css/cpViewArea.css">

<!-- ���� -->
<div id="contents" class="sub_page">
	<div class="sub_visual intro">
		<div class="visual_area">
			<h2 style="margin: 0; transform: translate(-50%, -50%);"></h2>
		</div>
	</div>
		<div class="content">
			<section>
				<!-- ���ȫ���� : S -->
				<div class="cpViewArea">

					<div class="comp_pagetitle MT45">
						<!-- �̹����϶�:S -->
						<div class="cp_imgt">
							<img src="/images/imgtxt/imgtxt0004.png" alt="���ȫ����">
						</div>
						<!-- �̹����϶�:E -->
						<div class="cp_rts">
							<!-- ���������:S -->
							<div class="comp_pagepath">
								<div class="cp_plst">
									<!-- foreach:S -->
									<div class="cp_ptp">
										<span class="tx">Ȩ</span>
									</div>
									<div class="cp_ptp">
										<span class="tx">���ȫ��</span>
									</div>
									<div class="cp_ptp">
										<span class="tx">���ȫ����</span>
									</div>
									<!-- foreach:E -->
								</div>
							</div>
							<!-- ���������:E -->
						</div>
					</div>
					<!-- �������:S -->
					<div class="cpViInfoArea">
						<div class="inner">
							<div class="lts">
								<div class="lgBox">
									<span class="log">
										<%If rs_logo_url <> "" then%>
										<img src="/files/intro/<%=rs_logo_url%>" alt="">
										<%else%>
										<img src="/files/intro/default_logo.png" alt="">
										<%End if%>
									</span>
									<div class="tx"><%=rs_com_name%></div>
								</div>
							</div>
							<div class="rts">
								<div class="lgGid">
									<!-- foerach:S -->
									<%
									If rs_est_date <> "" Then
										Dim career_est_date
										career_est_date = Year(Date())-Left(rs_est_date,4) + 1
									%>
									<div class="tp tp1">
										<div class="inn">
											<div class="ttit">����<%=career_est_date%>����</div>
											<div class="sttit"><%=TransDatetype(rs_est_date,"YYYY�� MM�� DD��")%> ����</div>
										</div>
									</div>
									<%
									End If
									%>
									<%If rs_scale <> "0" then%>
									<div class="tp tp2">
										<div class="inn">
											<div class="ttit"><%=arrListScale(1,rs_scale)%></div>
											<div class="sttit">�������</div>
										</div>
									</div>
									<%End if%>
									<%If rs_workforce <> "" then%>
									<div class="tp tp3">
										<div class="inn">
											<div class="ttit"><%=rs_workforce%>��</div>
											<div class="sttit">�����</div>
										</div>
									</div>
									<%End if%>
									<%If rs_sales <> "" then%>
									<div class="tp tp4">
										<div class="inn">
											<div class="ttit"><%=rs_sales%></div>
											<div class="sttit">����� (2020��)</div>
										</div>
									</div>
									<%End if%>
									<%If rs_address <> "" then%>
									<div class="tp tp5">
										<div class="inn">
											<div class="ttit"><%=rs_address%></div>
											<div class="sttit">������</div>
										</div>
									</div>
									<%End if%>
									<!-- foerach:E -->
								</div>
							</div>
						</div>
					</div>
					<!-- �������:E -->

					<!-- ���ȫ���� ������:S -->
					<div class="cpViContArea">
						<!-- ����ä��:S -->
						<!--#include virtual = "/company/intro/inc_intro_job_list.asp"-->
						<!-- ����ä��:E -->
						<!-- ȫ������:S -->
						<%If rs_intro_video <> "" then%>
						<div class="caRowBox">
							<div class="cpITit bordernone MT70">
								<span class="ims"><img src="/images/imgtxt/imgtxt0006.png" alt="ȫ������"></span>
							</div>
							<div class="cpGlbVideo">

								<iframe width="100%" height="100%" src="https://www.youtube.com/embed/<%=rs_intro_video%>" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
							</div>
						</div>
						<%End if%>
						<!-- ȫ������:E -->
						<!-- �����Ļ�:S -->
						<%If rs_welfare <> "" then%>
						<div class="caRowBox">
							<div class="cpITit MT70">
								<span class="ims"><img src="/images/imgtxt/imgtxt0007.png" alt="�����Ļ�"></span>
							</div>
							<div class="cpGlbLabGrp MT20">
								<!-- foreach:S -->
								<%
								Dim arr_rs_welfare
								arr_rs_welfare = Split(rs_welfare,",")
									For i=0 To UBound(arr_rs_welfare)
								%>
									<div class="cpglbs"><%=getWelfare(Trim(arr_rs_welfare(i)))%></div>
								<%
									next
								%>
								<!-- foreach:E -->
							</div>
						</div>
						<%End if%>
						<!-- �����Ļ�:E -->
						<!-- ��������:S -->
						<%If IsArray(ArrTalentList) then%>
							<%If ArrTalentList(1,0) <> "" then%>
							<div class="caRowBox">
								<div class="cpITit MT70">
									<span class="ims"><img src="/images/imgtxt/imgtxt0008.png" alt="��������"></span>
								</div>
								<!-- foreach:S -->
								<div class="cpGlbLabGrp tp2 MT20">
								<%
								For i=0 To UBound(ArrTalentList,2)
									Dim rs_talents_idx, rs_talents
									rs_talents_idx	= ArrTalentList(0,i)
									rs_talents		= ArrTalentList(1,i)
								%>
									<div class="cpglbs"><%=rs_talents%></div>
								<%
								Next
								%>
								</div>
								<!-- foreach:E -->
							</div>
							<%End if%>
						<%End if%>
						<!-- ��������:E -->
						<!-- ��������:S -->
						<%If IsArray(ArrProcessList) then%>
							<%If ArrProcessList(1,0) <> "" then%>
							<div class="caRowBox">
								<div class="cpITit MT70">
									<span class="ims"><img src="/images/imgtxt/imgtxt0010.png" alt="��������"></span>
								</div>
								<div class="cpGlbRecStp MT20">
									<!-- foreach:S -->
									<%
									For i=0 To UBound(ArrProcessList,2)
										Dim rs_processes_idx, rs_processes
										rs_processes_idx	= ArrProcessList(0,i)
										rs_processes		= ArrProcessList(1,i)
									%>
									<div class="cpgRst">
										<div class="inbws"><%=rs_processes%></div>
									</div>
									<%
									Next
									%>
									<!-- foreach:E -->
								</div>
							</div>
							<%End if%>
						<%End if%>
						<!-- ��������:E -->
						<!-- ä��ñ�:S -->
						<%If rs_period <> "" then%>
						<div class="caRowBox">
							<div class="cpITit MT70">
								<span class="ims"><img src="/images/imgtxt/imgtxt0009.png" alt="ä��ñ�"></span>
							</div>
							<div class="cpGlbLabGrp tp3 MT20">
								<!-- foreach:S -->
								<%
								Dim arr_rs_period
								arr_rs_period = Split(rs_period,",")
								If IsArray(arr_rs_period) Then
									For i=0 To UBound(arr_rs_period)
								%>
								<div class="cpglbs"><%=arr_rs_period(i)%></div>
								<%
									next
								End If
								%>
								<!-- foreach:E -->
							</div>
						</div>
						<%End if%>
						<!-- ä��ñ�:E -->
						<!-- ��տ���:S -->
						<%If rs_new_salary <> "" Or rs_salary <> "" then%>
						<div class="caRowBox">
							<div class="cpITit bordernone MT70">
								<span class="ims"><img src="/images/imgtxt/imgtxt0011.png" alt="��տ���"></span>
							</div>
							<div class="cpGlbPyGrp ">
								<%If rs_new_salary <> "" then%>
								<div class="cols5">
									<span class="clanb">���Կ��� :</span>
									<span class="tlanb"><%=rs_new_salary%> <span class="sm">����</span></span>
								</div>
								<%End if%>
								<%If rs_salary <> "" then%>
								<div class="cols5">
									<span class="clanb">��տ��� :</span>
									<span class="tlanb"><%=rs_salary%> <span class="sm">����</span></span>
								</div>
								<%End if%>
							</div>
						</div>
						<%End if%>
						<!-- ��տ���:E -->
						<!-- �λ����� Q&A:S -->
						<%If rs_etc1 <> "" Or rs_etc2 <> "" Or rs_etc3 <> "" then%>
						<div class="caRowBox">
							<div class="cpITit  MT70">
								<span class="ims"><img src="/images/imgtxt/imgtxt0012.png" alt="�λ����� Q&A"></span>
							</div>
							<div class="cpGlbQALst ">
								<!-- foreach:S -->
								<%If rs_etc1 <> "" then%>
								<div class="lstp">
									<div class="cpQrow">
										[ä�� ��] � ������ ���� �߿��ϰ� �����ϽǱ��?
									</div>
									<div class="cpArow">
										<%=rs_etc1%>
									</div>
								</div>
								<%End if%>
								<%If rs_etc2 <> "" then%>
								<div class="lstp">
									<div class="cpQrow">
										[ȸ�� �Ұ� ����] �츮 ȸ���� ���� ū �ڶ� �Ÿ� �� 1������ �Ұ��� �ּ���. (EX. ����, �系��ȭ ��)
									</div>
									<div class="cpArow">
										<%=rs_etc2%>
									</div>
								</div>
								<%End if%>
								<%If rs_etc3 <> "" then%>
								<div class="lstp">
									<div class="cpQrow">
										[������ �Ѹ���] ����������, �������μ� ���ػ����� ���ְ� ���� ���� �Ѹ��� ��Ź�帳�ϴ�.
									</div>
									<div class="cpArow">
										<%=rs_etc3%>
									</div>
								</div>
								<%End if%>
								<!-- foreach:E -->
							</div>
						</div>
						<%End if%>
						<!-- �λ����� Q&A:E -->

					</div>
					<!-- ���ȫ���� ������:E -->


				</div>
				<!-- ���ȫ���� : E -->
			</section>
		</div><!-- .content -->
</div>
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->

</body>
</html>
