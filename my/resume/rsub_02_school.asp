<script type="text/javascript">

	$(document).ready(function () {
		//����б� �ε�� selŬ�� (�з±��� sel)
		$('[name="univ_kind"]').each(function() {
			if (this.value == "2") {
				$(this).parents('.ib_m_box').find('#ul_sel_univ_kind').find('a').eq(0).click();
			} else if (this.value == "3") {
				$(this).parents('.ib_m_box').find('#ul_sel_univ_kind').find('a').eq(1).click();
			} else {
				$(this).parents('.ib_m_box').find('#lb_chk_gde').hide();
			}
			
			/*
			var kind_val = this.value;
			$(this).parents('.ib_m_box').find('#ul_sel_univ_kind').find('a').eq(kind_val - 3).click();
			*/

		});

		
		//������� üũ
		$('[name="gde"]').each(function() {
			if (this.value == "1") {
				$(this).parents('.ib_m_box').find('#chk_gde').attr('checked', true);
			}
		});


	});

	function fn_gde_chk(obj) {

		if ($(obj).is(":checked")) {
			$(obj).parents('.ib_m_box').find('#univ_name').val('���԰������').attr('readonly', true);
			$(obj).parents(".ib_m_box").children("#gde").val("1");
		} else {
			$(obj).parents('.ib_m_box').find('#univ_name').val('').attr('readonly', false);
			$(obj).parents(".ib_m_box").children("#gde").val("0");
		}

	}

	function fn_school_s_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#univ_syear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#univ_smonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#univ_syear").val("");
			$(obj).prevAll("#univ_smonth").val("");
		}
	}
	function fn_school_e_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#univ_eyear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#univ_emonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#univ_eyear").val("");
			$(obj).prevAll("#univ_emonth").val("");
		}
	}
	
	function fn_school_chg_univ_kind(obj, val) {
		//����б�, ���� �˻��ڵ��ϼ� �ڵ尪 ����
		$(obj).parents('.ib_m_box').find('#univ_name').attr('onkeyup','fn_kwSearchItem(this, \'' + val + '\')');

		if (val == "high") {
//			$(obj).parents('.ib_m_box').find('#univ_name').val("");
			$(obj).parents('.ib_m_box').find('#univ_point').val(""); //����
			$(obj).parents('.ib_m_box').find('#univ_major').val(""); //����
			$(obj).parents('.ib_m_box').find('#univ_research').val(""); //�̼�����
			$(obj).parents('.ib_m_box').find('#univ_minor').val(""); //������
			$(obj).parents('.ib_m_box').find('#univ_minornm').val(""); //��������

			//$(obj).parents('.ib_m_box').find('#univ_point').attr('readonly', true);
			//$(obj).parents('.ib_m_box').find('#univ_point').attr('class', 'txt last disabled');
			
			$(obj).parents('.ib_m_box').find('#div_search_box').show();
			$(obj).parents('.ib_m_box').find('#div_univ_etype').show();
			$(obj).parents('.ib_m_box').find('#div_univ_sdate').show();
			$(obj).parents('.ib_m_box').find('#div_univ_edate').show();
			$(obj).parents('.ib_m_box').find('#lb_chk_gde').show();

			$(obj).parents('.ib_m_box').find('#univ_point').hide();
			$(obj).parents('.ib_m_box').find('#univ_major').hide();
			$(obj).parents('.ib_m_box').find('#univ_research').hide();
			$(obj).parents('.ib_m_box').find('#univ_add_minor').hide();
			$(obj).parents('.ib_m_box').find('.con_add major').hide();
		} else if (val == "below") {

			$(obj).parents('.ib_m_box').find('#univ_name').val("����б� ����");
			$(obj).parents('.ib_m_box').find('#univ_etype').val("");
			$(obj).parents('.ib_m_box').find('#div_univ_sdate').val("");
			$(obj).parents('.ib_m_box').find('#div_univ_edate').val("");

			$(obj).parents('.ib_m_box').find('#univ_point').val(""); //����
			$(obj).parents('.ib_m_box').find('#univ_major').val(""); //����
			$(obj).parents('.ib_m_box').find('#univ_research').val(""); //�̼�����
			$(obj).parents('.ib_m_box').find('#univ_minor').val(""); //������
			$(obj).parents('.ib_m_box').find('#univ_minornm').val(""); //��������
			$(obj).parents('.ib_m_box').find('#lb_chk_gde').val("");

			$(obj).parents('.ib_m_box').find('#div_search_box').hide();
			$(obj).parents('.ib_m_box').find('#div_univ_etype').hide();
			$(obj).parents('.ib_m_box').find('#div_univ_sdate').hide();
			$(obj).parents('.ib_m_box').find('#div_univ_edate').hide();

			$(obj).parents('.ib_m_box').find('#univ_point').hide();
			$(obj).parents('.ib_m_box').find('#univ_major').hide();
			$(obj).parents('.ib_m_box').find('#univ_research').hide();
			$(obj).parents('.ib_m_box').find('#univ_add_minor').hide();
			$(obj).parents('.ib_m_box').find('.con_add major').hide();
			$(obj).parents('.ib_m_box').find('#lb_chk_gde').hide();

		} else {
			$(obj).parents('.ib_m_box').find('#univ_name').val("");

			//������� üũ�����϶� Ŭ���̺�Ʈ�� üũ����
			if ($(obj).parents('.ib_m_box').find('#chk_gde').is(":checked")) {
				$(obj).parents('.ib_m_box').find('#chk_gde').click();
			}
			$(obj).parents('.ib_m_box').find('#lb_chk_gde').hide();
			
			$(obj).parents('.ib_m_box').find('#div_search_box').show();
			$(obj).parents('.ib_m_box').find('#div_univ_etype').show();
			$(obj).parents('.ib_m_box').find('#div_univ_sdate').show();
			$(obj).parents('.ib_m_box').find('#div_univ_edate').show();

			$(obj).parents('.ib_m_box').find('#univ_point').show();
			$(obj).parents('.ib_m_box').find('#univ_major').show();
			$(obj).parents('.ib_m_box').find('#univ_research').show();
			$(obj).parents('.ib_m_box').find('#univ_add_minor').show();
		}
		$(obj).parents('.ib_m_box').find('.con_basic').show();
	}

</script>

<div class="input_box" id ="resume2">
	<p class="ib_tit">�з»���</p>
	<div class="ib_list add1">
		<input type="hidden" id="final_scholar" name="final_scholar" value="">
		<%
		Dim univ_etype_nm, univ_kind_nm, univ_minor_nm, univ_sdate, univ_edate, univ_visible
		If isArray(arrSchool) Then
			For i=0 To UBound(arrSchool, 2)
			univ_etype_nm = ""
			univ_sdate = ""
			univ_edate = ""
			univ_visible = ""
			Select Case arrSchool(12, i)
				Case "3" : univ_etype_nm = "����"
				Case "4" : univ_etype_nm = "����"
				Case "5" : univ_etype_nm = "����"
				Case "7" : univ_etype_nm = "����(��)"
				Case "8" : univ_etype_nm = "����"
				Case Else univ_etype_nm = "��������"
			End Select

			univ_kind_nm = ""
			Select Case arrSchool(2, i)
				Case "2" : univ_kind_nm = "����б� ����"
				Case "3" : univ_kind_nm = "����б�"
				Case "4" : univ_kind_nm = "����(2,3��)"
				Case "5" : univ_kind_nm = "���б�(4��)"
				Case "6" : univ_kind_nm = "���п�"
				Case Else univ_kind_nm = "�з±���"
			End Select

			univ_minor_nm = ""
			univ_minor_nm = arrSchool(17, i)
			If univ_minor_nm = "" Or isnull(univ_minor_nm) Then univ_minor_nm = "��������"

			If isDate(arrSchool(7, i) & "-" & arrSchool(8, i)) Then univ_sdate = arrSchool(7, i) & "." & arrSchool(8, i)
			If isDate(arrSchool(10, i) & "-" & arrSchool(11, i)) Then univ_edate = arrSchool(10, i) & "." & arrSchool(11, i)

			'If arrSchool(3, i) = "���԰������" Then univ_visible = "display:none;"
			Dim v_set_schoolNm
			v_set_schoolNm = arrSchool(3, i)
		%>
		<div class="ib_move">
			<button type="button" name="�̵���ư" class="ib_m_handle"></button>
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="univ_kind" name="univ_kind" value="<%=arrSchool(2, i)%>">
				<input type="hidden" id="sc_type" name="sc_type" value="2">
				<input type="hidden" id="univ_depth" name="univ_depth" value=""> <!-- �迭�ڵ�(X) -->
				<input type="hidden" id="univ_pointavg" name="univ_pointavg" value="<%=arrSchool(14, i)%>"> <!-- ��������(X) -->
				<input type="hidden" id="univ_code" name="univ_code" value=""> <!-- �����ڵ�(X) -->
				<input type="hidden" id="univ_major_code" name="univ_major_code" value=""> <!-- �����ڵ�(X) -->
				<input type="hidden" id="univ_area" name="univ_area" value=""> <!-- �����ڵ�(X) -->
				<input type="hidden" id="univ_stype" name="univ_stype" value="1"> <!-- �����ڵ�(X) -->
				<input type="hidden" id="univ1_grd" name="univ1_grd" value=""> <!-- ���������ڵ�(X) -->
				
				<input type="hidden" id="univ_syear" name="univ_syear" value="<%=arrSchool(7, i)%>">
				<input type="hidden" id="univ_smonth" name="univ_smonth" value="<%=arrSchool(8, i)%>">
				<input type="hidden" id="univ_eyear" name="univ_eyear" value="<%=arrSchool(10, i)%>">
				<input type="hidden" id="univ_emonth" name="univ_emonth" value="<%=arrSchool(11, i)%>">
				<input type="hidden" id="univ_etype" name="univ_etype" value="<%=arrSchool(12, i)%>"> <!-- �������� -->
				<input type="hidden" id="univ_minor" name="univ_minor" value="<%=arrSchool(17, i)%>"> <!-- ������ -->
				<input type="hidden" id="univ_mdepth" name="univ_mdepth" value=""> <!-- �������迭�ڵ�(X) -->
				<input type="hidden" id="univ_minor_code" name="univ_minor_code" value=""> <!-- �������ڵ�(X) -->

				<input type="hidden" id="gde" name="gde" value="<%=arrSchool(21,i)%>"> <!-- ������� -->

				<div class="select_down" style="width:290px;" title="�з±���">
					<div class="name"><a href="javaScript:;"><span><%=univ_kind_nm%></span></a></div>
					<div class="sel">
						<ul id="ul_sel_univ_kind" style="display: none;">
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '2'); fn_school_chg_univ_kind(this, 'below');">����б� ����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '3'); fn_school_chg_univ_kind(this, 'high');">����б�</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '4'); fn_school_chg_univ_kind(this, 'univ');">����(2,3��)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '5'); fn_school_chg_univ_kind(this, 'univ');">���б�(4��)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '6'); fn_school_chg_univ_kind(this, 'univ');">���п�</a></li>
						</ul>
					</div>
				</div>
				
				<div class="search_box" style="width:433px;" id="div_search_box">
					<input type="text" id="univ_name" name="univ_name" class="txt" placeholder="�б���" value="<%=arrSchool(3, i)%>" onkeyup="fn_kwSearchItem(this, 'univ')" style="width:100%;">
					<div class="result_box" id="id_result_box"><!-- �ڵ��ϼ� ���� -->
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
				</div>

				<label class="checkbox off" id="lb_chk_gde"><input type="checkbox" class="chk" value="1" id="chk_gde" onclick="fn_gde_chk(this)"><span>���� �������</span></label>
				
				<input type="text" id="univ_major" name="univ_major" class="txt last" placeholder="���� �� ���� (ex. �濵�а� �л�)" value="<%=arrSchool(6, i)%>" style="width:445px;">

				<br>
				<div class="select_down" id="div_univ_etype" style="width:290px;<%=univ_visible%>" title="��������">
					<div class="name"><a href="javaScript:;"><span><%=univ_etype_nm%></span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '3')">����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '4')">����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '5')">����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '7')">����(��)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '8')">����</a></li>
						</ul>
					</div>
				</div>

				<input type="text" id="div_univ_sdate" name="univ_sdate" class="txt" placeholder="���г�� (ex. 2019.03)" value="<%=univ_sdate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:290px;<%=univ_visible%>">
				<input type="text" id="div_univ_edate" name="univ_edate" class="txt" placeholder="������� (ex. 2020.02)" value="<%=univ_edate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:290px;">

				<input type="text" id="univ_point" name="univ_point" class="txt last" placeholder="���� (ex. 4.5)" value="<%=arrSchool(13, i)%>" maxlength="4" style="width:290px;">



				<input type="text" id="univ_research" name="univ_research" class="txt" placeholder="�̼����� �� ��������" value="<%=arrSchool(24, i)%>" style="width:100%">

				<div class="con_add major" style="<%If arrSchool(17, i) = "" Or isnull(arrSchool(17, i)) Then%>display:none;<%End If%>">
					<div class="select_down" style="width:217px;" title="��������">
						<div class="name"><a href="javaScript:;"><span><%=univ_minor_nm%></span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_minor', '��')">������</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_minor', '����')">��������</a></li>
							</ul>
						</div>
					</div>
					<input type="text" id="univ_minornm" name="univ_minornm" class="txt" placeholder="������" value="<%=arrSchool(18, i)%>" style="width:417px;">
				</div>

				<button type="button" id="univ_add_minor" name="�����߰�" class="add_btn<%If arrSchool(17, i) = "" Or isnull(arrSchool(17, i)) Then%> on<%End If%>">�ٸ� ���� �߰�</button>
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
				
				<input type="hidden" id="univ_kind" name="univ_kind" value="0">
				<input type="hidden" id="sc_type" name="sc_type" value="2">
				<input type="hidden" id="univ_depth" name="univ_depth" value=""> <!-- �迭�ڵ�(X) -->
				<input type="hidden" id="univ_pointavg" name="univ_pointavg" value=""> <!-- ��������(X) -->
				<input type="hidden" id="univ_code" name="univ_code" value=""> <!-- �����ڵ�(X) -->
				<input type="hidden" id="univ_major_code" name="univ_major_code" value=""> <!-- �����ڵ�(X) -->
				<input type="hidden" id="univ_area" name="univ_area" value=""> <!-- �����ڵ�(X) -->
				<input type="hidden" id="univ_stype" name="univ_stype" value="1"> <!-- �����ڵ�(X) -->
				<input type="hidden" id="univ1_grd" name="univ1_grd" value=""> <!-- ���������ڵ�(X) -->
				
				<input type="hidden" id="univ_syear" name="univ_syear" value="">
				<input type="hidden" id="univ_smonth" name="univ_smonth" value="">
				<input type="hidden" id="univ_eyear" name="univ_eyear" value="">
				<input type="hidden" id="univ_emonth" name="univ_emonth" value="">
				<input type="hidden" id="univ_etype" name="univ_etype" value=""> <!-- �������� -->
				<input type="hidden" id="univ_minor" name="univ_minor" value=""> <!-- ������ -->
				<input type="hidden" id="univ_mdepth" name="univ_mdepth" value=""> <!-- �������迭�ڵ�(X) -->
				<input type="hidden" id="univ_minor_code" name="univ_minor_code" value=""> <!-- �������ڵ�(X) -->

				<input type="hidden" id="gde" name="gde" value=""> <!-- ������� -->				

				<div class="select_down" style="width:290px;" title="�з±���">
					<div class="name"><a href="javaScript:;"><span>�з±���</span></a></div>
					<div class="sel">
						<ul id="ul_sel_univ_kind" id="ul_sel_univ_kind" style="display: none;">
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '2'); fn_school_chg_univ_kind(this, 'below');">����б� ����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '3'); fn_school_chg_univ_kind(this, 'high');">����б�</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '4'); fn_school_chg_univ_kind(this, 'univ');">����(2,3��)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '5'); fn_school_chg_univ_kind(this, 'univ');">���б�(4��)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '6'); fn_school_chg_univ_kind(this, 'univ');">���п�</a></li>
						</ul>
					</div>
				</div>

				<div class="search_box" style="width:433px;" id="div_search_box">
					<input type="text" id="univ_name" name="univ_name" class="txt" placeholder="�б���" onkeyup="fn_kwSearchItem(this, 'univ')" style="width:100%;">
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
				</div>

				<label class="checkbox off" id="lb_chk_gde"><input type="checkbox" class="chk" value="1" id="chk_gde" onclick="fn_gde_chk(this)"><span>���� �������</span></label>

				<input type="text" id="univ_major" name="univ_major" class="txt last" placeholder="���� �� ���� (ex. �濵�а� �л�)" style="width:445px; display:none;">

				<br>
				
				<div class="con_basic" style="display:none;">
					<div class="select_down" id="div_univ_etype" style="width:290px;" title="��������">
						<div class="name"><a href="javaScript:;"><span>��������</span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '3')">����</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '4')">����</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '5')">����</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '7')">����(��)</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '8')">����</a></li>
							</ul>
						</div>
					</div>

					<input type="text" id="div_univ_sdate" name="univ_sdate" class="txt" placeholder="���г�� (ex. 2019.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:290px;">
					<input type="text" id="div_univ_edate" name="univ_edate" class="txt" placeholder="������� (ex. 2020.02)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:290px;">
					<input type="text" id="univ_point" name="univ_point" class="txt last" placeholder="���� (ex. 4.5)" maxlength="4" style="width:290px;">

					<input type="text" id="univ_research" name="univ_research" class="txt" placeholder="�̼����� �� ��������" style="width:100%">
				</div>

				<div class="con_add major" style="display:none;">
					<div class="select_down" style="width:217px;" title="��������">
						<div class="name"><a href="javaScript:;"><span>��������</span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_minor', '��')">������</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_minor', '����')">��������</a></li>
							</ul>
						</div>
					</div>
					<input type="text" id="univ_minornm" name="univ_minornm" class="txt" placeholder="������" style="width:417px;">
				</div>
				<button type="button" id="univ_add_minor" name="�����߰�" class="add_btn on" style="display:none;">�ٸ� ���� �߰�</button>
			</div>
		</div>
		<%
		End If 
		%>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r1">�߰��ϱ�</button>
	</div>
</div><!-- �з»��� -->