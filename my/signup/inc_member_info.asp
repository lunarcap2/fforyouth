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
				<th><span>���̵�</span></th>
				<td>
					<input type="text" id="txtId" class="txt" name="txtId" placeholder="���̵� (5~12�� ����, ���� �Է�)" autocomplete="off" maxlength="12">
					<div class="rt">
						<div class="alertBox">
							<span class="bad" id="id_box"></span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->
				</td>
			</tr>
			<tr>
				<th rowspan="2"><span>��й�ȣ</span></th>
				<td>
					<input type="password" id="txtPass" class="txt" name="txtPass" placeholder="��й�ȣ (8~32�� ����, ���� �Է�)" autocomplete="new-password" maxlength="32">
					<div class="rt">
						<div class="alertBox">
							<span class="bad" id="pw_box"></span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->
				</td>
			</tr>
			<tr>
				<td>
					<input type="password" id="txtPassChk" class="txt" name="txtPassChk" placeholder="��й�ȣ Ȯ��" autocomplete="new-password" maxlength="32">
					<div class="rt">
						<div class="alertBox">
							<span class="bad" id="pw_box2"></span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->
				</td>
			</tr>
			<tr>
				<th><span>�̸���</span></th>
				<td>
					<input type="text" id="txtEmail" class="txt" name="txtEmail" placeholder="�̸���" autocomplete="off" maxlength="100">
					<div class="rt">
						<div class="alertBox">
							<span class="bad" id="mail_box"></span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->
				</td>
			</tr>
			<tr>
				<th><span>�޴��� ��ȣ</span></th>
				<td>
					<input type="text" id="txtPhone" class="txt" name="txtPhone" placeholder="�޴��� ��ȣ" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="return onlyNumber(event)" maxlength="13">
					<button type="button" class="inp_btn" id="aMobile" onclick="fn_chkJoin(); return false;">������ȣ ����</button>
					<div class="rt">											
						<div class="alertBox">
							<span class="num" id="timeCntdown" style="display:none;">(2:59)</span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->

					<div class="certification" id="rsltAuthArea" style="display:none;">
						<input type="text" id="mobileAuthNumber" class="txt" name="mobileAuthNumber" placeholder="������ȣ" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)">
						<button type="button" class="inp_btn" onclick="fnAuthNoChk(); return false;">���� Ȯ��</button>
						<div class="rt">
							<div class="alertBox">
								<span class="good" id="rsltMsg1" style="display:none;">������ȣ�� ���� �Է� �ƽ��ϴ�.</span>
								<span class="bad" id="rsltMsg2" style="display:none;">������ȣ�� Ʋ���ϴ�.</span>
							</div><!-- .alertBox -->
							
						</div><!-- .rt -->
					</div>
				</td>
			</tr>
		</tbody>
	</table>

	<label class="checkbox off" for="chkAgrPrv">
		<input type="checkbox" id="chkAgrPrv" class="chk" name="chkAgrPrv" value="1">
		<span>ä����� SMS / E-mail ���ſ� �����մϴ�.</span>
	</label>

	<div class="btn_area">
		<a href="javascript:;" class="btn" onclick="javascript:fn_step1();">������û�� �ۼ�</a>
	</div>
</div>