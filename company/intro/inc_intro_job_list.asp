<%
Function getListInfo_foryouth(DBcon)

Dim getListInfoParam(64)

'	Response.write "EXEC ä������_�󼼰˻�_����Ʈ_V2 '"&sqlgb1&"','"&sqlgb2&"','"&schkind1 &"','"&schkind2 &"','"& jc &"','"&jc2&"','"&ac &"','"&ac2&"','"&ck&"','"&wc&"','"&kw&"','"&sc&"','"&ec&"','"&ec1&"','"&ec2&"','"&sa&"','"&st&"','"&sx&"','"&wf&"','"&sb&"','"&sw_a&"','"&sw_l&"','"&la_1&"','"&la&"','"&la_tx&"','"&ct&"','"&cf&"','"&so1&"','"&so2&"','"&so3&"','"&so4&"','"&so_dasc&"','"&listType&"','"&isTopPost&"','"&Staff&"','"&classlevel&"','"&duty&"','"&special&"','"&age&"','"&noage&"','"&majorcode&"','"&pcuse&"','"&commonsp&"','"&s_date1&"','"&s_date2&"','"&edate&"','" & jobstorychk1 & "','" & jobstorychk2 & "','" & jobstorychk3 & "','" & jobstorychk4 & "', '"&comiso1&"','"&comiso2&"','"&comiso3&"','"&comiso4&"', '"& bc &"', '"& bc2 &"', '"&WorkDay &"', '"&page&"','"&PageSize&"','','','"& jobs_gubun &"', '"& jc1 &"', '"& jobs_gubun2 &"','"& rs_com_id &"' "
'	response.end

	getListInfoParam(0) =  makeparam("@sqldb1",adVarChar,adParamInput,30,sqlgb1)
	getListInfoParam(1) = makeparam("@sqldb2",adVarChar,adParamInput,30,sqlgb2)
	getListInfoParam(2) = makeparam("@schkind1",adVarChar,adParamInput,1,schkind1)
	getListInfoParam(3) = makeparam("@schkind2",adVarChar,adParamInput,1,schkind2)
	getListInfoParam(4) = makeparam("@jc",adVarChar,adParamInput,1000,jc)
	getListInfoParam(5) = makeparam("@jc2",adVarChar,adParamInput,1000,jc2)
	getListInfoParam(6) = makeparam("@ac",adVarChar,adParamInput,180,ac)
	getListInfoParam(7) = makeparam("@ac2",adVarChar,adParamInput,200,ac2)
	getListInfoParam(8) = makeparam("@ck",adVarChar,adParamInput,40,ck)
	getListInfoParam(9) = makeparam("@wc",adVarChar,adParamInput,50,wc)
	getListInfoParam(10) = makeparam("@kw",adVarChar,adParamInput,100,kw)
	getListInfoParam(11) = makeparam("@sc",adVarChar,adParamInput,30,sc)
	getListInfoParam(12) = makeparam("@ec",adVarChar,adParamInput,10, ec)
	getListInfoParam(13) = makeparam("@ec1",adVarChar,adParamInput,4,ec1)
	getListInfoParam(14) = makeparam("@ec2",adVarChar,adParamInput,4,ec2)
	getListInfoParam(15) = makeparam("@sa",adVarChar,adParamInput,250,sa)
	getListInfoParam(16) = makeparam("@st",adVarChar,adParamInput,10,st)
	getListInfoParam(17) = makeparam("@sx",adVarChar,adParamInput,10,sx)
	getListInfoParam(18) = makeparam("@wf",adVarChar,adParamInput,600,wf)
	getListInfoParam(19) = makeparam("@sb",adVarChar,adParamInput,100, sb)
	getListInfoParam(20) = makeparam("@sw_a",adChar,adParamInput,2,sw_a)
	getListInfoParam(21) = makeparam("@sw_l",adChar,adParamInput,2,sw_l)
	getListInfoParam(22) = makeparam("@la_1",adVarChar,adParamInput,40,la_1)
	getListInfoParam(23) = makeparam("@la",adVarChar,adParamInput,2,la)
	getListInfoParam(24) = makeparam("@la_tx",adVarChar,adParamInput,4,la_tx)
	getListInfoParam(25) = makeparam("@ct",adVarChar,adParamInput,4,ct)
	getListInfoParam(26) = makeparam("@cf",adVarChar,adParamInput,25,cf)
	getListInfoParam(27) = makeparam("@so1",advarChar,adParamInput,1,so1)
	getListInfoParam(28) = makeparam("@so2",advarChar,adParamInput,1,so2)
	getListInfoParam(29) = makeparam("@so3",advarChar,adParamInput,1,so3)
	getListInfoParam(30) = makeparam("@so4",advarChar,adParamInput,1,so4)
	getListInfoParam(31) = makeparam("@so_dasc",adChar,adParamInput,4,so_dasc)
	getListInfoParam(32) = makeparam("@listType",adChar,adParamInput,1,listType)
	getListInfoParam(33) = makeparam("@isTopPost",adChar,adParamInput,1,isTopPost)
	getListInfoParam(34) = makeparam("@Staff",adChar,adParamInput,1,Staff)
	getListInfoParam(35) = makeparam("@classlevel",advarChar,adParamInput,30,classlevel)
	getListInfoParam(36) = makeparam("@duty",advarChar,adParamInput,30,duty)
	getListInfoParam(37) = makeparam("@special",advarChar,adParamInput,100,special)
	getListInfoParam(38) = makeparam("@age",advarchar,adParamInput,4,age)
	getListInfoParam(39) = makeparam("@noage",advarchar,adParamInput,1,noage)
	getListInfoParam(40) = makeparam("@majorcode",advarchar,adParamInput,100,majorcode)
	getListInfoParam(41) = makeparam("@pcuse",advarchar,adParamInput,100,pcuse)
	getListInfoParam(42) = makeparam("@commonsp",advarchar,adParamInput,100,commonsp)
	getListInfoParam(43) = makeparam("@sdate1",adChar,adParamInput,10,s_date1)
	getListInfoParam(44) = makeparam("@sdate2",adChar,adParamInput,10,s_date2)
	getListInfoParam(45) = makeparam("@edate",adChar,adParamInput,10,edate)
	getListInfoParam(46) = makeparam("@jobstorychk1",adChar,adParamInput,1,jobstorychk1)
	getListInfoParam(47) = makeparam("@jobstorychk2",adChar,adParamInput,1,jobstorychk2)
	getListInfoParam(48) = makeparam("@jobstorychk3",adChar,adParamInput,1,jobstorychk3)
	getListInfoParam(49) = makeparam("@jobstorychk4",adChar,adParamInput,1,jobstorychk4)
	getListInfoParam(50) = makeparam("@comiso1",adChar,adParamInput,1,comiso1)
	getListInfoParam(51) = makeparam("@comiso2",adChar,adParamInput,1,comiso2)
	getListInfoParam(52) = makeparam("@comiso3",adChar,adParamInput,1,comiso3)
	getListInfoParam(53) = makeparam("@comiso4",adChar,adParamInput,1,comiso4)

	getListInfoParam(54) = makeparam("@bc",adChar,adParamInput,100,bc)
	getListInfoParam(55) = makeparam("@bc2",adChar,adParamInput,100,bc2)
	getListInfoParam(56) = makeparam("@wkcode",adChar,adParamInput,100,WorkDay)

	getListInfoParam(57) = makeparam("@NowPage",adInteger,adParamInput,4,page)
	getListInfoParam(58) = makeparam("@PageSize",adInteger,adParamInput,4,pagesize)
	getListInfoParam(59) = makeparam("@TotalCnt",adInteger,adParamOutput,4,"")
	getListInfoParam(60) = makeparam("@TotalPage",adInteger,adParamOutput,4,"")

	getListInfoParam(61) = makeparam("@gubun",advarchar,adParamInput,2,jobs_gubun) 'ä������� �ű� 2020-10-08
	getListInfoParam(62) = makeparam("@jc1",advarchar,adParamInput,100,jc1) '�����ڵ� 1�� �ű� 2020-10-19
	getListInfoParam(63) = makeparam("@gubun2",advarchar,adParamInput,100,jobs_gubun2) '2020-11-05 2�� ä�������-�����п����� ��� (1: ������ ��ȹ��/ 2: ������Ȱ���/ 3: ��Ϲ� ����ȭ��/ 4: ��Ÿ��)
	getListInfoParam(64) = makeparam("@BIZ_ID",advarchar,adParamInput,20,rs_com_id)

	Dim List(3)
	List(2) = arrGetRsSP(DBCon,"ä������_�󼼰˻�_����Ʈ_V2",getListInfoParam,"","")
	List(0) = getParamOutputValue(getListInfoParam,"@TotalCnt")
	List(1) = getParamOutputValue(getListInfoParam,"@TotalPage")
	List(3) = sort
	getListInfo_foryouth = List

End Function

%>
				<%
				If isArray(ArrRs) Then
				%>
				<div class="caRowBox">
					<div class="cpITit MT70">
						<span class="ims"><img src="/images/imgtxt/imgtxt0005.png" alt="����ä��"></span>
						<span class="oth">(<%=Tcnt%>��)</span>
					</div>
					<div class="cpGlbRecLst">
						<%
						For i = 0 To UBound(ArrRs, 2)
						Dim rs_id_num, rs_company_id, rs_company_name, rs_company_name_code, rs_subject, rs_sex_code, rs_school_code, rs_career_code, rs_apply_start_date, rs_view_count, rs_apply_selected, rs_apply_end, rs_apply_end_date, rs_area_code, rs_career_month, rs_career_over, rs_jc_code, rs_item_option, rs_site_gubun, rs_ipo, rs_company_kind, rs_item_option2, rs_tct_flag, rs_position_group, rs_position_title, rs_workplace, rs_modify_date, rs_runmber, rs_register_gubun, rs_school_over, rs_work_type, rs_salary_code, rs_subway_code, rs_biz_code, rs_applyUrl, rs_salary_text

							rs_id_num				= ArrRs(0, i)	'��Ϲ�ȣ
							rs_company_id			= ArrRs(1, i)	'ȸ����̵�
							rs_company_name			= ArrRs(2, i)	'ȸ���
							rs_company_name_code	= ArrRs(3, i)	'ȸ���1
							rs_subject				= ArrRs(4, i)	'������������
							rs_sex_code				= ArrRs(5, i)	'����
							rs_school_code			= ArrRs(6, i)	'�з��ڵ�
							rs_career_code			= ArrRs(7, i)	'����ڵ�
							rs_apply_start_date		= ArrRs(8, i)	'(null)����������
							rs_view_count			= ArrRs(9, i)	'��ȸ��
							rs_apply_selected		= ArrRs(10, i)	'�������
							rs_apply_selected = split(rs_apply_selected, ",")
							rs_apply_end			= ArrRs(11, i)	'������������
							rs_apply_end_date		= ArrRs(12, i)	'(null)����������
							rs_area_code			= ArrRs(13, i)	'�����ڵ�
							rs_career_month			= ArrRs(14, i)	'��¿���
							rs_career_over			= ArrRs(15, i)	'������Ѽ�
							rs_jc_code				= ArrRs(16, i)	'�����ڵ�
							rs_item_option			= ArrRs(17, i)	'�����ۿɼ�
							rs_site_gubun			= ArrRs(18, i)	'����Ʈ����
							rs_ipo					= ArrRs(19, i)	'���忩��
							'rs_?					= ArrRs(20, i)	'�����ڷῩ��
							rs_company_kind			= ArrRs(21, i)	'�����ڵ�
							rs_item_option2			= ArrRs(22, i)	'�����ۿɼ�2
							rs_tct_flag				= ArrRs(23, i)	'���ñٹ�����
							rs_position_group		= ArrRs(24, i)	'����
							rs_position_title		= ArrRs(25, i)	'��å
							rs_workplace			= ArrRs(26, i)	'�ٹ��μ�
							'rs_?					= ArrRs(27, i)	'ȸ�������
							'rs_?					= ArrRs(28, i)	'������
							'rs_?					= ArrRs(29, i)	'����Ŀ����
							rs_modify_date			= ArrRs(30, i)	'������
							rs_runmber				= ArrRs(31, i)	'�����ο�
							rs_register_gubun		= ArrRs(32, i)	'��ϼ���
							rs_school_over			= ArrRs(33, i)	'�з��̻�
							rs_work_type			= ArrRs(34, i)	'(null)�ٹ�����
							'rs_?					= ArrRs(35, i)	'�λ��
							'rs_?					= ArrRs(36, i)	'��۴�
							'rs_?					= ArrRs(37, i)	'(null)��亯
							'rs_?					= ArrRs(38, i)	'(null)��亯
							rs_salary_code			= ArrRs(39, i)	'�����ڵ�
							'rs_?					= ArrRs(40, i)	'����è�Ǿ𿩺�
							'rs_?					= ArrRs(41, i)	'WORK_TP_ICD
							rs_subway_code			= ArrRs(42, i)	'����ö�ڵ�
							rs_biz_code				= ArrRs(43, i)	'����ڹ�ȣ
							rs_applyUrl				= ArrRs(44, i)	'����Ʈ����URL
							'rs_?					= ArrRs(45, i)	'�޿���Ÿ
							rs_salary_text			= ArrRs(46, i)	'���������Է�

							ConnectDB DBCon, Application("DBInfo_FAIR")
							'ä������ 2��
							arrRsArea = arrGetRsSql(DBCon, "SELECT TOP 1 ���������ڵ�, �����ڵ� FROM ä������2 WITH(NOLOCK) WHERE ��Ϲ�ȣ = "& rs_id_num &" ORDER BY ������ȣ", "", "")

							DisconnectDB DBCon
						%>
						
						<div class="lstp">
							<div class="insArea">
								<div class="itxts">
									<a href="#" class="itit"><%=rs_subject%></a>
									<div class="istGrp">
										<span class="ists"><%=getExp(rs_career_code)%></span>
										<span class="ists"><%=getSchool3(rs_school_code)%></span>
										<% If isArray(arrRsArea) Then %>
											<span class="ists">
												<% For ii=0 To UBound(arrRsArea, 2) %>
												<%=getAcName(arrRsArea(0, ii))%> &gt;
												<%=getAcName(arrRsArea(1, ii))%>
												<% Next %>
											</span>
										<% End If %>
									</div>
									<div class="btnsGrp">
										<%
										Dim str_end_date
										Select Case rs_apply_end
											Case "1" : str_end_date = Right(rs_apply_end_date, 5) & "(" & weekday_txt(weekDay(rs_apply_end_date)) & ")"
											Case "2" : str_end_date = "ä��� ����"
											Case "3" : str_end_date = "���ä��"
										End Select
										%>
										<span class="bgins"><%=str_end_date%></span>
										<button class="comp_btn org" onclick="javascript:location.href='/jobs/view.asp?id_num=<%=rs_id_num%>'">������</button>
									</div>
								</div>
							</div>
						</div>
						<%
						next
						%>
					</div>
				</div>
				<%End if%>
						