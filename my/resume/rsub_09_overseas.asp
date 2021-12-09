<script type="text/javascript">

	function fn_overseas_s_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#abroad_syear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#abroad_smonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#abroad_syear").val("");
			$(obj).prevAll("#abroad_smonth").val("");
		}
	}
	function fn_overseas_e_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#abroad_eyear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#abroad_emonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#abroad_eyear").val("");
			$(obj).prevAll("#abroad_emonth").val("");
		}
	}

</script>

<div class="input_box" id ="resume9">
	<p class="ib_tit">해외경험</p>

	<div id="overseas_sel_option" style="display:none;">
	<% Call putCodeToatagOption("getNationCode", 1, 207, "1", "fn_sel_value_set", "abroad_nation_code") %>
	</div>
	<div class="ib_list add8">
		
		<%
		Dim abroad_sdate, abroad_edate
		If isArray(arrAbroad) Then
			For i=0 To UBound(arrAbroad, 2)
			If isDate(arrAbroad(3, i) & "-" & arrAbroad(4, i)) Then abroad_sdate = arrAbroad(3, i) & "." & arrAbroad(4, i)
			If isDate(arrAbroad(5, i) & "-" & arrAbroad(6, i)) Then abroad_edate = arrAbroad(5, i) & "." & arrAbroad(6, i)
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<input type="hidden" id="abroad_nation_code" name="abroad_nation_code" value="<%=arrAbroad(1, i)%>" />
				<input type="hidden" id="abroad_org_name" name="abroad_org_name" value="" />
				<input type="hidden" id="abroad_syear" name="abroad_syear" value="<%=arrAbroad(3, i)%>" />
				<input type="hidden" id="abroad_smonth" name="abroad_smonth" value="<%=arrAbroad(4, i)%>" />
				<input type="hidden" id="abroad_eyear" name="abroad_eyear" value="<%=arrAbroad(5, i)%>" />
				<input type="hidden" id="abroad_emonth" name="abroad_emonth" value="<%=arrAbroad(6, i)%>" />
	
				<input type="text" name="abroad_sdate" class="txt" placeholder="시작년월 (ex. 2019.02)" value="<%=abroad_sdate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_overseas_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">
				<input type="text" name="abroad_edate" class="txt" placeholder="종료년월 (ex. 2020.03)" value="<%=abroad_edate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_overseas_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">

				<div class="select_down" style="width:600px;" title="국가명">
					<div class="name">
						<a href="javaScript:;"><span><%=getNationCode(arrAbroad(1, i))%></span></a>
					</div>
					<div class="sel">
						<ul>
							<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
							<% Call putCodeToatagOption("getNationCode", 1, 207, "1", "fn_sel_value_set", "abroad_nation_code") %>
						</ul>
					</div>
				</div>

				<textarea class="area" name="abroad_academy_name" placeholder="해외에서 어떤 경험을 했는지 적어주세요 (ex. 어학연수, 교환학생, 워킹 홀리데이, 해외근무)" onkeyup="FC_ChkTextLen(this, 100)"><%=arrAbroad(7, i)%></textarea>
			</div>
		</div>
		<%
			Next
		Else
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<input type="hidden" id="abroad_nation_code" name="abroad_nation_code" value="" />
				<input type="hidden" id="abroad_org_name" name="abroad_org_name" value="" />
				<input type="hidden" id="abroad_syear" name="abroad_syear" value="" />
				<input type="hidden" id="abroad_smonth" name="abroad_smonth" value="" />
				<input type="hidden" id="abroad_eyear" name="abroad_eyear" value="" />
				<input type="hidden" id="abroad_emonth" name="abroad_emonth" value="" />
	
				<input type="text" name="abroad_sdate" class="txt" placeholder="시작년월 (ex. 2019.02)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_overseas_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">
				<input type="text" name="abroad_edate" class="txt" placeholder="종료년월 (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_overseas_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">

				<div class="select_down" style="width:600px;" title="국가명">
					<div class="name">
						<a href="javaScript:;"><span>국가명</span></a>
					</div>
					<div class="sel">
						<ul>
							<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
							<% Call putCodeToatagOption("getNationCode", 1, 207, "1", "fn_sel_value_set", "abroad_nation_code") %>
						</ul>
					</div>
				</div>

				<textarea class="area" name="abroad_academy_name" placeholder="해외에서 어떤 경험을 했는지 적어주세요 (ex. 어학연수, 교환학생, 워킹 홀리데이, 해외근무)" onkeyup="FC_ChkTextLen(this, 100)"></textarea>
			</div>
		</div>
		<%
		End If
		%>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r8">추가하기</button>
	</div>
</div><!-- 해외경험 -->