<script type="text/javascript">
	function fn_awards_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#prize_year").val(obj.value.substr(0, 4));
			$(obj).prevAll("#prize_month").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#prize_year").val("");
			$(obj).prevAll("#prize_month").val("");
		}
	}
</script>

<div class="input_box" id ="resume7">
	<p class="ib_tit">수상</p>
	<div class="ib_list add6">
		<%
		Dim prize_date
		If isArray(arrPrize) Then
			For i=0 To UBound(arrPrize, 2)
			If isDate(arrPrize(3, i) & "-" & arrPrize(4, i)) Then prize_date = arrPrize(3, i) & "." & arrPrize(4, i)
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<input type="hidden" id="prize_year" name="prize_year" value="<%=arrPrize(3, i)%>" />
				<input type="hidden" id="prize_month" name="prize_month" value="<%=arrPrize(4, i)%>" />
				<input type="text" name="prize_date" class="txt" placeholder="수상년월 (ex. 2020.03)" value="<%=prize_date%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_awards_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">
				<input type="text" name="prize_name" class="txt" placeholder="수상명" value="<%=arrPrize(2, i)%>" style="width:595px;">
				<input type="text" name="prize_org_name" class="txt last" placeholder="수상기관" value="<%=arrPrize(1, i)%>" style="width:310px;">
			</div>
		</div>
		<%
			Next
		Else
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<input type="hidden" id="prize_year" name="prize_year" value="" />
				<input type="hidden" id="prize_month" name="prize_month" value="" />
				<input type="text" name="prize_date" class="txt" placeholder="수상년월 (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_awards_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">
				<input type="text" name="prize_name" class="txt" placeholder="수상명" style="width:595px;">
				<input type="text" name="prize_org_name" class="txt last" placeholder="수상기관" style="width:310px;">
			</div>
		</div>
		<% End If %>
	</div>
	<div class="add_box">
		<button type="button" class="addItem r6">추가하기</button>
	</div>
</div><!-- 수상 -->