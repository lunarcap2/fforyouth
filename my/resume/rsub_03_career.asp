<%
	Dim experience
	If IsArray(arrResume) Then 
		experience = arrResume(12, 0)
	End If
%>
<script type="text/javascript">

	$(document).ready(function () {
		//����,��� üũ
		var experience = "<%=experience%>";
		$('[name="experience"]').each(function() {
			if (this.value == experience) {
				//this.checked = true;
				this.click();
			}
		});

		//ȸ��� �����üũ
		$('[name="com_close_hdn"]').each(function() {
			if (this.value == "0") {
				//console.log($(this).parents('.ib_m_box').find('#ul_sel_univ_kind').find('a').eq(0));
				$(this).parents('.ib_m_box').find('#chk_career_hidden').attr('checked', true);
			}
		});

		//������ �ε�� selŬ��
		$('[name="experience_nowstatus_hdn"]').each(function() {
			if (this.value == "2") {
				//console.log($(this).parents('.ib_m_box').find('#ul_sel_univ_kind').find('a').eq(0));
				$(this).parents('.ib_m_box').find('#ul_sel_hdn').find('a').eq(0).click();
			}
		});
	});

	function fn_career_s_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#experience_syear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#experience_smonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#experience_syear").val("");
			$(obj).prevAll("#experience_smonth").val("");
		}
	}
	function fn_career_e_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#experience_eyear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#experience_emonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#experience_eyear").val("");
			$(obj).prevAll("#experience_emonth").val("");
		}
	}
	function fn_career_hidden_chk(obj) {
		if ($(obj).is(":checked")) {
			$(obj).parents(".ib_m_box").children("#com_close_hdn").val("0");
		} else {
			$(obj).parents(".ib_m_box").children("#com_close_hdn").val("1");
		}
	}
	function fn_career_sel_hdn(obj, val) {
		if (val == "2") { //������
			$(obj).parents(".ib_m_box").children("#experience_eyear").val("");
			$(obj).parents(".ib_m_box").children("#experience_emonth").val("");
			$(obj).parents(".ib_m_box").children("#experience_edate").val("");
			$(obj).parents(".ib_m_box").children("#experience_edate").hide();
			$(obj).parents(".ib_m_box").children("#experience_edate_disabled").show();
		} else if (val == "1") { //���
			$(obj).parents(".ib_m_box").children("#experience_edate_disabled").hide();
			$(obj).parents(".ib_m_box").children("#experience_edate").show();
		}
	}

	function fn_chg_experience(obj) {
		if ($(obj).val() == "1") {
			$('#resume3').find('.ib_move').hide();
			$('#resume3').find('.add_box').hide();
		} else if($(obj).val() == "8") {
			$('#resume3').find('.ib_move').show();
			$('#resume3').find('.add_box').show();
		}
	}

</script>

<div class="input_box" id ="resume3">
	<p class="ib_tit">��»���</p>
	<div class="ib_list add2">
		
		<!-- �� ���� / ��� ���� :S -->
		<div class="crow">
			<div class="ccol4">
				<div class="cmmRadiochkButtonWrap tp3 lg ML40">
					<div class="cmmRadiochkButtonCol">
						<div class="cmmInput radiochk">
							<label>
								<input type="radio" name="experience" value="1" onclick="fn_chg_experience(this)">
								<span class="lb">����</span>
							</label>
						</div>
					</div>
					<div class="cmmRadiochkButtonCol">
						<div class="cmmInput radiochk">
							<label>
								<input type="radio" name="experience" value="8" onclick="fn_chg_experience(this)" checked>
								<span class="lb">���</span>
							</label>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- �� ���� / ��� ���� :E -->
		
		<%
		Dim experience_nowstatus_hdn_nm, experience_sdate, experience_edate
		If isArray(arrCareer) Then
			For i=0 To UBound(arrCareer, 2)
			Select Case arrCareer(5, i)
				Case "1" : experience_nowstatus_hdn_nm = "���"
				Case "2" : experience_nowstatus_hdn_nm = "������"
			End Select

			If isDate(arrCareer(6, i) & "-" & arrCareer(7, i)) Then experience_sdate = arrCareer(6, i) & "." & arrCareer(7, i)
			If isDate(arrCareer(8, i) & "-" & arrCareer(9, i)) Then experience_edate = arrCareer(8, i) & "." & arrCareer(9, i)
		%>
		<div class="ib_move">
			<button type="button" name="�̵���ư" class="ib_m_handle"></button>
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="experience_syear" name="experience_syear" value="<%=arrCareer(6, i)%>" />
				<input type="hidden" id="experience_smonth" name="experience_smonth" value="<%=arrCareer(7, i)%>" />
				<input type="hidden" id="experience_eyear" name="experience_eyear" value="<%=arrCareer(8, i)%>" />
				<input type="hidden" id="experience_emonth" name="experience_emonth" value="<%=arrCareer(9, i)%>" />
				<input type="hidden" id="experience_nowstatus_hdn" name="experience_nowstatus_hdn" value="<%=arrCareer(5, i)%>" />
				<input type="hidden" id="com_close_hdn" name="com_close_hdn" value="<%=arrCareer(20, i)%>" />

				<input type="hidden" id="openis_hdn" name="openis_hdn" value="" />
				<input type="hidden" id="experience_salary_txt" name="experience_salary_txt" value="<%=arrCareer(25,i)%>" />
				<input type="hidden" id="experience_salary5" name="experience_salary5" value="" />
				<input type="hidden" id="experience_duty" name="experience_duty" value="" />
				<input type="hidden" id="experience_corp_id" name="experience_corp_id" value="" />

				<div class="select_down"  style="width:352px;" title="�ٹ�����">
					<div class="name"><a href="javaScript:;"><span><%=experience_nowstatus_hdn_nm%></span></a></div>
					<div class="sel">
						<ul id="ul_sel_hdn">
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'experience_nowstatus_hdn', '2'); fn_career_sel_hdn(this, '2');">������</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'experience_nowstatus_hdn', '1'); fn_career_sel_hdn(this, '1');">���</a></li>
						</ul>
					</div>
				</div>
				
				<input type="text" id="experience_sdate" name="experience_sdate" class="txt" placeholder="�Ի��� (ex. 2019.02)" value="<%=experience_sdate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_career_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:403px;">
				<input type="text" id="experience_edate" name="experience_edate" class="txt last" placeholder="����� (ex. 2020.03)" value="<%=experience_edate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_career_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:410px;">
				<div class="disabled" id="experience_edate_disabled" style="width:405px; display:none;"><span>����� (ex. 2020.03)</span></div>

				<div class="search_box" style="width:486px;">
					<input type="text" id="experience_corp_name" name="experience_corp_name" class="txt" placeholder="ȸ���" value="<%=arrCareer(1, i)%>" onkeyup="fn_kwSearchItem(this, 'company')" style="width:100%;">
					<div class="result_box" id="id_result_box">
						<!--
						<ul class="rb_ul">
							<li>
								<a href="javaScript:;" class="rb_a">
									<p>Ŀ�����</p>
									<span>��ȣ����߰߱��</span><span>���˼���</span>
								</a>
							</li>
						</ul>
						<a href="javaScript:;" class="rb_direct"><span>Ŀ�����</span> �����Է�</a>
						-->
					</div>
					<label class="checkbox off"><input type="checkbox" class="chk" id="chk_career_hidden" onclick="fn_career_hidden_chk(this)"><span>ȸ��� �����</span></label>
				</div>
				<input type="text" name="experience_dept" class="txt last" placeholder="�μ���/��å" value="<%=arrCareer(3, i)%>" style="width:691px;">
				<div class="con_add" style="<%If isNull(arrCareer(26, i)) Or arrCareer(26, i) = "" Then%>display:none;<%End If%>">
					<textarea name="rca_part_skill"><%=arrCareer(26, i)%></textarea>
				</div>
				<button type="button" name="�����߰�" class="add_btn<%If isNull(arrCareer(26, i)) Or arrCareer(26, i) = "" Then%> on<%End If%>" onclick="toggleFnc();">�ֿ伺�� �� ��±��</button>
			</div>
		</div>
		<%
			Next
		Else
		%>
		<div class="ib_move">
			<button type="button" name="�̵���ư" class="ib_m_handle"></button>
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="experience_syear" name="experience_syear" value="" />
				<input type="hidden" id="experience_smonth" name="experience_smonth" value="" />
				<input type="hidden" id="experience_eyear" name="experience_eyear" value="" />
				<input type="hidden" id="experience_emonth" name="experience_emonth" value="" />
				<input type="hidden" id="experience_nowstatus_hdn" name="experience_nowstatus_hdn" value="" />
				<input type="hidden" id="com_close_hdn" name="com_close_hdn" value="1" />

				<input type="hidden" id="openis_hdn" name="openis_hdn" value="" />
				<input type="hidden" id="experience_salary_txt" name="experience_salary_txt" value="" />
				<input type="hidden" id="experience_salary5" name="experience_salary5" value="" />
				<input type="hidden" id="experience_duty" name="experience_duty" value="" />
				<input type="hidden" id="experience_corp_id" name="experience_corp_id" value="" />

				<div class="select_down"  style="width:352px;" title="�ٹ�����">
					<div class="name"><a href="javaScript:;"><span>�ٹ�����</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'experience_nowstatus_hdn', '2'); fn_career_sel_hdn(this, '2');">������</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'experience_nowstatus_hdn', '1'); fn_career_sel_hdn(this, '1');">���</a></li>
						</ul>
					</div>
				</div>
				
				<input type="text" id="experience_sdate" name="experience_sdate" class="txt" placeholder="�Ի��� (ex. 2019.02)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_career_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:403px;">
				<input type="text" id="experience_edate" name="experience_edate" class="txt last" placeholder="����� (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_career_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:410px;">
				<div class="disabled" id="experience_edate_disabled" style="width:405px; display:none;"><span>����� (ex. 2020.03)</span></div>
				<div class="search_box" style="width:486px;">
					<input type="text" id="experience_corp_name" name="experience_corp_name" class="txt" placeholder="ȸ���" onkeyup="fn_kwSearchItem(this, 'company')" style="width:100%;">
					<div class="result_box" id="id_result_box">
						<!--
						<ul class="rb_ul">
							<li>
								<a href="javaScript:;" class="rb_a">
									<p>Ŀ�����</p>
									<span>��ȣ����߰߱��</span><span>���˼���</span>
								</a>
							</li>
						</ul>
						<a href="javaScript:;" class="rb_direct"><span>Ŀ�����</span> �����Է�</a>
						-->
					</div>
					<label class="checkbox off"><input type="checkbox" class="chk" id="chk_career_hidden" onclick="fn_career_hidden_chk(this)"><span>ȸ��� �����</span></label>
				</div>
				<input type="text" name="experience_dept" class="txt last" placeholder="�μ���/��å" style="width:691px;">
				<div class="con_add" style="display:none;">
					<textarea name="rca_part_skill"></textarea>
				</div>
				<button type="button" name="�����߰�" class="add_btn on" onclick="toggleFnc();">�ֿ伺�� �� ��±��</button>
			</div>
		</div>
		<%
		End If 
		%>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r2">�߰��ϱ�</button>
	</div>
</div><!-- ��»��� -->