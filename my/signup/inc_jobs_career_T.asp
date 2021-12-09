<div class="titArea">
	<h4>희망 취업조건</h4>
</div><!-- .titArea -->
<div class="inputArea">
	<table class="tb">
		<colgroup>
			<col style="width:170px;"/>
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><span>희망직종</span></th>
				<td class="tb_sch">
					<input type="text" id="jc_name" class="txt sch" name="jc_name" placeholder="희망 직무를 입력해 주세요" onkeyup="fn_kwSearchItem2(this)" autocomplete="off">
					<div class="sch_box" style="width:285px;" id="id_sch_box2" />
				</td>
			</tr>
			<tr>
				<th>희망 입사형태</th>
				<td>
					<label class="radiobox off" for="career1">
						<input type="radio" id="career1" class="rdi" name="career" value="1">
						<span>신입</span>
					</label>
					<label class="radiobox off" for="career2">
						<input type="radio" id="career2" class="rdi" name="career" value="8">
						<span>경력</span>
					</label>
					
					<div class="career_box">
						<div>
							<input type="text" id="career_year" class="txt" name="career_year" style="width:185px;" maxlength="2" onkeyup="numCheck(this, 'int');">
							<em class="txt">년</em>
							<div class="select_box" title="선택" style="width:185px;">
									<div class="name"><a href="#none"><span>선택</span></a></div>
									<div class="sel">
										<ul>
											<li><a href="#none">선택</a></li>
											<% For i = 1 To 11 %>
											<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_career_month', '<%=i%>');"><%=i%></a></li>
											<% Next %>
										</ul>
									</div>
								</div>
							<em class="txt">개월</em>
						</div>
					</div>

					<script>
					$('.radiobox .rdi').on('click', function() {
						if ($('#career2').is(':checked')) {
							$('.tb .career_box div').show();
						} else {
							$('.tb .career_box div').hide();
							$("#career_year").val("");
							$("#hdn_career_month").val("");
						}
					});
					</script>
				</td>
			</tr>
			<tr>
				<th>희망 직무내용</th>
				<td>
					<input type="text" id="jc_content" class="txt" name="jc_content" placeholder="희망 직무를 입력해 주세요">	
				</td>
			</tr>
			<tr>
				<th><span>희망근무지역<br><font color="red">(1순위, 2순위<br>모두 필수 선택)</font></span></th>
				<td>
					<div class="area">
						<input type="hidden" id="area_check_cnt2" name="area_check_cnt2" value="0" />
						<input type="hidden" id="area_check_rank" name="area_check_rank" value="0" />

						<label for="area1">1순위</label>
						<input type="text" id="area1" class="txt pop" name="area" placeholder="희망 근무지역을 입력해 주세요" onclick="fn_reset();" autocomplete="off">
						<br>
						<label for="area2">2순위</label>
						<input type="text" id="area2" class="txt pop" name="area" placeholder="희망 근무지역을 입력해 주세요" onclick="fn_reset();" autocomplete="off">
						<br>
						<label class="checkbox on" for="home">
							<input type="checkbox" id="home" class="chk" name="home" value="1" onclick="fn_reset();">
							<span>재택근무</span>
						</label>

						<script>
						$("")
						$(".area #home").change(function(){
							if($(this).is(":checked")){
								$(".area .txt").attr("disabled",true).attr("readonly",true);

								// 하단부 지역표기 초기화
								$("[name='area']").val("");

								// 지역2차 체크박스 전체해제
								$('input:checkbox[name="chk_area"]').each(function() {
									this.checked = false;
								});

								$("#hdn_area").val("");

								checkboxFnc();//체크박스
							}else{
								$(".area .txt").attr("disabled",false).attr("readonly",false);
							}
						});
						</script>
					</div>
				</td>
			</tr>
			<tr>
				<th rowspan="2"><span>고용형태<br>(복수 선택가능)</span></th>
				<td class="employ">
					<label class="checkbox" for="employ1">
						<input type="checkbox" id="employ1" class="chk" name="chk_employ" value="1">
						<span>기간에 정함이 없는 근로계약 (정규직)</span>
					</label>
					<label class="checkbox" for="employ2">
						<input type="checkbox" id="employ2" class="chk" name="chk_employ" value="7">
						<span>기간에 정함이 있는 근로계약 (계약직)</span>
					</label>
					<label class="checkbox" for="employ3">
						<input type="checkbox" id="employ3" class="chk" name="chk_employ" value="9">
						<span>파견근로</span>
					</label>
				</td>
			</tr>
			<tr>
				<td class="employ">
					<label class="checkbox" for="employ4">
						<input type="checkbox" id="employ4" class="chk" name="chk_employ" value="00">
						<span>시간제</span>
					</label>
					<span class="red_txt">※ 위의 3가지 고용형태를 시간제로 원하는 경우에만 선택</span>
				</td>	
			</tr>
			<tr>
				<th><span>희망 입금형태 및 금액</span></th>
				<td>
					<div class="money">
						<div class="select_box" title="임금형태">
							<div class="name"><a href="#none"><span>임금형태</span></a></div>
							<div class="sel">
								<ul>
									<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_salary', '1');">연봉</a></li>
									<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_salary', '2');">월급</a></li>
									<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_salary', '3');">일급</a></li>
									<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_salary', '4');">시급</a></li>
								</ul>
							</div>
						</div>
						<br>
						<input type="text" id="salary_txt" class="txt" name="salary_txt" placeholder="" disabled onkeyup="numCheck(this, 'int'); this.value=numbeComma(this.value);">
						<em class="txt">만원 이상</em>
						<label class="checkbox off" for="money1">
							<input type="checkbox" id="money1" class="chk" name="chk_money" value="98">
							<span>면접 후 결정</span>
						</label>
					</div>
					<script>
					$(function(){
						$('.money .select_box .sel ul li a').click(function(){
							var text = $(this).html();
							$(this).parents('.sel').prev('.name').find('span').html(text);
							$(this).parents('.select_box').removeClass( 'on' );
							$(".money .txt").attr("disabled",false).attr("readonly",false);
							$('.money em.txt').html('만원 이상');
						});

						$('.money .select_box .sel ul li:nth-child(3) a, .money .select_box .sel ul li:nth-child(4) a').click(function(){
							$('.money em.txt').html('원 이상');
						});

						$('.money .select_box .sel ul li:nth-child(2) a, .money .select_box .sel ul li:nth-child(4) a').click(function(){
							$('#salary_txt').attr("maxlength", "5");
						});

						$('.money .select_box .sel ul li:nth-child(1) a, .money .select_box .sel ul li:nth-child(3) a').click(function(){
							$('#salary_txt').attr("maxlength", "6");
						});

						$(".money #money1").change(function(){
							if($(this).is(":checked")){
								$('.money .select_box').addClass('disabled');
								$(".money .txt").attr("disabled",true).attr("readonly",true);
								$('.money .select_box .sel').prev('.name').find('span').html('임금형태');
								$('.money em.txt').html('만원 이상');
								$("#hdn_salary").val("98");
								$("#salary_txt").val("");
							}else{
								$('.money .select_box').removeClass('disabled');
								$(".money .txt").attr("disabled",false).attr("readonly",false);
								$("#hdn_salary").val("");
							}
						});
																	
					});

					</script>
				</td>	
			</tr>
		</tbody>
	</table>
</div>