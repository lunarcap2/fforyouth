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
%>

<!--#include virtual = "/include/header/header.asp"-->
<script type="text/javascript">
	// SMS 인증 번호 전송
	/* start */
	function fnAuthSms() {
		if ($("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			return;
		}

		$("#hd_idx").val("");

		var strEmail;
		var contact = $("#txtPhone").val();

		if (Authchk_ing) {
			alert("처리중 입니다. 잠시만 기다려 주세요.");
		} else {
			if(contact=="“-” 생략하고 숫자만 입력해 주세요."){
				contact="";
			}

			if(contact==""){
				alert("연락처를 입력해 주세요.");
				$("#txtPhone").focus();
				return;
			}

			if(contact.length<10){
				alert("정확한 연락처를 입력해 주세요.");
				$("#txtPhone").focus();
				return;
			}
			else {
				Authchk_ing = true;

				var strUrl = "https://app.career.co.kr/sms/career/Authentication";

				var parm = {};

				parm.authCode	= "1";		// sms:1 | email:2
				parm.authvalue	= $("#txtPhone").val();		// 핸드폰 no( - 는 입력 해도 되고 안해도 됩니다.)
				parm.sitename	= "<%=site_short_name%>";	// sms 발송시 해당 내용으로 입력 됩니다.
				parm.sitecode	= "37";		// sitecode(꼭 해당 사이트 코드를 입력하세요) 발송 log 및 email 발송시 구분합니다. => 코드 정의(커리어 : 2, 박람회 : 37)
				parm.memkind	= "개인";
				parm.ip			= "";		// 개인 IP
				parm.callback	= "jsonp_sms_callback";

				$("#aMobile").text("인증번호 재전송");
				$.ajax({
					url: strUrl
					, dataType: "jsonp"
					, type: "post"
					, data: parm
					, success: function (data) {
						//alert("sccess : " + data.length);
					}
					, error: function (jqXHR, textStatus, errorThrown) {
						//alert(textStatus + ", " + errorThrown);
					}
				});
			}
		}
	}

	// Result 처리는 이곳에서 합니다.
	function jsonp_sms_callback(data) {
		Authchk_ing = false;
		if ($.trim(data.result) == "true") {
			$("#mobileAuthNumChk").val("1");

			$("#timeCntdown").show();
			fnDpFirst();
			fncDpTm(); //카운트

			$("#hd_idx").val(data.result_idx);
			alert("인증번호가 발송되었습니다.");
			$("#rsltAuthArea").show();
			$("#mobileAuthNumber").val("");
			$("#mobileAuthNumber").focus();
			$("#hd_kind").val("1");
		} else {
			$("#timeCntdown").hide();
			$("#rsltAuthArea").hide();
			$("#emailAuthNumChk").val("0");
			alert("인증번호 발송이 실패하였습니다.");
		}
	}
	/* end */

	// 인증번호 확인
	/* start */
	function fnAuth() {
		if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			alert("인증이 완료되었습니다.");
			return;

		} else if ($.trim($("#hd_idx").val()) == "") {
			alert("인증번호가 맞지 않습니다. 인증번호를 확인해 주세요.");
			return;
		}

		$("#mobileAuthNumber").val($.trim($("#mobileAuthNumber").val()));
		if  ($("#hd_kind").val() == "1") {
			if ($.trim($("#mobileAuthNumber").val()) == "") {
				alert("인증번호를 입력해 주세요.");
				$("#mobileAuthNumber").focus();
				return;
			}
		}

		var strUrl	= "https://app.career.co.kr/sms/career/AuthenticationResult";
		var parms	= {};

		var strAuthKey = "";
		if ($("#hd_kind").val() == "2") {
			strAuthKey = $("#emailAuthNumber").val();
		} else if ($("#hd_kind").val() == "1") {
			strAuthKey = $("#mobileAuthNumber").val();
		} else {
			return;
		}

		if ($.trim($("#hd_idx").val()) == "" || ($.trim($("#emailAuthNumber").val()) == "" && $.trim($("#mobileAuthNumber").val()) == "")) {
			return;
		}

		parms.authCode	= $("#hd_kind").val();	// sms:1 | email:2

		parms.authvalue	= strAuthKey;			// 발송된 인증 KEY Value

		parms.idx		= $("#hd_idx").val();	// 발송된 인증 번호
		parms.callback	= "jsonp_result_callback";
		$.ajax({
			url: strUrl
				, dataType: "jsonp"
				, type: "post"
				, data: parms
				, success: function (data) {
					//alert("sccess : " + data.length);
				}
				, error: function (jqXHR, textStatus, errorThrown) {
					//alert(textStatus + ", " + errorThrown);
				}
		});
	}

	//Result 처리는 이곳에서 합니다.
	function jsonp_result_callback(data) {
		if ($("#hd_kind").val() == "1") {
			if ($.trim(data.result_idx) == "Y") {
				$("#mobileAuthNumChk").val("4");
				$("#rsltMsg1").show();
				$("#authproc").val("1");
				$("#timeCntdown").hide();
				$("#rsltMsg2").hide();
			} else {
				$("#mobileAuthNumChk").val("3");
				$("#rsltMsg1").hide();
				$("#timeCntdown").show();
				$("#rsltMsg2").show();
			}
		}
	}
	/* end */

	var emailchk_ing	= false;
	var Authchk_ing		= false;

	var min = 60;
	var sec = 60;
	var ctm;			// 표시 시간
	var inputtime = 3;	// 입력분
	var tstop;			// 타이머 정지

	Number.prototype.dptm = function () { return this < 10 ? '0' + this : this; } //분에 "0" 넣기

	function fnDpFirst() {
		clearTimeout(tstop);
		ctm = sec * inputtime;
	}

	function fncDpTm() {
		var cmi = Math.floor((ctm % (min * sec)) / sec).dptm();
		var csc = Math.floor(ctm % sec).dptm();

		//document.getElementById("ctm1").innerText = cmi + ' : ' + csc; //값 보여줌
		//document.getElementById("").innerText = '남은시간 ' + cmi + ' : ' + csc; //값 보여줌
		$("#timeCntdown em:eq(0)").text('(' + cmi + ' : ' + csc + ")");
		if ((ctm--) <= 0) {
			ctm = sec * inputtime;
			clearTimeout(tstop);
			//재전송버튼
			//인증시간 초과 meassage
		}
		else {
			tstop = setTimeout("fncDpTm()", 1000);
		}
	}

	// 인증번호 검증 함수 호출
	function fnAuthNoChk(){
		fnAuth();
	}

	// 휴대폰번호 중복 가입 검증
	function fn_chkJoin(){
		if($("#txtPhone").val()=="“-” 생략하고 숫자만 입력해 주세요."){
			$("#txtPhone").val("");
		}

		if($("#txtPhone").val()==""){
			alert("연락처를 입력해 주세요.");
			$("#txtPhone").focus();
			return;
		}

		if($("#txtPhone").val().length<10){
			alert("정확한 연락처를 입력해 주세요.");
			$("#txtPhone").focus();
			return;
		} else {
			$.ajax({
				type: "POST"
				, url: "phone_CheckAll.asp"
				, data: { user_phone: $("#txtPhone").val() }
				, dataType: "text"
				, async: true
				, success: function (data) {
					// 기존 등록된 휴대폰번호가 존재하면 X, 없으면 O
					if (data.trim() == "X") {
						alert("입력하신 휴대폰번호로 회원 가입된 내역이 존재합니다.\n아이디 찾기를 이용하여 기존 가입하신 계정을 확인해 주세요.\n(우측 최상단 구직자 로그인 클릭> ID/PW찾기 이동)");
						return;
					} else {
						fnAuthSms();
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert(XMLHttpRequest.responseText);
				}

			});
		}
	}

	// 입력 값 체크
	function fn_sumbit(){
		var txtId		= $("#txtId").val();				// 아이디
		var txtPass		= $("#txtPass").val();				// 비번
		var txtPassChk	= $("#txtPassChk").val();			// 비번확인
		var	txtName		= $("#txtName").val();				// 이름

		var	sel_birthY	= $("#sel_birthY").val();			// 출생연도
		var	sel_birthM	= $("#sel_birthM").val();			// 출생월
		var	sel_birthD	= $("#sel_birthD").val();			// 출생일

		var txtEmail	= $("#txtEmail").val();				// 이메일
		var txtPhone	= $("#txtPhone").val();				// 휴대폰
//		var chkAgrPrv	= $("#agreeallPer").is(":checked");	// 이용약관 및 개인정보 수집 동의
		var agreeCheck	= $("input[name='agreeCheck']:checked").val();

		if(txtId==""){
			alert("아이디를 입력해 주세요.");
			$("#txtId").focus();
			return;
		}

		if($("#id_box").text()!="사용 가능한 아이디입니다."){
			alert("아이디를 다시 확인해 주세요.");
			$("#txtId").focus();
			return;
		}

		if(txtPass==""){
			alert("비밀번호를 입력해 주세요.");
			$("#txtPass").focus();
			return;
		}

		if($("#pw_box").text()!=""){
			alert("입력하신 비밀번호가 보안상 매우 취약합니다.\n8~32자까지 영문, 숫자, 특수문자 등의 조합으로\n아이디와 무관한 문자열을 입력해 주세요.");
			$("#txtPass").focus();
			return;
		}

		if(txtPassChk==""){
			alert("비밀번호 확인란을 입력해 주세요.");
			$("#txtPassChk").focus();
			return;
		}

		if(txtPassChk!=txtPass){
			alert("비밀번호와 비밀번호 확인란에 입력한 정보가\n일치하지 않습니다. 다시 확인해 주세요.");
			$("#txtPassChk").focus();
			return;
		}

		if(txtName==""){
			alert("이름을 입력해 주세요.");
			$("#txtName").focus();
			return;
		}

		if(sel_birthY==""){
			alert("출생연도를 선택해 주세요.");
			$("#sel_birthY").focus();
			return;
		}

		if(sel_birthM==""){
			alert("출생월을 선택해 주세요.");
			$("#sel_birthM").focus();
			return;
		}

		if(sel_birthD==""){
			alert("출생일자를 선택해 주세요.");
			$("#sel_birthD").focus();
			return;
		}

		if($("#txtEmail").val() == "") {
			alert("이메일을 입력해 주세요.");
			$("#txtEmail").focus();
			return;
		}

		if($("#mail_box").text()=="잘못된 이메일 형식입니다."){
			alert("이메일을 다시 확인해 주세요.");
			$("#mail_box").focus();
			return;
		}

		if(txtPhone==""){
			alert("휴대폰번호를 입력해 주세요.");
			$("#txtPhone").focus();
			return;
		}

		if ($("#mobileAuthNumChk").val() != "4") {
			alert("휴대폰번호를 인증하셔야 가입이 가능합니다.");
			$("#txtPhone").focus();
			return;
		}

		if (agreeCheck == "1"){
			var obj=document.frm1;
			if(confirm('입력하신 정보로 회원 가입 하시겠습니까?')) {
				obj.method = "post";
				obj.action = "join_individual_proc.asp";
				obj.submit();
			}
		}else{
			alert("개인정보 수집 및 이용에 동의해 주세요.");
			return;
		}
	}

	function onlyNumber(event){
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 )
			return;
		else
			return false;
	}

	function removeChar(event) {
		event = event || window.event;
		var keyID = (event.which) ? event.which : event.keyCode;
		if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 )
			return;
		else
			event.target.value = event.target.value.replace(/[^0-9]/g, "");
	}

	/*아이디 중복 체크 시작*/
	function fn_checkID() {
		$("#txtId").val($("#txtId").val().toLowerCase());

		$("#id_box").text("");
		$("#id_check").val("0");

		var checkNumber		= $("#txtId").val().search(/[0-9]/g);	// 숫자 입력 체크
		var checkEnglish	= $("#txtId").val().search(/[a-z]/ig);	// 영문 입력 체크

		if($("#txtId").val() == ""){
			$("#id_box").text("아이디를 입력해 주세요.");
			$("#txtId").focus();
			return;
		}else if(!Validchar($("#txtId").val(), num + alpha)){
			$("#id_box").text("아이디는 한글 및 특수문자를 지원하지 않습니다. 다시 입력해 주세요.");
			$("#txtId").focus();
			return;
		}else if($("#txtId").val().length < 5){
			$("#id_box").text("아이디는 최소 5자 이상이어야 합니다.");
			return;
		}else if(checkNumber <0 || checkEnglish <0){
			$("#id_box").text("영문과 숫자를 혼용하여 입력해 주세요.");
			return;
		}else{
			if (/(\w)\1\1\1/.test($("#txtId").val())){	// 같은형식 문자 4글자 이상 사용 금지
				$("#id_box").text("동일한 문자 연속 4글자 이상은 사용 금지합니다.");
				return;
			} else {
				$.ajax({
					type: "POST"
					, url: "Id_CheckAll.asp"
					, data: { user_id: $("#txtId").val() }
					, dataType: "text"
					, async: true
					, success: function (data) {
						// 기존 등록된 아이디가 존재하면 X, 없으면 O
						if (data.trim() == "X") {
							$("#id_box").addClass('bad').removeClass('good');
							$("#id_box").text("탈퇴한 아이디 또는 이미 사용중인 아이디로, 이용하실 수 없습니다.");
							return;
						} else {
							$("#id_check").val("1");
							$("#chk_id").val($("#txtId").val());
							$("#id_box").addClass('good').removeClass('bad');
							$("#id_box").text("사용 가능한 아이디입니다.");
							return;
						}
					}
					, error: function (XMLHttpRequest, textStatus, errorThrown) {
						alert(XMLHttpRequest.responseText);
					}

				});
			}
		}
	}
	/*아이디 중복 체크 끝*/

	/*비밀번호 체크 시작*/
	function fn_checkPW() {
		var chk = false;
		var id	= $("#txtId").val();
		if ($('#txtPass').val().length == 0 ) {
			return;
		} else {
			if ($('#txtPass').val().length < 8 || $('#txtPass').val().length > 32) {
				$("#pw_box").text("비밀번호는 8~32자 까지만 허용됩니다.");
				return false;
			}

			if (id != "" && $('#txtPass').val().search(id) > -1) {
				$("#pw_box").text("비밀번호에 아이디가 포함되어 있습니다.");
				return false;
			}

			var pattern1 = /[0-9]/;		// 숫자
			var pattern2 = /[a-zA-Z]/;	// 문자
			var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자

			//if (!$('#txtPass').val().match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/)) {
			//if (!$('#txtPass').val().match(/^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/)) {
			//if (!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/.test($('#txtPass').val())) {
			if(!pattern1.test($('#txtPass').val()) || !pattern2.test($('#txtPass').val()) || !pattern3.test($('#txtPass').val())) {
				$("#pw_box").text("비밀번호는 영문, 숫자 및 특수문자의 조합으로 생성해야 합니다");
				return;
			}else{
				if($('#txtPass').val().search(id) > -1) {
					$("#pw_box").text("비밀번호에 아이디가 포함되어 있습니다.");
					return false;
				}else{
					$("#pw_box").text("");
				}
			}
		}

		if ($('#txtPassChk').val().split(" ").join("") == "") {
			$("#pw_box2").text("비밀번호 확인을 입력해 주세요.");
			return;
		}

		if ($('#txtPass').val() != $('#txtPassChk').val()) {
			$("#pw_box2").text("비밀번호가 일치하지 않습니다.");
			return;
		} else {
			$("#pw_box").text("");
			$("#pw_box2").text("");
		}
		return chk;
	}
	/*비밀번호 체크 끝*/

	/*이메일 체크 시작*/
	function email_check( email ) {
		var regex=/([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
		return (email != '' && email != 'undefined' && regex.test(email));
	}

	// check when email input lost foucus
	function fn_checkMail() {
	  var email = $("#txtEmail").val();

	  // if value is empty then exit
	  if( email == '' || email == 'undefined') return;

	  // valid check
	  if(! email_check(email) ) {
		$("#mail_box").text("잘못된 이메일 형식입니다.");
		return false;
	  }
	  else {
		$("#mail_box").text("");
		return false;
	  }
	}
	/*이메일 체크 끝*/

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
        <div class="memberTab">
            <ul class="spl2">
                <li class="on"><a><span>개인회원</span></a></li>
            </ul>
        </div><!-- .memberTab -->

        <div class="layoutBox">
			<div id="memberPer" class="memberInfo per">

<form method="post" name="frm1" autocomplete="off">
<input type="hidden" name="id_check" id="id_check" value="" /><!-- 아이디 검증 여부(0/1) -->
<input type="hidden" name="chk_id" id="chk_id" value=""><!-- 사용(입력) 아이디 -->
<input type="hidden" name="hd_idx" id="hd_idx" value="" /><!-- 번호인증 idx -->
<input type="hidden" name="mobileAuthNumChk" id="mobileAuthNumChk" value="0" />
<input type="hidden" name="hd_kind" id="hd_kind" value="2" />
<input type="hidden" name="authproc" id="authproc" value="" />

				<div class="titArea">
					<h3>회원정보 입력</h3>
					<!-- <span class="txt">아래 회원정보를 입력하시면 커리어 회원으로 가입이 완료됩니다.</span> -->
				</div><!-- .titArea -->
				<div class="inputArea">
<input type="password" id="tempPwd" name="tempPwd" style="display:none;"/>
<input type="text" id="tempId" name="tempId" style="display:none;"/>

					<div class="inp">
						<label for="user_id">아이디</label>
						<input type="text" id="txtId" name="txtId" maxlength="12" style="ime-mode:disabled;" class="txt placehd" placeholder="아이디 (5~12자 영문, 숫자 입력)" autocomplete="off">
						<div class="rt">
							<div class="alertBox">
								<span class="good" id="id_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_pw1">비밀번호</label>
						<input type="password" id="txtPass" name="txtPass" maxlength="32" class="txt placehd" placeholder="비밀번호 (8~32자 영문, 숫자, 특수문자 입력)" autocomplete="new-password">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="pw_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_pw2">비밀번호 확인</label>
						<input type="password" id="txtPassChk" name="txtPassChk" maxlength="32" class="txt placehd" placeholder="비밀번호 확인" autocomplete="new-password">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="pw_box2"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_nm">이름</label>
						<input type="text" id="txtName" name="txtName" maxlength="10" style="ime-mode:active;" class="txt placehd" placeholder="이름 (실명입력)" autocomplete="off">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="nm_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->

					<div class="inp"><!-- 필수 입력 항목 생년월일 추가 [2020-11-30] -->
						<div class="birth" id="birth">
							<span class="selectbox" style="width:100px">
								<span>년도</span>
								<select id="sel_birthY" name="sel_birthY" title="년도 선택">
									<option value="">출생연도</option>
								<%
									Dim sYear
									For sYear=1950 To Year(Now())-14
								%>
								<option value="<%=sYear%>"><%=sYear%></option>
								<%
									Next
								%>
								</select>
							</span><!-- .selectbox -->
							<span class="selectbox" style="width:92px">
								<span>월</span>
								<select id="sel_birthM" name="sel_birthM" title="월 선택">
									<option value="">월</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
								</select>
							</span><!-- .selectbox -->
							<span class="selectbox" style="width:92px">
								<span>일</span>
								<select id="sel_birthD" name="sel_birthD" title="일 선택">
									<option value="">일</option>
									<option value="01">01</option>
									<option value="02">02</option>
									<option value="03">03</option>
									<option value="04">04</option>
									<option value="05">05</option>
									<option value="06">06</option>
									<option value="07">07</option>
									<option value="08">08</option>
									<option value="09">09</option>
									<option value="10">10</option>
									<option value="11">11</option>
									<option value="12">12</option>
									<option value="13">13</option>
									<option value="14">14</option>
									<option value="15">15</option>
									<option value="16">16</option>
									<option value="17">17</option>
									<option value="18">18</option>
									<option value="19">19</option>
									<option value="20">20</option>
									<option value="21">21</option>
									<option value="22">22</option>
									<option value="23">23</option>
									<option value="24">24</option>
									<option value="25">25</option>
									<option value="26">26</option>
									<option value="27">27</option>
									<option value="28">28</option>
									<option value="29">29</option>
									<option value="30">30</option>
									<option value="31">31</option>
								</select>
							</span><!-- .selectbox -->
							<br><br>
							<font color="red">
								회원 가입 시 만 15세 미만은 가입 불가합니다.
								<br>
								취직 최저 연령에 대한 제한(근로기준법 제 64조 1항)
							</font>
						</div><!-- .birth -->
					</div><!-- .inp -->

					<div class="inp">
						<label for="email_id">이메일</label>
						<input type="text" id="txtEmail" name="txtEmail" maxlength="100" style="ime-mode:disabled;" class="txt placehd" placeholder="이메일" autocomplete="off">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="mail_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<!-- 2020.06.11
					<div class="receiveArea">
						<label class="checkbox off" for="compReceive1"><input type="checkbox" id="chkAgrMail" name="chkAgrMail" class="chk" value="1"><span>맞춤 채용정보 / 정기 뉴스레터 / 이벤트 메일 수신에 동의합니다.</span></label>
					</div><!-- .receiveArea
					-->
					<div class="inp">
						<label for="hp_num">휴대폰 번호</label>
						<input type="text" id="txtPhone" name="txtPhone" maxlength="13" class="txt placehd" placeholder="휴대폰 번호" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="return onlyNumber(event)">
						<div class="rt">
							<div class="alertBox">
								<span class="num" id="timeCntdown" style="display:none;"><em>(2:59)</em></span>
							</div><!-- .alertBox -->
							<button type="button" class="btn" id="aMobile" onclick="fn_chkJoin(); return false;">인증번호 전송</button>
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp" id="rsltAuthArea" style="display:none;">
						<label for="mobileAuthNumber">인증번호</label>
						<input type="text" id="mobileAuthNumber" name="mobileAuthNumber" maxlength="6" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" class="txt placehd" placeholder="인증번호">
						<div class="rt">
							<div class="alertBox">
								<p class="good" id="rsltMsg1" style="display:none;">인증번호가 정상 입력 됐습니다.</p>
								<p class="bad" id="rsltMsg2" style="display:none;">인증번호가 틀립니다.</p>
							</div><!-- .alertBox -->
							<button type="button" class="btn" onclick="fnAuthNoChk(); return false;">인증확인</button>
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="receiveArea" style="display:none;">
						<label class="checkbox off" for="perReceive2"><input type="checkbox" id="chkAgrSms" name="chkAgrSms" class="chk" value="1"><span>채용관련 SMS 수신에 동의합니다.</span></label>
					</div><!-- .receiveArea -->
				</div><!-- .inputArea -->

				<div class="privacy">
					<dl>
						<dt>개인정보 수집 및 이용동의</dt>
						<dd>
							<strong>개인정보 수집목적</strong> : <%=site_name%> 채용설명회 로그인 및 지원자 개인 식별, 지원의사 확인, 입사전형의 진행,
        						  고지사항 전달, 입사 지원자와의 원활한 의사소통, 지원이력 확인, 이벤트 참여자당첨자 발표 및 고용노동부 마케팅 활용 목적<br>
							<strong>개인정보 수집항목</strong> : 아이디, 비밀번호, 이름, 생년월일, 이메일, 휴대폰번호 <br>
							<strong>개인정보 이용기간</strong> : 사이트 오픈 시작부터 행사 종료시까지.<br />(사이트 오픈 후부터 행사 종료시까지
							- 서비스 제공에 관한 고객사와의 계약 이행을 완료하기 위해 회원의 이용정보를 보관할 필요가 있음) <br>
							<strong>개인정보 파기</strong> : 행사 종료 및 행사 사업보고 종료 보고 후 파기 (고객사 협의 필)
							<p style="font-weight:500; margin:10px 0 10px 0;">* 개인정보 수집 및 이용에 대해서는 거부할 수 있으며, 거부 시에는 박람회 사이트 이용이<br />
								&nbsp;&nbsp;&nbsp;불가합니다.</p>
								<label class="radiobox" style="padding-right:10px;">
									<input class="rdi" name="agreeCheck" value="1" type="radio"><span style="font-size:1rem;">동의합니다.</span>
								</label>
								<label class="radiobox">
									<input class="rdi" name="agreeCheck" value="2" type="radio"><span style="font-size:1rem;">동의하지 않습니다.</span>
								</label>
						</dd>
					</dl>
					<!--<label class="checkbox off" for="agreeallPer">
						<input type="checkbox" id="agreeallPer" name="agreeallPer" class="chk" value="">
						<span>개인정보 수집 및 이용에 동의하십니까?</span>
					</label>-->
				</div><!-- .privacy -->

				<div class="btnWrap">
					<button type="button" class="btn typeSky pop" onclick="javascript:fn_sumbit();" style="cursor:pointer">회원 가입</button>
				</div><!-- .btnWrap -->

</form>
		</div>
		</div><!-- .layoutBox -->
    </div><!-- #career_contents -->
</div><!-- #career_container -->
<!--// CONTENTS -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

</body>
</html>
