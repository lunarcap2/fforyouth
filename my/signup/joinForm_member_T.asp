<%@codepage="949" language="VBScript"%>
<%
'--------------------------------------------------------------------
'   Comment		: ����ȸ�� ����
' 	History		: 2020-04-20, �̻��� 
'---------------------------------------------------------------------
Session.CodePage  = 949			'�ѱ�
Response.CharSet  = "euc-kr"	'�ѱ�
Response.AddHeader "Pragma","no-cache"
Response.AddHeader "cache-control", "no-staff"
Response.Expires  = -1
%>

<!--#include virtual = "/common/common.asp"-->

<%
If Request.ServerVariables("HTTPS") = "off" Then 
	Response.redirect "https://"& Request.ServerVariables("HTTP_HOST") & Request.ServerVariables("URL") 
End If


If request.Cookies(site_code & "WKC_F")("comid")<>"" Or request.Cookies(site_code & "WKP_F")("id")<>"" Then 
	Response.Write "<script language=javascript>"&_
		"alert('�α��� ���¿����� �ش� �������� ������ �� �����ϴ�.\n�α׾ƿ� �� �̿� �ٶ��ϴ�.');"&_
		"location.href='/';"&_
		"</script>"
	response.End 
End If
%>

<!--#include virtual = "/include/header/header.asp"-->

<script type="text/javascript" src="/my/signup/js/joinForm_T.js?<%=publishUpdateDt%>"></script>
<script type="text/javascript">
	// �Է°� üũ
	$(document).ready(function () {
		//$("#txtPass").val("");
		//$("#frm1")[0].reset();

		//���̵� �ߺ� üũ
		$("#txtId").bind("keyup keydown", function () {
			fn_checkID();
		});

		// ��� ��ȿ�� üũ
		$("#txtPass").bind("keyup keydown", function () {
			$(this).attr('type', 'password'); 
			fn_checkPW();
		});

		// ��� ��Ȯ�� ��ȿ�� üũ
		$("#txtPassChk").bind("keyup keydown", function () {
			fn_checkPW();
		});

		// �̸��� �ּ� ��ȿ�� üũ
		$("#txtEmail").bind("keyup keydown", function () {
			fn_checkMail();
		});
	});
</script>
</head>

<body id="membersWrap">
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->


<!-- CONTENTS -->
<div id="career_container" class="searchIdWrap">
	
    <div id="career_contents">
        <div class="layoutBox">
			<div class="step_area">
				<ul>
					<li class="on">Step1.����ȸ�� ���� �Է�</li>
					<li>Step2. ������û�� �ۼ�</li>
				</ul>
			</div>
			<h3><img src="/images/signup/signup_tit.png" alt="����ȸ��"></h3>
			<div id="memberPer" class="memberInfo per">



				<form name="frm1" id="frm1" method="post">
					<input type="hidden" name="id_check" id="id_check" value="" /><!-- ���̵� ���� ����(0/1) -->
					<input type="hidden" name="chk_id" id="chk_id" value=""><!-- ���(�Է�) ���̵� -->
					<input type="hidden" name="hd_idx" id="hd_idx" value="" /><!-- ��ȣ���� idx -->
					<input type="hidden" name="mobileAuthNumChk" id="mobileAuthNumChk" value="0" />
					<input type="hidden" name="hd_kind" id="hd_kind" value="2" />
					<input type="hidden" name="authproc" id="authproc" value="" />
					<input type="hidden" name="site_short_name" id="site_short_name" value="<%=site_short_name%>">

					<!--ȸ������ �Է�-->
					<!--#include file="./inc_member_info.asp"-->					
				</form>



			</div><!-- .memberInfo -->
		</div><!-- .layoutBox -->
    </div><!-- #career_contents -->

</div><!-- #career_container -->
<!--// CONTENTS -->


<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>