<%
option Explicit

'------ ������ �⺻���� ����.
g_MenuID = "010001"  '�� �� ���ڴ� lnb ��������, �� �� ���ڴ� �޴� �̹��� ���ϸ� ����
g_MenuID_Navi = "0,1"  '������̼� ��
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<%
Call FN_LoginLimit("1")    '����ȸ���� ���ٰ���
'ex)FN_LoginLimit("012")	<-- ��ȸ��/����ȸ��/���ȸ�� ���

Dim stp     : stp = 1					'�̷¼� �ܰ�
Dim rid     : rid = request("rid")		'�̷¼� ��Ϲ�ȣ (rid�� ������ ����)
Dim rtype   : rtype = "T"				'�̷¼� ����(T:�߰�����, C:�Ϸ�)
Dim cflag   : cflag = request("cflag")	'����/��� ����. 1/8 �� ���簪�� ����
Dim isBaseResume						'�⺻�̷¼�
Dim set_user_id '�ٸ� ������� �̷¼��� �������� ����ھ��̵�(�信���� ���)
Dim apply_resume '�Ի����� �̷¼� ��ȸ����(���ȸ�� �����ڰ��� ���)
%>
<!--#include virtual = "/wwwconf/code/code_function.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_resume.asp"-->
<!--#include virtual = "/wwwconf/code/code_resume.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/query_lib/user/ResumeInfo.asp"-->
<!--#include virtual = "/my/resume/comm/getResumeStepDBInfo.asp"-->
<%
	Dim i, ii, seq

	'--�ۼ����� �̷¼� rid
	Dim ing_rid : ing_rid = 0
	Dim ing_rGubun
	If IsArray(arrIngResume) Then 
		ing_rid = arrIngResume(0,0)
		ing_rGubun = arrIngResume(1,0)
	end If

	'--�̷¼� �űԵ�� �� : 3���̻� ��� ����
	If rid = 0  Then 
		If IsArray(arrIngResume) Then 
			If iResumeCnt >= 10 And ing_rid = 0 Then
				ShowAlertMsg "�̷¼��� 10������ ����� �����մϴ�.", "location.replace('/my/resume_list.asp');", True
			ElseIf iResumeCnt >= 10 And ing_rid > 0 Then
				ShowAlertMsg "", "if(confirm('�ۼ����� �̷¼��� �ֽ��ϴ�. ��� �ۼ��Ͻðڽ��ϱ�?')){location.replace('/my/resume/resume_regist.asp?rid="& ing_rid & "');}else{location.replace('/my/resume_list.asp');}", True
			ElseIf iResumeCnt < 10 And ing_rid > 0 Then
				ShowAlertMsg "", "if(confirm('�ۼ����� �̷¼��� �ֽ��ϴ�. ��� �ۼ��Ͻðڽ��ϱ�?')){location.replace('/my/resume/resume_regist.asp?rid="& ing_rid &"');}else{location.replace('/my/resume_list.asp');}", True
			End If
		else
			If iResumeCnt >= 10 And ing_rid = 0 Then
				ShowAlertMsg "�̷¼��� 10������ ����� �����մϴ�.", "location.replace('/my/resume_list.asp');", True
			ElseIf iResumeCnt >= 10 And ing_rid > 0 Then
				ShowAlertMsg "", "if(confirm('�ۼ����� �̷¼��� �ֽ��ϴ�. ��� �ۼ��Ͻðڽ��ϱ�?')){location.replace('"& mydir &"/resume/resume_regist.asp?rid="& ing_rid & "');}else{location.replace('"& mydir &"');}", True
			ElseIf iResumeCnt < 10 And ing_rid > 0 Then
				ShowAlertMsg "", "if(confirm('�ۼ����� �̷¼��� �ֽ��ϴ�. ��� �ۼ��Ͻðڽ��ϱ�?')){location.replace('"& mydir &"/resume/resume_regist.asp?rid="& ing_rid &"');}else{location.replace('"& mydir &"/resume/resume_reg_step1.asp?flag=1&cflag=" & cflag & "');}", True
			End If
		end if
	End If

	'-- �⺻�̷¼� ������
	If iResumeCnt = "0" Then isBaseResume = "1"
	If rid <> 0 And IsArray(arrResume) Then isBaseResume = arrResume(1, 0)
%>

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript" src="/js/resume_renew.js"></script>

<script type="text/javascript">
	$(document).ready(function () {
		var arrBase = '<%=isArray(arrBase)%>';
		//�̷¼� ��Ͻ�
		if ($("#rid").val() == "0" && arrBase == "False") {
			$("#resume4").hide();
			$("#rnb_toggle4").addClass("off");

			$("#resume5").hide();
			$("#rnb_toggle5").addClass("off");

			$("#resume6").hide();
			$("#rnb_toggle6").addClass("off");
			
			$("#resume7").hide();
			$("#rnb_toggle7").addClass("off");
			
			$("#resume8").hide();
			$("#rnb_toggle8").addClass("off");
			
			$("#resume9").hide();
			$("#rnb_toggle9").addClass("off");
			
			$("#resume10").hide();
			$("#rnb_toggle10").addClass("off");
			
			$("#resume13").hide();
			$("#rnb_toggle13").addClass("off");
		} else {
			var arrActivity =		'<%=isArray(arrActivity)%>';
			var arrLanguageUse =	'<%=isArray(arrLanguageUse)%>';
			var arrLanguageExam	=	'<%=isArray(arrLanguageExam)%>';
			var arrLicense =		'<%=isArray(arrLicense)%>';
			var arrPrize =			'<%=isArray(arrPrize)%>';
			var arrAcademy =		'<%=isArray(arrAcademy)%>';
			var arrAbroad =			'<%=isArray(arrAbroad)%>';
			var arrPersonal =		'<%=isArray(arrPersonal)%>';
			var arrMilitary =		'<%=isArray(arrMilitary)%>';
			var arrEmpSupport =		'<%=isArray(arrEmpSupport)%>';
			var arrEssay =			'<%=isArray(arrEssay)%>';

			if (arrActivity == "False") {
				$("#resume4").hide();
				$("#rnb_toggle4").addClass("off");
			}

			if (arrLanguageUse == "False" && arrLanguageExam == "False") {
				$("#resume5").hide();
				$("#rnb_toggle5").addClass("off");
			}

			if (arrLicense == "False") {
				$("#resume6").hide();
				$("#rnb_toggle6").addClass("off");
			}

			if (arrPrize == "False") {
				$("#resume7").hide();
				$("#rnb_toggle7").addClass("off");
			}

			if (arrAcademy == "False") {
				$("#resume8").hide();
				$("#rnb_toggle8").addClass("off");
			}

			if (arrAbroad == "False") {
				$("#resume9").hide();
				$("#rnb_toggle9").addClass("off");
			}

			if (arrPersonal == "False" && arrMilitary == "False" && arrEmpSupport == "False") {
				$("#resume10").hide();
				$("#rnb_toggle10").addClass("off");
			}

			if (arrEssay == "False") {
				$("#resume13").hide();
				$("#rnb_toggle13").addClass("off");
			}
		}

	});
</script>

</head>

<body id="info">
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- ���� -->
<div id="contents" class="sub_page resume">

	<!-- �̷¼� �׸� Rnb -->
	<div class="rnb_wrap" id="quick">
		<div class="rnb">
			<div class="rnb_box">
				<div class="rnb_con resume">
					<h5>�̷¼� �׸�</h5>
					<ul class="rr_ul">
						<li><button type="button" id="rnb_toggle1">������</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle2">�з�</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle3">���</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle4">����. ���Ȱ��</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle5">�ܱ���</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle6">�ڰ���</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle7">����</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle8">����</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle9">�ؿܰ���</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle10">�������׸�</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle11">��Ʈ������</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle12">����ٹ�����</button></li>
						<li class="rnb_toggle"><button type="button" id="rnb_toggle13">�ڱ�Ұ���</button></li>
					</ul>
					<div class="btn_area ruseme">
						<button type="button" onclick="fn_resume_save_preview();">�̸�����</button>
						<button type="button" onclick="fn_resume_save_imsi_T();">�ӽ�����</button>
						<button type="button" onclick="fn_resume_save();">�̷¼� ����</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- //�̷¼� �׸� Rnb -->

	<div class="content glay">
		<div class="con_area">
			<form id="frm1" name="frm1" method="post">
			<input type="hidden" id="rid" name="rid" value="<%=rid%>" />
			<input type="hidden" name="rtype" value="<%=rtype%>" />
			<input type="hidden" name="cflag" value="<%=cflag%>" />
			<input type="hidden" name="step" value="<%=stp%>" />
			<input type="hidden" name="rGubun" value="<%=rGubun%>" />
			<input type="hidden" name="resumeIsComplete" value="" />
			<input type="hidden" name="isBaseResume" value="<%=isBaseResume%>" />

			<!--#include file = "./rsub_01_userinfo_T.asp"--> 
			<!--#include file = "./rsub_02_school_T.asp"-->
			<!--#include file = "./rsub_03_career.asp"-->
			<!--#include file = "./rsub_04_activity.asp"-->
			<!--#include file = "./rsub_05_language.asp"-->
			<!--#include file = "./rsub_06_license.asp"-->
			<!--#include file = "./rsub_07_awards.asp"-->
			<!--#include file = "./rsub_08_education.asp"-->
			<!--#include file = "./rsub_09_overseas.asp"-->
			<!--#include file = "./rsub_10_preferential_T.asp"-->
			<!--#include file = "./rsub_11_portfolio.asp"-->
			<!--#include file = "./rsub_12_desire_T.asp"-->
			<!--#include file = "./rsub_13_introduce.asp"-->
			
			<div class="btn_area">
				<a href="javascript:" class="btn resume" onclick="fn_resume_save();">�̷¼� ����</a>
			</div>
			</form>
		</div><!-- .con_area -->
	</div><!-- .content -->

</div>
<!-- //���� -->


<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

<iframe id="procFrame" name="procFrame" style="position:absolute; top:0; left:0; width:0;height:0;border:0;" frameborder="0" src="about:blank"></iframe>
<form id="fileUploadForm" name="fileUploadForm" method="post" enctype="multipart/form-data" target="procFrame" action="./file_upload.asp" onsubmit="return false;">
	<span style="display:none;">
	<input type="file" id="uploadFile" name="uploadFile" onchange="javascript:document.fileUploadForm.submit();">
	</span>
	<input type="hidden" id="file_index" name="file_index" value="">
	<input type="hidden" id="pre_file_name" name="pre_file_name" value="">
</form>
<form id="filedelForm" name="filedelForm" method="post" target="procFrame" action="./file_del.asp">
	<input type="hidden" id="del_resume_no" name="del_resume_no" value="<%=rid%>">
	<input type="hidden" id="del_file_name" name="del_file_name" value="">
	<input type="hidden" id="del_file_seq" name="del_file_seq" value="">
</form>

<!-- �̷¼� ���� ���� -->
<form id="frm_my_sub_view" name="frm_my_sub_view" method="post">
<input type="hidden" id="hid_myPhoto" name="hid_myPhoto" value="<%=arrUser(11, 0)%>">
</form>

</body>
</html>
