<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<%
Call FN_LoginLimit("2")	'���ȸ�� ���


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
		strsql = strsql & " SELECT TOP 1 ��Ϲ�ȣ, ����"
		strsql = strsql & " FROM ("
		strsql = strsql & " 	SELECT ��Ϲ�ȣ, 'ing' AS ����, 1 AS ����, �����  FROM ä������ WITH(NOLOCK)"
		strsql = strsql & " 	WHERE ȸ����̵� = '"& comid &"'"
		strsql = strsql & " 	UNION "
		strsql = strsql & " 	SELECT ��Ϲ�ȣ, 'cl' AS ����, 2 AS ����, ����� FROM ����ä������ WITH(NOLOCK)"
		strsql = strsql & " 	WHERE ȸ����̵� = '"& comid &"'"
		strsql = strsql & " ) AS T"
		strsql = strsql & " ORDER BY ����, ����� DESC"
		
		arrRsjid = arrGetRsSql(DBCon, strsql, "", "")

		If isArray(arrRsjid) Then 
			jid = arrRsjid(0, 0)
			mode = arrRsjid(1, 0)
		Else 
			Call FN_AlertMsg("ä����� �Է��Ͻñ� �ٶ��ϴ�.", "history.back();", True)
		End If 
	End If


	If mode = "" Then
		Dim mode_param(2)
		mode_param(0)=makeParam("@id_num", adInteger, adParamInput, 4, jid)
		mode_param(1)=makeParam("@mode", adVarChar, adParamOutput, 4, "")
		mode_param(2)=makeParam("@bizNum", adVarChar, adParamOutput, 10, "")

		Call execSP(DBCon, "W_ä������_����_��ȸ", mode_param, "", "")

		mode	= getParamOutputValue(mode_param, "@mode")	' ä����� ����(ing : ����, cl: ����)
	End If

	If interview_day = "" Then interview_day = Date()
	If interview_time = "" Then interview_time = ""
	If job_part = "" Then job_part = ""

	Dim page, psize, totalCnt, totalPage, i
	page = CInt(Request("page"))
	psize = CInt(Request("psize"))
	If page = "0" Then page = 1
	If psize = "0" Then psize = 10

	'��������������
	Dim stropt
	stropt = "mode=" & mode & "&jid=" & jid & "&interview_day=" & interview_day & "&interview_time=" & interview_time & "&kw=" & kw & "&job_part=" & job_part 

	Dim spName, arrRs, arrRsTitle, arrRsMojip, arrRsTimeToCnt
	ReDim param(12)
	spName = "usp_�������_��������_����Ʈ"

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
		'ä������
		spName = "SELECT ������������ FROM ä������ WITH(NOLOCK) WHERE ��Ϲ�ȣ = " & jid
		arrRsTitle = arrGetRsSql(DBCon, spName, "", "")
		jid_NM = arrRsTitle(0,0)
		'�����ι�
		spName = "SELECT ��ϼ�����ȣ, �����ι��� FROM ä������ι� WITH(NOLOCK) WHERE ä���Ϲ�ȣ = " & jid
		arrRsMojip = arrGetRsSql(DBCon, spName, "", "")
	ElseIf mode = "cl" Then 
		'ä������
		spName = "SELECT ������������ FROM ����ä������ WITH(NOLOCK) WHERE ��Ϲ�ȣ = " & jid
		arrRsTitle = arrGetRsSql(DBCon, spName, "", "")
		jid_NM = arrRsTitle(0,0)
		'�����ι�
		spName = "SELECT ��ϼ�����ȣ, �����ι��� FROM ����ä������ι� WITH(NOLOCK) WHERE ä���Ϲ�ȣ = " & jid
		arrRsMojip = arrGetRsSql(DBCon, spName, "", "")
	End If

	ReDim param(2)
	param(0)  = makeParam("@JOBS_ID",			adInteger, adParamInput, 4, jid)
	param(1)  = makeParam("@INTERVIEW_DAY",		adVarchar, adParamInput, 10, interview_day)
	param(2)  = makeParam("@INTERVIEW_TIME",	adVarchar, adParamInput, 2, "")

	spName = "usp_�������_��������_�Ͻú��ο���"
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

		radioboxFnc(); //�����ڽ�
		fn_rece_set(); // ����뺸�ϱ� �ʱ����
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

					alert("���� �����ð��� �ƴմϴ�.");
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
			
			// �������������ϰ�� ���� �ʼ�
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
				alert("���뿡 ���� �ֽ��ϴ�. Ȯ���� �ּ���.\n(���������� ������ �������� ������ �Է��ϼž� �մϴ�.)");
				return false;
			}
		}
		
	}

	
	function fn_calendar(obj) {
		//$(obj).parents('.select_box').addClass('on');
	}

	// �������� ���� ����� �ϰ� ����/���� �߼�
	function fn_interview_msg_send(jid, bizid, confid) {
		if(confirm("�ش� ä������� ���� ������ �Ϸ�� ������ ��������\n���� �ȳ� ����/������ �ϰ� �߼��Ͻðڽ��ϳ�?\n�������� ���� �߼� �Ŀ��� ���� ��¥ �� �ð��� ������ �� �����ϴ�.")) {
			var url = "/company/applyjob/ontact_msg_send.asp";

			$("#jidnum").val(jid);
			$("#bizid").val(bizid);
			$("#confid").val(confid);

			$('#frm_ontact').attr("target", null);
			$('#frm_ontact').attr("action", url);
			$('#frm_ontact').submit();	
		}
	}

	// �������� ���� ��߼�
	function fn_msg_resend(jid, applyid, name, flag, confid){
		if (confid == "") {
			alert("ȭ������� ���̵� �߱޵��� �ʾҽ��ϴ�.\n����Ʈ �����ڿ��� ���̵� ���� ��û �ٶ��ϴ�.");
			return false;
		}else {

			var strMent = "�Կ��� �������� �ȳ� ����/������ �߼��Ͻðڽ��ϱ�?\n�������� ���� �߼� �Ŀ��� ���� ��¥ �� �ð��� ������ �� �����ϴ�.";
			if (flag != ""){
				strMent = "�Կ��� �������� �ȳ� ����/������ ��߼��Ͻðڽ��ϱ�?";	
			}

			if(confirm(name+strMent)) {
				var url = "ontact_msg_resend.asp?jid="+jid+"&applyid="+applyid;
				location.href = url;	
			}
		}
	}

	// ȭ������� URL �̵�
	/*
	function fn_interview(val){
		var dummy = document.createElement("textarea");
		document.body.appendChild(dummy);
		dummy.value = val;
		dummy.select();
		document.execCommand("copy");
		document.body.removeChild(dummy);


		// ȭ����� ��� ���� �������� ��쿡�� �� ������ ȭ����� �� �̵� ó��, �̿� Ŭ������ ���� �˸�
		var agent = navigator.userAgent.toLowerCase(); // ���� ������ üũ
		var browserChk = "";
		if ((agent.indexOf("chrome") != -1) || (agent.indexOf("safari") != -1) || (agent.indexOf("firefox") != -1) || (agent.indexOf("opr") != -1)) {
			window.open(val);
		}else{
			alert("ȭ������� URL ��ΰ� ����Ǿ����ϴ�.\nȭ����� ���񽺴� ũ�� ������������ �����˴ϴ�.\nũ�� �������� ���� �ٿ��ֱ�(Ctrl+v)�� �ּ���.");	
		}	
	}
	*/
	function fn_interview(val) {
		// ȭ����� ��� ���� �������� ��쿡�� �� ������ ȭ����� �� �̵� ó��, �̿� Ŭ������ ���� �˸�
		var agent = navigator.userAgent.toLowerCase(); // ���� ������ üũ
		var browserChk = "";
		if ((agent.indexOf("chrome") != -1) || (agent.indexOf("safari") != -1) || (agent.indexOf("firefox") != -1) || (agent.indexOf("opr") != -1)) {
			window.open("./view_interview_conn.asp?url=" + val);
		}else{
			alert("ȭ����� ���񽺴� ũ�� ������������ �����˴ϴ�.\nũ�� ���������� �����Ͻñ� �ٶ��ϴ�.");	
		}
	}
</script>
</head>

<body>

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->


<!-- ȭ����� ���� ������ ����/���� �߼ۿ� ��� ȣ�� start -->
<form method="post" id="frm_ontact" name="frm_ontact" action="">
	<input type="hidden" id="jidnum" name="jidnum" value="<%=jid%>" />
	<input type="hidden" id="bizid" name="bizid" value="" /> 
	<input type="hidden" id="confid" name="confid" value="" /> 
</form>			
<!-- ȭ����� ���� ������ ����/���� �߼ۿ� ��� ȣ�� end -->


<!-- ���� -->
<div id="contents" class="sub_page">
	<div class="content">
		<div class="con_area">
			<div class="interview_area">
				<h3>���� Interview </h3>
				<div class="hire_box">
					<div class="info">
						<% If mode = "ing" Then %>
						<span>������</span>
						<% ElseIf mode = "cl" Then %>
						<span>����</span>
						<% End If %>
						<p><%=arrRsTitle(0, 0)%></p>
						<div class="btn_area">
							<a href="/jobs/view.asp?id_num=<%=jid%>" class="btn orange" target="_blank">������</a>
							<!--<a href="javascript:;;" class="btn gray">�������</a>-->
						</div>
					</div>
				</div><!-- //.hire_box -->

				<div class="placement_box">
					<p class="tit">������ ����</p>
					<ul class="pb_ul">
						<li>1. �����հ��ڿ� ���� ������ ������ �� �� �ֽ��ϴ�.</li>
						<li>2. ������ ������ ���� ��ư�� Ŭ���ϸ� ���������� ������ �� �ֽ��ϴ�.</li>
						<li>3. ���� ������ �Ϸ�Ǹ� �Ʒ� ����Ʈ�� �����Ͻ� �������� ���ļ����� ����˴ϴ�.</li>
						<li>4. ���� ���� �Ϸ� �� �Ʒ� �������� ���ں����� ��ư�� Ŭ���Ͻø�, ������ ��ο��� ���������� ���ڸ޼����� ���۵˴ϴ�. <br>(�� ���ڸ޼����� ���۵Ǹ� �ɻ���¸� ������ �� �����ϴ�.)</li>
					</ul>
					<button type="button" class="pb_btn pop" onclick="openLayer('interview', '', '');">������ ����<br>����</button>
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
							<div class="select_box" title="��������" style="width:130px;">
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
									<a href="javascript:;"><span>��������</span></a>
								<% End If %>
								</div>
								<div class="sel">
									<ul>
										<li><a href="javascript:;" onclick="fn_sch_job_part('')">��������</a></li>
										<% For i=0 To UBound(arrRsMojip, 2) %>
										<li><a href="javascript:;" onclick="fn_sch_job_part('<%=arrRsMojip(0, i)%>')"><%=arrRsMojip(1, i)%></a></li>
										<% Next %>
									</ul>
								</div>
							</div>
							<% End If %>

<%
ConnectDB DBCon, Application("DBInfo_FAIR")

	' ȭ������� ȸ�� ���̵� ���� üũ
	Dim sql, arrRsdata, ont_confId
	sql = "SELECT ȭ�������ȸ����̵� FROM ��������_ȸ����̵� WHERE ȸ����̵�='"&comid&"' "
	arrRsdata = arrGetRsSql(DBCon, sql, "", "")
	If IsArray(arrRsdata) Then
		ont_confId = Trim(arrRsdata(0,0))
	Else 
		ont_confId = ""
	End If

	' ȭ����� URL ���� ���� üũ
	Dim sql2, arrRsdata2, rsvInterviewYn, ont_urlCd, ont_hostUrl, ont_submitApiYn, ont_intvDt, ont_intvTm, alertMsg
	sql2 = "SELECT TOP 1 URL�ڵ�, ������URL, API���ۿ���, ������, CASE �����ð� WHEN 1 THEN '09:25' WHEN 2 THEN '09:55' WHEN 3 THEN '10:25' WHEN 4 THEN '10:55' WHEN 5 THEN '11:25' WHEN 6 THEN '11:55' WHEN 7 THEN '13:25' WHEN 8 THEN '13:55' WHEN 9 THEN '14:25' WHEN 10 THEN '14:55' WHEN 11 THEN '15:25' WHEN 12 THEN '15:55' WHEN 13 THEN '16:25' WHEN 14 THEN '16:55' WHEN 15 THEN '17:25' WHEN 16 THEN '17:55' END AS tm FROM ��������_������URL "
	sql2 = sql2 & " WHERE ȸ����̵�='"&comid&"' AND ȭ�������ȸ����̵�='"&ont_confId&"' AND ä���Ϲ�ȣ='"&jid&"' "
	sql2 = sql2 & " AND ������='"&interview_day&"' AND �����ð�='"&interview_time&"' "
	arrRsdata2 = arrGetRsSql(DBCon, sql2, "", "")
	If IsArray(arrRsdata2) Then
		rsvInterviewYn = "Y"
		ont_urlCd		= Trim(arrRsdata2(0,0))
		ont_hostUrl		= Trim(arrRsdata2(1,0))
		ont_submitApiYn = Trim(arrRsdata2(2,0))
		ont_intvDt		= Trim(arrRsdata2(3,0))
		ont_intvTm		= Trim(arrRsdata2(4,0))

		If ont_submitApiYn="N" Then ' URL ���� API ������ ���� ���� ���
			rsvInterviewYn = "N"
			alertMsg = "ȭ�� �������� ���� ���Ͽ� ���Ͽ� ���� �����մϴ�."
		Else 
			If CDate(ont_intvDt) = Date() Then
				If ont_intvTm < FormatDateTime(Now(), 4) Then 
					rsvInterviewYn = "D"	
					alertMsg = "���ڰ� ����� ȭ�� �������� �ڵ� �����Ǿ� ������ �Ұ����մϴ�."
				Else 
					rsvInterviewYn = "Y"
				End If 
			ElseIf CDate(ont_intvDt) < Date() Then 
				rsvInterviewYn = "D"	
				alertMsg = "���ڰ� ����� ȭ�� �������� �ڵ� �����Ǿ� ������ �Ұ����մϴ�."				
			Else 
				rsvInterviewYn = "Y"
			End If 
		End If 
	Else 
		If interview_time="" Then
			rsvInterviewYn = "X"
			alertMsg = "��� �ڽ����� �����ð��븦 ������ �ּ���."			
		Else 
			rsvInterviewYn = "X"
			alertMsg = "��� �������� ���� ������ ��ư�� ������ ���� ���� Ȯ�� ó���� ���ּ���."
		End If 
	End If

	' ȭ����� ������ ���� ���� üũ
	Dim sql3, arrRsdata3, cntOntactRsv
	sql3 = "select COUNT(*) from ������������ where ä���Ϲ�ȣ='"&jid&"' AND ȸ����̵�='"&comid&"' AND ISNULL(����Ȯ������,'N')<>'Y' "
	arrRsdata3 = arrGetRsSql(DBCon, sql3, "", "")
	If IsArray(arrRsdata3) Then
		cntOntactRsv = Trim(arrRsdata3(0,0))
	Else 
		cntOntactRsv = 0		
	End If

DisconnectDB DBCon
%>	
							<button type="button" class="send" onclick="<%If cntOntactRsv > 0 Then%>fn_interview_msg_send('<%=jid%>', '<%=comid%>', '<%=ont_confId%>');<%Else%>alert('������ ������ �Ϸ�Ǿ�� �޽����� ���۵˴ϴ�.');<%End If%>">�������� ���ں�����</button>
							<button type="button" class="pdf pop" onclick="openLayer('result_apply','','');">������� �뺸</button>

							<div class="select_box calendar" title="�޷º���" style="width:150px;">
								<div class="name">
									<a href="javascript:;" onclick="fn_calendar(this);"><span id="sel_interview_day"><%=interview_day%></span></a>
								</div>
								<div class="sel">
									<div class="calendar_box">
										<!-- ���س�� ���� -->
										<div id="sel_calendar_box">
										</div>
										<!-- �޷¿��� -->
										<div id="sel_calendar_table">
										</div>
									</div>
								</div>
							</div>

						</div>
						<div class="right_box">
							<div class="sch_box">
								<input type="text" id="kw" name="kw" class="txt" value="<%=kw%>" placeholder="�̸� �Ǵ� �޴��� ��ȣ�� �Է��� �ּ���.">
								<button type="button" class="reset_btn" onclick="fn_reset();">�ʱ�ȭ</button>
								<button type="button" class="sch_btn" onclick="fn_sch();">�˻�</button>
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

							' ���� �Ϸ� Ŭ���� ���� ���� üũ
							ConnectDB DBCon, Application("DBInfo_FAIR")

							Dim sql4, arrRsdata4, ont_apiCreateYn, ont_apiDelYn, ont_interviewTm, clsComplete
							clsComplete = ""
							sql4 = "SELECT TOP 1 ISNULL(API���ۿ���,'N'), ISNULL(API��������,'N'), CASE �����ð� WHEN 1 THEN '09:25' WHEN 2 THEN '09:55' WHEN 3 THEN '10:25' WHEN 4 THEN '10:55' WHEN 5 THEN '11:25' WHEN 6 THEN '11:55' WHEN 7 THEN '13:25' WHEN 8 THEN '13:55' WHEN 9 THEN '14:25' WHEN 10 THEN '14:55' WHEN 11 THEN '15:25' WHEN 12 THEN '15:55' WHEN 13 THEN '16:25' WHEN 14 THEN '16:55' WHEN 15 THEN '17:25' WHEN 16 THEN '17:55' END AS tm FROM ��������_������URL "
							sql4 = sql4 & " WHERE ä���Ϲ�ȣ='"&jid&"' AND ȸ����̵�='"&comid&"' AND ������='"&interview_day&"' AND �����ð�='"&arrRsTimeToCnt(2, i)&"' "
							arrRsdata4 = arrGetRsSql(DBCon, sql4, "", "")
							If IsArray(arrRsdata4) Then
								ont_apiCreateYn	= Trim(arrRsdata4(0,0))
								ont_apiDelYn	= Trim(arrRsdata4(1,0))	
								ont_interviewTm	= Trim(arrRsdata4(2,0))		

								If ont_apiCreateYn="N" Then ' URL �ڵ� ���� �� �̶�� �Ϸ� ���̾� ���� �� ��
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
									Else  ' ���� �����ڰ� ���� ��� �Ϸ� ���̾� ���� �� ��
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
									<span>(<%=arrRsTimeToCnt(3, i)%>��)</span>
								</a>
							<%If clsComplete="Y" Then%>
								<div class="complete">
									<p>�Ϸ�</p>
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
										mode: 'horizontal',// ���� ���� ���� �����̵�
										speed: 500,        // �̵� �ӵ��� ����
										pager: false,      // ���� ��ġ ����¡ ǥ�� ���� ����
										moveSlides: 8,     // �����̵� �̵��� ����
										slideWidth: 149,   // �����̵� �ʺ�
										minSlides: 8,      // �ּ� ���� ����
										maxSlides: 8,      // �ִ� ���� ����
										slideMargin: 10,    // �����̵尣�� ����
										infiniteLoop:true,
										auto: false,        // �ڵ� ���� ����
										autoHover: false,   // ���콺 ȣ���� ���� ����
										controls: true    // ���� ���� ��ư ���� ����
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

					<!--����Ʈ-->
					<!--#include file = "./inc_list.asp"-->

					<!--����¡-->
					<% Call putPage(page, stropt, totalPage) %>

					<div class="list_btn inter">
						<a class="btn prev" href="./list.asp?mode=<%=mode%>&jid=<%=jid%>">���� ������ �̵�</a>
						<a class="btn inter" href="javascript:;;" onclick="<%If rsvInterviewYn="Y" Then%>fn_interview('<%=ont_hostUrl%>');return false;<%Else%>alert('<%=alertMsg%>');<%End If%>">������ �̵�</a>
						<p class="btn_ment">��ư�� Ŭ���ؼ� �ش� �ð��� ȭ������� ������ �ּ���!<p>
					</div><!--//list_btn-->

				</div><!--//board_area -->

			</div><!-- .manage_area -->
		</div><!-- .con_area -->
	</div><!-- .content -->

</div>
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

<!-- ������ ����, ������� �Է� -->
<!--#include file = "./inc_pop_interview.asp"-->
<!-- //������ ����, ������� �Է� -->

<!-- ����Է� -->
<div id="pop_result_interview">
<div id="pop_dim2" class="pop_dim"></div>
<div id="popup2" class="popup">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>������� �Է�</h3>
			<a href="javascript:;" class="layer_close">�ݱ�</a>
		</div>
		<div id="result_interview_html" class="pop_con">
		</div>
		<div class="pop_footer">
			<div class="btn_area">
				<a href="javaScript:;" onclick="fn_result_submit();"  class="btn blue">����Է�</a>
			</div>
		</div>
	</div>	
</div>
</div>
<!-- ����Է� -->

<!-- ����뺸�ϱ�,  �뺸����, �̸����� -->
<!--#include file = "../applyjob/apply_result.asp"-->
<!-- ����뺸�ϱ�,  �뺸����, �̸����� -->

</body>
</html>