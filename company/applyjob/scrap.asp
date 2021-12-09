<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<%
	Call FN_LoginLimit("2")    '���ȸ���� ���ٰ���
%>

<%
	Dim Page, PageSize, OrderNum, JobNum, stropt 
	
	Page		= Request("page")
	PageSize	= 5
	OrderNum	= Request("ordernum")
	JobNum		= Request("jobnum")
	
	If Page = "" Then
		Page = 1
	End If

	If OrderNum = "" Then
		OrderNum = 1
	End If

	If JobNum = "" Then
		JobNum = 0
	End If

	ConnectDB DBCon, Application("DBInfo_FAIR")	

	Dim total, totalPage, result
	ReDim param(12)	
	
	param(0) = makeParam("@Gubun", adVarChar, adParamInput, 1, "1")
	param(1) = makeParam("@BizID", adVarChar, adParamInput, 20, comid)
	param(2) = makeParam("@JobNum", adInteger, adParamInput, 4, JobNum)
	param(3) = makeParam("@ExpCode", adVarChar, adParamInput, 10, "")
	param(4) = makeParam("@School", adVarChar, adParamInput, 10, "")
	param(5) = makeParam("@JobCode", adVarChar, adParamInput, 20, "")
	param(6) = makeParam("@UserName", adVarChar, adParamInput, 20, "")
	param(7) = makeParam("@StartDate", adVarChar, adParamInput, 10, "")
	param(8) = makeParam("@EndDate", adVarChar, adParamInput, 10, "")
	param(9) = makeParam("@OrderNum", adInteger, adParamInput, 4, OrderNum)
	param(10) = makeParam("@Page", adInteger, adParamInput, 4, Page)
	param(11) = makeParam("@PageSize", adInteger, adParamInput, 4, PageSize)
	param(12) = makeParam("@TotalCnt", adInteger, adParamOutput, 1, "0")
	
	result		= arrGetRsSP(DBCon, "USP_BIZSERVICE_SCRAP_RESUME_LIST", param, "", "")
	total		= getParamOutputValue(param, "@TotalCnt")
	
	totalPage	= Fix(((total-1)/PageSize) +1)
	stropt		= ""

	DisconnectDB DBCon

	'Response.write "EXEC USP_BIZSERVICE_SCRAP_RESUME_LIST '1','"&comid&"','"&JobNum &"','','','','','','','"&OrderNum&"','"&Page&"','"&PageSize&"','' " & "<br><br><br>"
%>

<script type="text/javascript">

	$(document).ready(function () {
		//���� class on ����
        var orderNum = <%=OrderNum%>;

        switch (orderNum) {
            case 1 :
				$('#sort_ul > li').eq(0).addClass('on');
				break;
            case 2 :
				$('#sort_ul > li').eq(1).addClass('on');
				break;
            case 4 :
				$('#sort_ul > li').eq(2).addClass('on');
				break;
            case 5 :
				$('#sort_ul > li').eq(3).addClass('on');
				break;
            default :
				$('#sort_ul > li').eq(0).addClass('on');
				break;
        }
	});

	function goListOrder(orderNum) {
        $("#orderNum").val(orderNum);
        $('#frm').submit();
    }

	function fn_del() {
		var chk		= $(".checkbox.on > input[name=rid]");
		var rid		= "";		

		for (i = 0; i < chk.length; i++) {
			rid = (i == 0) ? chk.eq(i).val() : rid + "," + chk.eq(i).val();
		}
        
        if (rid.length == 0) {
            alert("������ ���縦 �����ؾ� �մϴ�.");
            return;
        }

        if (confirm("������ ���縦 ���� �Ͻðڽ��ϱ�?")) {
            $.ajax({
                type: "POST",
                url: "/company/applyjob/scrapDel.asp",
                data: { rid: rid },
                dataType: "html",
                success: function (data) {
                    if (data == "0") {
                        alert("������� ����: �����ڿ��� �����ϼ���.");
                    } else if (data == "1") {
                        alert("��������� �Ϸ�Ǿ����ϴ�.");
                        location.href = location.href;
                    } else {
                        alert("���� ������ ����: �����ڿ��� �����ϼ���. code=" + data);
                    }
                },
                error: function (xhr) {
                    var status = xhr.status;
                    var responseText = xhr.responseText;
                    alert(responseText + '//');
                }
            });
        }
    }
	
	function fn_resume_view(rid, set_user_id) {
		var _frm1 = document.frm1;
		_frm1.rid.value = rid;
		_frm1.set_user_id.value = set_user_id;

		_frm1.action = '/resume/view.asp';
		_frm1.target = "_blank";
		_frm1.submit();
	}

</script>
</head>

<body>
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- ���� -->
<div id="contents" class="sub_page">
	<div class="content glay">
		<div class="con_area">
			<div class="manage_area">
				<div class="view_box">
					<h3>��ũ���� ����</h3>
					<div class="layoutBox">
						<div class="notiArea">
							<ul>
								<li>����ũ���� ������ �̷¼��� ä���� �������θ� Ȱ��Ǹ�, ������ �޼��Ǹ� ��ü ���� �ı�Ǿ�� �մϴ�.</li>
							</ul>
							<p>�� ä���� �ƴ� �����̳� ������ �� ��Ÿ �̿��� �������� ���� ���, <em>������Ÿ��� �� 72�� 3�׿� �ǰ� 5�� ���� ¡�� �Ǵ� 5,000���� ������ ����</em>�� ó���� �� �ֽ��ϴ�.</p>
						</div><!-- .notiArea -->
					</div>

				</div><!-- .view_box -->

				<div class="list_area">
					<div class="tlt_wrap">
						<h3>��ũ���� ����</h3><!-- ��ũ���� ���� -->
						<span class="list_number">����<span class="number"><%=total%></span>���� ��ũ���� ���������� �ֽ��ϴ�.</span>
						<ul class="sort" id="sort_ul">
							<li><a href="javascript:" onclick="goListOrder('1')">��ũ�� ����ϼ�</a></li> <!-- [D]Ŭ���� Ŭ���� on ���� -->
							<li><a href="javascript:" onclick="goListOrder('2')">�̷¼� �����ϼ�</a></li>
							<li><a href="javascript:" onclick="goListOrder('4')">�з¼�</a></li>
							<li><a href="javascript:" onclick="goListOrder('5')">��¼�</a></li>
						</ul>
					</div><!--.titArea-->

					<div class="board_area">
						<table class="tb" summary="��ũ���� ���翡 ���� �̸�/����/����,�̷¼� ����/�������,����� �׸��� ��Ÿ�� ǥ">
							<caption>��ũ���� ����</caption>
							<colgroup>
								<col style="width:310px">
								<col>
								<col style="width:160px">
							</colgroup>
							<thead>
								<tr>
									<th>
										<label class="checkbox off"><input class="chk" id="" name="" type="checkbox" onclick="noncheckallFnc(this, 'chk_list');"></label>
										�̸�/����
									</th>
									<th>�̷¼� ����/�������</th>
									<th>�����</th>
								</tr>
							</thead>
							<tbody>
								<%
									If total > 0 Then
										If isArray(result) Then
											Dim resume_birth_year,resume_age
											Dim tot_sum, totalyear, totmonth, resume_ec, resume_careersum
											Dim str_jc
											Dim workArea, workAreaDetail, jj, str_ac

											For i = 0 to ubound(result, 2)
												If result(5,i) <> "" Then ' �ֹι�ȣ��
													If result(6,i) = "3" Or result(6,i) = "4" Or result(6,i) = "7" Or result(6,i) = "8" Then ' �ֹι�ȣ����
														resume_birth_year = "20" & result(5,i) ' �ֹι�ȣ��
													Else 
														resume_birth_year = "19" & result(5,i) ' �ֹι�ȣ��
													End If
										
													resume_age	= year(date) - resume_birth_year + 1
												End If

												If result(30,i) <> "0" Then ' ��¿���
													resume_ec	= "���" 
													tot_sum		= result(30,i) * 30 ' ��¿���

													If (tot_sum / 30) > 12 Then
														totalyear = Fix((tot_sum / 30) / 12)
														totmonth = Fix((tot_sum / 30) - (totalyear) * 12)
														
														resume_careersum = "<span class='num'>" & totalyear & "</span>�� " & "<span class='num'>" & totmonth & "</span>���� "
													Else
														resume_careersum = Round(tot_sum / 30) & "����"
													End If
												Else
													resume_ec			= "����"
													resume_careersum	=	""
												End If

												str_jc	= Replace(getJobTypeAll(result(32,i)),"/",", ") ' ��������ڵ���ü												
												
												workArea = split(result(33,i), "|") ' �ٹ����������ڵ���ü
												str_ac = ""

												For ii=0 To Ubound(workArea)
													workAreaDetail = split(workArea(ii), "/")

													For jj=0 To Ubound(workAreaDetail)
														If jj = 0 Then
															str_ac = str_ac & get_simple_Ac(getAcName(workAreaDetail(jj)))
														End If
													Next
													
													If ii <> Ubound(workArea)  Then
														str_ac = str_ac & ","
													Else
														str_ac = str_ac & ""
													End If
												Next

												' �ߺ� ���� ����
												Dim workArea_temp, array_temp, m
												workArea_temp = ""

												array_temp = Split(str_ac,",")

												For m = 0 To UBound(array_temp)
													If InStr(workArea_temp,array_temp(m)) = 0 Then
														If m =0 Then
															workArea_temp = array_temp(m)
														Else
															workArea_temp = workArea_temp & ", " & array_temp(m)
														End If
													End If
												Next
								%>
								<tr>
									<td class="t1 tc">
										<label class="checkbox off">
											<input class="chk" id="" name="chk_list" type="checkbox" value="<%=result(1,i)%>"> <!-- ��Ϲ�ȣ -->
											<input type="hidden" name="rid" value="<%=result(1,i)%>" /> <!--��Ϲ�ȣ-->
										</label>
										<div class="photoBox">
											<div class="photo">
												<span class="frame sprite"></span>
												<img src="/files/mypic/<%=result(13,i)%>"> <!-- �������� -->
											</div>
											<div class="photo_info">
												<em class="name"><%=result(4,i)%></em> <!-- ���� -->												
												<p class="birth">(<span class="num"><%=resume_birth_year%></span>���, <span class="num"><%=resume_age%></span>��)</p>
											</div>
										</div>
									</td>
									<td class="t2">
										<div class="txtBox">
											<div class="tit">
												<% If result(25,i) = 1 Then %> <!-- �̷¼����� -->
												<a href="javascript:;" onclick="fn_resume_view('<%=result(1,i)%>', '<%=objEncrypter.Encrypt(result(3,i))%>')"><%=result(12,i)%></a> <!-- ��Ϲ�ȣ, ���ξ��̵�, �̷¼����� -->
												<% Else %>
												<a href="javascript:alert('������� ��ȯ�� �����Դϴ�.');"><%=result(12,i)%></a> <!-- �̷¼����� -->
												<% End If %>
											</div>
											<div>
												<dl>
													<dt>��³�� :</dt>
													<dd><%=resume_ec%>&nbsp;<%=resume_careersum%></dd>
												</dl>
												<dl>
													<dt>������� :</dt>
													<dd><%=str_jc%></dd>
												</dl>
												<dl>
													<dt>�����з� :</dt>
													<dd>
													<%
														dbCon.Open Application("DBInfo_FAIR")
														
														Dim strSql, resume_school, resume_school2, Major
														strSql = "SELECT �б���, ������ FROM �̷¼��з� WHERE ��Ϲ�ȣ = " & result(1,i) ' ��Ϲ�ȣ

														If result(22,i) <> "" Then ' �����з��ڵ�
															strSql = strSql & " AND �з����� = " & result(22,i) ' �����з��ڵ�

															Select Case result(22,i) ' �����з��ڵ�
																Case 4
																	resume_school2 = "(2,3����)"
																Case 5
																	resume_school2 = "(4����)"
																Case Else
																	resume_school2 = ""
															End Select
														Else
															strSql			= strSql & " AND ������ȣ = 1"
															resume_school2	= ""
														End If
														
														Rs.Open strSql, dbCon, 0, 1
														
														If (Rs.BOF=False And Rs.EOF=False) Then
															resume_school	= Rs.Fields(0).Value															
															Major			= Rs.Fields(1).Value
														Else
															resume_school	= ""
															Major			= ""
														End If

														Response.write resume_school & resume_school2 & " " & Major

														Rs.Close
														dbCon.Close
													%>
													</dd>
												</dl>
												<dl>
													<dt>������� :</dt>
													<dd><%=workArea_temp%></dd>
												</dl>
											</div>
										</div><!--.txtBox-->
									</td>
									<td class="t3 tc">
										<span class="num"><%=Replace(result(2,i),"/","-")%></span> <!-- ����� -->
									</td>
								</tr>
								<%		
											Next
										End If
									Else
								%>
								<tr>
									<td class="no_date" colspan="3">
										<div class="none_list">
											�����Ͱ� �����ϴ�.
										</div>
									</td>
								</tr>
								<%
									End If
								%>								
							</tbody>
						</table>
					</div>
				</div><!--/list_area -->
				<div class="option_btn">
					<button type="button" onclick="fn_del();">�����׸� ����</button>
				</div>

				<!--����¡-->
				<% Call putPage(Page, stropt, totalPage) %>	
			</div><!-- .manage_area -->
		</div><!-- .con_area -->
	</div><!-- .content -->
</div>
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

<form method="post" id="frm" name="frm" action="">
    <input type="hidden" id="page" name="page" value="" />
    <input type="hidden" id="orderNum" name="orderNum" value="" />
    <input type="hidden" id="delRids" name="delRids" value="" />
</form>

<form id="frm1" name="frm1" method="post">
	<input type="hidden" id="rid" name="rid" value="">
	<input type="hidden" id="set_user_id" name="set_user_id" value="">
</form>

</body>
</html>

<OBJECT RUNAT="SERVER" PROGID="ADODB.Connection" ID="dbCon"></OBJECT>
<OBJECT RUNAT="SERVER" PROGID="ADODB.RecordSet" ID="Rs"></OBJECT>