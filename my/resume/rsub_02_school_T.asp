<script type="text/javascript">

	$(document).ready(function () {
		//고등학교 로드시 sel클릭
		$('[name="univ_kind"]').each(function() {
			if (this.value == "3") {
				//console.log($(this).parents('.ib_m_box').find('#ul_sel_univ_kind').find('a').eq(0));
				$(this).parents('.ib_m_box').find('#ul_sel_univ_kind').find('a').eq(0).click();
			}
		});
	});

	function fn_school_s_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#univ_syear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#univ_smonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#univ_syear").val("");
			$(obj).prevAll("#univ_smonth").val("");
		}
	}
	function fn_school_e_div(obj) {
		if (obj.value.length == 7) {
			$(obj).prevAll("#univ_eyear").val(obj.value.substr(0, 4));
			$(obj).prevAll("#univ_emonth").val(obj.value.substr(5, 2));
		} else {
			$(obj).prevAll("#univ_eyear").val("");
			$(obj).prevAll("#univ_emonth").val("");
		}
	}
	
	function fn_school_chg_univ_kind(obj, val) {
		//고등학교, 대학 검색자동완성 코드값 변경
		$(obj).parents('.ib_m_box').find('#univ_name').attr('onkeyup','fn_kwSearchItem(this, \'' + val + '\')');

		if (val == "high") {
			$(obj).parents('.ib_m_box').find('#univ_point').val(""); //학점
			$(obj).parents('.ib_m_box').find('#univ_major').val(""); //전공
			$(obj).parents('.ib_m_box').find('#univ_research').val(""); //이수내용
			$(obj).parents('.ib_m_box').find('#univ_minor').val(""); //부전공
			$(obj).parents('.ib_m_box').find('#univ_minornm').val(""); //부전공명

			//$(obj).parents('.ib_m_box').find('#univ_point').attr('readonly', true);
			//$(obj).parents('.ib_m_box').find('#univ_point').attr('class', 'txt last disabled');
			$(obj).parents('.ib_m_box').find('#univ_point').hide();
			$(obj).parents('.ib_m_box').find('#univ_major').hide();
			$(obj).parents('.ib_m_box').find('#univ_research').hide();
			$(obj).parents('.ib_m_box').find('#univ_add_minor').hide();
			$(obj).parents('.ib_m_box').find('.con_add major').hide();
		} else {
			$(obj).parents('.ib_m_box').find('#univ_point').show();
			$(obj).parents('.ib_m_box').find('#univ_major').show();
			$(obj).parents('.ib_m_box').find('#univ_research').show();
			$(obj).parents('.ib_m_box').find('#univ_add_minor').show();
		}
	}

</script>

<div class="input_box" id ="resume2">
	<p class="ib_tit">학력사항</p>
	<div class="ib_list add1">
		<input type="hidden" id="final_scholar" name="final_scholar" value="">
		<%
		Dim univ_etype_nm, univ_kind_nm, univ_minor_nm, univ_sdate, univ_edate, univ_visible
		If isArray(arrSchool) Then
			For i=0 To UBound(arrSchool, 2)
			univ_etype_nm = ""
			univ_sdate = ""
			univ_edate = ""
			univ_visible = ""
			Select Case arrSchool(12, i)
				Case "3" : univ_etype_nm = "재학"
				Case "4" : univ_etype_nm = "휴학"
				Case "5" : univ_etype_nm = "중퇴"
				Case "7" : univ_etype_nm = "졸업(예)"
				Case "8" : univ_etype_nm = "졸업"
				Case Else univ_etype_nm = "졸업상태"
			End Select

			univ_kind_nm = ""
			Select Case arrSchool(2, i)
				Case "3" : univ_kind_nm = "고등학교"
				Case "4" : univ_kind_nm = "대학(2,3년)"
				Case "5" : univ_kind_nm = "대학교(4년)"
				Case "6" : univ_kind_nm = "대학원"
				Case Else univ_kind_nm = "학력구분"
			End Select

			univ_minor_nm = ""
			univ_minor_nm = arrSchool(17, i)
			If univ_minor_nm = "" Or isnull(univ_minor_nm) Then univ_minor_nm = "전공상태"

			If isDate(arrSchool(7, i) & "-" & arrSchool(8, i)) Then univ_sdate = arrSchool(7, i) & "." & arrSchool(8, i)
			If isDate(arrSchool(10, i) & "-" & arrSchool(11, i)) Then univ_edate = arrSchool(10, i) & "." & arrSchool(11, i)

			If arrSchool(3, i) = "대입검정고시" Then univ_visible = "display:none;"
		%>
		<div class="ib_move">
			<button type="button" name="이동버튼" class="ib_m_handle"></button>
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				<input type="hidden" id="univ_kind" name="univ_kind" value="<%=arrSchool(2, i)%>">
				<input type="hidden" id="sc_type" name="sc_type" value="2">
				<input type="hidden" id="univ_depth" name="univ_depth" value=""> <!-- 계열코드(X) -->
				<input type="hidden" id="univ_pointavg" name="univ_pointavg" value=""> <!-- 학점기준(X) -->
				<input type="hidden" id="univ_code" name="univ_code" value=""> <!-- 대학코드(X) -->
				<input type="hidden" id="univ_major_code" name="univ_major_code" value=""> <!-- 전공코드(X) -->
				<input type="hidden" id="univ_area" name="univ_area" value=""> <!-- 지역코드(X) -->
				<input type="hidden" id="univ_stype" name="univ_stype" value="1"> <!-- 입학코드(X) -->
				<input type="hidden" id="univ1_grd" name="univ1_grd" value=""> <!-- 학위구분코드(X) -->
				
				<input type="hidden" id="univ_syear" name="univ_syear" value="<%=arrSchool(7, i)%>">
				<input type="hidden" id="univ_smonth" name="univ_smonth" value="<%=arrSchool(8, i)%>">
				<input type="hidden" id="univ_eyear" name="univ_eyear" value="<%=arrSchool(10, i)%>">
				<input type="hidden" id="univ_emonth" name="univ_emonth" value="<%=arrSchool(11, i)%>">
				<input type="hidden" id="univ_etype" name="univ_etype" value="<%=arrSchool(12, i)%>"> <!-- 졸업상태 -->
				<input type="hidden" id="univ_minor" name="univ_minor" value="<%=arrSchool(17, i)%>"> <!-- 부전공 -->
				<input type="hidden" id="univ_mdepth" name="univ_mdepth" value=""> <!-- 부전공계열코드(X) -->
				<input type="hidden" id="univ_minor_code" name="univ_minor_code" value=""> <!-- 부전공코드(X) -->

				<input type="hidden" id="gde" name="gde" value="<%=arrSchool(21,i)%>"> <!--모바일에서 사용-->				
				
				<div class="select_down"  style="width:290px;<%=univ_visible%>" title="졸업상태">
					<div class="name"><a href="javaScript:;"><span><%=univ_etype_nm%></span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '3')">재학</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '4')">휴학</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '5')">중퇴</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '7')">졸업(예)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '8')">졸업</a></li>
						</ul>
					</div>
				</div>

				<input type="text" name="univ_sdate" class="txt" placeholder="입학년월 (ex. 2019.03)" value="<%=univ_sdate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:290px;<%=univ_visible%>">
				<input type="text" name="univ_edate" class="txt" placeholder="졸업년월 (ex. 2020.02)" value="<%=univ_edate%>" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:290px;">
				<input type="text" id="univ_point" name="univ_point" class="txt last" placeholder="학점 (ex. 4.5)" value="<%=arrSchool(13, i)%>" maxlength="4" style="width:290px;">

				<div class="select_down" style="width:290px;" title="학력구분">
					<div class="name"><a href="javaScript:;"><span><%=univ_kind_nm%></span></a></div>
					<div class="sel">
						<ul id="ul_sel_univ_kind" style="display: none;">
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '3'); fn_school_chg_univ_kind(this, 'high');">고등학교</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '4'); fn_school_chg_univ_kind(this, 'univ');">대학(2,3년)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '5'); fn_school_chg_univ_kind(this, 'univ');">대학교(4년)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '6'); fn_school_chg_univ_kind(this, 'univ');">대학원</a></li>
						</ul>
					</div>
				</div>

				<div class="search_box" style="width:433px;">
					<input type="text" id="univ_name" name="univ_name" class="txt" placeholder="학교명" value="<%=arrSchool(3, i)%>" onkeyup="fn_kwSearchItem(this, 'univ')" style="width:100%;">
					<div class="result_box" id="id_result_box">
					<!--
						<ul class="rb_ul">
							<li>
								<a href="javaScript:;" class="rb_a">
									<p>커리어넷</p>
									<span>보호대상중견기업</span><span>고용알선업</span>
								</a>
							</li>
						</ul>
						<a href="javaScript:;" class="rb_direct"><span>커리어넷</span> 직접입력</a>
					-->
					</div>
				</div>
				
				<input type="text" id="univ_major" name="univ_major" class="txt last" placeholder="전공 및 학위 (ex. 경영학과 학사)" value="<%=arrSchool(6, i)%>" style="width:445px;">
				<input type="text" id="univ_research" name="univ_research" class="txt" placeholder="이수과목 및 연구내용" value="<%=arrSchool(24, i)%>" style="width:100%">

				<div class="con_add major" style="<%If arrSchool(17, i) = "" Or isnull(arrSchool(17, i)) Then%>display:none;<%End If%>">
					<div class="select_down" style="width:217px;" title="전공상태">
						<div class="name"><a href="javaScript:;"><span><%=univ_minor_nm%></span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_minor', '부')">부전공</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_minor', '복수')">복수전공</a></li>
							</ul>
						</div>
					</div>
					<input type="text" id="univ_minornm" name="univ_minornm" class="txt" placeholder="전공명" value="<%=arrSchool(18, i)%>" style="width:417px;">
				</div>

				<button type="button" id="univ_add_minor" name="전공추가" class="add_btn<%If arrSchool(17, i) = "" Or isnull(arrSchool(17, i)) Then%> on<%End If%>">다른 전공 추가</button>
			</div>
		</div>
		<%
			Next
		Else
		%>
		<div class="ib_move">
			<button type="button" name="이동버튼" class="ib_m_handle"></button>
			<div class="deleteBox">삭제</div>
			<div class="ib_m_box">
				
				<input type="hidden" id="univ_kind" name="univ_kind" value="0">
				<input type="hidden" id="sc_type" name="sc_type" value="2">
				<input type="hidden" id="univ_depth" name="univ_depth" value=""> <!-- 계열코드(X) -->
				<input type="hidden" id="univ_pointavg" name="univ_pointavg" value=""> <!-- 학점기준(X) -->
				<input type="hidden" id="univ_code" name="univ_code" value=""> <!-- 대학코드(X) -->
				<input type="hidden" id="univ_major_code" name="univ_major_code" value=""> <!-- 전공코드(X) -->
				<input type="hidden" id="univ_area" name="univ_area" value=""> <!-- 지역코드(X) -->
				<input type="hidden" id="univ_stype" name="univ_stype" value="1"> <!-- 입학코드(X) -->
				<input type="hidden" id="univ1_grd" name="univ1_grd" value=""> <!-- 학위구분코드(X) -->
				
				<input type="hidden" id="univ_syear" name="univ_syear" value="">
				<input type="hidden" id="univ_smonth" name="univ_smonth" value="">
				<input type="hidden" id="univ_eyear" name="univ_eyear" value="">
				<input type="hidden" id="univ_emonth" name="univ_emonth" value="">
				<input type="hidden" id="univ_etype" name="univ_etype" value=""> <!-- 졸업상태 -->
				<input type="hidden" id="univ_minor" name="univ_minor" value=""> <!-- 부전공 -->
				<input type="hidden" id="univ_mdepth" name="univ_mdepth" value=""> <!-- 부전공계열코드(X) -->
				<input type="hidden" id="univ_minor_code" name="univ_minor_code" value=""> <!-- 부전공코드(X) -->
				
				<div class="select_down"  style="width:290px;" title="졸업상태">
					<div class="name"><a href="javaScript:;"><span>졸업상태</span></a></div>
					<div class="sel">
						<ul>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '3')">재학</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '4')">휴학</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '5')">중퇴</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '7')">졸업(예)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_etype', '8')">졸업</a></li>
						</ul>
					</div>
				</div>

				<input type="text" name="univ_sdate" class="txt" placeholder="입학년월 (ex. 2019.03)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_s_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:290px;">
				<input type="text" name="univ_edate" class="txt" placeholder="졸업년월 (ex. 2020.02)" onkeyup="numCheck(this, 'int'); changeDateType(this); fn_school_e_div(this);" onblur="chkDateType(this)" maxlength="6" style="width:290px;">
				<input type="text" id="univ_point" name="univ_point" class="txt last" placeholder="학점 (ex. 4.5)" maxlength="4" style="width:290px;">

				<div class="select_down" style="width:290px;" title="학력구분">
					<div class="name"><a href="javaScript:;"><span>학력구분</span></a></div>
					<div class="sel">
						<ul id="ul_sel_univ_kind" style="display: none;">
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '3'); fn_school_chg_univ_kind(this, 'high');">고등학교</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '4'); fn_school_chg_univ_kind(this, 'univ');">대학(2,3년)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '5'); fn_school_chg_univ_kind(this, 'univ');">대학교(4년)</a></li>
							<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_kind', '6'); fn_school_chg_univ_kind(this, 'univ');">대학원</a></li>
						</ul>
					</div>
				</div>

				<div class="search_box" style="width:433px;">
					<input type="text" id="univ_name" name="univ_name" class="txt" placeholder="학교명" onkeyup="fn_kwSearchItem(this, 'univ')" style="width:100%;">
					<div class="result_box" id="id_result_box">
					<!--
						<ul class="rb_ul">
							<li>
								<a href="javaScript:;" class="rb_a">
									<p>커리어넷</p>
									<span>보호대상중견기업</span><span>고용알선업</span>
								</a>
							</li>
						</ul>
						<a href="javaScript:;" class="rb_direct"><span>커리어넷</span> 직접입력</a>
					-->
					</div>
				</div>

				<input type="text" id="univ_major" name="univ_major" class="txt last" placeholder="전공 및 학위 (ex. 경영학과 학사)" style="width:445px;">
				<input type="text" id="univ_research" name="univ_research" class="txt" placeholder="이수과목 및 연구내용" style="width:100%">

				<div class="con_add major" style="display:none;">
					<div class="select_down" style="width:217px;" title="전공상태">
						<div class="name"><a href="javaScript:;"><span>전공상태</span></a></div>
						<div class="sel">
							<ul>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_minor', '부')">부전공</a></li>
								<li><a href="javaScript:;" onclick="fn_sel_value_set(this, 'univ_minor', '복수')">복수전공</a></li>
							</ul>
						</div>
					</div>
					<input type="text" id="univ_minornm" name="univ_minornm" class="txt" placeholder="전공명" style="width:417px;">
				</div>
				<button type="button" id="univ_add_minor" name="전공추가" class="add_btn on">다른 전공 추가</button>
			</div>
		</div>
		<%
		End If 
		%>

	</div>
	<div class="add_box">
		<button type="button" class="addItem r1">추가하기</button>
	</div>
</div><!-- 학력사항 -->