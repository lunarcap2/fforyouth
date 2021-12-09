<div class="titArea">
	<h4>��� �������</h4>
</div><!-- .titArea -->
<div class="inputArea">
	<table class="tb">
		<colgroup>
			<col style="width:170px;"/>
			<col/>
		</colgroup>
		<tbody>
			<tr>
				<th><span>�������</span></th>
				<td class="tb_sch">
					<input type="text" id="jc_name" class="txt sch" name="jc_name" placeholder="��� ������ �Է��� �ּ���" onkeyup="fn_kwSearchItem2(this)" autocomplete="off">
					<div class="sch_box" style="width:285px;" id="id_sch_box2" />
				</td>
			</tr>
			<tr>
				<th>��� �Ի�����</th>
				<td>
					<label class="radiobox off" for="career1">
						<input type="radio" id="career1" class="rdi" name="career" value="1">
						<span>����</span>
					</label>
					<label class="radiobox off" for="career2">
						<input type="radio" id="career2" class="rdi" name="career" value="8">
						<span>���</span>
					</label>
					
					<div class="career_box">
						<div>
							<input type="text" id="career_year" class="txt" name="career_year" style="width:185px;" maxlength="2" onkeyup="numCheck(this, 'int');">
							<em class="txt">��</em>
							<div class="select_box" title="����" style="width:185px;">
									<div class="name"><a href="#none"><span>����</span></a></div>
									<div class="sel">
										<ul>
											<li><a href="#none">����</a></li>
											<% For i = 1 To 11 %>
											<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_career_month', '<%=i%>');"><%=i%></a></li>
											<% Next %>
										</ul>
									</div>
								</div>
							<em class="txt">����</em>
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
				<th>��� ��������</th>
				<td>
					<input type="text" id="jc_content" class="txt" name="jc_content" placeholder="��� ������ �Է��� �ּ���">	
				</td>
			</tr>
			<tr>
				<th><span>����ٹ�����<br><font color="red">(1����, 2����<br>��� �ʼ� ����)</font></span></th>
				<td>
					<div class="area">
						<input type="hidden" id="area_check_cnt2" name="area_check_cnt2" value="0" />
						<input type="hidden" id="area_check_rank" name="area_check_rank" value="0" />

						<label for="area1">1����</label>
						<input type="text" id="area1" class="txt pop" name="area" placeholder="��� �ٹ������� �Է��� �ּ���" onclick="fn_reset();" autocomplete="off">
						<br>
						<label for="area2">2����</label>
						<input type="text" id="area2" class="txt pop" name="area" placeholder="��� �ٹ������� �Է��� �ּ���" onclick="fn_reset();" autocomplete="off">
						<br>
						<label class="checkbox on" for="home">
							<input type="checkbox" id="home" class="chk" name="home" value="1" onclick="fn_reset();">
							<span>���ñٹ�</span>
						</label>

						<script>
						$("")
						$(".area #home").change(function(){
							if($(this).is(":checked")){
								$(".area .txt").attr("disabled",true).attr("readonly",true);

								// �ϴܺ� ����ǥ�� �ʱ�ȭ
								$("[name='area']").val("");

								// ����2�� üũ�ڽ� ��ü����
								$('input:checkbox[name="chk_area"]').each(function() {
									this.checked = false;
								});

								$("#hdn_area").val("");

								checkboxFnc();//üũ�ڽ�
							}else{
								$(".area .txt").attr("disabled",false).attr("readonly",false);
							}
						});
						</script>
					</div>
				</td>
			</tr>
			<tr>
				<th rowspan="2"><span>�������<br>(���� ���ð���)</span></th>
				<td class="employ">
					<label class="checkbox" for="employ1">
						<input type="checkbox" id="employ1" class="chk" name="chk_employ" value="1">
						<span>�Ⱓ�� ������ ���� �ٷΰ�� (������)</span>
					</label>
					<label class="checkbox" for="employ2">
						<input type="checkbox" id="employ2" class="chk" name="chk_employ" value="7">
						<span>�Ⱓ�� ������ �ִ� �ٷΰ�� (�����)</span>
					</label>
					<label class="checkbox" for="employ3">
						<input type="checkbox" id="employ3" class="chk" name="chk_employ" value="9">
						<span>�İ߱ٷ�</span>
					</label>
				</td>
			</tr>
			<tr>
				<td class="employ">
					<label class="checkbox" for="employ4">
						<input type="checkbox" id="employ4" class="chk" name="chk_employ" value="00">
						<span>�ð���</span>
					</label>
					<span class="red_txt">�� ���� 3���� ������¸� �ð����� ���ϴ� ��쿡�� ����</span>
				</td>	
			</tr>
			<tr>
				<th><span>��� �Ա����� �� �ݾ�</span></th>
				<td>
					<div class="money">
						<div class="select_box" title="�ӱ�����">
							<div class="name"><a href="#none"><span>�ӱ�����</span></a></div>
							<div class="sel">
								<ul>
									<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_salary', '1');">����</a></li>
									<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_salary', '2');">����</a></li>
									<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_salary', '3');">�ϱ�</a></li>
									<li><a href="javascript:;" onclick="fn_sel_val_set(this, 'hdn_salary', '4');">�ñ�</a></li>
								</ul>
							</div>
						</div>
						<br>
						<input type="text" id="salary_txt" class="txt" name="salary_txt" placeholder="" disabled onkeyup="numCheck(this, 'int'); this.value=numbeComma(this.value);">
						<em class="txt">���� �̻�</em>
						<label class="checkbox off" for="money1">
							<input type="checkbox" id="money1" class="chk" name="chk_money" value="98">
							<span>���� �� ����</span>
						</label>
					</div>
					<script>
					$(function(){
						$('.money .select_box .sel ul li a').click(function(){
							var text = $(this).html();
							$(this).parents('.sel').prev('.name').find('span').html(text);
							$(this).parents('.select_box').removeClass( 'on' );
							$(".money .txt").attr("disabled",false).attr("readonly",false);
							$('.money em.txt').html('���� �̻�');
						});

						$('.money .select_box .sel ul li:nth-child(3) a, .money .select_box .sel ul li:nth-child(4) a').click(function(){
							$('.money em.txt').html('�� �̻�');
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
								$('.money .select_box .sel').prev('.name').find('span').html('�ӱ�����');
								$('.money em.txt').html('���� �̻�');
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