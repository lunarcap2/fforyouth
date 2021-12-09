<script type="text/javascript" src="/js/resume_renew.js"></script>
<script type="text/javascript" src="/js/printThis.js"></script>

<script type="text/javascript">
	document.domain = "career.co.kr";

	function printPage() {
		print();
	}

	function fn_mlr_print(id) {
		var iframe = document.frames ? document.frames[id] : document.getElementById(id);

		var ifWin = iframe.contentWindow || iframe;
		iframe.focus();
		ifWin.leehoPreview();
		return false;
	}

	function print_test() {
		$("#print_div").printThis();
	}

</script>

<%
'arrIngResume	= arrData(0)(0)	'작성중인 이력서번호(중간저장)
'arrBase		= arrData(0)(1)	'기본이력서
'arrUser		= arrData(0)(2)	'개인회원정보(이력서용)
'arrComm		= arrData(0)(3)	'이력서 공통정보
'arrResume		= arrData(0)(4)	'이력서1,2
'
'arrSchool		= arrData(0)(5)	'이력서학력
'arrCareer		= arrData(0)(6)	'이력서경력
'arrActivity	= arrData(0)(7)	'주요활동사항(인턴,대외활동)
'
'arrLanguageUse	= arrData(0)(8)	'외국어 회화능력
'arrLanguageExam= arrData(0)(9)	'외국어 공인시험
'arrLicense		= arrData(0)(10)'자격증
'arrPrize		= arrData(0)(11)'수상
'arrAcademy		= arrData(0)(12)'교육
'arrAbroad		= arrData(0)(13)'해외연수
'
'arrPersonal	= arrData(0)(14)'보훈/장애
'arrMilitary	= arrData(0)(15)'병역
'arrEmpSupport	= arrData(0)(16)'고용지원금대상
'
'arrPortfolio	= arrData(0)(17)'포트폴리오
'
'arrWorkType	= arrData(0)(18)'희망근무형태
'arrArea		= arrData(0)(19)'희망지역
'arrCtKwd		= arrData(0)(20)'희망업종
'arrJcKwd		= arrData(0)(21)'희망직종
'
'arrEssay		= arrData(0)(22)'자기소개서


'이력서 공통정보
Dim p_birth, p_birthYY, p_birthMM, p_birthDD, p_jumin_code, p_phone, p_phone1, p_phone2, p_phone3, p_email, p_email1, p_email2, p_userName, p_address, p_userPhoto, p_selfIntro, p_age
If isArray(arrComm) Then
	p_phone			= arrComm(8, 0)
	p_birthYY		= arrComm(1, 0)
	p_birthMM		= arrComm(2, 0)
	p_birthDD		= arrComm(3, 0)
	p_jumin_code	= arrComm(4, 0)
	If p_jumin_code = "1" Or p_jumin_code = "2" Then
		p_birthYY = "19" & p_birthYY
	Else 
		p_birthYY = "20" & p_birthYY
	End If
	p_birth			= p_birthYY & "." & p_birthMM & "." & p_birthDD
	p_email			= arrComm(10, 0)
	If arrComm(10, 0) <> "" Then p_email1 = Split(arrComm(10, 0), "@")(0)
	If arrComm(10, 0) <> "" Then p_email2 =  Split(arrComm(10, 0), "@")(1)
	p_userName		= arrComm(0, 0)
	p_address		= arrComm(13, 0)
	p_age			= year(date) - p_birthYY + 1
	If arrComm(19, 0) <> "" Then
		'p_userPhoto = "/files/mypic/" & arrComm(19, 0)
		p_userPhoto = "http://www2.career.co.kr/hdrive/fair/mypic/" & arrComm(19, 0)
	End If 
End If 

Dim cal_sdate, cal_edate, cal_datediff

Function getDateDiff(p_sdate, p_edate)
	Dim out_value, sdate, edate

	sdate = Replace(p_sdate, ".", "-")
	edate = Replace(p_edate, ".", "-")

	If isDate(sdate) And isDate(edate) Then
		out_value = Datediff("m", sdate, edate) +1

		If out_value > 11 Then
			If out_value mod 12 > 0 Then
				out_value = fix(out_value / 12) & "년 " & out_value mod 12 & "개월"
			Else 
				out_value = fix(out_value / 12) & "년"
			End If
		Else
			out_value = out_value & "개월"
		End If
	End If

	getDateDiff = out_value
End Function 

%>	

<div id="contents" class="sub_page">
	<!-- 이력서 항목 Rnb -->
	<div class="rnb_wrap" id="quick">
		<div class="rnb">
			<div class="rnb_box">
				<div class="rnb_con view">
					
					<% If v_menu_data = "Y" Then %>
					<ul class="btn_ul">
						<li><a href="/my/resume/resume_regist.asp?rid=<%=rid%>">이력서 수정</a><li>
						<li><a href="javascript:fn_mod_date_update(<%=rid%>);">오늘 날짜로 업데이트</a><li>
					</ul>
					<% End If %>
					
					<% If v_menu_file = "Y" Then %>
					<ul class="btn_ul">
						<li><a href="javaScript:;" onclick="printIframe('printUrl');">인쇄하기</a><li>
						<!--
						<li><a href="javaScript:;" onclick="fn_mlr_print('printMLR');">인쇄하기</a><li>
						<li><a href="javaScript:;" onclick="fn_mlr_print('printMLR');">PDF로 다운로드</a><li>
						-->
					</ul>
					<% End If %>

					<ul class="navi_ul">
						<li><a href="#view1">프로필</a></li>
							
						<% If isArray(arrSchool) Then %>
						<li><a href="#view2">학력</a></li>
						<% End If %>

						<% If isArray(arrCareer) Then %>
						<li><a href="#view3">경력</a></li>
						<% End If %>
						
						<% If isArray(arrActivity) Then %>
						<li><a href="#view4">인턴. 대외활동</a></li>
						<% End If %>

						<% If isArray(arrLanguageUse) Or isArray(arrLanguageExam) Then %>
						<li><a href="#view5">외국어</a></li>
						<% End If %>

						<% If isArray(arrLicense) Then %>
						<li><a href="#view6">자격증</a></li>
						<% End If %>

						<% If isArray(arrPrize) Then %>
						<li><a href="#view7">수상</a></li>
						<% End If %>

						<% If isArray(arrAcademy) Then %>
						<li><a href="#view8">교육</a></li>
						<% End If %>

						<% If isArray(arrAbroad) Then %>
						<li><a href="#view9">해외경험</a></li>
						<% End If %>

						<% If isArray(arrPersonal) Or isArray(arrEmpSupport) Or isArray(arrMilitary) Then %>
						<li><a href="#view10">취업우대항목</a></li>
						<% End If %>

						<% If isArray(arrPortfolio) Then %>
						<li><a href="#view11">포트폴리오</a></li>
						<% End If %>

						<% If isArray(arrEssay) Then %>
						<li><a href="#view12">자기소개서</a></li>
						<% End If %>

						<% If isArray(arrWorkType) Or isArray(arrArea) Or isArray(arrCtKwd) Or isArray(arrJcKwd) Or salary_amt <> "" Then %>
						<li><a href="#view13">희망근무조건</a></li>
						<% End If %>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!-- //이력서 항목 Rnb -->

	<div class="content" id="print_div">
		<div class="con_area print">
			


			<div id="view0" class="view_box">
				<h3 class="title"><%=arrResume(2, 0)%></h3>
			</div>

			<div id="view1" class="view_box">
				<h3 class="name"><%=p_userName%><span>(<%=p_age%>세)</span></h3>
				<div class="img_box">
					<span><img src="<%=p_userPhoto%>"></span>
				</div>
				<div class="vb_area">
					<div class="vb_item">
						<div class="vb_label">연락처</div>
						<div class="vb_value"><%=p_phone%></div>
					</div>

					<div class="vb_item">
						<div class="vb_label">생년월일</div>
						<div class="vb_value"><%=p_birth%></div>
					</div>

					<div class="vb_item">
						<div class="vb_label">E-mail</div>
						<div class="vb_value"><%=p_email%></div>
					</div>

					<div class="vb_item">
						<div class="vb_label">주소</div>
						<div class="vb_value"><%=p_address%></div>
					</div>
				</div>
				
				<% If arrResume(32, 0) <> "" Then %>
				<div class="vb_txt">
					<p><%=Replace(arrResume(32, 0), Chr(13), "<br>")%></p>
				</div>
				<% End If %>
			</div>

			<% If isArray(arrSchool) Then %>
			<div id="view2" class="view_box">
				<h3>학력사항</h3>
				<% 
				For i=0 To UBound(arrSchool, 2)
				Dim univ_etype_nm
				Select Case arrSchool(12, i)
					Case "3" : univ_etype_nm = "재학"
					Case "4" : univ_etype_nm = "휴학"
					Case "5" : univ_etype_nm = "중퇴"
					Case "7" : univ_etype_nm = "졸업(예)"
					Case "8" : univ_etype_nm = "졸업"
				End Select
				
				Dim univ_year : univ_year = ""
				Select Case arrSchool(2,i)
					Case "4" : univ_year = "2,3년제"
					Case "5" : univ_year = "4년제"
				End Select

				cal_sdate = ""
				cal_edate = ""
				If isDate(arrSchool(7, i) & "-" & arrSchool(8, i)) Then cal_sdate = arrSchool(7, i) & "." & arrSchool(8, i)
				If isDate(arrSchool(10, i) & "-" & arrSchool(11, i)) Then cal_edate = arrSchool(10, i) & "." & arrSchool(11, i)
				%>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name"><%=arrSchool(3, i)%></div> 
						<div class="term">
							(
							<span><%=cal_sdate%></span>~<span><%=cal_edate%></span>
							<% If univ_year <> "" Then %>
							/ <%=univ_year%>
							<% End If %>
							)
						</div>
						<div class="line">
							<span><%=arrSchool(6, i)%></span>
							<span><%=univ_etype_nm%></span>
							<% If arrSchool(13, i) <> "" then %>
							<span>(<%=arrSchool(13, i)%>)</span>
							<% End If %>
							<% If arrSchool(17, i) <> "" Then %>
							/ <span><%=arrSchool(17, i)%>전공</span>
							<span><%=arrSchool(18, i)%></span>
							<% End If %>
						</div>
					</div>

					<div class="vb_row">
						<p><%=arrSchool(24, i)%></p>
					</div>
				</div>
				<% Next %>
			</div><!-- 학력사항 -->
			<% End If %>

			
			<% If isArray(arrCareer) Then %>
			<div id="view3" class="view_box">
				<h3>경력사항</h3>
				<% 
				For i=0 To UBound(arrCareer, 2) 
				Dim experience_nowstatus_hdn_nm

				cal_sdate = ""
				cal_edate = ""
				cal_datediff = ""

				If arrCareer(5, i) = "2" Then 
					If isDate(arrCareer(6, i) & "-" & arrCareer(7, i)) Then cal_sdate = arrCareer(6, i) & "." & arrCareer(7, i)
					cal_datediff = getDateDiff(cal_sdate, Left(Date(), 7))
					cal_edate = "재직중"
				Else
					If isDate(arrCareer(6, i) & "-" & arrCareer(7, i)) Then cal_sdate = arrCareer(6, i) & "." & arrCareer(7, i)
					If isDate(arrCareer(8, i) & "-" & arrCareer(9, i)) Then cal_edate = arrCareer(8, i) & "." & arrCareer(9, i)
					cal_datediff = getDateDiff(cal_sdate, cal_edate)
				End If
				%>
				<div class="vb_section">
					<div class="vb_row">
						<% If arrCareer(20, i) = "0" Then %>
						<div class="name">회사명 비공개</div>
						<% Else %>
						<div class="name"><%=arrCareer(1, i)%></div>
						<% End If %>
						<div class="term">
						( <span><%=cal_sdate%></span> ~ <span><%=cal_edate%></span>
						<% If cal_datediff <> "" Then %>
						 / <%=cal_datediff%>
						<% End If %>
						)
						</div>
					</div>
					<div class="vb_detail">
						<div class="position"><%=arrCareer(3, i)%></div>
						<% If arrCareer(26, i) <> "" Then %>
						<p><%=Replace(arrCareer(26, i), Chr(13), "<br>")%></p>
						<% End If %>
					</div>
				</div>
				<% Next %>
			</div><!-- 경력사항 -->
			<% End If %>
			
			<% If isArray(arrActivity) Then %>
			<div id="view4" class="view_box">
				<h3>인턴,대외활동</h3>
				<% 
				For i=0 To UBound(arrActivity, 2)
				Dim rac_type_nm
				Select Case arrActivity(1, i)
					Case "1" : rac_type_nm = "인턴"
					Case "2" : rac_type_nm = "아르바이트"
					Case "3" : rac_type_nm = "교내활동"
					Case "4" : rac_type_nm = "동아리"
					Case "5" : rac_type_nm = "자원봉사"
					Case "6" : rac_type_nm = "대외활동"
					Case "7" : rac_type_nm = "사회활동"
				End Select

				cal_sdate = ""
				cal_edate = ""
				cal_datediff = ""
				if isDate(arrActivity(3, i) & "-" & arrActivity(4, i)) Then cal_sdate = arrActivity(3, i) & "." & arrActivity(4, i)
				If isDate(arrActivity(5, i) & "-" & arrActivity(6, i)) Then cal_edate = arrActivity(5, i) & "." & arrActivity(6, i)
				cal_datediff = getDateDiff(cal_sdate, cal_edate)
				%>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name"><%=arrActivity(7, i)%></div> 
						<div class="term">
						( <span><%=cal_sdate%></span> ~ <span><%=cal_edate%></span>
						<% If cal_datediff <> "" Then %>
						 / <%=cal_datediff%>
						<% End If %>
						)</div>
					</div>
					<div class="vb_detail">
						<div class="position v2"><%=rac_type_nm%></div>
						<% If arrActivity(9, i) <> "" Then %>
						<p><%=Replace(arrActivity(9, i), Chr(13), "<br>")%></p>
						<% End If %>
					</div>
				</div>
				<% Next %>
			</div><!-- 인턴,대외활동 -->
			<% End If %>

			<% If isArray(arrLanguageUse) Or isArray(arrLanguageExam) Then %>
			<div id="view5" class="view_box">
				<h3>외국어</h3>
				<div class="vb_section">
					<div class="vb_row">
						<div class="language">
							<% If IsArray(arrLanguageUse) Then %>
							<dl>
								<dt>회화능력</dt>
								<dd>
									<table>
										<tbody>
											<%
											For i=0 To UBound(arrLanguageUse, 2) 
											Dim language_talk_nm
											Select Case arrLanguageUse(2, i)
												Case "1" : language_talk_nm = "상"
												Case "2" : language_talk_nm = "중"
												Case "3" : language_talk_nm = "하"
											End Select
											%>
											<tr>
												<td><%=getLanguageCode(arrLanguageUse(1, i))%></td>
												<td><%=language_talk_nm%></td>
											</tr>
											<% Next %>
										</tbody>
									</table>
								</dd>
							</dl>
							<% End If %>

							<% If IsArray(arrLanguageExam) Then %>
							<dl>
								<dt>공인시험</dt>
								<dd>
									<table>
										<tbody>
											<% 
											For i=0 To UBound(arrLanguageExam, 2) 
											cal_sdate = ""
											If isDate(arrLanguageExam(4, i) & "-" & arrLanguageExam(5, i)) Then cal_sdate = arrLanguageExam(4, i) & "." & arrLanguageExam(5, i)
											%>
											<tr>
												<td><%=getLanguageCode(arrLanguageExam(1, i))%></td>
												<td><%=getLanguageExamCodeNm(arrLanguageExam(2, i))%></td>
												<td><%=arrLanguageExam(3, i)%></td>
												<td><%=cal_sdate%></td>
											</tr>
											<% Next %>
										</tbody>
									</table>									
								</dd>
							</dl>
							<% End If %>
						</div>
					</div>
				</div>
			</div><!-- 외국어 -->
			<% End If %>
			
			<% If isArray(arrLicense) Then %>
			<div id="view6" class="view_box">
				<h3>자격증</h3>
				<% 
				For i=0 To UBound(arrLicense, 2) 
				cal_sdate = ""
				If isDate(arrLicense(3, i) & "-" & arrLicense(4, i)) Then  cal_sdate = arrLicense(3, i) & "." & arrLicense(4, i)
				%>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name"><%=arrLicense(1, i)%></div>
						<div class="data">
							( <span><%=cal_sdate%></span> / <span><%=arrLicense(2, i)%></span> )
						</div>
					</div>
				</div>
				<% Next %>
			</div><!-- 자격증 -->
			<% End If %>
			
			<% If isArray(arrPrize) Then %>
			<div id="view7" class="view_box">
				<h3>수상</h3>
				<% 
				For i=0 To UBound(arrPrize, 2) 
				cal_sdate = ""
				If isDate(arrPrize(3, i) & "-" & arrPrize(4, i)) Then cal_sdate = arrPrize(3, i) & "." & arrPrize(4, i)
				%>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name"><%=arrPrize(2, i)%></div>
						<div class="data">
							( <span><%=cal_sdate%></span> / <span><%=arrPrize(1, i)%></span> )
						</div>
					</div>
				</div>
				<% Next %>
			</div><!-- 수상 -->
			<% End If %>

			<% If isArray(arrAcademy) Then %>
			<div id="view8" class="view_box">
				<h3>교육</h3>
				<% 
				For i=0 To UBound(arrAcademy, 2) 
				cal_sdate = ""
				cal_edate = ""
				cal_datediff = ""
				If isDate(arrAcademy(2, i) & "-" & arrAcademy(3, i)) Then cal_sdate = arrAcademy(2, i) & "." & arrAcademy(3, i)
				If isDate(arrAcademy(4, i) & "-" & arrAcademy(5, i)) Then cal_edate = arrAcademy(4, i) & "." & arrAcademy(5, i)
				cal_datediff = getDateDiff(cal_sdate, cal_edate)
				%>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name"><%=arrAcademy(6, i)%></div>
						<div class="data">
							( <span><%=cal_sdate%></span> ~ <span><%=cal_edate%></span>
							<% If cal_datediff <> "" Then %>
							 / <%=cal_datediff%> 
							<% End If %>
							/ <span><%=arrAcademy(1, i)%></span> )
						</div>
					</div>
				</div>
				<% Next %>
			</div><!-- 교육 -->
			<% End If %>
			
			<% If isArray(arrAbroad) Then %>
			<div id="view9" class="view_box">
				<h3>해외경험</h3>
				<% 
				For i=0 To UBound(arrAbroad, 2)
				cal_sdate = ""
				cal_edate = ""
				cal_datediff = ""
				If isDate(arrAbroad(3, i) & "-" & arrAbroad(4, i)) Then cal_sdate = arrAbroad(3, i) & "." & arrAbroad(4, i)
				If isDate(arrAbroad(5, i) & "-" & arrAbroad(6, i)) Then cal_edate = arrAbroad(5, i) & "." & arrAbroad(6, i)
				cal_datediff = getDateDiff(cal_sdate, cal_edate)
				%>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name"><%=getNationCode(arrAbroad(1, i))%></div>
						<div class="term">
						( <span><%=cal_sdate%></span> ~ <span><%=cal_edate%></span>
						<% If cal_datediff <> "" Then %>
						 / <%=cal_datediff%>
						<% End If %>
						)
						</div>

						<% If arrAbroad(7, i) <> "" Then %>
						<div class="txt"><%=Replace(arrAbroad(7, i), Chr(13), "<br>")%></div>
						<% End If %>
					</div>
				</div>
				<% Next %>
			</div><!-- 해외경험 -->
			<% End If %>
			
			<%
			If isArray(arrPersonal) Or isArray(arrEmpSupport) Or isArray(arrMilitary) Then 

			Dim patriot_flag, protect_flag, handicap_flag, handicap_grd, handicap_grd_nm, emp_support_flag
			Dim military_yn, military_nm, kind_class_nm, military_kind, military_class
			Dim military_sdate, military_syear, military_smonth, military_edate, military_eyear, military_emonth, military_reason

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
					Case Else : handicap_grd_nm = "장애등급"
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
				military_kind	= arrMilitary(1, 0)
				military_class	= arrMilitary(2, 0)
				military_reason	= arrMilitary(10, 0)

				Select Case military_yn
					Case "1" : military_nm = "군필"
					Case "2" : military_nm = "미필"
					Case "3" : military_nm = "면제"
					Case "4" : military_nm = "복무중"
					Case Else : military_nm = "병역상태"
				End Select

				cal_sdate = ""
				cal_edate = ""
				cal_datediff = ""
				If isDate(military_syear & "-" & military_smonth) Then cal_sdate = military_syear & "." & military_smonth
				If isDate(military_eyear & "-" & military_emonth) Then cal_edate = military_eyear & "." & military_emonth
				cal_datediff = getDateDiff(cal_sdate, cal_edate)

				Select Case military_yn
					Case 1 kind_class_nm = "군필"
					Case 2 kind_class_nm = "미필"
					Case 3 kind_class_nm = "면제"
					Case 4 kind_class_nm = "복무중"
					Case 5 kind_class_nm = "해당없음"
				End Select

				If military_yn = "1" Or military_yn = "4" Then
					kind_class_nm = getMilitaryKind(military_kind) & " / " & getMilitaryClass(military_class)
				End If
			End If

			%>
			<div id="view10" class="view_box">
				<h3>취업우대.병역</h3>
				<% If patriot_flag = "1" Then %>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name">보훈 대상</div>
					</div>
				</div>
				<% End If %>
				
				<% If protect_flag = "1" Then %>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name">취업보호 대상</div> 
					</div>
				</div>
				<% End If %>
				
				<% If emp_support_flag = "1" Then %>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name">고용지원금 대상</div> 
					</div>
				</div>
				<% End If %>

				<% If handicap_flag = "1" Then %>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name">장애</div>
						<div class="term">(<span><%=handicap_grd_nm%></span>)</div>
					</div>
				</div>
				<% End If %>
				
				<% If military_yn <> "" Then %>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name"><span><%=kind_class_nm%></span></div>
						<% If military_reason <> "" Then %>
						<div class="term"><%=military_reason%></div>
						<% Else %>
						<div class="term">( <span><%=cal_sdate%></span> ~ <span><%=cal_edate%></span>
						<% If cal_datediff <> "" Then %>
						 / <%=cal_datediff%>
						<% End If %>
						)</div>
						<% End If %>
					</div>
				</div>
				<% End If %>
			</div><!-- 취업우대.병역 -->
			<% End If %>
			
			<% If isArray(arrPortfolio) Then %>
			<div id="view11" class="view_box">
				<h3>포트폴리오</h3>
				<div class="vb_section">
					<div class="vb_link">
						<ul>
							<% 
							For i=0 To UBound(arrPortfolio, 2)
								If arrPortfolio(1, i) = "1" Then
							%>
							<li><span>링크</span><a href="http://<%=arrPortfolio(2, i)%>" target="_blank"><%=arrPortfolio(2, i)%></a></li>
							<% 
								End If 
							Next 
							%>
						</ul>
					</div>
					<div class="vb_link">
						<ul>
							<% 
							For i=0 To UBound(arrPortfolio, 2)
								If arrPortfolio(1, i) = "2" Then
							%>
							<li><span>파일</span><a href="https://www2.career.co.kr/myjob/resume/file_download.asp?fileid1=<%=arrPortfolio(3, i)%>&fileid2=<%=arrPortfolio(4, i)%>"><%=arrPortfolio(3, i)%></a></li>
							<!-- <li><span>파일</span><a href="/my/resume/file_download.asp?fileid1=<%=arrPortfolio(3, i)%>&fileid2=<%=arrPortfolio(4, i)%>"><%=arrPortfolio(3, i)%></a></li> -->
							<!-- <li><span>파일</span><a href="/files/resume/<%=arrPortfolio(4, i)%>" target="_blank"><%=arrPortfolio(3, i)%></a></li> -->
							<% 
								End If 
							Next 
							%>
						</ul>
					</div>
				</div>
			</div><!-- 포트폴리오 -->
			<% End If %>
			
			<% If isArray(arrEssay) Then %>
			<div id="view12" class="view_box">
				<h3>자기소개서</h3>
				<% For i=0 To UBound(arrEssay, 2) %>
				<div class="vb_section">
					<div class="vb_row">
						<div class="name"><%=arrEssay(4, i)%></div> 
					</div>
					<div class="vb_me">
						<% If arrEssay(5, i) <> "" Then %>
						<p><%=Replace(arrEssay(5, i), Chr(13), "<br>")%></p>
						<% End If %>
					</div> 
				</div>
				<% Next %>
			</div><!-- 자기소개서 -->
			<% End If %>
			
			<% 
			'arrWorkType	= arrData(0)(18)'희망근무형태
			'arrArea		= arrData(0)(19)'희망지역
			'arrCtKwd		= arrData(0)(20)'희망업종
			'arrJcKwd		= arrData(0)(21)'희망직종

			Dim work_style, work_style_nm, salary_amt, salary_amt_nm
			If isArray(arrWorkType) Then work_style = arrWorkType(0, 0)
			If isArray(arrResume) Then salary_amt = arrResume(10, 0)

			work_style_nm = "고용형태"
			If work_style <> "" Then work_style_nm = getComWorkType(work_style)

			salary_amt_nm = "희망연봉"
			If salary_amt <> "" And salary_amt <> "98" Then salary_amt_nm = getSalayYear(salary_amt)
			If salary_amt = "98" Then salary_amt_nm = "면접 후 결정"

			'업/직종 코드2차 전체
			Dim jc_code_all, ct_code_all
			If isArray(arrResume) Then
				jc_code_all = arrResume(28, 0)
				ct_code_all = arrResume(29, 0)
				If jc_code_all <> "" Then jc_code_all = Split(jc_code_all, "|")
				If ct_code_all <> "" Then ct_code_all = Split(ct_code_all, "|")
			End If


			If isArray(arrWorkType) Or isArray(arrArea) Or isArray(arrCtKwd) Or isArray(arrJcKwd) Or salary_amt <> "" Then
			%>
			<div id="view13" class="view_box">
				<h3>희망 근무조건</h3>
				<div class="vb_tb">
					<table>
						<colgroup>
							<col style="width:140px;">
							<col>
						</colgroup>
						<tbody>
							<% If isArray(arrWorkType) Then %>
							<tr>
								<th>고용형태</th>
								<td colspan="2"><%=work_style_nm%></td>
							</tr>
							<% End If %>

							<% If IsArray(arrArea) Then %>
							<tr>
								<th>희망근무지</th>
								<td colspan="2">
									<div class="category_area area">
										<div class="category">
											<div class="c_jobs">
											<% 
												For i=0 To UBound(arrArea, 2)
													Dim workArea_temp, workArea_temp2
													workArea_temp2 = ""

													If InStr(workArea_temp,getAcName(arrArea(0,i))) = 0 Then
														workArea_temp	= getAcName(arrArea(0,i))
														
														Response.write workArea_temp & " > "

														For ii=0 To UBound(arrArea, 2)
															If arrArea(0,i) = arrArea(0,ii) Then
																If workArea_temp2 = "" Then
																	workArea_temp2 = getAcName(arrArea(1,ii))
																Else
																	workArea_temp2	= workArea_temp2 & ", " & getAcName(arrArea(1,ii))
																End If
															End If															
														Next

														Response.write workArea_temp2 & "<br>"														
													End If
												Next												
											%>
											</div>
										</div>
									</div>
								</td>
							</tr>
							<% End If %>

							<% If salary_amt <> "" Then %>
							<tr>
								<th>희망연봉</th>
								<td colspan="2"><%=salary_amt_nm%></td>
							</tr>
							<% End If %>

							<% If isArray(jc_code_all) Or isArray(ct_code_all) Then %>
							<tr>
								<th rowspan="2">지원분야</th>
								<td colspan="2">
									<% If isArray(jc_code_all) Then	%>
									<div class="category_area jobs">
										<% For i=0 To UBound(jc_code_all) %>
										<div class="category">
											<% If i = 0 Then %>
											<div class="c_head">직무</div>
											<% End If %>
											<div class="c_recommend"><%=getJobtype(Left(jc_code_all(i), 2))%></div>
											<div class="c_recommend"><%=getJobtype(jc_code_all(i))%></div>
											<div class="c_jobs">
											<%
											If isArray(arrJcKwd) Then
												For ii=0 To UBound(arrJcKwd, 2)
												If jc_code_all(i) = Left(arrJcKwd(0, ii), 4) Then
											%>
											<%=arrJcKwd(1, ii)%>&nbsp;
											<%
												End If
												Next
											End If
											%>
											</div>
										</div>
										<% Next %>
									</div>
									<% End If %>

									<% If isArray(ct_code_all) Then	%>
									<div class="category_area">
										<% For i=0 To UBound(ct_code_all) %>
										<div class="category">
											<% If i = 0 Then %>
											<div class="c_head">산업</div>
											<% End If %>
											<div class="c_recommend"><%=getJobtype(Left(ct_code_all(i), 2))%></div>
											<div class="c_recommend"><%=getJobtype(ct_code_all(i))%></div>
											<div class="c_jobs">
											<%
											If isArray(arrCtKwd) Then
												For ii=0 To UBound(arrCtKwd, 2)
												If ct_code_all(i) = Left(arrCtKwd(0, ii), 4) Then
											%>
											<%=arrCtKwd(1, ii)%>&nbsp;
											<%
												End If
												Next
											End If
											%>
											</div>
										</div>
										<% Next %>
									</div>
									<% End If %>
								</td>
							</tr>
							<% End If %>
						</tbody>
					</table>
				</div>
			</div><!-- 희망 근무조건 -->
			<% End If %>
				
			<% If v_pop_yn = "Y" Then %>
			<div class="list_btn">
				<a class="btn close" href="javascript:;" onclick="javascript:window.close();">닫기</a>
			</div>
			<% Else %>
			<div class="list_btn">
				<a class="btn list" href="/my/resume_list.asp">목록보기</a>
			</div>
			<% End If %>


			<%
			Dim resume_mod_date, str_resume_mod_date
			resume_mod_date = Split(Left(arrResume(19, 0), 10), "-")
			str_resume_mod_date = resume_mod_date(0) & "년 " & resume_mod_date(1) & "월 " & resume_mod_date(2) & "일"
			%>
			<div class="chk_txt">
				<p>위의 모든 기재사항은 사실과 다름없음을 확인합니다.<br>
				작성자 : <span><%=p_userName%></span></p>
				<em>
				이 이력서는 <%=str_resume_mod_date%>에 최종 업데이트된 이력서 입니다.<br>
				위조된 문서를 등록하여 취업활동에 이용 시 법적 책임을 지게 될 수 있습니다.<br>
				<%=site_name%> 서비스는 구직자가 등록 한 문서에 대해 보증하거나 별도의 책임을 지지 않으며<br>
				첨부된 문서를 신뢰하여 발생한 법적 분쟁에 책임을 지지 않습니다.<br>
				또한 구인/구직 목적 외 다른 목적으로 이용시 이력서 삭제 혹은 비공개 조치가 될 수 있습니다.
				</em>
			</div>

		</div><!-- .con_area -->
	</div><!-- .content -->
</div>

<% If v_menu_file = "Y" Then %>
<!-- <iframe src="https://newprint.career.co.kr/hkpartner/resume_mlrpt_load.asp?set_rid=<%=rid%>&set_userid=<%=set_user_id%>&set_url=<%=Request.ServerVariables("SERVER_NAME")%>/resume/view_print.asp" id="printMLR" border="0" cellspacing="0" width="0px" height="0px" frameborder="0"></iframe> -->
<iframe src="/resume/view_print.asp?rid=<%=rid%>&set_user_id=<%=set_user_id%>&apply_resume=<%=apply_resume%>" id="printUrl" border="0" cellspacing="0" width="0px" height="0px" frameborder="0"></iframe>
<% End If %>