<script type="text/javascript">
	function fn_license_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#license_year").val(obj.value.substr(0, 4));
			$(obj).prevAll("#license_month").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#license_year").val("");
			$(obj).prevAll("#license_month").val("");
		}
	}
</script>

<div class="input_box" id ="resume6">
	<p class="ib_tit">�ڰ���</p>
	<div class="ib_list add5">
		<%
		Dim license_date
		If isArray(arrLicense) Then
			For i=0 To UBound(arrLicense, 2)
			If isDate(arrLicense(3, i) & "-" & arrLicense(4, i)) Then license_date = arrLicense(3, i) & "." & arrLicense(4, i)
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" name="license_code" value="" />
				<input type="hidden" id="license_year" name="license_year" value="<%=arrLicense(3, i)%>" />
				<input type="hidden" id="license_month" name="license_month" value="<%=arrLicense(4, i)%>" />

				<input type="text" name="license_date" class="txt" placeholder="����� (ex. 2020.03)" value="<%=license_date%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_license_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">
				<div class="search_box" style="width:595px;">
					<input type="text" id="license_name" name="license_name" class="txt" placeholder="�ڰ�����" value="<%=arrLicense(1, i)%>" onkeyup="fn_kwSearchItem(this, 'license')" style="width:595px;">
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
				<input type="text" name="license_org" class="txt last" placeholder="�߱ޱ��" value="<%=arrLicense(2, i)%>" style="width:310px;">
			</div>
		</div>
		<%
			Next
		Else
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" name="license_code" value="" />
				<input type="hidden" id="license_year" name="license_year" value="" />
				<input type="hidden" id="license_month" name="license_month" value="" />

				<input type="text" name="license_date" class="txt" placeholder="����� (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_license_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">
				<div class="search_box" style="width:595px;">
					<input type="text" id="license_name" name="license_name" class="txt" placeholder="�ڰ�����" onkeyup="fn_kwSearchItem(this, 'license')" style="width:595px;">
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
				<input type="text" name="license_org" class="txt last" placeholder="�߱ޱ��" style="width:310px;">
			</div>
		</div>
		<%
		End If 
		%>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r5">�߰��ϱ�</button>
	</div>
</div><!-- �ڰ��� -->