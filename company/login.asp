<%
	Option Explicit

	'------ 페이지 기본정보 셋팅.
	g_MenuID = "10000"
	g_MenuID_Navi = "100"
%>

<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/inc/function/auth/clearCookie.asp"-->

<%
	If Request.ServerVariables("SERVER_PORT") = 80 Then
		Dim strSecureURL
		strSecureURL = "https://"
		strSecureURL = strSecureURL & Request.ServerVariables("SERVER_NAME")
		strSecureURL = strSecureURL & Request.ServerVariables("URL")
		strSecureURL = strSecureURL &"?"&Request.ServerVariables("QUERY_STRING")
		Response.Redirect strSecureURL
   End If

	redir = Request.QueryString("redir")

	'로그인 된 경우 페이지 분기.
	'Select Case g_LoginChk
	'	Case 1 : redir = "http://hkpartner.career.co.kr/default.asp"
	'	Case Else : redir = redir
	'End Select
	
	g_LoginChk = 0
	Call ClearCookieWK
%>

<!--#include virtual = "/include/header/header.asp"-->

<script type="text/javascript">
	function fn_submit(e) {
		if (event.keyCode == 13) {
			validate(document.lform);
		}
	}

	function validate(frm1){
		var objF = frm1;

		if (objF.id.value.length == 0) {
			fieldChk("아이디를 입력해 주세요. ", objF.id);
			return false;
		}

		if (objF.pw.value.length == 0) {
			fieldChk("비밀번호를 입력해 주세요. ", objF.pw);
			return false;
		}

		if (objF.pw.value.length > 25) {
			fieldChk("비밀번호를 올바르게 입력해 주세요. ", objF.pw);
			return false;
		}

		objF.action ="/company/login_check.asp";
		objF.submit();
	}

	function setCookie(cookieName, value, exdays){
		var exdate = new Date();
		exdate.setDate(exdate.getDate() + exdays);
		var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
		document.cookie = cookieName + "=" + cookieValue;
	}
	 
	function deleteCookie(cookieName){
		var expireDate = new Date();
		expireDate.setDate(expireDate.getDate() - 1);
		document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
	}
	 
	function getCookie(cookieName) {
		cookieName = cookieName + '=';
		var cookieData = document.cookie;
		var start = cookieData.indexOf(cookieName);
		var cookieValue = '';
		if(start != -1){
			start += cookieName.length;
			var end = cookieData.indexOf(';', start);
			if(end == -1)end = cookieData.length;
			cookieValue = cookieData.substring(start, end);
		}
		return unescape(cookieValue);
	}
	
	$(document).ready(function(){	
		var key = getCookie("key");

		if(key != ""){ 
			$("#id").val(key); 
			$("#save_id").attr("checked", true);
		}
		 
		$("#save_id").change(function(){
			if($("#save_id").is(":checked")){
				setCookie("key", $("#id").val(), 30);
			}else{
				deleteCookie("key");
			}
		});
		 
		$("#id").keyup(function(){
			if($("#save_id").is(":checked")){
				setCookie("key", $("#id").val(), 30);
			}
		});
	});
</script>
</head>

<body id="loginWrap">
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- 상단 -->

<!-- 본문 -->
<div id="contents" class="content">	
		<div class="layoutBox">
			<div class="titArea">
				<h2>
					<img src="../images/signup/login_tit.jpg" alt="로그인 후 서비스를 이용해 주세요.">
					<span>통합 로그인 시스템</span>
				</h2>
			</div><!-- .titArea -->

			<form name="lform" id="lform" method="post" autocomplete="off" onsubmit="return validate(this);">
				<input type="hidden" value="W" name="from">
				<input type="hidden" value="2" name="logtype" class="1">
				<input type="hidden" name="redir" value="<%=redir%>" id="Hidden1">
				<input type="hidden" name="cp" value="" id="Hidden2">
				<input type="hidden" name="ReturnUrl" value="" id="Hidden3">
				<input type="hidden" name="com_id" value="" id="com_id">
				<input type="hidden" name="passwd" value="" id="passwd">
				<input type="hidden" name="UserIPAddress" value="<%=Request.ServerVariables("LOCAL_ADDR")%>" id="UserIPAddress">


				<div id="loginbox">
					<div class="fl">
						<div class="logInput">
							<p><%=site_name%>에 오신 것을 환영합니다.</p>
							<div>
								<label for="id">아이디</label>
								<input type="text" class="txt placehd" id="id" name="id" placeholder="아이디">
							</div>
							<div>
								<label for="pw">비밀번호</label>
								<input type="password" class="txt placehd" id="pw" name="pw" placeholder="비밀번호" onkeyup="FC_ChkTextLen(this,32); fn_submit(this);">
							</div>
							<button type="button" class="btn" title="" onclick="return validate(document.lform);">
								<strong>로그인</strong>
							</button>
						</div><!-- .logInput -->
		
						<div class="logCheck">
							<label class="checkbox" for="save_id">
								<input class="chk" id="save_id" name="save_id" type="checkbox"><span>ID저장</span>
							</label>
							<div class="link">
								<a href="/company/search/searchID.asp"><span>ID/PW</span>찾기</a>
								<!--<a href="/company/signup/join.asp"><strong>회원가입</strong></a>-->
							</div>
						</div><!-- .logCheck -->
					</div><!--.fl -->
				</div><!--#loginbox-->
			</form>	

			<div class="customCenter">
					<dl>
						<dt><%=site_name%> 운영사무국</dt>
						<dd><%=site_name%> 운영사무국</dd>
						<dd class="tel">
							<span>TEL) <strong class="num"><%=site_callback_phone%></strong></span>
							<span>FAX) 02-2006-9594</span>
						</dd><!-- .tel -->
						<dd class="time">
							<em>상담운영시간 :</em> 평일 10시~18시 까지 (주말, 공휴일 휴무)
						</dd><!-- .time -->
						<dd class="email">
							<span>e-mail)</span> <a href="mailto:<%=site_helpdesk_mail%>"><%=site_helpdesk_mail%></a>
						</dd><!-- .email -->
					</dl>
				</div>
			</div><!--#loginbox-->
	</div><!-- .content -->
</div>
<!-- //본문 -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->
</body>	
</html>