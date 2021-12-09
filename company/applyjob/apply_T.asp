<%
option Explicit

'------ 페이지 기본정보 셋팅.
g_MenuID = "010001"  '앞 두 숫자는 lnb 페이지명, 맨 뒤 숫자는 메뉴 이미지 파일명에 참조
g_MenuID_Navi = "0,1"  '내비게이션 값
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->

<%
Call FN_LoginLimit("2")    '기업회원만 접근가능

ConnectDB DBCon, Application("DBInfo_FAIR")
	
	Dim page, psize, totalCnt, stropt, totalPage, i, ii
	page = CInt(Request("page"))
	psize = CInt(Request("psize"))

	If page = "0" Then page = 1
	If psize = "0" Then psize = 10

	'미열람	    isRead 0
   ' 전체        pid 0
   ' 심사전	    pid 1 미열람 동일
   ' 검토중	    pid 2
   ' 서류합격    pid 3
   ' 최종합격	pid 4
   ' 불합격	    pid 5
    '스크랩	    pid 10

	Dim mode,jid, pid, sch_kw, sch_gb, isRead, sch_sc, sch_ex, sch_area, sch_age, chk_1, chk_2, chk_3, chk_4, so1, so2, so3
	mode	 = Request("mode")
	jid		 = Request("jid")
	pid		 = Request("pid")
	sch_kw	 = Request("sch_kw")
	sch_gb	 = Request("sch_gb")
	isRead	 = Request("isRead")
	sch_sc	 = Request("sch_sc")
	sch_ex	 = Request("sch_ex")
	sch_area = Request("sch_area")
	sch_age	 = Request("sch_age")
	chk_1	 = Request("chk_1")
	chk_2	 = Request("chk_2")
	chk_3	 = Request("chk_3")
	chk_4	 = Request("chk_4")
	so1		 = Request("so1")
	so2		 = Request("so2")
	so3		 = Request("so3")
	
	If mode = "" Then
		Dim mode_param(2)
		mode_param(0)=makeParam("@id_num", adInteger, adParamInput, 4, jid)
		mode_param(1)=makeParam("@mode", adVarChar, adParamOutput, 4, "")
		mode_param(2)=makeParam("@bizNum", adVarChar, adParamOutput, 10, "")

		Call execSP(DBCon, "W_채용정보_상태_조회", mode_param, "", "")

		mode	= getParamOutputValue(mode_param, "@mode")	' 채용공고 상태(ing : 진행, cl: 마감)
	End If

	If pid = "" Then pid = "0"
	If so1 = "" Then so1 = "접수일 desc, 지원번호 desc"

	if (mode = "" Or jid = "" Or pid = "") Then
		Response.write "<script>"
		Response.write "alert(""잘못된 접근입니다."");"
		Response.write "history.back();"
		Response.write "</script>"
		Response.End
	End If

	'mode     = "cl"
	'jid		 = "18519875"
	'pid		 = "0"
	'sch_kw	 = ""
	'sch_gb	 = ""
	'isRead	 = ""
	'sch_sc	 = ""
	'sch_ex	 = ""
	'sch_area = ""
	'sch_age	 = ""
	'chk_1	 = ""
	'chk_2	 = ""
	'chk_3	 = ""
	'chk_4	 = ""
	'so1		 = "접수일 desc, 지원번호 desc"
	'so2		 = ""
	'so3		 = ""

	Dim spName, arrRs, arrRsMojip

	'채용 모집부문
	spName = "SELECT 등록순차번호, 모집부문명 FROM 채용모집부문 WITH(NOLOCK) WHERE 채용등록번호 = " & jid
	arrRsMojip = arrGetRsSql(DBCon, spName, "", "")


	ReDim param(24)
	spName = "usp_기업서비스_입사지원자_목록2"

	param(0)  = makeParam("@mode",			adVarchar, adParamInput, 10, mode) '--ing:진행, cl:마감
	param(1)  = makeParam("@jid",			adVarchar, adParamInput, 30, jid)
	param(2)  = makeParam("@pid",			adVarchar, adParamInput, 30, pid)
	param(3)  = makeParam("@sch_kw",		adVarchar, adParamInput, 30, sch_kw)
	param(4)  = makeParam("@sch_gb",		adVarchar, adParamInput, 30, sch_gb)
	param(5)  = makeParam("@isRead",		adVarchar, adParamInput, 30, isRead)
	param(6)  = makeParam("@sch_sc",		adVarchar, adParamInput, 30, sch_sc)
	param(7)  = makeParam("@sch_ex",		adVarchar, adParamInput, 30, sch_ex)
	param(8)  = makeParam("@sch_area",		adVarchar, adParamInput, 30, sch_area)
	param(9)  = makeParam("@sch_age",		adVarchar, adParamInput, 30, sch_age)
	param(10) = makeParam("@chk_1",			adVarchar, adParamInput, 30, chk_1)
	param(11) = makeParam("@chk_2",			adVarchar, adParamInput, 30, chk_2)
	param(12) = makeParam("@chk_3",			adVarchar, adParamInput, 30, chk_3)
	param(13) = makeParam("@chk_4",			adVarchar, adParamInput, 30, chk_4)
	param(14) = makeParam("@so1",			adVarchar, adParamInput, 50, so1) '접수일 desc, 지원번호 desc
	param(15) = makeParam("@so2",			adVarchar, adParamInput, 30, so2)
	param(16) = makeParam("@so3",			adVarchar, adParamInput, 30, so3)

	param(17) = makeParam("@PageSize",		adInteger, adParamInput, 4 , psize)
	param(18) = makeParam("@Page",			adInteger, adParamInput, 4 , page)
	param(19) = makeParam("@sch_method",	adVarchar, adParamInput, 1 , "")
	param(20) = makeParam("@formtype",		adVarchar, adParamInput, 2 , "")
	param(21) = makeParam("@TotalCount",	adInteger, adParamOutput, 4 , 0)
	param(22) = makeParam("@TotalCount1",	adInteger, adParamOutput, 4 , 0)
	param(23) = makeParam("@TotalCount2",	adInteger, adParamOutput, 4 , 0)
	param(24) = makeParam("@TotalCount3",	adInteger, adParamOutput, 4 , 0)

	arrRs = arrGetRsSP(dbCon, spName, param, "", "")
	totalCnt = getParamOutputValue(param, "@TotalCount")
	totalPage = (totalCnt / psize) + 1

	stropt = "mode=" & mode & "&jid=" & jid & "&pid=" & pid & "&sch_gb=" & sch_gb

	'Response.write "EXEC usp_기업서비스_입사지원자_목록2 " & "'" & mode & "', " & "'" & jid & "', " & "'" & pid & "', " & "'" & sch_kw & "', " & "'" & sch_gb & "', " & "'" & isRead & "', " & "'" & sch_sc & "', " & "'" & sch_ex & "', " & "'" & sch_area & "', " & "'" & sch_age & "', " & "'" & chk_1 & "', " & "'" & chk_2 & "', " & "'" & chk_3 & "', " & "'" & chk_4 & "', " & "'" & so1 & "', " & "'" & so2 & "', " & "'" & so3 & "', " & "'" & psize & "', " & "'" & page & "', '', '', '', '', '', ''"


DisconnectDB DBCon

%>

<script type="text/javascript">
	document.domain = "career.co.kr";
	
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

			radioboxFnc(); //라디오박스
		});
	});

	function openLayer(idName) {
		switch(idName)
		{
			case "email":
				$("input:radio[name='tb1_1'][value='email']").prop("checked", true);
				$("#tb_email").show();
				$("#tb_sms").hide();
				$("#chk_sms").show();
				break;
			case "sms":
				$("input:radio[name='tb1_1'][value='sms']").prop("checked", true);
				$("#tb_email").hide();
				$("#tb_sms").show();
				$("#chk_sms").hide();
				break;
		}

		radioboxFnc(); //라디오박스
		fn_rece_set(); // 결과통보하기 초기셋팅
	}
	
	//이력서 보기
	function fn_resume_view(rid, set_user_id) {		
		$("#rid").val(rid);
		$("#set_user_id").val(set_user_id);

        $('#frm').attr("target", "_blank");
        $('#frm').attr("action", "./resumeView.asp");
        $('#frm').submit();
	}

	//채용모집부문 변경
    function goMojip(value) {
        $("#sch_gb").val(value);
        $('#frm').attr("target", null);
        $('#frm').attr("action", "/company/applyjob/apply.asp");
        $('#frm').submit();
    }

	//상단메뉴(전체,검토중,서류합격 등...)
    function goApply(pid) {
        $("#pid").val(pid);

        $("#so1").val("");
        $("#sch_kw").val("");

        $('#frm').attr("target", null);
        $('#frm').attr("action", "/company/applyjob/apply.asp");
        $('#frm').submit();
    }

	//상태변경
	function fn_SetParam(_gb, _apply_num, _status) {
		if ($('input:checkbox[name="chk_list"]:checked').length == 0 && _gb == "status" && _apply_num == "") {
			alert("지원자를 선택하여 주십시오.");
			return;
		}
		else {
			var interviewYN = "";

			if (_apply_num == "") {
				var arr_applynum = ""

				$('input:checkbox[name="chk_list"]').each(function () {
					if (this.checked) {//checked 처리된 항목의 값
						var arr = new Array();
						arr = this.value.split(",");

						arr_applynum += "," + arr[0];

						if (arr[3] == "Y") {
							interviewYN = "Y";
							return;
						}
					}
				});
				
				_apply_num += arr_applynum.substr(1);
			}
			
			if(interviewYN == "Y") {
				alert("면접 배정을 한 지원자가 있습니다.\n면접 배정을 한 지원자의 상태는 변경 할 수 없습니다.");
				return;
			}
			else {
				goStatusSelect(_gb, "2", _apply_num, "");

				if (_gb == "read" && _apply_num != "" && _status == "1") {
					goStatusSelect(_gb, "3", _apply_num, "2");
				}
				else if (_gb == "status") {
					if (!confirm("상태를 변경하시겠습니까?")) {
						return;
					}

					goStatusSelect(_gb, "3", _apply_num, _status);
				}
			}
			
		}
	}

	//지원자 상태변경
    function goStatusSelect(_gb, _gubun, _apply_num, _status) {
        var param = {};
        param.gubun = _gubun;
        param.mode = $('#mode').val();
        param.jid = $('#jid').val();
        param.apply_num = _apply_num;
        param.status = _status;

        $.ajax({
            type: "POST",
            url: "apply_setStatus.asp",
            data: param,
            dataType: "html",
            success: function (data) {
                if (data == "0") {
                    alert("실패: 관리자에게 문의하세요.");
                    return false;
                } else if (data == "1") {
					if (_gb == "status") {
						alert("지원자 상태변경이 완료되었습니다.");
					}				
                    $("#pid").val(status);
					$('#frm').attr("target", null);
                    $('#frm').attr("action", "/company/applyjob/apply.asp");
                    $('#frm').submit();
					
                }
				/*
				else {
                    alert("서버 데이터 오류: 관리자에게 문의하세요. code=" + data);
                    //location.reload();
                    return false;
                }
				*/
            },
            error:function(request,status,error){
				//alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
			}
        });
    }
	
	//인쇄하기, PDF저장
	function fn_mlr_print(id, Gubun) {
		var arr_rid		= "";
		var arr_userid	= "";

        if ($('input:checkbox[name="chk_list"]:checked').length == 0) {
			switch (Gubun) {
				case "PRINT":
					alert("인쇄할 지원서를 선택하여 주십시오.");
					break;
				case "PDF":
					alert("PDF로 저장할 지원서를 선택하여 주십시오.");
					break;
			}
        }
		
		$('input:checkbox[name="chk_list"]').each(function () {
            if (this.checked) {//checked 처리된 항목의 값
				var arr = new Array();
				arr = this.value.split(",");
				
				if (arr[1] != "") {
					arr_rid		+= "," + arr[1];
					arr_userid	+= "," + arr[2];
				}
            }
        });
		
		var src="http://newprint.career.co.kr/hkpartner/resume_mlrpt_load.asp?set_rid=" + arr_rid.substr(1) + "&set_userid=" + arr_userid.substr(1) + "&set_url=<%=Request.ServerVariables("SERVER_NAME")%>/resume/view_print.asp";

		$("#printMLR").attr("src", src);

		$("#printMLR").load(function(){
			var iframe = document.frames ? document.frames[id] : document.getElementById(id);
			var ifWin = iframe.contentWindow || iframe;

			iframe.focus();
			ifWin.leehoPreview();
			return false;
		});
	}
</script>

</head>
<body>

<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- //상단 -->

<!-- 본문 -->
<div id="contents" class="sub_page">
	<div class="content">
		<div class="con_area">
			<div class="manage_area">
				<!--#include file = "./apply_inc_sel_joblist_N.asp"-->
				
				<form method="post" id="frm" name="frm" action="">
                    <input type="hidden" id="mode" name="mode" value="<%=mode%>" />
                    <input type="hidden" id="jid" name="jid" value="<%=jid%>" />
                    <input type="hidden" id="pid" name="pid" value="<%=pid%>" />
                    <input type="hidden" id="page" name="page" value="<%=page%>" />
                    <input type="hidden" id="psize" name="psize" value="<%=psize%>" />
                    <input type="hidden" id="so1" name="so1" value="<%=so1%>" />
					<input type="hidden" id="sch_gb" name="sch_gb" value="<%=sch_gb%>" />

                    <input type="hidden" id="rid" name="rid" value="" /> <!-- 상세페이지사용 -->
                    <input type="hidden" id="apply_num_view" name="apply_num_view" value="" /> <!-- 상세페이지사용 -->
                    <input type="hidden" id="apply_date_view" name="apply_date_view" value="" /> <!-- 상세페이지사용 -->
					<input type="hidden" id="set_user_id" name="set_user_id" value="" /> <!-- 상세페이지사용 -->
                    
                    <input type="hidden" id="rtype" name="rtype" value="" />
                    <input type="hidden" id="apply_num" name="apply_num" value="" />
                    <input type="hidden" id="gubun" name="gubun" value="" />
                    <input type="hidden" id="status" name="status" value="" />

					<input type="hidden" id="arr_rid" name="arr_rid" value="" />
					<input type="hidden" id="arr_userid" name="arr_userid" value="" />
					
					<div class="board_area">
						<div class="option_area">
							<div class="left_box">
								<% If isArray(arrRsMojip) Then %>
								<div class="select_box" title="모집구분" style="width:130px;">
									<div class="name">
											<% 
												If sch_gb <> "" Then 
													For i=0 To UBound(arrRsMojip, 2) 
														If CStr(arrRsMojip(0, i)) = sch_gb Then
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
											<li><a href="javascript:goMojip('');">모집구분</a></li>
											<% For i=0 To UBound(arrRsMojip, 2) %>
											<li><a href="javascript:goMojip('<%=arrRsMojip(0, i)%>');"><%=arrRsMojip(1, i)%></a></li>
											<% Next %>
										</ul>
									</div>
								</div>
								<% End If %>

								<div class="select_box" title="심사하기" style="width:130px;">
									<div class="name"><a href="#none"><span>심사하기</span></a></div>
									<div class="sel">
										<ul>
											<li><a href="#none" onclick="fn_SetParam('status', '', '2');">검토중</a></li>
											<li><a href="#none" onclick="fn_SetParam('status', '', '4');">예비합격</a></li>
											<li><a href="#none" onclick="fn_SetParam('status', '', '5');">서류불합격</a></li>
											<li><a href="#none" onclick="fn_SetParam('status', '', '3');">서류합격</a></li>
										</ul>
									</div>
								</div>

								<div class="select_box img" title="결과통보" style="width:130px;">
									<div class="name"><a href="#none"><span>결과통보</span></a></div>
									<div class="sel">
										<ul>
											<li><a href="#none" class="pop" onclick="openLayer('email');">결과통보<span>메일발송</span></a></li>
											<li><a href="#none" class="pop" onclick="openLayer('sms');">결과통보<span>문자발송</span></a></li>
										</ul>
									</div>
								</div>

								<button type="button" class="btn_print pop2" onclick="fn_mlr_print('printMLR', 'PRINT');">인쇄하기</button>
								<button type="button" class="pdf" onclick="fn_mlr_print('printMLR', 'PDF');">PDF저장</button>
							</div>
						</div>
						<table class="tb" summary="스크랩한 인재에 관한 이름/성별/나이,이력서 정보/요약정보,등록일 항목을 나타낸 표">
							<caption>스크랩한 공고</caption>
							<colgroup>
								<col style="width:60px">
								<col style="width:300px">
								<col style="width:330px">
								<col style="width:150px">
								<col style="width:210px">
								<col>
							</colgroup>
							<thead>
								<tr>
									<th>
										<label class="checkbox off"><input class="chk" id="" name="" type="checkbox" onclick="noncheckallFnc(this, 'chk_list');"></label>
									</th>
									<th>이름/나이</th>
									<th>학력/경력</th>
									<th>첨부</th>
									<th>심사상태</th>									
									<th>입사지원일</th>
								</tr>
							</thead>
							<tbody>
								<%
									If isArray(arrRs) Then 
									For i=0 To UBound(arrRs, 2)
									
									ConnectDB DBCon, Application("DBInfo_FAIR")
									Dim strSql, arrRsView, arrRsSchool, interviewYN
									strSql = "SELECT 지원번호, 일련번호, 업파일경로, 업파일명, 실파일명 FROM 인터넷입사지원파일첨부 WITH(NOLOCK) WHERE 채용등록번호 ='"& jid &"' AND 지원번호 = '"& arrRs(34, i) &"' ORDER BY 일련번호"
									arrRsView = arrGetRsSql(DBCon, strSql, "", "")

									strSql = " SELECT 학교명, 전공명, 졸업구분 FROM 이력서학력 WHERE 등록번호 = '" & arrRs(1,i) & "' AND 학력종류 = '" & arrRs(9,i) & "' "
									arrRsSchool = arrGetRsParam(DBCon, strSql, "", "", "")
									
									strSql = " SELECT 면접확정여부 AS 면접확정여부 FROM 면접배정정보 WHERE 채용등록번호 = '" & jid & "' AND 입사지원등록번호 = '"& arrRs(34, i) &"' AND 면접확정여부 = 'Y' "
									interviewYN = arrGetRsParam(DBCon, strSql, "", "", "")

									DisconnectDB DBCon

									'모집부문
									Dim strMojip : strMojip = ""
									If arrRs(52, i) <> "" Then strMojip = "["& arrRs(52, i) &"]"

									'합격상태
									Dim statusNm
									Select Case arrRs(29, i)
										Case "1" : statusNm = "심사하기"
										Case "2" : statusNm = "검토중"
										Case "3" : statusNm = "서류합격"
										Case "4" : statusNm = "예비합격"
										Case "5" : statusNm = "서류불합격"
									End Select 

									'이력서 열람여부
									Dim isopen
									Select Case arrRs(31, i)
										Case "1" : isopen = "열람"
										Case "0" : isopen = "미열람"
									End Select

									'생년 / 나이
									Dim birth_ymd, birth_age
									If arrRs(3, i) = "1" Or arrRs(3, i) = "2" Then 
										birth_ymd = "19" & Left(arrRs(2, i), 2)
										birth_age = Left(Date(), 4) - birth_ymd + 1
									ElseIf arrRs(3, i) = "3" Or arrRs(3, i) = "4" Then 
										birth_ymd = "20" & Left(arrRs(2, i), 2)
										birth_age = Left(Date(), 4) - birth_ymd + 1
									End If

									'경력표기
									Dim career_str, tot_sum
									tot_sum = Abs(arrRs(12, i))

									If tot_sum = "0" Then 
										career_str = "신입"
									ElseIf tot_sum > 12 Then
										career_str = "경력 " & fix(tot_sum / 12) & "년 "
										
										If tot_sum mod 12 > 0 Then
											career_str = career_str & tot_sum mod 12 & "개월"
										End If
									Else 
										career_str = "경력 " & tot_sum & "개월"
									End If

									' 희망직무
									Dim strjc
									If arrRs(10, i) <> "" Then
										strjc = Replace(getJobTypeAll(arrRs(10, i)),"/",",")
									End If
									
									' 최종학력
									Dim strFinalSchool
									Select Case arrRs(9, i)
										Case "3" : strFinalSchool = "고등학교"
										Case "4" : strFinalSchool = "대학(2,3년)"
										Case "5" : strFinalSchool = "대학교(4년)"
										Case "6" : strFinalSchool = "대학원"
										Case Else strFinalSchool = ""
									End Select

									' 희망지역
									Dim workArea, workAreaDetail, jj, strArea
									If arrRs(15, i) <> "" Then									
										workArea = split(arrRs(15, i), "|") 

										For ii=0 To Ubound(workArea)
											workAreaDetail = split(workArea(ii), "/")

											For jj=0 To Ubound(workAreaDetail)
												If jj = 0 Then
													strArea = strArea & get_simple_Ac(getAcName(workAreaDetail(jj)))
												End If
											Next
											
											If ii <> Ubound(workArea)  Then
												strArea = strArea & ","
											Else
												strArea = strArea & ""
											End If
										Next

										' 중복 지역 제거
										Dim workArea_temp, array_temp, m
										workArea_temp = ""

										array_temp = Split(strArea,",")

										For m = 0 To UBound(array_temp)
											If InStr(workArea_temp,array_temp(m)) = 0 Then
												If m =0 Then
													workArea_temp = array_temp(m)
												Else
													workArea_temp = workArea_temp & ", " & array_temp(m)
												End If
											End If
										Next
									End If

									'회원탈퇴여부
									Dim secession
									If arrRs(53, i) = "Y" Then
										secession = " (탈퇴회원)"
									Else
										secession = ""
									End If

								%>
								<tr>
									<td>
										<label class="checkbox off">
											<input class="chk" id="" name="chk_list" type="checkbox" value="<%=arrRs(50,i)%>,<%=arrRs(1,i)%>,<%=arrRs(51,i)%>,<% If isArray(interviewYN) Then %>Y<% End If %>">
										</label>
									</td>
									<td class="t1 tc">
										
										<div class="photoBox">
											<a href="#none" <% If arrRs(48,i) = "A" And arrRs(23,i) <> "" Then %>onclick="fn_resume_view('<%=arrRs(1,i)%>', '<%=objEncrypter.Encrypt(arrRs(51,i))%>'); fn_SetParam('read', '<%=arrRs(34, i)%>', '<%=arrRs(29,i)%>');"<% End If %>>											
												<div class="photo">
													<span class="frame sprite"></span>
													<% If arrRs(24, i) <> "" Then %>
													<img src="/files/mypic/<%=arrRs(24, i)%>">
													<% End If %>
												</div>
												<div class="photo_info">
													<em class="name"><%=arrRs(0, i)%><%=secession%></span>
													</em>
													<p class="birth">(<span class="num"><%=birth_ymd%></span>년생, <span class="num"><%=birth_age%></span>세)</p>
												</div>
											</a>
										</div>
									</td>
									<td class="t2  tc">
										<div class="txtBox">
											<% If arrRs(48,i) = "A" And arrRs(23,i) <> "" Then %>
											<p><%=strFinalSchool%>&nbsp;<%=GraduatedState%></p>
											<% 
												If isArray(arrRsSchool) Then
													Dim GraduatedState
													Select Case arrRsSchool(2,0)
														Case "3" : GraduatedState = "재학"
														Case "4" : GraduatedState = "휴학"
														Case "5" : GraduatedState = "중퇴"
														Case "7" : GraduatedState = "졸업(예)"
														Case "8" : GraduatedState = "졸업"
													End Select
											%>	
												<p><%=arrRsSchool(0,0)%>&nbsp;<%=arrRsSchool(1,0)%></p>
											<% 
												End If 
											%>
											<p><%=career_str%></p>
											<% Else %>
											<p>자사/자유양식 지원자입니다.<br>첨부파일을 다운받아주세요.</p>
											<% End If %>
										</div>
									</td>
									<td class="t3 tc">
										<% If isArray(arrRsView) Then %>
										<div class="select_box" title="첨부파일" style="width:130px;">
											<div class="name"><a href="#none"><span>첨부파일</span></a></div>
											<div class="sel">
												<ul>
													<% For ii=0 To UBound(arrRsView, 2) %>
													<li><a href="http://www2.career.co.kr/myjob/files/filedownload_apply_starfieldjob.asp?aid=<%=arrRsView(0, ii)%>&orderno=<%=arrRsView(1, ii)%>&folderpath=<%=arrRsView(2, ii)%>&filename=<%=arrRsView(3, ii)%>&orifilename=<%=arrRsView(4, ii)%>" target="_blank" onclick="fn_SetParam('read', '<%=arrRs(34, i)%>', '<%=arrRs(29,i)%>');"><%=arrRsView(4, ii)%></a></li>
													<% Next %>
												</ul>
											</div>
										</div>
										<% End If %>		
									</td>
									<td class="t4 tc">
										<% If isArray(interviewYN) Then %>
										<div class="txtBox">
											<p><%=statusNm%></p>
											<p class=<% If isopen = "열람" Then %> blue <% Else %> red <% End If %>><%=isopen%></p>
										</div>
										<% Else %>
										<div class="select_box" title="심사하기" style="width:130px;">
											<div class="name"><a href="#none"><span><%=statusNm%></span></a></div>
											<div class="sel">
												<ul>
													<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(34, i)%>', '2');">검토중</a></li>
													<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(34, i)%>', '4');">예비합격</a></li>
													<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(34, i)%>', '5');">서류불합격</a></li>
													<li><a href="#none" onclick="fn_SetParam('status', '<%=arrRs(34, i)%>', '3');">서류합격</a></li>
												</ul>
											</div>
										</div>

										<div class="txtBox">
											<p class=<% If isopen = "열람" Then %> blue <% Else %> red <% End If %>><%=isopen%></p>
										</div>
										<% End If %>
									</td>
									<td class="t5 tc">
										<p class="data"><span><%=arrRs(30, i)%></span></p>	
									</td>
								</tr>
								<%
								Next
								Else
								%>
								<tr>
									<td colspan="6" style="text-align: center;">
										<!--[D]데이터 없을경우-->
										<p>해당공고에 지원자가 없습니다.</p>
									</td>
								</tr>
								<%
								End If
								%>
							</tbody>
						</table>
					</div><!--//board_area -->				
				</form>

				<!--페이징-->
				<% Call putPage(page, stropt, totalPage) %>
			</div><!-- .manage_area -->
		</div><!-- .con_area -->
	</div><!-- .content -->
</div>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- //하단 -->

<!-- 결과통보하기,  통보내역, 미리보기 -->
<!--#include file = "./apply_result.asp"-->
<!-- 결과통보하기,  통보내역, 미리보기 -->

<iframe src="http://newprint.career.co.kr/hkpartner/resume_mlrpt_load.asp" id="printMLR" border="0" cellspacing="0" width="0px" height="0px" frameborder="0"></iframe>

</body>
</html>