<%
	'�����ڵ� xml
	Dim arrListArea1 '1��
	arrListArea1 = getAreaList1() '/wwwconf/code/code_function_ac.asp

	ReDim arrListArea2(UBound(arrListArea1)) '2��
	For i=0 To UBound(arrListArea1)
		arrListArea2(i) = getArrJcList(arrListArea1(i,0))
	Next
%>

<div id="pop_dim" class="pop_dim"></div>
<div id="popup" class="popup small">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>����ٹ� ����<br><font color="red" size="4">(1����, 2���� ��� �ʼ� ����)</font></h3>
			<a href="javaScript:;" class="layer_close">��</a>	
		</div>
		<div class="pop_con">
			<div class="desired_area">
				<div class="left">
					<ul>
						<!-- 1������ -->
						<% For i=0 To UBound(arrListArea1) %>
						<li>
							<label class="radiobox off" for="da<%=i%>">
								<input type="radio" id="da<%=i%>" class="rdi" name="da" onclick="fn_set_area_change(this, '<%=i%>')">
								<span><%=arrListArea1(i, 1)%></span>
							</label>
						</li>
						<% Next %>
					</ul>
				</div>
				<div class="right">
					<!-- 2������ -->
					<% For i=0 To UBound(arrListArea1) %>
					<ul id="area_ul_<%=i%>" name="area_ul" style="display:none;">
						<% For ii=0 To UBound(arrListArea2(i)) %>
						<li>
							<label class="checkbox off">
								<input type="checkbox" class="chk" name="chk_area" onclick="fn_set_area2(this, '<%=arrListArea1(i, 0)%>', '<%=arrListArea1(i, 1)%>')" value="<%=arrListArea2(i)(ii, 0)%>">
								<span><%=arrListArea2(i)(ii, 1)%></span>
							</label>
						</li>
						<% Next %>
					</ul>
					<% Next %>
				</div>
				<table class="tb">
					<colgroup>
						<col style="width:133px;"/>
						<col />
					</colgroup>
					<tbody id="view_area_rank">
					</tbody>
				</table>
			</div>
		</div>
		<div class="pop_footer">
			<div class="btn_area">
				<a href="javaScript:;" class="btn gray" onclick="fn_save();">����</a>
				<a href="javaScript:;" class="btn white" onclick="javascript:$('.popup, .pop_dim').hide();">�ݱ�</a>
			</div>
		</div>
	</div>				
</div>