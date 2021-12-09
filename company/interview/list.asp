<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<%
Call FN_LoginLimit("2")	'기업회원 허용


ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim jid, mode, pid, interview_day, interview_time, interview_result, kw, job_part, interview_N
	Dim jid_NM
	jid = request("jid")
	mode = request("mode")
	pid = request("pid")
	interview_day = request("interview_day")
	interview_time = request("interview_time")
	interview_result = request("interview_result")
	kw = request("kw")
	job_part = request("job_part")
	If job_part = "" Then job_part = ""
	interview_N = "N"
	
	'jid = 69
	'mode = "ing"


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


	Dim page, psize, totalCnt, totalPage, i
	page = CInt(Request("page"))
	psize = CInt(Request("psize"))
	If page = "0" Then page = 1
	If psize = "0" Then psize = 10

	'페이지변수셋팅
	Dim stropt
	stropt = "mode=" & mode & "&jid=" & jid & "&interview_day=" & interview_day & "&interview_time=" & interview_time & "&kw=" & kw & "&job_part=" & job_part 

	Dim spName, arrRs, arrRsTitle, arrRsMojip, Interview_Cnt
	ReDim param(12)
	spName = "usp_기업서비스_면접배정_리스트"

	param(0)  = makeParam("@MODE",				adVarchar, adParamInput, 20, mode)
	param(1)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, jid)
	param(2)  = makeParam("@PID",				adVarchar, adParamInput, 1, "3")
	param(3)  = makeParam("@INTERVIEW_N",		adVarchar, adParamInput, 1, "N")
	param(4)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, "")
	param(5)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, "")
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
		jid_NM = arrRsTitle(0, 0)
		'모집부문
		spName = "SELECT 등록순차번호, 모집부문명 FROM 채용모집부문 WITH(NOLOCK) WHERE 채용등록번호 = " & jid
		arrRsMojip = arrGetRsSql(DBCon, spName, "", "")
	ElseIf mode = "cl" Then 
		'채용제목
		spName = "SELECT 모집내용제목 FROM 마감채용정보 WITH(NOLOCK) WHERE 등록번호 = " & jid
		arrRsTitle = arrGetRsSql(DBCon, spName, "", "")
		jid_NM = arrRsTitle(0, 0)
		'모집부문
		spName = "SELECT 등록순차번호, 모집부문명 FROM 마감채용모집부문 WITH(NOLOCK) WHERE 채용등록번호 = " & jid
		arrRsMojip = arrGetRsSql(DBCon, spName, "", "")
	End If

	'면접배정된 사용자 카운트
	spName = "SELECT COUNT(등록번호) FROM 면접배정정보 WITH(NOLOCK) WHERE 채용등록번호 = " & jid
	Interview_Cnt = arrGetRsSql(DBCon, spName, "", "")(0, 0)


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

		radioboxFnc(); //라디오박스
		fn_rece_set(); // 결과통보하기 초기셋팅
	});

	function openLayer(idName) {
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
		}
	}

	function fn_sch() {
		$('#frm').attr('method', 'post');
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

</script>
</head>

<body>

<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

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
					
					<% If totalCnt = 0 Then %>
					<button type="button" class="pb_btn v2" onclick="javascript:alert('면접배정이 완료되었습니다.'); return false;">면접자 배정</button>
					<% Else %>
					<button type="button" class="pb_btn v2 pop" onclick="openLayer('interview');">면접자 배정</button>
					<% End If %>

					<% If Interview_Cnt > 0 Then %>
					<button type="button" class="pb_btn" onclick="location.href='./list_interview.asp?mode=<%=mode%>&jid=<%=jid%>&interview_day=<%=Date()%>'">면접배정 결과</button>
					<% End If %>
				</div><!-- //.placement_box -->



				<div class="board_area">
					<div class="option_area">
						<form id="frm" name="frm" method="get" action="./list.asp">
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
							<!-- <button type="button" class="send">면접일정 문자보내기</button> -->
							<button type="button" class="result pop" onclick="openLayer('result_apply');">면접결과 통보</button>
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

					<!--리스트-->
					<!--#include file = "./inc_list.asp"-->

					<!--페이징-->
					<% Call putPage(page, stropt, totalPage) %>
				</div><!--//board_area -->
			</div><!-- .manage_area -->
		</div><!-- .con_area -->
	</div><!-- .content -->

</div>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

<!-- 면접자 배정 -->
<!--#include file = "./inc_pop_interview.asp"-->
<!-- //면접자 배정 -->

<!-- 결과통보하기,  통보내역, 미리보기 -->
<!--#include file = "../applyjob/apply_result.asp"-->
<!-- 결과통보하기,  통보내역, 미리보기 -->

</body>
</html>