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
<!--#include virtual = "/include/header/header.asp"-->
<!--#include virtual = "/wwwconf/code/code_function_ac.asp"-->

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


Dim txtId, txtPass, txtEmail, txtPhone, chkAgrPrv
txtId = "styleji12"
txtPass = "qwer1234"
txtEmail = "styleji@career.co.kr"
txtPhone = "010-6829-0511"
chkAgrPrv = "1"

'Response.write "txtId : " & Request("txtId") & "<br>"
'Response.write "txtPass : " & Request("txtPass") & "<br>"
'Response.write "txtEmail : " & Request("txtEmail") & "<br>"
'Response.write "txtPhone : " & Request("txtPhone") & "<br>"
'Response.write "chkAgrPrv : " & Request("chkAgrPrv") & "<br>"
%>

<script type="text/javascript" src="/my/signup/js/joinForm.js?<%=publishUpdateDt%>"></script>
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
	// url �Ķ���� �Ⱥ��̰�
	history.replaceState({}, null, location.pathname);

	$(document).ready(function () {
		$(".tb").mouseleave(function () {
			$('.sb_area').hide();
		});
	});
</script>

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
					<li>Step1.����ȸ�� ���� �Է�</li>
					<li class="on">Step2. ������û�� �ۼ�</li>
				</ul>
			</div>
			<h3><img src="/images/signup/signup_tit2.png" alt="������û�� �ۼ�"></h3>
			<div id="memberPer" class="memberInfo per">


				<form name="frm1" id="frm1" method="post">
					<input type="hidden" id="txtId" name="txtId" value="<%=txtId%>">
					<input type="hidden" id="txtPass" name="txtPass" value="<%=txtPass%>">
					<input type="hidden" id="txtEmail" name="txtEmail" value="<%=txtEmail%>">
					<input type="hidden" id="txtPhone" name="txtPhone" value="<%=txtPhone%>">
					<input type="hidden" id="chkAgrPrv" name="chkAgrPrv" value="<%=chkAgrPrv%>">

					<input type="hidden" id="juminH" name="juminH" maxlength="7">				<!--�ֹι�ȣ���ڸ�-->
					
					<input type="hidden" id="univ_kind" name="univ_kind" value="0">				<!--�з±���-->
					<input type="hidden" id="univ_syear" name="univ_syear" value="">			<!--���г�-->
					<input type="hidden" id="univ_smonth" name="univ_smonth" value="">			<!--���п�-->
					<input type="hidden" id="univ_eyear" name="univ_eyear" value="">			<!--������-->
					<input type="hidden" id="univ_emonth" name="univ_emonth" value="">			<!--������-->

					<input type="hidden" id="hdn_jc_name" name="hdn_jc_name" value="">				<!--�������-->
					<input type="hidden" id="hdn_career_month" name="hdn_career_month" value="">	<!--��¿��Է�-->
					<input type="hidden" id="hdn_area" name="hdn_area" value="">					<!--����ٹ�����-->
					<input type="hidden" id="hdn_employ" name="hdn_employ" value="">				<!--�������-->
					<input type="hidden" id="hdn_salary" name="hdn_salary" value="">				<!--����Ա�����-->
					<input type="hidden" id="hdn_hire_info" name="hdn_hire_info" value="">			<!--���������������ǿ���-->

					
					<!--ȸ������ �Է�-->
					<!--#include file="./inc_jobs_info.asp"-->
					
					<!--�����з»���-->
					<!--#include file="./inc_jobs_education.asp"-->

					<!--����������-->
					<!--#include file="./inc_jobs_career.asp"-->

					<!--���� �� ��û�Ϸ�-->
					<!--#include file="./inc_jobs_agree.asp"-->
				</form>


			</div>
		</div>
	<div>

</div><!-- #career_container -->
<!--// CONTENTS -->

<!-- ������� �˾� -->
<!--#include file="./pop_sch_workarea.asp"-->
<!-- ������� �˾� -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>


