<%
option Explicit

'------ ������ �⺻���� ����.
g_MenuID = "010001"  '�� �� ���ڴ� lnb ��������, �� �� ���ڴ� �޴� �̹��� ���ϸ� ����
g_MenuID_Navi = "0,1"  '������̼� ��
%>
<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/function/library/AES256.asp"-->
<%
Call FN_LoginLimit("2")	'���ȸ�� ���

Dim stp     : stp = 1					'�̷¼� �ܰ�
Dim rid     : rid = request("rid")		'�̷¼� ��Ϲ�ȣ (rid�� ������ ����)
Dim rtype   : rtype = "T"				'�̷¼� ����(T:�߰�����, C:�Ϸ�)
Dim cflag   : cflag = request("cflag")	'����/��� ����. 1/8 �� ���簪�� ����
Dim set_user_id : set_user_id = Request("set_user_id") '�ٸ� ������� �̷¼��� �������� ����ھ��̵�

'�Ի����� �̷¼� ��ȸ����
'/wwwconf_2009/query_lib/user/ResumeInfo2.asp (�̷¼�:getResumeStepDataNew, �Ի������̷¼�:getApplyResumeStepDataNew)
Dim apply_resume : apply_resume = "Y"

If rid = "" Or rid = "0" Or set_user_id = "" Then
	ShowAlertMsg "�߸��� �����Դϴ�.", "window.close();", True
End If

If set_user_id = "" Or Len(set_user_id) < 20 Then 
	ShowAlertMsg "�߸��� �����Դϴ�.", "window.close();", True
End If

'����ھ��̵� ��ȣȭ AES256
set_user_id = objEncrypter.Decrypt(set_user_id)

Dim i, ii
Dim v_pop_yn, v_menu_data, v_menu_file
v_pop_yn = "Y"
v_menu_data = "N" '�̷¼�����, ���ó�¥ ������Ʈ
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
</head>

<body id="bodyResume">

<!-- ���� -->
<!--#include virtual = "/my/resume/comm/inc_resume_view.asp"-->
<!-- //���� -->

</body>
</html>
