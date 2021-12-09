<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<%
Call FN_LoginLimit("2")	'기업회원 허용


ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim jid, mode, pid, interview_day, interview_time, interview_result, kw, job_part
	Dim jid_NM
	jid = request("jid")
	mode = request("mode")
	pid = request("pid")
	interview_day = request("interview_day")
	interview_time = request("interview_time")
	interview_result = request("interview_result")
	kw = request("kw")
	job_part = request("job_part")


	If jid = "" Then 
		strsql = ""
		strsql = strsql & " SELECT TOP 1 등록번호, 구분"
		strsql = strsql & " FROM ("
		strsql = strsql & " 	SELECT 등록번호, 'ing' AS 구분, 1 AS 순번, 등록일  FROM 채용정보 WITH(NOLOCK)"
		strsql = strsql & " 	WHERE 회사아이디 = '"& comid &"'"
		strsql = strsql & " 	UNION "
		strsql = strsql & " 	SELECT 등록번호, 'cl' AS 구분, 2 AS 순번, 등록일 FROM 마감채용정보 WITH(NOLOCK)"
		strsql = strsql & " 	WHERE 회사아이디 = '"& comid &"'"
		strsql = strsql & " ) AS T"
		strsql = strsql & " ORDER BY 순번, 등록일 DESC"
		
		arrRsjid = arrGetRsSql(DBCon, strsql, "", "")

		If isArray(arrRsjid) Then 
			jid = arrRsjid(0, 0)
			mode = arrRsjid(1, 0)
		Else 
			Call FN_AlertMsg("채용공고를 입력하시기 바랍니다.", "history.back();", True)
		End If 
	End If


	If mode = "" Then
		Dim mode_param(2)
		mode_param(0)=makeParam("@id_num", adInteger, adParamInput, 4, jid)
		mode_param(1)=makeParam("@mode", adVarChar, adParamOutput, 4, "")
		mode_param(2)=makeParam("@bizNum", adVarChar, adParamOutput, 10, "")

		Call execSP(DBCon, "W_채용정보_상태_조회", mode_param, "", "")

		mode	= getParamOutputValue(mode_param, "@mode")	' 채용공고 상태(ing : 진행, cl: 마감)
	End If

	If interview_day = "" Then interview_day = Date()
	If interview_time = "" Then interview_time = ""
	If job_part = "" Then job_part = ""

	Dim page, psize, totalCnt, totalPage, i
	page = CInt(Request("page"))
	psize = CInt(Request("psize"))
	If page = "0" Then page = 1
	If psize = "0" Then psize = 10

	'페이지변수셋팅
	Dim stropt
	stropt = "mode=" & mode & "&jid=" & jid & "&interview_day=" & interview_day & "&interview_time=" & interview_time & "&kw=" & kw & "&job_part=" & job_part 

	Dim spName, arrRs, arrRsTitle, arrRsMojip, arrRsTimeToCnt
	ReDim param(12)
	spName = "usp_기업서비스_면접배정_리스트"

	param(0)  = makeParam("@MODE",				adVarchar, adParamInput, 20, mode)
	param(1)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, jid)
	param(2)  = makeParam("@PID",				adVarchar, adParamInput, 1, "3")
	param(3)  = makeParam("@INTERVIEW_N",		adVarchar, adParamInput, 1, "")
	param(4)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, interview_day)
	param(5)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, interview_time)
	param(6)  = makeParam("@INTERVIEW_RESULT",	adVarchar, adParamInput, 1, "")
	param(7)  = makeParam("@CONFIRM_YN",		adVarchar, adParamInput, 1, "")
	param(8)  = makeParam("@KW",				adVarchar, adParamInput, 100, kw)
	param(9)  = makeParam("@JOB_PART",			adInteger, adParamInput, 4, job_part)
	param(10) = makeParam("@PAGE",				adInteger, adParamInput, 4, page)
	param(11) = makeParam("@PAGE_SIZE",			adInteger, adParamInput, 4, psize)
	param(12) = makeParam("@TOTAL_CNT",			adInteger, adParamOutput, 4, 0)

	arrRs = arrGetRsSP(dbCon, spName, param, "", "")
	totalCnt = getParamOutputValue(param, "@TOTAL_CNT")
	totalPage = (totalCnt / 10) + 1
	
	If mode = "ing" Then
		'채용제목
		spName = "SELECT 모집내용제목 FROM 채용정보 WITH(NOLOCK) WHERE 등록번호 = " & jid
		arrRsTitle = arrGetRsSql(DBCon, spName, "", "")
		jid_NM = arrRsTitle(0,0)
		'모집부문
		spName = "SELECT 등록순차번호, 모집부문명 FROM 채용모집부문 WITH(NOLOCK) WHERE 채용등록번호 = " & jid
		arrRsMojip = arrGetRsSql(DBCon, spName, "", "")
	ElseIf mode = "cl" Then 
		'채용제목
		spName = "SELECT 모집내용제목 FROM 마감채용정보 WITH(NOLOCK) WHERE 등록번호 = " & jid
		arrRsTitle = arrGetRsSql(DBCon, spName, "", "")
		jid_NM = arrRsTitle(0,0)
		'모집부문
		spName = "SELECT 등록순차번호, 모집부문명 FROM 마감채용모집부문 WITH(NOLOCK) WHERE 채용등록번호 = " & jid
		arrRsMojip = arrGetRsSql(DBCon, spName, "", "")
	End If

	ReDim param(2)
	param(0)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, jid)
	param(1)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, interview_day)
	param(2)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, "")

	spName = "usp_기업서비스_면접배정_일시별인원수"
	arrRsTimeToCnt = arrGetRsSP(dbCon, spName, param, "", "")

	stropt = "mode=" & mode & "&jid=" & jid & "&pid=" & pid

DisconnectDB DBCon
%>
<script type="text/javascript">

	$(document).ready(function () {

		$("input:radio[name=tb1_1]").click(function(){
			if($("input:radio[name=tb1_1]:checked").val() == "email"){
				$("#tb_email").show();
				$("#tb_sms").hide();
				$("#chk_sms").show();
			}else{
				$("#tb_email").hide();
				$("#tb_sms").show();
				$("#chk_sms").hide();
			}
		});

		$("input:radio[name='tb1_1'][value='email']").prop("checked", true);
		$("#tb_email").show();
		$("#tb_sms").hide();
		$("#chk_sms").show();

		$("#preview").hide();

		radioboxFnc(); //라디오박스
		fn_rece_set(); // 결과통보하기 초기셋팅
	});

	function openLayer(idName, apply_num, interview_time) {
		switch (idName)
		{
			case "interview":
				$("#pop_interview").show();
				$("#pop_result_interview").hide();
				$("#pop_result_apply").hide();
				break;
			case "result_apply":
				$("#pop_interview").hide();
				$("#pop_result_interview").hide();
				$("#pop_result_apply").show();
				break;
			case "result_interview":
				$("#pop_interview").hide();
				$("#pop_result_apply").hide();

				var date = new Date();

				var today_date = getDateToString(date);
				var set_date = "<%=interview_day%>"
				var set_time = getInterviewTime(interview_time).split("~")[0];
				var today_time = date.getHours() + ":" + date.getMinutes();

				if ((today_date == set_date && today_time < set_time) || (today_date < set_date)) {
					$("#pop_result_interview").hide();

					alert("아직 면접시간이 아닙니다.");
				} else {
					$("#pop_result_interview").show();

					$.ajax({
						type: "POST",
						url: "inc_pop_result_interview.asp",
						data: { _apply_num: apply_num, _interview_time: interview_time, _interview_day: "<%=interview_day%>", _mode: "<%=mode%>", _jid: "<%=jid%>" },
						dataType: "html",
						success: function (data) {
							$("#result_interview_html").html(data);
						},
						error:function(request,status,error){
							//alert("code:"+request.status+"\n"+"\n"+"error:"+error);
						}
					});
				}

				break;
		}
	}

	function fn_sch() {
		$('#frm').submit();
	}

	function fn_sch_job_part(_val) {
		$('#job_part').val(_val);
		$('#frm').submit();
	}

	function fn_reset() {
		$('#kw').val("");
		$('#job_part').val("");
		$('#frm').submit();
	}


	function fn_set_interview_time(_val) {
		$('#interview_time').val(_val);
		$('#frm').submit();
	}

	function fn_result_submit() {
		var chk = $(".radiobox.on > input[name ^= 'achk']");
		
		for (i=0; i < chk.length; i++)
		{
			var apply_num = chk.eq(i).parent().parent().prev().val();
			var acco_chk = chk.eq(i).val();
			var acco_textarea = chk.eq(i).parent().parent().next().val();
			
			// 면접불참제외하고는 내용 필수
			if ((trim(acco_chk) != "8" && trim(acco_textarea) != "") || (trim(acco_chk) == "8")) {
				$.ajax({
					type: "POST",
					url: "proc_interview_result_save.asp",
					data: { _apply_num: apply_num, _acco_chk: acco_chk, _acco_textarea: escape(acco_textarea), _jid: "<%=jid%>" },
					success: function (data) {
						if (data == "1") {
							location.reload();
						}
					},
					error:function(request,status,error){
						//alert("code:"+request.status+"\n"+"\n"+"error:"+error);
					}
				});
			}			
			else {
				alert("내용에 빈값이 있습니다. 확인해 주세요.\n(면접불참을 제외한 나머지는 내용을 입력하셔야 합니다.)");
				return false;
			}
		}
		
	}

	
	function fn_calendar(obj) {
		//$(obj).parents('.select_box').addClass('on');
	}

	// 면접일정 배정 대상자 일괄 문자/메일 발송
	function fn_interview_msg_send(jid, bizid, confid) {
		if(confirm("해당 채용공고의 면접 배정이 완료된 지원자 전원에게\n면접 안내 문자/메일을 일괄 발송하시겠습니끼?\n면접일정 문자 발송 후에는 면접 날짜 및 시간을 변경할 수 없습니다.")) {
			var url = "/company/applyjob/ontact_msg_send.asp";

			$("#jidnum").val(jid);
			$("#bizid").val(bizid);
			$("#confid").val(confid);

			$('#frm_ontact').attr("target", null);
			$('#frm_ontact').attr("action", url);
			$('#frm_ontact').submit();	
		}
	}

	// 면접일정 문자 재발송
	function fn_msg_resend(jid, applyid, name, flag, confid){
		if (confid == "") {
			alert("화상면접용 아이디가 발급되지 않았습니다.\n사이트 관리자에게 아이디 생성 요청 바랍니다.");
			return false;
		}else {

			var strMent = "님에게 면접일정 안내 문자/메일을 발송하시겠습니까?\n면접일정 문자 발송 후에는 면접 날짜 및 시간을 변경할 수 없습니다.";
			if (flag != ""){
				strMent = "님에게 면접일정 안내 문자/메일을 재발송하시겠습니까?";	
			}

			if(confirm(name+strMent)) {
				var url = "ontact_msg_resend.asp?jid="+jid+"&applyid="+applyid;
				location.href = url;	
			}
		}
	}

	// 화상면접용 URL 이동
	/*
	function fn_interview(val){
		var dummy = document.createElement("textarea");
		document.body.appendChild(dummy);
		dummy.value = val;
		dummy.select();
		document.execCommand("copy");
		document.body.removeChild(dummy);


		// 화상면접 기능 지원 브라우저일 경우에만 새 탭으로 화상면접 방 이동 처리, 이외 클립보드 복사 알림
		var agent = navigator.userAgent.toLowerCase(); // 접속 브라우저 체크
		var browserChk = "";
		if ((agent.indexOf("chrome") != -1) || (agent.indexOf("safari") != -1) || (agent.indexOf("firefox") != -1) || (agent.indexOf("opr") != -1)) {
			window.open(val);
		}else{
			alert("화상면접방 URL 경로가 복사되었습니다.\n화상면접 서비스는 크롬 브라우저에서만 지원됩니다.\n크롬 브라우저를 띄우고 붙여넣기(Ctrl+v)해 주세요.");	
		}	
	}
	*/
	function fn_interview(val) {
		// 화상면접 기능 지원 브라우저일 경우에만 새 탭으로 화상면접 방 이동 처리, 이외 클립보드 복사 알림
		var agent = navigator.userAgent.toLowerCase(); // 접속 브라우저 체크
		var browserChk = "";
		if ((agent.indexOf("chrome") != -1) || (agent.indexOf("safari") != -1) || (agent.indexOf("firefox") != -1) || (agent.indexOf("opr") != -1)) {
			window.open("./view_interview_conn.asp?url=" + val);
		}else{
			alert("화상면접 서비스는 크롬 브라우저에서만 지원됩니다.\n크롬 브라우저에서 접속하시기 바랍니다.");	
		}
	}
</script>
</head>

<body>

<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->


<!-- 화상면접 배정 지원자 문자/메일 발송용 경로 호출 start -->
<form method="post" id="frm_ontact" name="frm_ontact" action="">
	<input type="hidden" id="jidnum" name="jidnum" value="<%=jid%>" />
	<input type="hidden" id="bizid" name="bizid" value="" /> 
	<input type="hidden" id="confid" name="confid" value="" /> 
</form>			
<!-- 화상면접 배정 지원자 문자/메일 발송용 경로 호출 end -->


<!-- 본문 -->
<div id="contents" class="sub_page">
	<div class="content">
		<div class="con_area">
			<div class="interview_area">
				<h3>면접 Interview </h3>
				<div class="hire_box">
					<div class="info">
						<% If mode = "ing" Then %>
						<span>진행중</span>
						<% ElseIf mode = "cl" Then %>
						<span>마감</span>
						<% End If %>
						<p><%=arrRsTitle(0, 0)%></p>
						<div class="btn_area">
							<a href="/jobs/view.asp?id_num=<%=jid%>" class="btn orange" target="_blank">공고보기</a>
							<!--<a href="javascript:;;" class="btn gray">공고관리</a>-->
						</div>
					</div>
				</div><!-- //.hire_box -->

				<div class="placement_box">
					<p class="tit">면접자 배정</p>
					<ul class="pb_ul">
						<li>1. 서류합격자에 한해 면접자 배정을 할 수 있습니다.</li>
						<li>2. 우측의 면접자 배정 버튼을 클릭하면 면접일정을 배정할 수 있습니다.</li>
						<li>3. 면접 배정이 완료되면 아래 리스트는 면접일시 기준으로 정렬순서가 변경됩니다.</li>
						<li>4. 면접 배정 완료 후 아래 면접일정 문자보내기 버튼을 클릭하시면, 면접자 모두에게 면접일정이 문자메세지로 전송됩니다. <br>(※ 문자메세지가 전송되면 심사상태를 변경할 수 없습니다.)</li>
					</ul>
					<button type="button" class="pb_btn pop" onclick="openLayer('interview', '', '');">면접자 배정<br>수정</button>
				</div><!-- //.placement_box -->

				<div class="board_area">
					<div class="option_area">
						<form id="frm" name="frm" method="get" action="./list_interview.asp">
						<input type="hidden" id="mode" name="mode" value="<%=mode%>">
						<input type="hidden" id="jid" name="jid" value="<%=jid%>">
						<input type="hidden" id="interview_day" name="interview_day" value="<%=interview_day%>">
						<input type="hidden" id="interview_time" name="interview_time" value="<%=interview_time%>">
						<input type="hidden" id="interview_result" name="interview_result" value="<%=interview_result%>">
						<input type="hidden" id="job_part" name="job_part" value="<%=job_part%>">

						<div class="left_box">
							<% If IsArray(arrRsMojip) Then %>
							<div class="select_box" title="모집구분" style="width:130px;">
								<div class="name">
								<% 
								If job_part <> "" Then
									For i=0 To UBound(arrRsMojip, 2) 
										If CStr(arrRsMojip(0, i)) = job_part Then 
								%>
										<a href="javascript:;"><span><%=arrRsMojip(1, i)%></span></a>
								<% 
										End If
									Next 
								Else
								%>
									<a href="javascript:;"><span>모집구분</span></a>
								<% End If %>
								</div>
								<div class="sel">
									<ul>
										<li><a href="javascript:;" onclick="fn_sch_job_part('')">모집구분</a></li>
										<% For i=0 To UBound(arrRsMojip, 2) %>
										<li><a href="javascript:;" onclick="fn_sch_job_part('<%=arrRsMojip(0, i)%>')"><%=arrRsMojip(1, i)%></a></li>
										<% Next %>
									</ul>
								</div>
							</div>
							<% End If %>

<%
ConnectDB DBCon, Application("DBInfo_FAIR")

	' 화상면접용 회사 아이디 정보 체크
	Dim sql, arrRsdata, ont_confId
	sql = "SELECT 화상면접용회사아이디 FROM 면접배정_회사아이디 WHERE 회사아이디='"&comid&"' "
	arrRsdata = arrGetRsSql(DBCon, sql, "", "")
	If IsArray(arrRsdata) Then
		ont_confId = Trim(arrRsdata(0,0))
	Else 
		ont_confId = ""
	End If

	' 화상면접 URL 생성 여부 체크
	Dim sql2, arrRsdata2, rsvInterviewYn, ont_urlCd, ont_hostUrl, ont_submitApiYn, ont_intvDt, ont_intvTm, alertMsg
	sql2 = "SELECT TOP 1 URL코드, 면접관URL, API전송여부, 면접일, CASE 면접시간 WHEN 1 THEN '09:25' WHEN 2 THEN '09:55' WHEN 3 THEN '10:25' WHEN 4 THEN '10:55' WHEN 5 THEN '11:25' WHEN 6 THEN '11:55' WHEN 7 THEN '13:25' WHEN 8 THEN '13:55' WHEN 9 THEN '14:25' WHEN 10 THEN '14:55' WHEN 11 THEN '15:25' WHEN 12 THEN '15:55' WHEN 13 THEN '16:25' WHEN 14 THEN '16:55' WHEN 15 THEN '17:25' WHEN 16 THEN '17:55' END AS tm FROM 면접배정_면접관URL "
	sql2 = sql2 & " WHERE 회사아이디='"&comid&"' AND 화상면접용회사아이디='"&ont_confId&"' AND 채용등록번호='"&jid&"' "
	sql2 = sql2 & " AND 면접일='"&interview_day&"' AND 면접시간='"&interview_time&"' "
	arrRsdata2 = arrGetRsSql(DBCon, sql2, "", "")
	If IsArray(arrRsdata2) Then
		rsvInterviewYn = "Y"
		ont_urlCd		= Trim(arrRsdata2(0,0))
		ont_hostUrl		= Trim(arrRsdata2(1,0))
		ont_submitApiYn = Trim(arrRsdata2(2,0))
		ont_intvDt		= Trim(arrRsdata2(3,0))
		ont_intvTm		= Trim(arrRsdata2(4,0))

		If ont_submitApiYn="N" Then ' URL 생성 API 전송이 되지 않은 경우
			rsvInterviewYn = "N"
			alertMsg = "화상 면접방은 면접 당일에 한하여 접속 가능합니다."
		Else 
			If CDate(ont_intvDt) = Date() Then
				If ont_intvTm < FormatDateTime(Now(), 4) Then 
					rsvInterviewYn = "D"	
					alertMsg = "일자가 경과된 화상 면접방은 자동 삭제되어 접속이 불가능합니다."
				Else 
					rsvInterviewYn = "Y"
				End If 
			ElseIf CDate(ont_intvDt) < Date() Then 
				rsvInterviewYn = "D"	
				alertMsg = "일자가 경과된 화상 면접방은 자동 삭제되어 접속이 불가능합니다."				
			Else 
				rsvInterviewYn = "Y"
			End If 
		End If 
	Else 
		If interview_time="" Then
			rsvInterviewYn = "X"
			alertMsg = "상단 박스에서 면접시간대를 선택해 주세요."			
		Else 
			rsvInterviewYn = "X"
			alertMsg = "상단 면접일정 문자 보내기 버튼을 눌러서 면접 배정 확정 처리를 해주세요."
		End If 
	End If

	' 화상면접 지원자 배정 여부 체크
	Dim sql3, arrRsdata3, cntOntactRsv
	sql3 = "select COUNT(*) from 면접배정정보 where 채용등록번호='"&jid&"' AND 회사아이디='"&comid&"' AND ISNULL(면접확정여부,'N')<>'Y' "
	arrRsdata3 = arrGetRsSql(DBCon, sql3, "", "")
	If IsArray(arrRsdata3) Then
		cntOntactRsv = Trim(arrRsdata3(0,0))
	Else 
		cntOntactRsv = 0		
	End If

DisconnectDB DBCon
%>	
							<button type="button" class="send" onclick="<%If cntOntactRsv > 0 Then%>fn_interview_msg_send('<%=jid%>', '<%=comid%>', '<%=ont_confId%>');<%Else%>alert('면접자 배정이 완료되어야 메시지가 전송됩니다.');<%End If%>">면접일정 문자보내기</button>
							<button type="button" class="pdf pop" onclick="openLayer('result_apply','','');">면접결과 통보</button>

							<div class="select_box calendar" title="달력보기" style="width:150px;">
								<div class="name">
									<a href="javascript:;" onclick="fn_calendar(this);"><span id="sel_interview_day"><%=interview_day%></span></a>
								</div>
								<div class="sel">
									<div class="calendar_box">
										<!-- 기준년월 영역 -->
										<div id="sel_calendar_box">
										</div>
										<!-- 달력영역 -->
										<div id="sel_calendar_table">
										</div>
									</div>
								</div>
							</div>

						</div>
						<div class="right_box">
							<div class="sch_box">
								<input type="text" id="kw" name="kw" class="txt" value="<%=kw%>" placeholder="이름 또는 휴대폰 번호를 입력해 주세요.">
								<button type="button" class="reset_btn" onclick="fn_reset();">초기화</button>
								<button type="button" class="sch_btn" onclick="fn_sch();">검색</button>
							</div>
						</div>

						</form>
					</div>

					<div class="slide_area">
						<ul>
						<%
						If IsArray(arrRsTimeToCnt) Then
						For i=0 To UBound(arrRsTimeToCnt, 2)
							Dim TimeToCnt : TimeToCnt = arrRsTimeToCnt(3, i)
							Dim str_class_on : str_class_on = ""
							
							If interview_time = CStr(i+1) Then str_class_on = "on"

							' 면접 완료 클래스 적용 여부 체크
							ConnectDB DBCon, Application("DBInfo_FAIR")

							Dim sql4, arrRsdata4, ont_apiCreateYn, ont_apiDelYn, ont_interviewTm, clsComplete
							clsComplete = ""
							sql4 = "SELECT TOP 1 ISNULL(API전송여부,'N'), ISNULL(API삭제여부,'N'), CASE 면접시간 WHEN 1 THEN '09:25' WHEN 2 THEN '09:55' WHEN 3 THEN '10:25' WHEN 4 THEN '10:55' WHEN 5 THEN '11:25' WHEN 6 THEN '11:55' WHEN 7 THEN '13:25' WHEN 8 THEN '13:55' WHEN 9 THEN '14:25' WHEN 10 THEN '14:55' WHEN 11 THEN '15:25' WHEN 12 THEN '15:55' WHEN 13 THEN '16:25' WHEN 14 THEN '16:55' WHEN 15 THEN '17:25' WHEN 16 THEN '17:55' END AS tm FROM 면접배정_면접관URL "
							sql4 = sql4 & " WHERE 채용등록번호='"&jid&"' AND 회사아이디='"&comid&"' AND 면접일='"&interview_day&"' AND 면접시간='"&arrRsTimeToCnt(2, i)&"' "
							arrRsdata4 = arrGetRsSql(DBCon, sql4, "", "")
							If IsArray(arrRsdata4) Then
								ont_apiCreateYn	= Trim(arrRsdata4(0,0))
								ont_apiDelYn	= Trim(arrRsdata4(1,0))	
								ont_interviewTm	= Trim(arrRsdata4(2,0))		

								If ont_apiCreateYn="N" Then ' URL 코드 생성 전 이라면 완료 레이어 노출 안 함
									clsComplete = ""
								Else 
									If arrRsTimeToCnt(3, i)>0 Then
										If CDate(interview_day) = Date() Then
											If ont_interviewTm < FormatDateTime(Now(), 4) Then 
												clsComplete = "Y"	
											Else 
												clsComplete = ""
											End If 
										ElseIf CDate(interview_day) < Date() Then 
											clsComplete = "Y"		
										Else 
											clsComplete = ""
										End If
									Else  ' 면접 배정자가 없을 경우 완료 레이어 노출 안 함
										clsComplete = ""
									End If 
								End If 
							End If

							DisconnectDB DBCon

							If arrRsTimeToCnt(3, i) > 0 Then
						%>
							<li class="slide_con<%If clsComplete="Y" Then%>complete<%End If%>">
								<a href="javascript:;" onclick="fn_set_interview_time('<%=i+1%>')" class="slide_box <%=str_class_on%>">
									<p class="date"><%=interview_day%></p>
									<p class="time"><%=getInterviewTime(i+1)%></p>
									<span>(<%=arrRsTimeToCnt(3, i)%>명)</span>
								</a>
							<%If clsComplete="Y" Then%>
								<div class="complete">
									<p>완료</p>
								</div>
							<%End If%>
							</li>
						<%
							End If
						Next
						End If
						%>
						</ul>
						<script>
							$(document).ready(function(){
								if ($("li[class^='slide_con']").length > 8) {
									$('.slide_area ul').bxSlider( {
										mode: 'horizontal',// 가로 방향 수평 슬라이드
										speed: 500,        // 이동 속도를 설정
										pager: false,      // 현재 위치 페이징 표시 여부 설정
										moveSlides: 8,     // 슬라이드 이동시 개수
										slideWidth: 149,   // 슬라이드 너비
										minSlides: 8,      // 최소 노출 개수
										maxSlides: 8,      // 최대 노출 개수
										slideMargin: 10,    // 슬라이드간의 간격
										infiniteLoop:true,
										auto: false,        // 자동 실행 여부
										autoHover: false,   // 마우스 호버시 정지 여부
										controls: true    // 이전 다음 버튼 노출 여부
									});

									$('.slide_box').click(function(){
										$(this).addClass('on');
										$('.slide_box').not(this).removeClass('on');
										return false;
									});
								}
							});
						</script>
					</div>					

					<!--리스트-->
					<!--#include file = "./inc_list.asp"-->

					<!--페이징-->
					<% Call putPage(page, stropt, totalPage) %>

					<div class="list_btn inter">
						<a class="btn prev" href="./list.asp?mode=<%=mode%>&jid=<%=jid%>">이전 페이지 이동</a>
						<a class="btn inter" href="javascript:;;" onclick="<%If rsvInterviewYn="Y" Then%>fn_interview('<%=ont_hostUrl%>');return false;<%Else%>alert('<%=alertMsg%>');<%End If%>">면접방 이동</a>
						<p class="btn_ment">버튼을 클릭해서 해당 시간의 화상면접을 진행해 주세요!<p>
					</div><!--//list_btn-->

				</div><!--//board_area -->

			</div><!-- .manage_area -->
		</div><!-- .con_area -->
	</div><!-- .content -->

</div>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

<!-- 면접자 배정, 면접결과 입력 -->
<!--#include file = "./inc_pop_interview.asp"-->
<!-- //면접자 배정, 면접결과 입력 -->

<!-- 결과입력 -->
<div id="pop_result_interview">
<div id="pop_dim2" class="pop_dim"></div>
<div id="popup2" class="popup">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>면접결과 입력</h3>
			<a href="javascript:;" class="layer_close">닫기</a>
		</div>
		<div id="result_interview_html" class="pop_con">
		</div>
		<div class="pop_footer">
			<div class="btn_area">
				<a href="javaScript:;" onclick="fn_result_submit();"  class="btn blue">결과입력</a>
			</div>
		</div>
	</div>	
</div>
</div>
<!-- 결과입력 -->

<!-- 결과통보하기,  통보내역, 미리보기 -->
<!--#include file = "../applyjob/apply_result.asp"-->
<!-- 결과통보하기,  통보내역, 미리보기 -->

</body>
</html>