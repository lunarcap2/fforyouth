<%
'arrPersonal		= arrData(0)(14)'보훈/장애
'arrMilitary		= arrData(0)(15)'병역
'arrEmpSupport	= arrData(0)(16)'고용지원금대상

Dim patriot_flag, protect_flag, handicap_flag, handicap_grd, handicap_grd_nm, emp_support_flag
Dim military_yn, military_nm, kind_class_nm, military_kind, military_class
Dim military_sdate, military_syear, military_smonth, military_edate, military_eyear, military_emonth, military_end

handicap_grd_nm = "장애등급"
If isArray(arrPersonal) Then 
	patriot_flag = arrPersonal(0, 0)	'보훈
	protect_flag = arrPersonal(5, 0)	'취업보호대상
	handicap_flag = arrPersonal(1, 0)	'장애
	handicap_grd = arrPersonal(2, 0)	'장애등급
	Select Case handicap_grd
		Case "1" : handicap_grd_nm = "1급"
		Case "2" : handicap_grd_nm = "2급"
		Case "3" : handicap_grd_nm = "3급"
		Case "4" : handicap_grd_nm = "4급"
		Case "5" : handicap_grd_nm = "5급"
		Case "6" : handicap_grd_nm = "6급"
		Case Else :handicap_grd_nm = "장애등급"
	End Select 
End If

If isArray(arrEmpSupport) Then 
	emp_support_flag = arrEmpSupport(0, 0) '고용지원금
End If

military_nm = "병역상태"
kind_class_nm = "군별/제대계급"
If isArray(arrMilitary) Then
	military_yn		= arrMilitary(0, 0)
	military_syear	= arrMilitary(3, 0)
	military_smonth	= arrMilitary(4, 0)
	military_eyear	= arrMilitary(5, 0)
	military_emonth	= arrMilitary(6, 0)
	military_kind	= Trim(arrMilitary(1, 0))
	military_class	= Trim(arrMilitary(2, 0))
	military_end	= arrMilitary(10, 0)

	Select Case military_yn
		Case "1" : military_nm = "군필"
		Case "2" : military_nm = "미필"
		Case "3" : military_nm = "면제"
		Case "4" : military_nm = "복무중"
		Case "5" : military_nm = "해당없음"
		Case Else : military_nm = "병역상태"
	End Select
	
	If isDate(military_syear & "-" & military_smonth) Then military_sdate = military_syear & "." & military_smonth
	If isDate(military_eyear & "-" & military_emonth) Then military_edate = military_eyear & "." & military_emonth

	If military_kind <> "" And military_class <> "" Then
		kind_class_nm = getMilitaryKind(military_kind) & "/" & getMilitaryClass(military_class)
	End If
End If
%>

<script type="text/javascript">
	
	$(document).ready(function () {
		var patriot_flag, protect_flag, handicap_flag, emp_support_flag, military_yn, military_kind, military_class
		
		patriot_flag = "<%=patriot_flag%>";
		protect_flag = "<%=protect_flag%>";
		handicap_flag = "<%=handicap_flag%>";
		emp_support_flag = "<%=emp_support_flag%>";
		military_yn = "<%=military_yn%>";
		military_kind = "<%=military_kind%>";
		military_class = "<%=military_class%>";

		if (patriot_flag == "1") {
			$("#patriot_flag").click();
		}
		if (protect_flag == "1") {
			$("#protect_flag").click();
		}
		if (handicap_flag == "1") {
			$("#handicap_flag").click();
			$('.chk_input.n1').show();
		}
		if (emp_support_flag == "1") {
			$("#emp_support_flag").click();
		}
		if (military_yn != "") {
			$("#military_chk").click();
			$('.chk_input.n2').show();

			if(military_yn == '2' || military_yn == '3' || military_yn == '5') {
				if(military_yn == '2' || military_yn == '3') {
					$('#military_end').show();
				}

				$('[name="div_military"]').attr('style','display:none;');
			}
			else {
				$('[name="military_kind"]').each(function() {
					if (this.value == military_kind) {
						this.checked = true; //checked 처리
					}
				});
				
				$('[name="military_class"]').each(function() {
					if (this.value == military_class) {
						this.checked = true; //checked 처리
					}
				});

				$('[name="div_military"]').attr('style','display:inline-block;');
			}
		}
	});

	function fn_military_s_div(obj) {
		if (obj.value.length == 7) {
			$(obj).parents(".ib_m_box").children("#military_syear").val(obj.value.substr(0, 4));
			$(obj).parents(".ib_m_box").children("#military_smonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).parents(".ib_m_box").children("#military_syear").val("");
			$(obj).parents(".ib_m_box").children("#military_smonth").val("");
		}
	}
	function fn_military_e_div(obj) {
		if (obj.value.length == 7) {
			$(obj).parents(".ib_m_box").children("#military_eyear").val(obj.value.substr(0, 4));
			$(obj).parents(".ib_m_box").children("#military_emonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).parents(".ib_m_box").children("#military_eyear").val("");
			$(obj).parents(".ib_m_box").children("#military_emonth").val("");
		}
	}

	function fn_reset_military() {
		
		$("#kind_class_nm").html("군별/제대계급");

		
		$('input:radio[name="military_kind"]').attr("checked", false);
		$('input:radio[name="military_class"]').attr("checked", false);
		radioboxFnc();//라디오박스
		
		/*
		// 군별 라디오 전체해제
		$('input:radio[name="military_kind"]').each(function() {
			this.checked = false;
		});

		// 계급 라디오 전체해제
		$('input:radio[name="military_class"]').each(function() {
			this.checked = false;
		});
		checkboxFnc();//체크박스
		*/
	}

	function fn_save_military() {
		var military_kind = "";
		$('input:radio[name="military_kind"]').each(function() {
			if (this.checked) {
				military_kind = $(this).next('span').html();
			}
		});
		var military_class = "";
		$('input:radio[name="military_class"]').each(function() {
			if (this.checked) {
				military_class = $(this).next('span').html();
			}
		});
		$("#kind_class_nm").html(military_kind + "/" + military_class);
	}





	// 지역값 초기화
	function fn_reset_area() {
		// 하단부 지역표기 초기화
		$("#btm_item_list").html("");

		// 지역2차 체크박스 전체해제
		$('input:checkbox[name="area_check2_val"]').each(function() {
			this.checked = false;
		});
		checkboxFnc();//체크박스.
	}

	// 지역값 조건저장
	function fn_save_area() {
		var out_html = '';
		var set_area_cnt = $('[name="view_resume_area"]').length;
		for (i=0; i<set_area_cnt; i++) {
			
			var resume_area			= $('[name="view_resume_area"]').eq(i).val();
			var resume_area_nm		= $('[name="view_resume_area_nm"]').eq(i).val();
			var resume_area_sub		= $('[name="view_resume_area_sub"]').eq(i).val();
			var resume_area_sub_nm	= $('[name="view_resume_area_sub_nm"]').eq(i).val();

			out_html += '<li>';
			out_html += '	<input type="hidden" name="resume_area" value="'+ resume_area +'">';
			out_html += '	<input type="hidden" name="resume_area_sub" value="'+ resume_area_sub +'">';
			out_html += '	'+resume_area_nm+' > '+resume_area_sub_nm+'<button type="button" class="del" onclick="fn_save_area_del(this, \''+ resume_area_sub +'\')">삭제</button>';
			out_html += '</li>';
		}
		$('#ul_place_area').html(out_html);
	}

	function fn_military(_val) {
		if(_val == '2' || _val == '3' || _val == '5') {
			if(_val == '2' || _val == '3') {
				$('#military_end').show();
			}
			
			$('#military_kind').val('');
			$('#military_class').val('');
			$('#military_syear').val('');
			$('#military_smonth').val('');
			$('#military_eyear').val('');
			$('#military_emonth').val('');

			$('[name="military_sdate"]').val('');
			$('[name="military_edate"]').val('');

			$('[name="div_military"]').attr('style','display:none;');

			fn_reset_military();
		}
		else {
			$('#military_end').val('');
			$('#military_end').hide();

			$('[name="div_military"]').attr('style','display:inline-block;');
		}
	}


</script>

<div class="input_box" id ="resume10">
	<p class="ib_tit">취업우대.병역</p>
	<div class="ib_list">
		<div class="ib_move non">
			<div class="ib_m_box">

				<!-- 장애 -->
				<input type="hidden" id="handicap_grd" name="handicap_grd" value="<%=handicap_grd%>" />

				<!-- 병역정보 -->
				<input type="hidden" id="military_yn" name="military_yn" value="<%=military_yn%>" />
				<input type="hidden" id="military_syear" name="military_syear" value="<%=military_syear%>" />
				<input type="hidden" id="military_smonth" name="military_smonth" value="<%=military_smonth%>" />
				<input type="hidden" id="military_eyear" name="military_eyear" value="<%=military_eyear%>" />
				<input type="hidden" id="military_emonth" name="military_emonth" value="<%=military_emonth%>" />
				<input type="hidden" id="military_work" name="military_work" value="" />

				<div class="check_area">
					<label class="checkbox off" for="patriot_flag">
						<input type="checkbox" class="chk" id="patriot_flag" name="patriot_flag" value="1">
						<span>보훈대상</span>
					</label>
					<label class="checkbox off" for="protect_flag">
						<input type="checkbox" class="chk" id="protect_flag" name="protect_flag" value="1">
						<span>취업보호 대상</span>
					</label>
					<label class="checkbox off" for="emp_support_flag">
						<input type="checkbox" class="chk" id="emp_support_flag" name="emp_support_flag" value="1">
						<span>고용지원금 대상</span>
					</label>
					<label class="checkbox off" for="handicap_flag">
						<input type="checkbox" class="chk obstacle" id="handicap_flag" name="handicap_flag" value="1">
						<span>장애</span>
					</label>
					<label class="checkbox off tg2" for="military_chk">
						<input type="checkbox" class="chk mili" id="military_chk" value="1">
						<span>병역</span>
					</label>
				</div>
				
				<!-- 장애 -->
				<div class="chk_input n1" style="display:none;">
					<div class="select_down"  style="width:200px;" title="장애">
						<div class="name"><a href="javaScript:;"><span><%=handicap_grd_nm%></span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'handicap_grd', '1');">1급</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'handicap_grd', '2');">2급</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'handicap_grd', '3');">3급</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'handicap_grd', '4');">4급</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'handicap_grd', '5');">5급</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'handicap_grd', '6');">6급</a></li>
							</ul>
						</div>
					</div>
				</div>

				<!-- 병역정보 -->
				<div class="chk_input n2" style="display:none;">
					<div class="select_down"  style="width:200px;" title="군필">
						<div class="name"><a href="javaScript:;"><span><%=military_nm%></span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'military_yn', '1'); fn_military('1');">군필</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'military_yn', '2'); fn_military('2');">미필</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'military_yn', '3'); fn_military('3');">면제</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'military_yn', '4'); fn_military('4');">복무중</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'military_yn', '5'); fn_military('5');">해당없음</a></li>
							</ul>
						</div>
					</div>
					
					<div name="div_military" style="display:none;">
						<input type="text" name="military_sdate" class="txt" placeholder="입대년월 (ex. 2019.02)" value="<%=military_sdate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_military_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">
						<input type="text" name="military_edate" class="txt" placeholder="제대년월 (ex. 2020.03)" value="<%=military_edate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_military_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:300px;">
						<div class="hidden_open" style="width:393px;">
							<button type="button" id="kind_class_nm" name="군별/제대계급" class="pop_btn"><%=kind_class_nm%></button>
							<div class="ho_area">
								<div class="cols">
									<div class="col col1">
										<% For i = 1 To 7 %>
										<label class="radiobox" for="rdi<%=i%>"><input type="radio" class="rdi" id="rdi<%=i%>" name="military_kind" value="<%=i%>"><span><%=getMilitaryKind(i)%></span></label>
										<% Next %>
										<label class="radiobox" for="rdi8"><input type="radio" class="rdi" id="rdi8" name="military_kind" value="99"><span>기타</span></label>
									</div>
									<div class="col col2">
										<ul class="radio_box">
											<% For i = 1 To 19 %>
											<li>
												<label class="radiobox" for="rank1_<%=i%>">
													<input type="radio" class="rdi" id="rank1_<%=i%>" name="military_class" value="<%=i%>">
													<span><%=getMilitaryClass(i)%></span>
												</label>
											</li>
											<% Next %>
										</ul>
									</div>

									<div class="btm">
										<div class="btm_btn">
											<button type="button" class="button reset" onclick="fn_reset_military()">초기화</button>
											<button type="button" class="button save" onclick="fn_save_military()">조건저장</button>
										</div>
									</div>

								</div>
							</div>
						</div>
					</div>

					<input type="text" id="military_end" name="military_end" class="txt" placeholder="사유 입력" value="<%=military_end%>" style="width:700px; display:none;">
				</div><!-- //병역정보 -->

			</div>
		</div>
		
	</div>
</div><!-- 취업우대.병역 -->