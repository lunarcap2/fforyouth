<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/inc/function/code_function.asp"-->
<!--#include virtual = "/inc/function/paging.asp"-->
<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<%
Call FN_LoginLimit("2")	'���ȸ�� ���


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


	Dim page, psize, totalCnt, totalPage, i
	page = CInt(Request("page"))
	psize = CInt(Request("psize"))
	If page = "0" Then page = 1
	If psize = "0" Then psize = 10

	'��������������
	Dim stropt
	stropt = "mode=" & mode & "&jid=" & jid & "&interview_day=" & interview_day & "&interview_time=" & interview_time & "&kw=" & kw & "&job_part=" & job_part 

	Dim spName, arrRs, arrRsTitle, arrRsMojip, Interview_Cnt
	ReDim param(12)
	spName = "usp_�������_��������_����Ʈ"

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
		'ä������
		spName = "SELECT ������������ FROM ä������ WITH(NOLOCK) WHERE ��Ϲ�ȣ = " & jid
		arrRsTitle = arrGetRsSql(DBCon, spName, "", "")
		jid_NM = arrRsTitle(0, 0)
		'�����ι�
		spName = "SELECT ��ϼ�����ȣ, �����ι��� FROM ä������ι� WITH(NOLOCK) WHERE ä���Ϲ�ȣ = " & jid
		arrRsMojip = arrGetRsSql(DBCon, spName, "", "")
	ElseIf mode = "cl" Then 
		'ä������
		spName = "SELECT ������������ FROM ����ä������ WITH(NOLOCK) WHERE ��Ϲ�ȣ = " & jid
		arrRsTitle = arrGetRsSql(DBCon, spName, "", "")
		jid_NM = arrRsTitle(0, 0)
		'�����ι�
		spName = "SELECT ��ϼ�����ȣ, �����ι��� FROM ����ä������ι� WITH(NOLOCK) WHERE ä���Ϲ�ȣ = " & jid
		arrRsMojip = arrGetRsSql(DBCon, spName, "", "")
	End If

	'���������� ����� ī��Ʈ
	spName = "SELECT COUNT(��Ϲ�ȣ) FROM ������������ WITH(NOLOCK) WHERE ä���Ϲ�ȣ = " & jid
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

		radioboxFnc(); //�����ڽ�
		fn_rece_set(); // ����뺸�ϱ� �ʱ����
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

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

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
					
					<% If totalCnt = 0 Then %>
					<button type="button" class="pb_btn v2" onclick="javascript:alert('���������� �Ϸ�Ǿ����ϴ�.'); return false;">������ ����</button>
					<% Else %>
					<button type="button" class="pb_btn v2 pop" onclick="openLayer('interview');">������ ����</button>
					<% End If %>

					<% If Interview_Cnt > 0 Then %>
					<button type="button" class="pb_btn" onclick="location.href='./list_interview.asp?mode=<%=mode%>&jid=<%=jid%>&interview_day=<%=Date()%>'">�������� ���</button>
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
							<!-- <button type="button" class="send">�������� ���ں�����</button> -->
							<button type="button" class="result pop" onclick="openLayer('result_apply');">������� �뺸</button>
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

					<!--����Ʈ-->
					<!--#include file = "./inc_list.asp"-->

					<!--����¡-->
					<% Call putPage(page, stropt, totalPage) %>
				</div><!--//board_area -->
			</div><!-- .manage_area -->
		</div><!-- .con_area -->
	</div><!-- .content -->

</div>
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

<!-- ������ ���� -->
<!--#include file = "./inc_pop_interview.asp"-->
<!-- //������ ���� -->

<!-- ����뺸�ϱ�,  �뺸����, �̸����� -->
<!--#include file = "../applyjob/apply_result.asp"-->
<!-- ����뺸�ϱ�,  �뺸����, �̸����� -->

</body>
</html>