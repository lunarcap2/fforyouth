<div class="inputArea">
	<table class="tb">
		<colgroup>
			<col style="width:170px;"/>
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><span>�����˼��������</span></th>
				<td>
					<label class="radiobox off" for="hire_h1">
						<input type="radio" id="hire_h1" class="rdi" name="hire_h2" value="1">
						<span>�˼��ʿ�</span>
					</label>
				</td>
			</tr>
			<tr>
				<th><span>��������<br> �������� ����</span></th>
				<td>
					<label class="checkbox" for="hire_info3">
						<input type="checkbox" id="hire_info3" class="chk" name="hire_info" value="3">
						<span>������ġ��ü���� ����</span>
					</label>
				</td>
				<script>
					// �������� ������ ���ý� ������ ������ �κ� ����
					$(document).ready(function () {
						$("input:checkbox[name='hire_info']").click(function() {
							if ($("input:checkbox[name=hire_info][value='0']").prop("checked")) {
								$("input:checkbox[name=hire_info]").prop("checked",false);
								$(this).prop("checked", true);

								checkboxFnc(); //üũ�ڽ�
							}
						});
					});
				</script>
			</tr>
			<tr>
				<th><span>��������<br> ��ȸ ���� ����</span></th>
				<td>
					<label class="radiobox off" for="individual_info1">
						<input type="radio" id="individual_info1" class="rdi" name="individual_info" value="1">
						<span>����</span>
					</label>
					<p class="agree">
						�ؽ�û���� ��뺸�谡�� �̷� �� ���������� ��ȸ�ϴ� �Ϳ� ���� ���� ���� �Դϴ�.
					</p>
				</td>
			</tr>
		</tbody>
	</table>
	<p class="apply">
		* �����˼� / ������������ / �������� ��ȸ�� �������� �����ø� �¶��� �ڶ�ȸ ������ �Ұ����մϴ�.<br>
		[���������� �����Ģ] ��2�� ��1�׿� ���� ���� ���� ������û �մϴ�.
	</p>

	<div class="txt_area">
		<p><%=Year(Now()) & "�� " & Month(Now()) & "�� " & Day(Now()) & "�� "%> <span id="joinNM">OOO</span>�Բ��� ���� �ۼ��� ������û�� �Դϴ�.</p>
	</div>

	<div class="btn_area">
		<a href="javascript:;" class="btn v2" onclick="javascript:fn_step2();">������û�� �ۼ��Ϸ�</a>
	</div>
</div>