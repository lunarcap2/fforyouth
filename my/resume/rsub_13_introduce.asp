
<div class="input_box" id ="resume13">
	<p class="ib_tit">자기소개서</p>
	<div class="ib_list add9">
		
		<%
		If isArray(arrEssay) Then
			For i=0 To UBound(arrEssay, 2)
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<input type="hidden" id="res_seq" name="res_seq" value="0">
				<input type="text" id="res_quotation" name="res_quotation" value="<%=arrEssay(4, i)%>" class="txt" placeholder="항목 제목" style="width:100%;">
				<textarea class="resume_tt" id="res_content" name="res_content" placeholder="해당 내용을 입력해주세요."><%=arrEssay(5, i)%></textarea>
			</div>
		</div>
		<% 
			Next
		Else 
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<input type="hidden" id="res_seq" name="res_seq" value="0">
				<input type="text" id="res_quotation" name="res_quotation" class="txt" placeholder="항목 제목" style="width:100%;">
				<textarea class="resume_tt" id="res_content" name="res_content" placeholder="해당 내용을 입력해주세요."></textarea>
			</div>
		</div>
		<% End If %>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r9">추가하기</button>
	</div>
</div><!-- 자기소개서 -->