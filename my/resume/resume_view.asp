<%
option Explicit

'------ ������ �⺻���� ����.
g_MenuID = "010001"  '�� �� ���ڴ� lnb ��������, �� �� ���ڴ� �޴� �̹��� ���ϸ� ����
g_MenuID_Navi = "0,1"  '������̼� ��
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<%
Call FN_LoginLimit("1")	'����ȸ�� ���

Dim stp     : stp = 1					'�̷¼� �ܰ�
Dim rid     : rid = request("rid")		'�̷¼� ��Ϲ�ȣ (rid�� ������ ����)
Dim rtype   : rtype = "T"				'�̷¼� ����(T:�߰�����, C:�Ϸ�)
Dim cflag   : cflag = request("cflag")	'����/��� ����. 1/8 �� ���簪�� ����
Dim set_user_id '�ٸ� ������� �̷¼��� �������� ����ھ��̵�
set_user_id = user_id
Dim apply_resume '�Ի����� �̷¼� ��ȸ����(���ȸ�� �����ڰ��� ���)

If rid = "" Or rid = "0" Then
	ShowAlertMsg "�߸��� �����Դϴ�.", "history.back();", True
End If

Dim i, ii
Dim v_pop_yn, v_menu_data, v_menu_file
v_pop_yn = "N"
v_menu_data = "Y" '�̷¼�����, ���ó�¥ ������Ʈ
v_menu_file = "Y" '�μ�, word/pdf �ٿ�ε�
%>
<!--#include virtual = "/wwwconf/code/code_function.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_jc.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_resume.asp"-->
<!--#include virtual = "/wwwconf/code/code_resume.asp"-->

<!--#include virtual = "/wwwconf/function/db/DBConnection.asp"-->
<!--#include virtual = "/wwwconf/query_lib/user/ResumeInfo.asp"-->
<!--#include virtual = "/my/resume/comm/getResumeStepDBInfo.asp"-->
<script type="text/javascript">
	//document.domain = "career.co.kr";
</script>
</head>

<body id="bodyResume">

<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->

<!-- ���� -->
<!--#include file = "./comm/inc_resume_view.asp"-->
<!-- //���� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>