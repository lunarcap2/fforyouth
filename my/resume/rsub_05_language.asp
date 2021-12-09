<script type="text/javascript" src="https://job3.career.co.kr/js/language_exam.js"></script>
<script type="text/javascript">
		
		/*
		$(document).ready(function () {
			//공인시험 선택 변경부분
			var exam_seq = $('[name="language_exam_seq"]').length;
			for (i=0; i<exam_seq; i++) {
				var exam_group_val = $('[name="language_exam_seq"]').eq(i).nextAll('#language_exam_group').val();
				var exam_set_obj = $('[name="language_exam_seq"]').eq(i).nextAll('.select_down.test').children('.sel').find("a");
				exam_set_obj.eq(exam_group_val -1).click();
			}
		});
		*/

	function fn_language_reset(obj, val) {
		switch (val) {
			case '1' :
				//input hidden 초기화
				$(obj).parents(".ib_m_box").children("#language_exam_group").val("");
				$(obj).parents(".ib_m_box").children("#language_exam").val("");
				$(obj).parents(".ib_m_box").children("#language_year").val("");
				$(obj).parents(".ib_m_box").children("#language_month").val("");
				//input text 초기화
				$(obj).parents(".ib_m_box").find("#language_grade").val("");
				$(obj).parents(".ib_m_box").find("#language_date").val("");
				//select 초기화
				$(obj).parents(".ib_m_box").find("#language_title_exam_group").html("외국어명");
				$(obj).parents(".ib_m_box").find("#language_title_exam").html("공인시험 선택");
			break;

			case '2' :
				//input hidden 초기화
				$(obj).parents(".ib_m_box").children("#language_name").val("");
				$(obj).parents(".ib_m_box").children("#language_talk").val("");
				//select 초기화
				$(obj).parents(".ib_m_box").find("#language_title_name").html("외국어명");
				$(obj).parents(".ib_m_box").find("#language_title_talk").html("회화능력");
			break;
		};

		selectDown();//셀렉트형 UL
	}

	function fn_language_div(obj) {
		if (obj.value.length == 7) {
			$(obj).parents(".ib_m_box").children("#language_year").val(obj.value.substr(0, 4));
			$(obj).parents(".ib_m_box").children("#language_month").val(obj.value.substr(5, 2));
		} else {
			$(obj).parents(".ib_m_box").children("#language_year").val("");
			$(obj).parents(".ib_m_box").children("#language_month").val("");
		}
	}

	// 공인시험 언어선택에 따른 어학시험 bind
	function fn_chgLanguage(obj, val) {
		//공인시험(시험명)값 초기화
		$(obj).parents(".ib_m_box").children("#language_exam").val("");
		$(obj).parents(".ib_m_box").find("#language_title_exam").html("공인시험 선택");

		
		//공인시험(시험명)선택 셀렉트 각 언어에맞는 시험리스트
		var li_html = '';
		if (trim(val)) {
			for (var i = 0; i < langex_cd1[val].length; i++) {
				li_html += '<li>'
				li_html += '<a href="javascript:;" onclick="fn_sel_value_set(this, \'language_exam\', \'' + langex_cd1[val][i] + '\')">'
				li_html += langex_nm1[val][i]
				li_html += '</a>'
				li_html += '</li>'
			}
			li_html += '<li><a href="javascript:;" onclick="fn_sel_value_set(this, \'language_exam\', \'99\')">기타</a></li>'
		}

		$(obj).parents(".ib_m_box").find("#language_exam_list").html(li_html);
		selectDown();//셀렉트형 UL
	}

</script>

<div class="input_box" id ="resume5">
	<p class="ib_tit">외국어</p>
	<div id="language_sel_option" style="display:none;">
	<% Call putCodeToatagOption("getLanguageCode", 1, 99, "1", "fn_sel_value_set", "language_name") %>
	</div>
	<div class="ib_list add4">	
		<%
		If isArray(arrLanguageUse) Then '회화능력
			For i=0 To UBound(arrLanguageUse, 2)
			Dim language_talk_nm
			Select Case arrLanguageUse(2, i)
				Case "1" : language_talk_nm = "상"
				Case "2" : language_talk_nm = "중"
				Case "3" : language_talk_nm = "하"
			End Select
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<div class="select_down"  style="width:200px;" title="구분">
					<div class="name"><a href="javaScript:;"><span>회화능력</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" class="skill" onclick="fn_language_reset(this, '1')">회화능력</a></li>
							<li><a href="javaScript:;" class="test" onclick="fn_language_reset(this, '2')">공인시험</a></li>
						</ul>
					</div>
				</div>

				<!-- 회화능력 -->
				<input type="hidden" id="language_name" name="language_name" value="<%=arrLanguageUse(1, i)%>" />
				<input type="hidden" id="language_talk" name="language_talk" value="<%=arrLanguageUse(2, i)%>" />
				<input type="hidden" id="language_read" name="language_read" value="" />
				<input type="hidden" id="language_write" name="language_write" value="" />

				<div class="select_down skill" style="width:250px;" title="외국어명">
					<div class="name"><a href="javaScript:;"><span id="language_title_name"><%=getLanguageCode(arrLanguageUse(1, i))%></span></a></div>
					<div class="sel">
						<ul>
							<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
							<% Call putCodeToatagOption("getLanguageCode", 1, 99, "1", "fn_sel_value_set", "language_name") %>
						</ul>
					</div>
				</div>
				<div class="select_down skill" style="width:276px;" title="회화능력">
					<div class="name"><a href="javaScript:;"><span id="language_title_talk"><%=language_talk_nm%></span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '1');">상</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '2');">중</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '3');">하</a></li>
						</ul>
					</div>
				</div>
				<!-- //회화능력 -->

				<!-- 공인시험 -->
				<input type="hidden" id="language_exam_group" name="language_exam_group" value="" />
				<input type="hidden" id="language_exam" name="language_exam" value="" />
				<input type="hidden" id="language_year" name="language_year" value="" />
				<input type="hidden" id="language_month" name="language_month" value="" />

				<input type="hidden" id="language_exam_etc" name="language_exam_etc" value="" />
				<input type="hidden" id="language_grade_opic" name="language_grade_opic" value="" />

				<div class="select_down test"  style="width:250px; display:none;" title="외국어명">
					<div class="name"><a href="javaScript:;"><span id="language_title_exam_group">외국어명</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '1'); fn_chgLanguage(this, '1');">영어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '2'); fn_chgLanguage(this, '2');">일본어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '3'); fn_chgLanguage(this, '3');">중국어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '4'); fn_chgLanguage(this, '4');">프랑스어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '5'); fn_chgLanguage(this, '5');">독일어</a></li>
						</ul>
					</div>
				</div>
				<div class="con_add test" style="display: none;">
					<div class="ca_input">
						<div class="select_down" style="width:370px;" title="공인시험 선택">
							<div class="name"><a href="javaScript:;"><span id="language_title_exam">공인시험 선택</span></a></div>
							<div class="sel">
								<ul id="language_exam_list">
									<!-- <li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam', '1');">영어</a></li> -->
								</ul>
							</div>
						</div>
						<input type="text" id="language_grade" name="language_grade" class="txt" placeholder="점수/급" maxlength="10" style="width:370px;">
						<input type="text" id="language_date" name="language_date" class="txt last" placeholder="인증일자 (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_language_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:360px;">
					</div>
				</div>
				<!-- <button type="button" name="어학시험 추가" class="add_test">어학시험 추가</button> -->
				<!-- //공인시험 -->
			</div>
		</div>
		<%
			Next
		End If

		If isArray(arrLanguageExam) Then '공인시험
			For i=0 To UBound(arrLanguageExam, 2)
			Dim language_exam_group_nm, language_exam_nm
			Select Case arrLanguageExam(1, i)
				Case "1" : language_exam_group_nm = "영어"
				Case "2" : language_exam_group_nm = "일본어"
				Case "3" : language_exam_group_nm = "중국어"
				Case "4" : language_exam_group_nm = "프랑스어"
				Case "5" : language_exam_group_nm = "독일어"
			End Select

			language_exam_nm = getLanguageExamCodeNm(arrLanguageExam(2, i))

			Dim language_date
			If isDate(arrLanguageExam(4, i) & "-" & arrLanguageExam(5, i)) Then language_date = arrLanguageExam(4, i) & "." & arrLanguageExam(5, i)
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<div class="select_down"  style="width:200px;" title="구분">
					<div class="name"><a href="javaScript:;"><span>공인시험</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" class="skill" onclick="fn_language_reset(this, '1')">회화능력</a></li>
							<li><a href="javaScript:;" class="test" id="language_test_click" onclick="fn_language_reset(this, '2')">공인시험</a></li>
						</ul>
					</div>
				</div>

				<!-- 회화능력 -->
				<input type="hidden" id="language_name" name="language_name" value="" />
				<input type="hidden" id="language_talk" name="language_talk" value="" />
				<input type="hidden" id="language_read" name="language_read" value="" />
				<input type="hidden" id="language_write" name="language_write" value="" />

				<div class="select_down skill" style="width:250px; display:none;" title="외국어명">
					<div class="name"><a href="javaScript:;"><span id="language_title_name">외국어명</span></a></div>
					<div class="sel">
						<ul>
							<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
							<% Call putCodeToatagOption("getLanguageCode", 1, 99, "1", "fn_sel_value_set", "language_name") %>
						</ul>
					</div>
				</div>
				<div class="select_down skill" style="width:276px; display:none;" title="회화능력">
					<div class="name"><a href="javaScript:;"><span id="language_title_talk">회화능력</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '1');">상</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '2');">중</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '3');">하</a></li>
						</ul>
					</div>
				</div>
				<!-- //회화능력 -->

				<!-- 공인시험 -->
				<input type="hidden" id="language_exam_seq" name="language_exam_seq" value="<%=arrLanguageExam(0, i)%>" />
				<input type="hidden" id="language_exam_group" name="language_exam_group" value="<%=arrLanguageExam(1, i)%>" />
				<input type="hidden" id="language_exam" name="language_exam" value="<%=arrLanguageExam(2, i)%>" />
				<input type="hidden" id="language_year" name="language_year" value="<%=arrLanguageExam(4, i)%>" />
				<input type="hidden" id="language_month" name="language_month" value="<%=arrLanguageExam(5, i)%>" />

				<input type="hidden" id="language_exam_etc" name="language_exam_etc" value="<%=arrLanguageExam(6,i)%>" />
				<input type="hidden" id="language_grade_opic" name="language_grade_opic" value="" />

				<div class="select_down test" id="select_down_language_exam" style="width:250px;" title="외국어명">
					<div class="name"><a href="javaScript:;"><span id="language_title_exam_group"><%=language_exam_group_nm%></span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '1'); fn_chgLanguage(this, '1');">영어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '2'); fn_chgLanguage(this, '2');">일본어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '3'); fn_chgLanguage(this, '3');">중국어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '4'); fn_chgLanguage(this, '4');">프랑스어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '5'); fn_chgLanguage(this, '5');">독일어</a></li>
						</ul>
					</div>
				</div>
				<div class="con_add test">
					<div class="ca_input">
						<div class="select_down" style="width:370px;" title="공인시험 선택">
							<div class="name"><a href="javaScript:;"><span id="language_title_exam"><%=language_exam_nm%></span></a></div>
							<div class="sel">
								<ul id="language_exam_list">
									<!-- <li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam', '1');">영어</a></li> -->
								</ul>
							</div>
						</div>
						<input type="text" id="language_grade" name="language_grade" class="txt" placeholder="점수/급" value="<%=arrLanguageExam(3, i)%>" maxlength="10" style="width:370px;">
						<input type="text" id="language_date" name="language_date" class="txt last" placeholder="인증일자 (ex. 2020.03)" value="<%=language_date%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_language_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:360px;">
					</div>
				</div>
				<!-- <button type="button" name="어학시험 추가" class="add_test">어학시험 추가</button> -->
				<!-- //공인시험 -->
			</div>
		</div>
		<%
			Next
		End If

		If isArray(arrLanguageUse) = False And isArray(arrLanguageExam) = False Then
		%>
		<div class="ib_move non">
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<div class="select_down"  style="width:200px;" title="구분">
					<div class="name"><a href="javaScript:;"><span>구분</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" class="skill" onclick="fn_language_reset(this, '1')">회화능력</a></li>
							<li><a href="javaScript:;" class="test" onclick="fn_language_reset(this, '2')">공인시험</a></li>
						</ul>
					</div>
				</div>

				<!-- 회화능력 -->
				<input type="hidden" id="language_name" name="language_name" value="" />
				<input type="hidden" id="language_talk" name="language_talk" value="" />
				<input type="hidden" id="language_read" name="language_read" value="" />
				<input type="hidden" id="language_write" name="language_write" value="" />

				<div class="select_down skill" style="width:250px;" title="외국어명">
					<div class="name"><a href="javaScript:;"><span id="language_title_name">외국어명</span></a></div>
					<div class="sel">
						<ul id="language_sel_option">
							<% '/wwwconf/code/code_function.asp, /wwwconf/code/codeToHtml.asp %>
							<% Call putCodeToatagOption("getLanguageCode", 1, 99, "1", "fn_sel_value_set", "language_name") %>
						</ul>
					</div>
				</div>
				<div class="select_down skill" style="width:276px;" title="회화능력">
					<div class="name"><a href="javaScript:;"><span id="language_title_talk">회화능력</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '1');">상</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '2');">중</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_talk', '3');">하</a></li>
						</ul>
					</div>
				</div>
				<!-- //회화능력 -->

				<!-- 공인시험 -->
				<input type="hidden" id="language_exam_group" name="language_exam_group" value="" />
				<input type="hidden" id="language_exam" name="language_exam" value="" />
				<input type="hidden" id="language_year" name="language_year" value="" />
				<input type="hidden" id="language_month" name="language_month" value="" />

				<input type="hidden" id="language_exam_etc" name="language_exam_etc" value="" />
				<input type="hidden" id="language_grade_opic" name="language_grade_opic" value="" />

				<div class="select_down test"  style="width:250px; display:none;" title="외국어명">
					<div class="name"><a href="javaScript:;"><span id="language_title_exam_group">외국어명</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '1'); fn_chgLanguage(this, '1');">영어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '2'); fn_chgLanguage(this, '2');">일본어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '3'); fn_chgLanguage(this, '3');">중국어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '4'); fn_chgLanguage(this, '4');">프랑스어</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam_group', '5'); fn_chgLanguage(this, '5');">독일어</a></li>
						</ul>
					</div>
				</div>
				<div class="con_add test" style="display: none;">
					<div class="ca_input">
						<div class="select_down" style="width:370px;" title="공인시험 선택">
							<div class="name"><a href="javaScript:;"><span id="language_title_exam">공인시험 선택</span></a></div>
							<div class="sel">
								<ul id="language_exam_list">
									<!-- <li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'language_exam', '1');">영어</a></li> -->
								</ul>
							</div>
						</div>
						<input type="text" id="language_grade" name="language_grade" class="txt" placeholder="점수/급" maxlength="10" style="width:370px;">
						<input type="text" id="language_date" name="language_date" class="txt last" placeholder="인증일자 (ex. 2020.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_language_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:360px;">
					</div>
				</div>
				<!-- <button type="button" name="어학시험 추가" class="add_test">어학시험 추가</button> -->
				<!-- //공인시험 -->
			</div>
		</div>
		<%
		End If 
		%>
	</div>

	<div class="add_box">
		<button type="button" class="addItem r4">추가하기</button>
	</div>
</div><!-- 외국어 -->