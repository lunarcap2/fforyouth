<div class="titArea">
	<h4>ȸ������ �Է�</h4>
</div><!-- .titArea -->
<div class="inputArea">
	<table class="tb">
		<colgroup>
			<col style="width:170px;"/>
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><span>�̸�</span></th>
				<td>
					<input type="text" id="txtName" class="txt" name="txtName" placeholder="�̸��� �Է��� �ּ���" autocomplete="off" maxlength="20">
					<script>
						$("#txtName").on("keydown keyup", function(){
							$("#joinNM").text($(this).val()); //inc_jobs_agree.asp�� ���� �־���
						});
					</script>
				</td>
			</tr>
			<tr>
				<th rowspan="2"><span>�ּ�</span></th>
				<td>
					<input type="text" id="addr" class="txt" name="addr" placeholder="�ּҸ� �Է��� �ּ���" style="width:100%;" onclick="openPostCode('zipcode','addr', '');" readonly>
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="detailAddr" class="txt" name="detailAddr" placeholder="�� �ּҸ� �Է��� �ּ���" style="width:100%;">
					<input type="hidden" id="zipcode" name="zipcode">
				</td>
			</tr>
			<tr>
				<th><span>�ֹε�Ϲ�ȣ</span></th>
				<td class="my_num">
					<input type="text" id="jumin1" class="txt" name="jumin1" placeholder="�������" autocomplete="off" style="width:185px;" maxlength="6" onkeyup="numCheck(this, 'int');">
					<em>-</em>
					<input type="password" id="jumin2" class="txt" name="jumin2" placeholder="-" autocomplete="off" style="width:185px;" maxlength="7" onkeyup="numCheck(this, 'int'); fn_jumin_set(this);">
					<label class="checkbox off" for="num1">
						<input type="checkbox" id="num1" class="chk" name="chk_num" value="1">
						<span>�ֹε�Ϲ�ȣ ��������</span>
					</label>
				</td>
				<script type="text/javascript">
					// �ֹι�ȣ ���ڸ� �Է½�
					function fn_jumin_set(obj) {
						if (obj.value.length == 7) {
							$("#juminH").val(obj.value);
						}
						else {
							$("#juminH").val("");
						}
					}
				</script>
			</tr>
		</tbody>
	</table>
</div>