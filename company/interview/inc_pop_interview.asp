<%
	Dim disYY : disYY = Year(now)
	Dim disMM : disMM = Month(now)

	ConnectDB DBCon, Application("DBInfo_FAIR")

	Dim arrRsPopInterview
	ReDim param(12)

	param(0)  = makeParam("@MODE",				adVarchar, adParamInput, 20, mode)
	param(1)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, jid)
	param(2)  = makeParam("@PID",				adVarchar, adParamInput, 1, "3")
	param(3)  = makeParam("@INTERVIEW_N",		adVarchar, adParamInput, 1, "")
	param(4)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, "")
	param(5)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, "")
	param(6)  = makeParam("@INTERVIEW_RESULT",	adVarchar, adParamInput, 1, "")
	param(7)  = makeParam("@CONFIRM_YN",		adVarchar, adParamInput, 1, "")
	param(8)  = makeParam("@KW",				adVarchar, adParamInput, 100, "")
	param(9)  = makeParam("@JOB_PART",			adInteger, adParamInput, 4, "")
	param(10) = makeParam("@PAGE",				adInteger, adParamInput, 4, 1)
	param(11) = makeParam("@PAGE_SIZE",			adInteger, adParamInput, 4, 1000)
	param(12) = makeParam("@TOTAL_CNT",			adInteger, adParamOutput, 4, 0)

	arrRsPopInterview = arrGetRsSP(dbCon, "usp_기업서비스_면접배정_리스트", param, "", "")
	
	Dim str_set_interview_day : str_set_interview_day = ""
	If isArray(arrRsPopInterview) Then
	For i=0 To UBound(arrRsPopInterview, 2)
		If arrRsPopInterview(24, i) <> "" Then str_set_interview_day = str_set_interview_day & "," & arrRsPopInterview(24, i)
	Next
	End If

	DisconnectDB DBCon
%>
<script type="text/javascript" src="./js/interview.js"></script>
<script type="text/javascript" src="./js/calendar.js"></script>
<script type="text/javascript">
	var diart_date = 'empty';

	$(document).ready(function () {
		onLoad_Action(); //달력로드
		

		//var interview_day = "<%=interview_day%>";

		$('.day_btn').each(function() {
			if (this.value == todayToString) {
				$(this).addClass('on');
			}
		});

	});
</script>

<!-- 면접자 배정 -->
<div id="pop_interview">
<div id="pop_dim" class="pop_dim"></div>
<div id="popup" class="popup large">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>면접자 배정</h3>
			<a href="#none" class="layer_close">닫기</a>
		</div> 
		<div class="pop_con">
			<div class="placement_area">
				<div class="left_box">

					<!-- ☆ 면접선택 추가:S -->
					<div class="caTypeChk MB30" style="display:none;">
						<h4>
							면접 선택
							<!-- <a href="javascript:;" class="initChoice" title="선택취소"></a> -->
						</h4>
						<div class="ctp">
							<div class="cmmInput radiochk">
								<label>
									<input type="radio" name="online_yn" value="Y" checked />
									<span class="lb">비대면(온라인화상) 면접</span>
								</label>
							</div>
							<div class="cmmInput radiochk">
								<label>
									<input type="radio" name="online_yn" value="N"/>
									<span class="lb">대면(오프라인) 면접</span>
								</label>
							</div>
						</div>
					</div>
					<!-- ☆ 면접선택 추가:E -->

					<input type="hidden" id="str_set_interview_day" value="<%=str_set_interview_day%>">
					<div class="calendar_area">
						<h4>일시선택</h4>
						<div class="calendar_box">
							<!-- 기준년월 영역 -->
							<div id="calendar_date_in">
								<button type="button" class="btn left">왼쪽</button>
								<p><span>2020</span>.<span>07</span>.</p>
								<button type="button" class="btn right">오른쪽</button>
							</div>
							<!-- 달력영역 -->
							<div id="table-id">
							</div>
						</div>
					</div>
					<div class="time">
						<h4>면접시간 선택</h4>
						<ul class="t_ul">
							<% For i = 1 To 6 %>
							<li>							
								<label class="radiobox off" for="time1_<%=i%>">
									<input type="radio" class="rdi" id="time1_<%=i%>" name="set_interview_time" value="<%=i%>" onclick="fn_time_set(this);">
								</label>
								<span><%=getInterviewTime(i)%></span>
							</li>
							<% Next %>
						</ul>
						<ul class="t_ul">
							<% For i = 7 To 16 %>
							<li>
								<label class="radiobox off" for="time1_<%=i%>">
									<input type="radio" class="rdi" id="time1_<%=i%>" name="set_interview_time" value="<%=i%>" onclick="fn_time_set(this);">
								</label>
								<span><%=getInterviewTime(i)%></span>
							</li>
							<% Next %>
						</ul>
					</div>
				</div>
				<div class="middle_box">
					<div class="passer">
						<h4>서류합격자</h4>
						<div class="p_list">
							<ul id="ul_passer_list">
								<% 
								If isArray(arrRsPopInterview) Then

								For i=0 To UBound(arrRsPopInterview, 2)

									If isnull(arrRsPopInterview(30,i)) = false Then

										'생년월일 나이
										If arrRsPopInterview(6, i) = "1" Or arrRsPopInterview(6, i) = "2" Then
											birth_ymd = "19" & arrRsPopInterview(5, i)
										Else
											birth_ymd = "20" & arrRsPopInterview(5, i)
										End If
										user_age = Year(now) - Left(birth_ymd, 4) + 1

										'경력표기
										tot_sum = Abs(arrRsPopInterview(11, i))

										If tot_sum = "0" Then 
											career_str = "신입"
										ElseIf tot_sum > 12 Then
											career_str = "경력 " & fix(tot_sum / 12) & "년"
											If tot_sum mod 12 > 0 Then 
												career_str = career_str & " " & tot_sum mod 12 & "개월"
											End If
										Else 
											career_str = "경력 " & tot_sum & "개월"
										End If

										'최종학력
										strFinalSchool = ""
										Select Case arrRsPopInterview(9, i)
											Case "3" : strFinalSchool = "고등학교"
											Case "4" : strFinalSchool = "대학(2.3년)"
											Case "5" : strFinalSchool = "대학교(4년)"
											Case "6" : strFinalSchool = "대학원"
										End Select

										Dim pop_interviewYN : pop_interviewYN = False
										If arrRsPopInterview(24, i) <> "" Then pop_interviewYN = True

										Dim pop_confirmYN : pop_confirmYN = false
										If arrRsPopInterview(26, i) = "Y" Then pop_confirmYN = True

										Dim label_class : label_class = ""
										If pop_interviewYN And pop_confirmYN = False Then label_class = "assi"
										If pop_confirmYN Then label_class = "confi"
								%>
								<li>
									<label class="checkbox <%=label_class%> off">
										<% If pop_confirmYN = False Then %>
										<input class="chk" name="set_interview_applyno" type="checkbox" value="<%=arrRsPopInterview(14, i)%>" onclick="fn_applyno_max_cnt(this);">
										<% End If %>
										<div class="txt">
											<strong><%=arrRsPopInterview(4, i)%> (<%=user_age%>세)</strong><br>
											<span>
												
												<% If pop_interviewYN And pop_confirmYN = False Then %>
													<%=Split(arrRsPopInterview(24, i), "-")(1)%>월 <%=Split(arrRsPopInterview(24, i), "-")(2)%>일 <%=getInterviewTime(arrRsPopInterview(25, i))%>
													<br><em>면접배정</em>

												<% ElseIf pop_confirmYN Then %>
													<%=Split(arrRsPopInterview(24, i), "-")(1)%>월 <%=Split(arrRsPopInterview(24, i), "-")(2)%>일 <%=getInterviewTime(arrRsPopInterview(25, i))%>
													<br><em>면접확정</em>
												
												<% Else %>
													<%=career_str%>
													<% If arrRsPopInterview(16, i) <> "" Then Response.write " | " & arrRsPopInterview(16, i) %>
													<% If strFinalSchool <> "" Then Response.write "<br>" & strFinalSchool %>

												<% End If %>
											</span>
										</div>
									</label>
								</li>
								<%
									End If
								Next 
								End if
								%>
							</ul>
						</div>
						<button type="button" class="btn_preview" onclick="fn_set_preview();">미리보기</button>
					</div>
				</div>

				<form id="frm_pop" name="frm_pop" method="post" action="./proc_interview_save.asp">

				<input type="hidden" id="set_mode" name="set_mode" value="<%=mode%>">
				<input type="hidden" id="set_jid" name="set_jid" value="<%=jid%>">
				<input type="hidden" id="set_interview_day" name="set_interview_day" value="">

				<div class="right_box">
					<div class="preview">
						<h4>면접배정자 미리보기</h4>
						<div class="p_list">
							<ul id="ul_preview_list">
								<!--
								<li id="">
									<div class="preview_info">
										<p>8월 10일 09:00-09:25</p>
										<ul class="pi_ul">
											<li>
												<strong>이순신 (남, 33세)</strong> / 신입 / 4년제 졸업
												<button type="button">닫기</button>
											</li>
											<li>
												<strong>정도전 (남, 35세)</strong> / 2년 2개월 / 4년제 졸업
												<button type="button">닫기</button>
											</li>
										</ul>
									</div>
								</li>
								-->
								<p class="p_ment">
									면접일자, 시간, 서류합격자를 선택 후<br>
									<span>미리보기 버튼을 클릭</span>해 주세요.<br><br>
									면접시간 당 최대 4명 까지만 <br>
									배정할 수 있습니다.
								</p>
							</ul>
						</div>
					</div>
				</div>
				</form>

			</div><!--//placement_area-->
		</div>
		<div class="pop_footer">
			<div class="btn_area right">
				<a href="javaScript:;" onclick="fn_interview_save();"  class="btn blue">저장</a>
			</div>
		</div>

	</div>
</div>
</div>
<!-- //면접자 배정 -->