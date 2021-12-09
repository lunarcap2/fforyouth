<%
'지역코드 xml
Dim arrListArea1 '1차
arrListArea1 = getAreaList1() '/wwwconf/code/code_function_ac.asp

ReDim arrListArea2(UBound(arrListArea1)) '2차
For i=0 To UBound(arrListArea1)
	arrListArea2(i) = getArrJcList(arrListArea1(i,0))
Next


'업/직종 코드2차 전체
Dim jc_code_all, ct_code_all
Dim jc1_set, ct1_set
If isArray(arrResume) Then
	jc_code_all = arrResume(28, 0)
	ct_code_all = arrResume(29, 0)

	If jc_code_all <> "" Then
		jc_code_all = Split(jc_code_all, "|")
		jc1_set		= jc_code_all(0)		
	End If

	If ct_code_all <> "" Then 
		ct_code_all = Split(ct_code_all, "|")
		ct1_set		= ct_code_all(0)
	End If
End If


Dim work_style, work_style_nm, salary_amt, salary_amt_nm
If isArray(arrWorkType) Then work_style = arrWorkType(0, 0)
If isArray(arrResume) Then salary_amt = arrResume(10, 0)

work_style_nm = "고용형태"
If work_style <> "" Then work_style_nm = getComWorkType(work_style)

salary_amt_nm = "희망연봉"
If salary_amt <> "" And salary_amt <> "98" Then salary_amt_nm = getSalayYear(salary_amt)

%>
<script type="text/javascript" src="https://job3.career.co.kr/js/cat_jc.js"></script>
<script type="text/javascript" src="https://job3.career.co.kr/js/cat_ct.js"></script>
<script type="text/javascript" src="/js/resume_ct_T.js"></script>
<script type="text/javascript" src="/js/resume_jc_T.js"></script>
<script type="text/javascript">
	var jc1 = '';
	var ct1 = '';

	$(document).ready(function () {
		var salary_amt = "<%=salary_amt%>";
		if (salary_amt == "98") {
			$("#chk_salay_code1").click();
		}

		if(jc1 == '') {
			jc1 = '<%=jc1_set%>';
		}

		if(ct1 == '') {
			ct1 = '<%=ct1_set%>';
		}
	});

	// 면접후결정
	function fn_chk_salay_code(obj) {
		if ($(obj).is(":checked")) {
			$('#select_down_salary_amt').attr('class', 'select_down disabled');
			$('#select_down_salary_amt').find('span').html('희망연봉');
			$('#salary_amt').val("98");
		} else {
			$('#select_down_salary_amt').attr('class', 'select_down');
			$('#salary_amt').val("");
		}
	}
	
	// 1차지역 선택
	function fn_set_area_change(obj, _i) {
		$('[name="area_ul_list1"]').attr('class', 'button'); //1차지역 class off
		$(obj).attr('class', 'button on'); //선택한 1차지역 class on

		$('[name="area_ul_list2"]').hide(); //2차지역 전체숨김
		$("#area_ul_list2_" + _i).show(); //선택한 1차지역의 2차지역 리스트 노출
		
		// 지역2차 체크박스(로드된 값 있을경우)
		if ($('[name="resume_area_sub"]').length > 0) {
			var resume_area_sub_val = "";
			$('[name="resume_area_sub"]').each(function() {
				resume_area_sub_val = this.value

				$('[name="area_check2_val"]').each(function() {
					if (this.value == resume_area_sub_val) {
						this.checked = true;
					}
				});
				
			});
			checkboxFnc();//체크박스.
		}
		
	}

	// 2차지역 선택
	function fn_set_area2(obj, _area1_cd, _area1_nm) {
		var area2_cd, area2_nm, area2_checked
		area2_cd = $(obj).val();
		area2_nm = $(obj).next().html();
		area2_checked = $(obj).is(":checked");

		if (area2_checked) {
			
			var area_check2_cnt = $('input:checkbox[name="area_check2_val"]:checked').length
			if (area_check2_cnt > 10) {
				alert("희망 근무지는 최대 10개까지 선택이 가능합니다.");
				fn_set_area2_del(area2_cd);
				return;
			} else {
				var up_html = '';
				up_html += '<div class="btm_area">'
				up_html += '	<input type="hidden" name="view_resume_area" value="' + _area1_cd + '">'
				up_html += '	<input type="hidden" name="view_resume_area_nm" value="' + _area1_nm + '">'
				up_html += '	<input type="hidden" name="view_resume_area_sub" value="' + area2_cd + '">'
				up_html += '	<input type="hidden" name="view_resume_area_sub_nm" value="' + area2_nm + '">'
				up_html += '	<span>' + _area1_nm + '</span>'
				up_html += '	<div class="ba_area">'
				up_html += '		<ul>'
				up_html += '			<li>' + area2_nm + '<button type="button" class="del" onclick="fn_set_area2_del(\'' + area2_cd + '\')">삭제</button></li>'
				up_html += '		</ul>'
				up_html += '	</div>'
				up_html += '</div>'

				$('#btm_item_list').append(up_html);
			}
		} else {
			fn_set_area2_del(area2_cd);
		}

	}

	// 선택한 지역삭제, 체크해제
	function fn_set_area2_del(_val) {
		// 하단부 선택된 지역표기 삭제
		$('input[name="view_resume_area_sub"]').each(function() {
			if (this.value == _val) {
				$(this).parents(".btm_area").remove();
			}
		});
		// 지역2차 선택된 체크박스 해제
		$('input:checkbox[name="area_check2_val"]').each(function() {
			if (this.value == _val) {
				this.checked = false;
			}
		});
		checkboxFnc();//체크박스.
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

	// 저장된 지역값 삭제
	function fn_save_area_del(_obj, _val) {
		$(_obj).parent().remove();
		fn_set_area2_del(_val);
	}

	// 업직종 초기화
	function fn_reset_ctjc() {
		fn_reset_jc();
		fn_reset_ct();
	}

	// 업직종값 조건저장
	function fn_save_ctjc() {
		fn_save_jc();
		fn_save_ct();
	}
</script>

<div class="input_box" id ="resume12">
	<p class="ib_tit">희망 근무조건</p>
	<div class="ib_list">
		<div class="ib_move non">
			<!-- <div class="deleteBox">삭제</div> -->
			<div class="ib_m_box">
				
				<input type="hidden" id="work_style" name="work_style" value="<%=work_style%>" /> <!-- 고용형태 -->
				<input type="hidden" id="salary_amt" name="salary_amt" value="<%=salary_amt%>" /> <!-- 연봉코드 -->

				<div class="select_down" id="select_down_work_style" style="width:300px;" title="고용형태">
					<div class="name"><a href="javaScript:;"><span><%=work_style_nm%></span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '1');">정규직</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '7');">계약직</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '6');">인턴직</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '9');">파견직</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '10');">위촉직</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '5');">병역특례</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '4');">정보화근로</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '11');">프리랜서</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '2');">해외취업</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'work_style', '3');">해외인턴/국제기구</a></li>
						</ul>
					</div>
				</div>

				<div class="chk_able">
					<div class="select_down" id="select_down_salary_amt" style="width:300px;" title="희망연봉">
						<div class="name"><a href="javaScript:;"><span><%=salary_amt_nm%></span></a></div>
						<div class="sel">
							<ul>
								<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
								<% Call putCodeToatagOption("getSalayYear", 1, 29, "1", "fn_sel_value_set", "salary_amt") %>
							</ul>
						</div>
					</div>

					<label class="checkbox off" for="chk_salay_code1">
						<input type="checkbox" id="chk_salay_code1" class="chk" onclick="fn_chk_salay_code(this)">
						<span>면접 후 결정</span>
					</label>
				</div>
				
				<!-- 희망근무지 -->
				<div class="popup_area place">
					<p class="pa_tit">희망근무지</p>
					<div class="place_area">
						<ul id="ul_place_area">
							<%
							If isArray(arrArea) Then
								For i=0 To UBound(arrArea, 2)
							%>
							<li>
								<input type="hidden" name="resume_area" value="<%=arrArea(0, i)%>">
								<input type="hidden" name="resume_area_sub" value="<%=arrArea(1, i)%>">
								<%=getAcName(arrArea(0, i))%> > <%=getAcName(arrArea(1, i))%>
								<button type="button" class="del" onclick="fn_save_area_del(this, '<%=arrArea(1, i)%>')">삭제</button>
							</li>
							<%
								Next
							End If
							%>
						</ul>
					</div>
					<button type="button" name="추가하기" class="pop_btn">추가하기</button>
					<div class="dim"></div>
					<div class="pop_sel">
						<div class="cols">
							<div class="col col1">
								<ul class="col_on">
									<!-- 1차지역 -->
									<% For i=0 To UBound(arrListArea1) %>
									<li><button type="button" class="button" name="area_ul_list1" onclick="fn_set_area_change(this, '<%=i%>')"><%=arrListArea1(i, 1)%></button></li>
									<% Next %>
								</ul>
							</div>
							<div class="col col2">
								<!-- 2차지역 -->
								<% For i=0 To UBound(arrListArea1) %>
								<ul class="chk" id="area_ul_list2_<%=i%>" name="area_ul_list2" style="display:none;">
									<% For ii=0 To UBound(arrListArea2(i)) %>
									<li>
										<label class="checkbox off">
											<input type="checkbox" class="chk" name="area_check2_val" value="<%=arrListArea2(i)(ii, 0)%>" onclick="fn_set_area2(this, '<%=arrListArea1(i, 0)%>', '<%=arrListArea1(i, 1)%>')">
											<span><%=arrListArea2(i)(ii, 1)%></span>
										</label>
									</li>
									<% Next %>
								</ul>
								<% Next %>
							</div>
						</div>
						<div class="btm">
							<div id="btm_item_list">
								<%
								If isArray(arrArea) Then
									For i=0 To UBound(arrArea, 2)
								%>
								<div class="btm_area">
									<input type="hidden" name="view_resume_area" value="<%=arrArea(0, i)%>">
									<input type="hidden" name="view_resume_area_nm" value="<%=getAcName(arrArea(0, i))%>">
									<input type="hidden" name="view_resume_area_sub" value="<%=arrArea(1, i)%>">
									<input type="hidden" name="view_resume_area_sub_nm" value="<%=getAcName(arrArea(1, i))%>">
									<span><%=getAcName(arrArea(0, i))%></span>
									<div class="ba_area">
										<ul>
											<li><%=getAcName(arrArea(1, i))%><button type="button" class="del" onclick="fn_set_area2_del('<%=arrArea(1, i)%>')">삭제</button></li>
										</ul>
									</div>
								</div>
								<%
									Next
								End If
								%>
							</div>
							<div class="btm_btn">
								<button type="button" class="button reset" onclick="fn_reset_area()">초기화</button>
								<button type="button" class="button save" onclick="fn_save_area()">조건저장</button>
							</div>
						</div>
					</div>
				</div>
				<!-- //희망근무지 -->
				
				<!-- 업.직종 키워드 -->
				<div class="popup_area jobs">
					<p class="pa_tit">직업.산업 키워드</p>
					<div class="category_area">

						<div class="category">
							<div class="c_head" id="c_head_jc_title"><%If isArray(jc_code_all) Then%>직무<%End If%></div>
							<ul id="ul_place_jc">
								<%
								If isArray(jc_code_all) Then
									For i=0 To UBound(jc_code_all)
								%>
								<li>
									<div class="c_recommend">
										<input type="hidden" name="resume_jobcode" value="<%=jc_code_all(i)%>">
										<span><%=getJobtype(jc_code_all(i))%></span>
										<button type="button" onclick="fn_save_jc2_del(this, '<%=jc_code_all(i)%>')">삭제</button>
									</div>
									<div class="c_jobs">
										<ul>
											<%
											If isArray(arrJcKwd) Then
												For ii=0 To UBound(arrJcKwd, 2)
												If jc_code_all(i) = Left(arrJcKwd(0, ii), 4) Then
											%>
												<li>
													<input type="hidden" name="jc_keyword" value="<%=arrJcKwd(0, ii)%>">
													<span><%=arrJcKwd(1, ii)%></span>
													<button type="button" onclick="fn_save_jc3_del(this, '<%=arrJcKwd(0, ii)%>')">삭제</button>
												</li>
											<%
												End If
												Next
											End If
											%>
										</ul>
									</div>
								</li>
								<%
									Next 
								End If
								%>
							</ul>
						</div>

						<div class="category">
							<div class="c_head" id="c_head_ct_title"><%If isArray(ct_code_all) Then%>산업<%End If%></div>
							<ul id="ul_place_ct">
								<%
								If isArray(ct_code_all) Then
									For i=0 To UBound(ct_code_all)
								%>
								<li>
									<div class="c_recommend">
										<input type="hidden" name="resume_jobtype" value="<%=ct_code_all(i)%>">
										<span><%=getJobtype(ct_code_all(i))%></span>
										<button type="button" onclick="fn_save_ct2_del(this, .'<%=ct_code_all(i)%>')">삭제</button>
									</div>
									<div class="c_jobs">
										<ul>
											<%
											If isArray(arrCtKwd) Then
												For ii=0 To UBound(arrCtKwd, 2)
												If ct_code_all(i) = Left(arrCtKwd(0, ii), 4) Then
											%>
												<li>
													<input type="hidden" name="ct_keyword" value="<%=arrCtKwd(0, ii)%>">
													<span><%=arrCtKwd(1, ii)%></span>
													<button type="button" onclick="fn_save_ct3_del(this, '<%=arrCtKwd(0, ii)%>')">삭제</button>
												</li>
											<%
												End If
												Next
											End If
											%>
										</ul>
									</div>
								</li>
								<%
									Next 
								End If
								%>
							</ul>
						</div>
					</div>

					<button type="button" name="추가하기" class="pop_btn" onclick="fn_append_jc()">추가하기</button>
					<div class="dim"></div>
					<div class="pop_sel">
						<div class="tab_area">
							<ul class="tabs">
								<li><a href="#tab1" onclick="fn_append_jc()">직무 (직종)</a></li>
								<li><a href="#tab2" onclick="fn_append_ct()">산업 (업종)</a></li>
								<li><a href="#tab3">키워드</a></li>
							</ul>

							<!--탭 콘텐츠 영역 -->
							<div class="tab_container">
								<!-- 직무(직종) -->
								<div id="tab1" class="tab_content">
									<div class="cols">
										<div class="col col1">
											<ul class="col_on" id="col_ul_jc1">
											</ul>
										</div>
										<div class="col col2">
											<ul class="col_on" id="col_ul_jc2">
											</ul>
										</div>
										<div class="col col3">
											<ul class="chk" id="col_ul_jc3">
											</ul>
										</div>
									</div>
								</div><!-- //직무(직종) -->

								<!-- 산업(업종) -->
								<div id="tab2" class="tab_content">
									<div class="cols">
										<div class="col col1">
											<ul class="col_on" id="col_ul_ct1">
											</ul>
										</div>
										<div class="col col2">
											<ul class="col_on" id="col_ul_ct2">
											</ul>
										</div>
										<div class="col col3">
											<ul class="chk" id="col_ul_ct3">
											</ul>
										</div>
									</div>
								</div><!-- 산업(업종) -->

								<!-- 키워드 -->
								<div id="tab3" class="tab_content">
									<div class="cols">
										<div class="col col1">
											<ul class="col_on" id="col_ul_jc1">
											</ul>
										</div>
										<div class="col col2">
											<ul class="col_on" id="col_ul_jc2">
											</ul>
										</div>
										<div class="col col3">
											<ul class="chk" id="col_ul_jc3">
												<%
												If isArray(jc_code_all) Then
													For i=0 To UBound(jc_code_all)
												%>
												<script>
													fn_jc3_set('<%=jc_code_all(i)%>','<%=getJobtype(jc_code_all(i))%>');
												</script>
												<%
													Next 
												End If
												%>

												<%
												If isArray(ct_code_all) Then
													For i=0 To UBound(ct_code_all)
												%>
												<script>
													fn_ct3_set('<%=ct_code_all(i)%>','<%=getJobtype(ct_code_all(i))%>');
												</script>
												<%
													Next 
												End If
												%>
											</ul>
										</div>
									</div>
								</div><!-- 키워드 -->
							</div>

						</div>

						<!--탭 하단영역 -->
						<div class="btm">
							<div class="category_area">
								<div class="category">
									<div class="c_head">직무</div>
									<ul id="btm_category_jc">
										<%
										If isArray(jc_code_all) Then
											For i=0 To UBound(jc_code_all)
										%>
										<li>
											<div class="c_recommend">
												<span><%=getJobtype(jc_code_all(i))%></span>
												<button type="button" class="del" name="category_out_jc2" value="<%=jc_code_all(i)%>" onclick="fn_jckey2_del('<%=jc_code_all(i)%>')">삭제</button>
											</div>
											<div class="c_jobs">
												<ul>
													<%
													If isArray(arrJcKwd) Then
														For ii=0 To UBound(arrJcKwd, 2)
														If jc_code_all(i) = Left(arrJcKwd(0, ii), 4) Then
													%>
														<li>
															<span><%=arrJcKwd(1, ii)%></span>
															<button type="button" class="del" name="category_out_jc3" value="<%=arrJcKwd(0, ii)%>" onclick="fn_jckey3_del('<%=arrJcKwd(0, ii)%>')">삭제</button>
														</li>
													<%
														End If
														Next
													End If
													%>
												</ul>
											</div>
										</li>
										<%
											Next 
										End If
										%>
									</ul>
								</div>
								<div class="category">
									<div class="c_head">산업</div>
									<ul id="btm_category_ct">
										<%
										If isArray(ct_code_all) Then
											For i=0 To UBound(ct_code_all)
										%>
										<li>
											<div class="c_recommend">
												<span><%=getJobtype(ct_code_all(i))%></span>
												<button type="button" class="del" name="category_out_ct2" value="<%=ct_code_all(i)%>" onclick="fn_ctkey2_del('<%=ct_code_all(i)%>')">삭제</button>
											</div>
											<div class="c_jobs">
												<ul>
													<%
													If isArray(arrCtKwd) Then
														For ii=0 To UBound(arrCtKwd, 2)
														If ct_code_all(i) = Left(arrCtKwd(0, ii), 4) Then
													%>
														<li>
															<span><%=arrCtKwd(1, ii)%></span>
															<button type="button" class="del" name="category_out_ct3" value="<%=arrCtKwd(0, ii)%>" onclick="fn_ctkey3_del('<%=arrCtKwd(0, ii)%>')">삭제</button>
														</li>
													<%
														End If
														Next
													End If
													%>
												</ul>
											</div>
										</li>
										<%
											Next 
										End If
										%>
									</ul>
								</div>
							</div>
							<div class="btm_btn">
								<button type="button" class="button reset" onclick="fn_reset_ctjc()">초기화</button>
								<button type="button" class="button save" onclick="fn_save_ctjc()">조건저장</button>
							</div>
						</div>

					</div>
				</div>
				<!-- 업.직종 키워드 -->

				<div class="ib_jobs">
				</div>
			</div>
		</div>
		
	</div>
</div><!-- 희망 근무조건 -->