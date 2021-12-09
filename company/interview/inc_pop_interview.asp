<%
	Dim disYY : disYY = Year(now)
	Dim disMM : disMM = Month(now)

	ConnectDB DBCon, Application("DBInfo_FAIR")

	Dim arrRsPopInterview
	ReDim param(12)

	param(0)  = makeParam("@MODE",				adVarchar, adParamInput, 20, mode)
	param(1)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, jid)
	param(2)  = makeParam("@PID",				adVarchar, adParamInput, 1, "3")
	param(3)  = makeParam("@INTERVIEW_N",		adVarchar, adParamInput, 1, "")
	param(4)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, "")
	param(5)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, "")
	param(6)  = makeParam("@INTERVIEW_RESULT",	adVarchar, adParamInput, 1, "")
	param(7)  = makeParam("@CONFIRM_YN",		adVarchar, adParamInput, 1, "")
	param(8)  = makeParam("@KW",				adVarchar, adParamInput, 100, "")
	param(9)  = makeParam("@JOB_PART",			adInteger, adParamInput, 4, "")
	param(10) = makeParam("@PAGE",				adInteger, adParamInput, 4, 1)
	param(11) = makeParam("@PAGE_SIZE",			adInteger, adParamInput, 4, 1000)
	param(12) = makeParam("@TOTAL_CNT",			adInteger, adParamOutput, 4, 0)

	arrRsPopInterview = arrGetRsSP(dbCon, "usp_�������_��������_����Ʈ", param, "", "")
	
	Dim str_set_interview_day : str_set_interview_day = ""
	If isArray(arrRsPopInterview) Then
	For i=0 To UBound(arrRsPopInterview, 2)
		If arrRsPopInterview(24, i) <> "" Then str_set_interview_day = str_set_interview_day & "," & arrRsPopInterview(24, i)
	Next
	End If

	DisconnectDB DBCon
%>
<script type="text/javascript" src="./js/interview.js"></script>
<script type="text/javascript" src="./js/calendar.js"></script>
<script type="text/javascript">
	var diart_date = 'empty';

	$(document).ready(function () {
		onLoad_Action(); //�޷·ε�
		

		//var interview_day = "<%=interview_day%>";

		$('.day_btn').each(function() {
			if (this.value == todayToString) {
				$(this).addClass('on');
			}
		});

	});
</script>

<!-- ������ ���� -->
<div id="pop_interview">
<div id="pop_dim" class="pop_dim"></div>
<div id="popup" class="popup large">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>������ ����</h3>
			<a href="#none" class="layer_close">�ݱ�</a>
		</div> 
		<div class="pop_con">
			<div class="placement_area">
				<div class="left_box">

					<!-- �� �������� �߰�:S -->
					<div class="caTypeChk MB30" style="display:none;">
						<h4>
							���� ����
							<!-- <a href="javascript:;" class="initChoice" title="�������"></a> -->
						</h4>
						<div class="ctp">
							<div class="cmmInput radiochk">
								<label>
									<input type="radio" name="online_yn" value="Y" checked />
									<span class="lb">����(�¶���ȭ��) ����</span>
								</label>
							</div>
							<div class="cmmInput radiochk">
								<label>
									<input type="radio" name="online_yn" value="N"/>
									<span class="lb">���(��������) ����</span>
								</label>
							</div>
						</div>
					</div>
					<!-- �� �������� �߰�:E -->

					<input type="hidden" id="str_set_interview_day" value="<%=str_set_interview_day%>">
					<div class="calendar_area">
						<h4>�Ͻü���</h4>
						<div class="calendar_box">
							<!-- ���س�� ���� -->
							<div id="calendar_date_in">
								<button type="button" class="btn left">����</button>
								<p><span>2020</span>.<span>07</span>.</p>
								<button type="button" class="btn right">������</button>
							</div>
							<!-- �޷¿��� -->
							<div id="table-id">
							</div>
						</div>
					</div>
					<div class="time">
						<h4>�����ð� ����</h4>
						<ul class="t_ul">
							<% For i = 1 To 6 %>
							<li>							
								<label class="radiobox off" for="time1_<%=i%>">
									<input type="radio" class="rdi" id="time1_<%=i%>" name="set_interview_time" value="<%=i%>" onclick="fn_time_set(this);">
								</label>
								<span><%=getInterviewTime(i)%></span>
							</li>
							<% Next %>
						</ul>
						<ul class="t_ul">
							<% For i = 7 To 16 %>
							<li>
								<label class="radiobox off" for="time1_<%=i%>">
									<input type="radio" class="rdi" id="time1_<%=i%>" name="set_interview_time" value="<%=i%>" onclick="fn_time_set(this);">
								</label>
								<span><%=getInterviewTime(i)%></span>
							</li>
							<% Next %>
						</ul>
					</div>
				</div>
				<div class="middle_box">
					<div class="passer">
						<h4>�����հ���</h4>
						<div class="p_list">
							<ul id="ul_passer_list">
								<% 
								If isArray(arrRsPopInterview) Then

								For i=0 To UBound(arrRsPopInterview, 2)

									If isnull(arrRsPopInterview(30,i)) = false Then

										'������� ����
										If arrRsPopInterview(6, i) = "1" Or arrRsPopInterview(6, i) = "2" Then
											birth_ymd = "19" & arrRsPopInterview(5, i)
										Else
											birth_ymd = "20" & arrRsPopInterview(5, i)
										End If
										user_age = Year(now) - Left(birth_ymd, 4) + 1

										'���ǥ��
										tot_sum = Abs(arrRsPopInterview(11, i))

										If tot_sum = "0" Then 
											career_str = "����"
										ElseIf tot_sum > 12 Then
											career_str = "��� " & fix(tot_sum / 12) & "��"
											If tot_sum mod 12 > 0 Then 
												career_str = career_str & " " & tot_sum mod 12 & "����"
											End If
										Else 
											career_str = "��� " & tot_sum & "����"
										End If

										'�����з�
										strFinalSchool = ""
										Select Case arrRsPopInterview(9, i)
											Case "3" : strFinalSchool = "����б�"
											Case "4" : strFinalSchool = "����(2.3��)"
											Case "5" : strFinalSchool = "���б�(4��)"
											Case "6" : strFinalSchool = "���п�"
										End Select

										Dim pop_interviewYN : pop_interviewYN = False
										If arrRsPopInterview(24, i) <> "" Then pop_interviewYN = True

										Dim pop_confirmYN : pop_confirmYN = false
										If arrRsPopInterview(26, i) = "Y" Then pop_confirmYN = True

										Dim label_class : label_class = ""
										If pop_interviewYN And pop_confirmYN = False Then label_class = "assi"
										If pop_confirmYN Then label_class = "confi"
								%>
								<li>
									<label class="checkbox <%=label_class%> off">
										<% If pop_confirmYN = False Then %>
										<input class="chk" name="set_interview_applyno" type="checkbox" value="<%=arrRsPopInterview(14, i)%>" onclick="fn_applyno_max_cnt(this);">
										<% End If %>
										<div class="txt">
											<strong><%=arrRsPopInterview(4, i)%> (<%=user_age%>��)</strong><br>
											<span>
												
												<% If pop_interviewYN And pop_confirmYN = False Then %>
													<%=Split(arrRsPopInterview(24, i), "-")(1)%>�� <%=Split(arrRsPopInterview(24, i), "-")(2)%>�� <%=getInterviewTime(arrRsPopInterview(25, i))%>
													<br><em>��������</em>

												<% ElseIf pop_confirmYN Then %>
													<%=Split(arrRsPopInterview(24, i), "-")(1)%>�� <%=Split(arrRsPopInterview(24, i), "-")(2)%>�� <%=getInterviewTime(arrRsPopInterview(25, i))%>
													<br><em>����Ȯ��</em>
												
												<% Else %>
													<%=career_str%>
													<% If arrRsPopInterview(16, i) <> "" Then Response.write " | " & arrRsPopInterview(16, i) %>
													<% If strFinalSchool <> "" Then Response.write "<br>" & strFinalSchool %>

												<% End If %>
											</span>
										</div>
									</label>
								</li>
								<%
									End If
								Next 
								End if
								%>
							</ul>
						</div>
						<button type="button" class="btn_preview" onclick="fn_set_preview();">�̸�����</button>
					</div>
				</div>

				<form id="frm_pop" name="frm_pop" method="post" action="./proc_interview_save.asp">

				<input type="hidden" id="set_mode" name="set_mode" value="<%=mode%>">
				<input type="hidden" id="set_jid" name="set_jid" value="<%=jid%>">
				<input type="hidden" id="set_interview_day" name="set_interview_day" value="">

				<div class="right_box">
					<div class="preview">
						<h4>���������� �̸�����</h4>
						<div class="p_list">
							<ul id="ul_preview_list">
								<!--
								<li id="">
									<div class="preview_info">
										<p>8�� 10�� 09:00-09:25</p>
										<ul class="pi_ul">
											<li>
												<strong>�̼��� (��, 33��)</strong> / ���� / 4���� ����
												<button type="button">�ݱ�</button>
											</li>
											<li>
												<strong>������ (��, 35��)</strong> / 2�� 2���� / 4���� ����
												<button type="button">�ݱ�</button>
											</li>
										</ul>
									</div>
								</li>
								-->
								<p class="p_ment">
									��������, �ð�, �����հ��ڸ� ���� ��<br>
									<span>�̸����� ��ư�� Ŭ��</span>�� �ּ���.<br><br>
									�����ð� �� �ִ� 4�� ������ <br>
									������ �� �ֽ��ϴ�.
								</p>
							</ul>
						</div>
					</div>
				</div>
				</form>

			</div><!--//placement_area-->
		</div>
		<div class="pop_footer">
			<div class="btn_area right">
				<a href="javaScript:;" onclick="fn_interview_save();"  class="btn blue">����</a>
			</div>
		</div>

	</div>
</div>
</div>
<!-- //������ ���� -->