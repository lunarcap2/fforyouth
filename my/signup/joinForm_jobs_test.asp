<%@codepage="949" language="VBScript"%>
<%
'--------------------------------------------------------------------
'   Comment		: 개인회원 가입
' 	History		: 2020-04-20, 이샛별 
'---------------------------------------------------------------------
Session.CodePage  = 949			'한글
Response.CharSet  = "euc-kr"	'한글
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
		"alert('로그인 상태에서는 해당 페이지에 접근할 수 없습니다.\n로그아웃 후 이용 바랍니다.');"&_
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
	// url 파라미터 안보이게
	history.replaceState({}, null, location.pathname);

	$(document).ready(function () {
		$(".tb").mouseleave(function () {
			$('.sb_area').hide();
		});
	});
</script>

<body id="membersWrap">
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- 상단 -->


<!-- CONTENTS -->
<div id="career_container" class="searchIdWrap">

	<div id="career_contents">
        <div class="layoutBox">
			<div class="step_area">
				<ul>
					<li>Step1.개인회원 정보 입력</li>
					<li class="on">Step2. 구직신청서 작성</li>
				</ul>
			</div>
			<h3><img src="/images/signup/signup_tit2.png" alt="구직신청서 작성"></h3>
			<div id="memberPer" class="memberInfo per">


				<form name="frm1" id="frm1" method="post">
					<input type="hidden" id="txtId" name="txtId" value="<%=txtId%>">
					<input type="hidden" id="txtPass" name="txtPass" value="<%=txtPass%>">
					<input type="hidden" id="txtEmail" name="txtEmail" value="<%=txtEmail%>">
					<input type="hidden" id="txtPhone" name="txtPhone" value="<%=txtPhone%>">
					<input type="hidden" id="chkAgrPrv" name="chkAgrPrv" value="<%=chkAgrPrv%>">

					<input type="hidden" id="juminH" name="juminH" maxlength="7">				<!--주민번호뒷자리-->
					
					<input type="hidden" id="univ_kind" name="univ_kind" value="0">				<!--학력구분-->
					<input type="hidden" id="univ_syear" name="univ_syear" value="">			<!--입학년-->
					<input type="hidden" id="univ_smonth" name="univ_smonth" value="">			<!--입학월-->
					<input type="hidden" id="univ_eyear" name="univ_eyear" value="">			<!--졸업년-->
					<input type="hidden" id="univ_emonth" name="univ_emonth" value="">			<!--졸업월-->

					<input type="hidden" id="hdn_jc_name" name="hdn_jc_name" value="">				<!--희망직종-->
					<input type="hidden" id="hdn_career_month" name="hdn_career_month" value="">	<!--경력월입력-->
					<input type="hidden" id="hdn_area" name="hdn_area" value="">					<!--희망근무지역-->
					<input type="hidden" id="hdn_employ" name="hdn_employ" value="">				<!--고용형태-->
					<input type="hidden" id="hdn_salary" name="hdn_salary" value="">				<!--희망입금형태-->
					<input type="hidden" id="hdn_hire_info" name="hdn_hire_info" value="">			<!--구직정도제공동의여부-->

					
					<!--회원정보 입력-->
					<!--#include file="./inc_jobs_info.asp"-->
					
					<!--최종학력사항-->
					<!--#include file="./inc_jobs_education.asp"-->

					<!--희망취업조건-->
					<!--#include file="./inc_jobs_career.asp"-->

					<!--동의 및 신청완료-->
					<!--#include file="./inc_jobs_agree.asp"-->
				</form>


			</div>
		</div>
	<div>

</div><!-- #career_container -->
<!--// CONTENTS -->

<!-- 희망지역 팝업 -->
<!--#include file="./pop_sch_workarea.asp"-->
<!-- 희망지역 팝업 -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

</body>
</html>


