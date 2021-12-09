<div class="inputArea">
	<table class="tb">
		<colgroup>
			<col style="width:170px;"/>
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><span>구직알선희망정도</span></th>
				<td>
					<label class="radiobox off" for="hire_h1">
						<input type="radio" id="hire_h1" class="rdi" name="hire_h2" value="1">
						<span>알선필요</span>
					</label>
				</td>
			</tr>
			<tr>
				<th><span>구직정보<br> 제공동의 여부</span></th>
				<td>
					<label class="checkbox" for="hire_info3">
						<input type="checkbox" id="hire_info3" class="chk" name="hire_info" value="3">
						<span>지방자치단체제공 동의</span>
					</label>
				</td>
				<script>
					// 동의하지 않음을 선택시 나머지 선택한 부분 해제
					$(document).ready(function () {
						$("input:checkbox[name='hire_info']").click(function() {
							if ($("input:checkbox[name=hire_info][value='0']").prop("checked")) {
								$("input:checkbox[name=hire_info]").prop("checked",false);
								$(this).prop("checked", true);

								checkboxFnc(); //체크박스
							}
						});
					});
				</script>
			</tr>
			<tr>
				<th><span>개인정보<br> 조회 동의 여부</span></th>
				<td>
					<label class="radiobox off" for="individual_info1">
						<input type="radio" id="individual_info1" class="rdi" name="individual_info" value="1">
						<span>동의</span>
					</label>
					<p class="agree">
						※신청인의 고용보험가입 이력 등 개인정보를 조회하는 것에 대한 동의 여부 입니다.
					</p>
				</td>
			</tr>
		</tbody>
	</table>
	<p class="apply">
		* 구직알선 / 구직정보제공 / 개인정보 조회에 동의하지 않으시면 온라인 박람회 참여가 불가능합니다.<br>
		[직업안정법 시행규칙] 제2조 제1항에 따라 위와 같이 구직신청 합니다.
	</p>

	<div class="txt_area">
		<p><%=Year(Now()) & "년 " & Month(Now()) & "월 " & Day(Now()) & "일 "%> <span id="joinNM">OOO</span>님께서 직접 작성한 구직신청서 입니다.</p>
	</div>

	<div class="btn_area">
		<a href="javascript:;" class="btn v2" onclick="javascript:fn_step2();">구직신청서 작성완료</a>
	</div>
</div>