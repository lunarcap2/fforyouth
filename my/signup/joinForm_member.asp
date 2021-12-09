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

Dim sUsrAgent : sUsrAgent = UCase(Request.ServerVariables("HTTP_USER_AGENT"))

If InStr(sUsrAgent, "ANDROID") > 0 Or InStr(sUsrAgent, "IPAD") > 0 Or InStr(sUsrAgent, "IPHONE") > 0 Then
	Response.Write "<script language=javascript>"&_
		"alert('PC환경에서 회원가입을 해주시기 바랍니다.');"&_
		"location.href='/';"&_
		"</script>"
	response.End 
End If
%>

<!--#include virtual = "/include/header/header.asp"-->

<script type="text/javascript" src="/my/signup/js/joinForm.js?<%=publishUpdateDt%>"></script>
<script type="text/javascript">
	// 입력값 체크
	$(document).ready(function () {
		//$("#txtPass").val("");
		//$("#frm1")[0].reset();

		//아이디 중복 체크
		$("#txtId").bind("keyup keydown", function () {
			fn_checkID();
		});

		// 비번 유효성 체크
		$("#txtPass").bind("keyup keydown", function () {
			$(this).attr('type', 'password'); 
			fn_checkPW();
		});

		// 비번 재확인 유효성 체크
		$("#txtPassChk").bind("keyup keydown", function () {
			fn_checkPW();
		});

		// 이메일 주소 유효성 체크
		$("#txtEmail").bind("keyup keydown", function () {
			fn_checkMail();
		});
	});
</script>
</head>

<body id="membersWrap">
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- 상단 -->


<!-- CONTENTS -->
<div id="career_container" class="searchIdWrap">
	
    <div id="career_contents">
        <div class="layoutBox">
			<h3><img src="/images/signup/signup_tit.png" alt="개인회원"></h3>
			<div id="memberPer" class="memberInfo per">



				<form name="frm1" id="frm1" method="post">
					<input type="hidden" name="id_check" id="id_check" value="" /><!-- 아이디 검증 여부(0/1) -->
					<input type="hidden" name="chk_id" id="chk_id" value=""><!-- 사용(입력) 아이디 -->
					<input type="hidden" name="hd_idx" id="hd_idx" value="" /><!-- 번호인증 idx -->
					<input type="hidden" name="mobileAuthNumChk" id="mobileAuthNumChk" value="0" />
					<input type="hidden" name="hd_kind" id="hd_kind" value="2" />
					<input type="hidden" name="authproc" id="authproc" value="" />
					<input type="hidden" name="site_short_name" id="site_short_name" value="<%=site_short_name%>">

					<!--회원정보 입력-->
					<!--#include file="./inc_member_info.asp"-->

				</form>



			</div><!-- .memberInfo -->
		</div><!-- .layoutBox -->
    </div><!-- #career_contents -->

</div><!-- #career_container -->
<!--// CONTENTS -->


<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

</body>
</html>