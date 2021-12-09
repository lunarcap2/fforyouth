<script type="text/javascript">
	function fn_rac_s_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#rac_syear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#rac_smonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#rac_syear").val("");
			$(obj).prevAll("#rac_smonth").val("");
		}
	}
	function fn_rac_e_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#rac_eyear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#rac_emonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#rac_eyear").val("");
			$(obj).prevAll("#rac_emonth").val("");
		}
	}
</script>


<div class="input_box" id="resume4">
	<p class="ib_tit">����,���Ȱ��</p>
	<div class="ib_list add3 ui-sortable">

		<%
		Dim rac_type_nm, rac_sdate, rac_edate
		If isArray(arrActivity) Then
			For i=0 To UBound(arrActivity, 2)
			Select Case arrActivity(1, i)
				Case "1" : rac_type_nm = "����"
				Case "2" : rac_type_nm = "�Ƹ�����Ʈ"
				Case "3" : rac_type_nm = "����Ȱ��"
				Case "4" : rac_type_nm = "���Ƹ�"
				Case "5" : rac_type_nm = "�ڿ�����"
				Case "6" : rac_type_nm = "���Ȱ��"
				Case "7" : rac_type_nm = "��ȸȰ��"
			End Select

			If arrActivity(4, i) < 10 Then arrActivity(4, i) = "0" & arrActivity(4, i)
			If arrActivity(6, i) < 10 Then arrActivity(6, i) = "0" & arrActivity(6, i)

			If isDate(arrActivity(3, i) & "-" & arrActivity(4, i)) Then rac_sdate = arrActivity(3, i) & "." & arrActivity(4, i)
			If isDate(arrActivity(5, i) & "-" & arrActivity(6, i)) Then rac_edate = arrActivity(5, i) & "." & arrActivity(6, i)
		%>
		<div class="ib_move">
			<button type="button" name="�̵���ư" class="ib_m_handle ui-sortable-handle"></button>
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="rac_type" name="rac_type" value="<%=arrActivity(1, i)%>" />
				<input type="hidden" id="rac_type_text" name="rac_type_text" value=" " />
				<input type="hidden" id="rac_syear" name="rac_syear" value="<%=arrActivity(3, i)%>" />
				<input type="hidden" id="rac_smonth" name="rac_smonth" value="<%=arrActivity(4, i)%>" />
				<input type="hidden" id="rac_eyear" name="rac_eyear" value="<%=arrActivity(5, i)%>" />
				<input type="hidden" id="rac_emonth" name="rac_emonth" value="<%=arrActivity(6, i)%>" />
				<input type="hidden" id="rac_location" name="rac_location" value=" " />

				<input type="hidden" id="rac_seq" name="rac_seq" value="0">

				<input type="text" name="rac_sdate" class="txt" placeholder="���۳�� (ex. 2019.02)" value="<%=arrActivity(3, i)%>.<%=arrActivity(4, i)%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_rac_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:289px;">
				<input type="text" name="rac_edate" class="txt" placeholder="������ (ex. 2020.03)" value="<%=arrActivity(5, i)%>.<%=arrActivity(6, i)%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_rac_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:289px;">
				<div class="select_down" style="width:288px;" title="Ȱ������">
					<div class="name"><a href="javaScript:;"><span><%=rac_type_nm%></span></a></div>
					<div class="sel">
						<ul style="display: none;">
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '1')">����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '2')">�Ƹ�����Ʈ</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '3')">����Ȱ��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '4')">���Ƹ�</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '5')">�ڿ�����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '6')">���Ȱ��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '7')">��ȸȰ��</a></li>
						</ul>
					</div>
				</div>
				<input type="text" name="rac_organization" class="txt last" placeholder="ȸ��/���/��ü��" value="<%=arrActivity(7, i)%>" style="width:288px;">
				<textarea class="resume_tt" name="rac_content" placeholder="������ ���õ� ������ �������ּ���."><%=arrActivity(9, i)%></textarea>
			</div>
		</div>
		<%
			Next
		Else
		%>
		<div class="ib_move">
			<button type="button" name="�̵���ư" class="ib_m_handle ui-sortable-handle"></button>
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="rac_type" name="rac_type" value="" />
				<input type="hidden" id="rac_type_text" name="rac_type_text" value=" " />
				<input type="hidden" id="rac_syear" name="rac_syear" value="" />
				<input type="hidden" id="rac_smonth" name="rac_smonth" value="" />
				<input type="hidden" id="rac_eyear" name="rac_eyear" value="" />
				<input type="hidden" id="rac_emonth" name="rac_emonth" value="" />
				<input type="hidden" id="rac_location" name="rac_location" value=" " />

				<input type="hidden" id="rac_seq" name="rac_seq" value="0">

				<input type="text" name="rac_sdate" class="txt" placeholder="���۳�� (ex. 2019.02)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_rac_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:289px;">
				<input type="text" name="rac_edate" class="txt" placeholder="������ (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_rac_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:289px;">
				<div class="select_down" style="width:288px;" title="Ȱ������">
					<div class="name"><a href="javaScript:;"><span>Ȱ������</span></a></div>
					<div class="sel">
						<ul style="display: none;">
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '1')">����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '2')">�Ƹ�����Ʈ</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '3')">����Ȱ��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '4')">���Ƹ�</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '5')">�ڿ�����</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '6')">���Ȱ��</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'rac_type', '7')">��ȸȰ��</a></li>
						</ul>
					</div>
				</div>
				<input type="text" name="rac_organization" class="txt last" placeholder="ȸ��/���/��ü��" style="width:288px;">
				<textarea class="area" name="rac_content" placeholder="������ ���õ� ������ �������ּ���."></textarea>
			</div>
		</div>
		<%
		End If
		%>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r3">�߰��ϱ�</button>
	</div>
</div><!-- ����,���Ȱ�� -->