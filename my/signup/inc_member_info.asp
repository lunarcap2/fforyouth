<div class="titArea">
	<h4>회원정보 입력</h4>
</div><!-- .titArea -->
<div class="inputArea">
	<table class="tb">
		<colgroup>
			<col style="width:170px;"/>
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><span>아이디</span></th>
				<td>
					<input type="text" id="txtId" class="txt" name="txtId" placeholder="아이디 (5~12자 영문, 숫자 입력)" autocomplete="off" maxlength="12">
					<div class="rt">
						<div class="alertBox">
							<span class="bad" id="id_box"></span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->
				</td>
			</tr>
			<tr>
				<th rowspan="2"><span>비밀번호</span></th>
				<td>
					<input type="password" id="txtPass" class="txt" name="txtPass" placeholder="비밀번호 (8~32자 영문, 숫자 입력)" autocomplete="new-password" maxlength="32">
					<div class="rt">
						<div class="alertBox">
							<span class="bad" id="pw_box"></span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->
				</td>
			</tr>
			<tr>
				<td>
					<input type="password" id="txtPassChk" class="txt" name="txtPassChk" placeholder="비밀번호 확인" autocomplete="new-password" maxlength="32">
					<div class="rt">
						<div class="alertBox">
							<span class="bad" id="pw_box2"></span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->
				</td>
			</tr>
			<tr>
				<th><span>이메일</span></th>
				<td>
					<input type="text" id="txtEmail" class="txt" name="txtEmail" placeholder="이메일" autocomplete="off" maxlength="100">
					<div class="rt">
						<div class="alertBox">
							<span class="bad" id="mail_box"></span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->
				</td>
			</tr>
			<tr>
				<th><span>휴대폰 번호</span></th>
				<td>
					<input type="text" id="txtPhone" class="txt" name="txtPhone" placeholder="휴대폰 번호" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="return onlyNumber(event)" maxlength="13">
					<button type="button" class="inp_btn" id="aMobile" onclick="fn_chkJoin(); return false;">인증번호 전송</button>
					<div class="rt">											
						<div class="alertBox">
							<span class="num" id="timeCntdown" style="display:none;">(2:59)</span>
						</div><!-- .alertBox -->
					</div><!-- .rt -->

					<div class="certification" id="rsltAuthArea" style="display:none;">
						<input type="text" id="mobileAuthNumber" class="txt" name="mobileAuthNumber" placeholder="인증번호" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)">
						<button type="button" class="inp_btn" onclick="fnAuthNoChk(); return false;">인증 확인</button>
						<div class="rt">
							<div class="alertBox">
								<span class="good" id="rsltMsg1" style="display:none;">인증번호가 정상 입력 됐습니다.</span>
								<span class="bad" id="rsltMsg2" style="display:none;">인증번호가 틀립니다.</span>
							</div><!-- .alertBox -->
							
						</div><!-- .rt -->
					</div>
				</td>
			</tr>
		</tbody>
	</table>

	<label class="checkbox off" for="chkAgrPrv">
		<input type="checkbox" id="chkAgrPrv" class="chk" name="chkAgrPrv" value="1">
		<span>채용관련 SMS / E-mail 수신에 동의합니다.</span>
	</label>

	<div class="btn_area">
		<a href="javascript:;" class="btn" onclick="javascript:fn_step1();">구직신청서 작성</a>
	</div>
</div>