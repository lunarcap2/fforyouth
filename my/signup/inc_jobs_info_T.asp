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
				<th><span>이름</span></th>
				<td>
					<input type="text" id="txtName" class="txt" name="txtName" placeholder="이름을 입력해 주세요" autocomplete="off" maxlength="20">
					<script>
						$("#txtName").on("keydown keyup", function(){
							$("#joinNM").text($(this).val()); //inc_jobs_agree.asp에 값을 넣어줌
						});
					</script>
				</td>
			</tr>
			<tr>
				<th rowspan="2"><span>주소</span></th>
				<td>
					<input type="text" id="addr" class="txt" name="addr" placeholder="주소를 입력해 주세요" style="width:100%;" onclick="openPostCode('zipcode','addr', '');" readonly>
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="detailAddr" class="txt" name="detailAddr" placeholder="상세 주소를 입력해 주세요" style="width:100%;">
					<input type="hidden" id="zipcode" name="zipcode">
				</td>
			</tr>
			<tr>
				<th><span>주민등록번호</span></th>
				<td class="my_num">
					<input type="text" id="jumin1" class="txt" name="jumin1" placeholder="생년월일" autocomplete="off" style="width:185px;" maxlength="6" onkeyup="numCheck(this, 'int');">
					<em>-</em>
					<input type="password" id="jumin2" class="txt" name="jumin2" placeholder="-" autocomplete="off" style="width:185px;" maxlength="7" onkeyup="numCheck(this, 'int'); fn_jumin_set(this);">
					<label class="checkbox off" for="num1">
						<input type="checkbox" id="num1" class="chk" name="chk_num" value="1">
						<span>주민등록번호 수집동의</span>
					</label>
				</td>
				<script type="text/javascript">
					// 주민번호 뒷자리 입력시
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