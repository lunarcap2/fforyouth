
<div class="input_box" id ="resume13">
	<p class="ib_tit">�ڱ�Ұ���</p>
	<div class="ib_list add9">
		
		<%
		If isArray(arrEssay) Then
			For i=0 To UBound(arrEssay, 2)
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="res_seq" name="res_seq" value="0">
				<input type="text" id="res_quotation" name="res_quotation" value="<%=arrEssay(4, i)%>" class="txt" placeholder="�׸� ����" style="width:100%;">
				<textarea class="resume_tt" id="res_content" name="res_content" placeholder="�ش� ������ �Է����ּ���."><%=arrEssay(5, i)%></textarea>
			</div>
		</div>
		<% 
			Next
		Else 
		%>
		<div class="ib_move non">
			<div class="deleteBox">����</div>
			<div class="ib_m_box">
				<input type="hidden" id="res_seq" name="res_seq" value="0">
				<input type="text" id="res_quotation" name="res_quotation" class="txt" placeholder="�׸� ����" style="width:100%;">
				<textarea class="resume_tt" id="res_content" name="res_content" placeholder="�ش� ������ �Է����ּ���."></textarea>
			</div>
		</div>
		<% End If %>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r9">�߰��ϱ�</button>
	</div>
</div><!-- �ڱ�Ұ��� -->