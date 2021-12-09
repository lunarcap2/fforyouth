<script type="text/javascript">
	function fn_education_s_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#academy_syear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#academy_smonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#academy_syear").val("");
			$(obj).prevAll("#academy_smonth").val("");
		}
	}
	function fn_education_e_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#academy_eyear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#academy_emonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#academy_eyear").val("");
			$(obj).prevAll("#academy_emonth").val("");
		}
	}
</script>

<div class="input_box" id ="resume8">
	<p class="ib_tit">����</p>
	<div class="ib_list add7">
		<%
		Dim academy_sdate, academy_edate
		If isArray(arrAcademy) Then
			For i=0 To UBound(arrAcademy, 2)
			If isDate(arrAcademy(2, i) & "-" & arrAcademy(3, i)) Then academy_sdate = arrAcademy(2, i) & "." & arrAcademy(3, i)
			If isDate(arrAcademy(4, i) & "-" & arrAcademy(5, i)) Then academy_edate = arrAcademy(4, i) & "." & arrAcademy(5, i)
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="academy_syear" name="academy_syear" value="<%=arrAcademy(2, i)%>" />
				<input type="hidden" id="academy_smonth" name="academy_smonth" value="<%=arrAcademy(3, i)%>" />
				<input type="hidden" id="academy_eyear" name="academy_eyear" value="<%=arrAcademy(4, i)%>" />
				<input type="hidden" id="academy_emonth" name="academy_emonth" value="<%=arrAcademy(5, i)%>" />

				<input type="text" name="academy_sdate" class="txt" placeholder="���۳�� (ex. 2019.02)" value="<%=academy_sdate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_education_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:298px;">
				<input type="text" name="academy_edate" class="txt" placeholder="������ (ex. 2020.03)" value="<%=academy_edate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_education_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:298px;">
				<input type="text" name="academy_name" class="txt" placeholder="������" value="<%=arrAcademy(6, i)%>" style="width:298px;">
				<input type="text" name="academy_org_name" class="txt last" placeholder="�������" value="<%=arrAcademy(1, i)%>" style="width:298px;">
			</div>
		</div>
		<%
			Next
		Else
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="academy_syear" name="academy_syear" value="" />
				<input type="hidden" id="academy_smonth" name="academy_smonth" value="" />
				<input type="hidden" id="academy_eyear" name="academy_eyear" value="" />
				<input type="hidden" id="academy_emonth" name="academy_emonth" value="" />

				<input type="text" name="academy_sdate" class="txt" placeholder="���۳�� (ex. 2019.02)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_education_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:298px;">
				<input type="text" name="academy_edate" class="txt" placeholder="������ (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_education_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:298px;">
				<input type="text" name="academy_name" class="txt" placeholder="������" style="width:298px;">
				<input type="text" name="academy_org_name" class="txt last" placeholder="�������" style="width:298px;">
			</div>
		</div>
		<%
		End If 
		%>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r7">�߰��ϱ�</button>
	</div>
</div><!-- ���� -->