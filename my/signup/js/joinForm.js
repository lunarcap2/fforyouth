/**********************************************************************************
Setp1. 개인회원 정보 입력  작성관련 함수
**********************************************************************************/

// 인증번호 검증 함수 호출
function fnAuthNoChk(){
	fnAuth();
}

// 숫자만 입력
function onlyNumber(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		return false;
}

// 문자입력 못하게
function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}

/* 인증번호 타이머 셋팅 - 3분 start */
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
	$("#timeCntdown").text('(' + cmi + ' : ' + csc + ")");
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
/* 인증번호 타이머 셋팅 - 3분 end */

/* SMS 인증 번호 전송 start */
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
			parm.sitename	= $.trim($("#site_short_name").val());	// sms 발송시 해당 내용으로 입력 됩니다.
			parm.sitecode	= "37";		// sitecode(꼭 해당 사이트 코드를 입력하세요) 발송 log 및 email 발송시 구분합니다. => 코드 정의(커리어 : 2, 박람회 : 37)
			parm.memkind	= "개인";
			parm.ip			= "";		// 개인 IP
			parm.callback	= "jsonp_sms_callback";

			$("#aMobile").html("인증번호<br>재전송");
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
/* SMS 인증 번호 전송 end */

/* 인증번호 확인 start */
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
/* 인증번호 확인 end */

/* 휴대폰번호 중복 가입 검증 start */
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
/* 휴대폰번호 중복 가입 검증 end */

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

/*입력 값 체크 start*/
function fn_step1(){
	var txtId			= $("#txtId").val();				// 아이디
	var txtPass			= $("#txtPass").val();				// 비번
	var txtPassChk		= $("#txtPassChk").val();			// 비번확인
	var txtEmail		= $("#txtEmail").val();				// 이메일
	var txtPhone		= $("#txtPhone").val();				// 휴대폰
	var chkAgrPrv		= $("input:checkbox[name='chkAgrPrv']:checked").val();	// SMS/E-mail 수신여부
	

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
	

	var obj=document.frm1;

	obj.method = "post";
	obj.action = "joinForm_jobs.asp";
	obj.submit();
}
/*입력 값 체크 end*/


/**********************************************************************************
Setp2. 구직신청서 작성관련 함수
**********************************************************************************/
/* 최종 학력사항 start */

//입학년월입력시
function fn_school_s_div(obj) {
	if (obj.value.length == 7) {
		$("#univ_syear").val(obj.value.substr(0, 4));
		$("#univ_smonth").val(obj.value.substr(5, 2));
	} else {
		$("#univ_syear").val("");
		$("#univ_smonth").val("");
	}
}

//졸업년월입력시
function fn_school_e_div(obj) {
	if (obj.value.length == 7) {
		$("#univ_eyear").val(obj.value.substr(0, 4));
		$("#univ_emonth").val(obj.value.substr(5, 2));
	} else {
		$("#univ_eyear").val("");
		$("#univ_emonth").val("");
	}
}

//학력구분선택시
function fn_school_univ_kind(obj, val) {
	//고등학교, 대학 검색자동완성 코드값 변경
	$("#univ_name").attr('onkeyup','fn_kwSearchItem(this, \'' + val + '\')');

	if (val == "high") {
		$("#univ_major").val("");
		$("#univ_major").hide();
	}
	else {
		$("#univ_major").show();
	}
}

//학교검색
function fn_kwSearchItem(obj, _gubun) {
	/*
	이전 형제 노드 찾기
	$("선택자").prev()
	$("선택자").prevAll("선택자");

	다음 형제 노드 찾기
	$("선택자").next()
	$("선택자").nextAll("선택자");
	*/

	var _kw = $(obj).val();
	var _result_obj = $(obj).attr("id");

	if (_kw == "") {
		return;
	}

	$.ajax({
		url: "/my/signup/ajax_sch_result_school.asp",
		type: "POST",
		dataType: "text",
//		contentType: 'application/x-www-form-urlencoded; charset=euc-kr',
		data: ({
			"kw": escape(_kw),
			"sGubun": _gubun,
			"idx": 0,
			"result_obj_id": _result_obj
		}),
		success: function (data) {
			$(obj).nextAll("#id_sch_box").html(data);
		},
		error: function (req, status, err) {
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
	
	document.charset = "euc-kr";
	/*
	$.get("/my/resume/comm/search_result_school.asp", { "kw": _kw, "sGubun": _gubun, "idx": 0, "result_obj_id": _result_obj }, function (data) {
		$(obj).nextAll("#id_result_box").html(data);
	});
	*/
}
/* 최종 학력사항 end */

/* 희망 취업조건 start */

//직무검색
function fn_kwSearchItem2(obj) {
	var _kw = $(obj).val();
	var _result_obj = $(obj).attr("id");

	if (_kw == "") {
		return;
	}

	$.ajax({
		url: "/my/signup/ajax_sch_result_jc.asp",
		type: "POST",
		dataType: "text",
//		contentType: 'application/x-www-form-urlencoded; charset=euc-kr',
		data: ({
			"kw": escape(_kw),
			"idx": 0,
			"result_obj_id": _result_obj
		}),
		success: function (data) {
			$(obj).nextAll("#id_sch_box2").html(data);
		},
		error: function (req, status, err) {
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
	
	document.charset = "euc-kr";
}

// 1차지역 선택
function fn_set_area_change(obj, _i) {
	$('[name="da"]').attr('class', 'radiobox off'); //1차지역 class off
	$(obj).attr('class', 'radiobox on'); //선택한 1차지역 class on

	$('[name="area_ul"]').hide(); //2차지역 전체숨김
	$("#area_ul_" + _i).show(); //선택한 1차지역의 2차지역 리스트 노출
	
	// 지역2차 체크박스(로드된 값 있을경우)
	if ($('[name="area1"]').length > 0) {
		var area2_val = "";
		$('[name="area2"]').each(function() {
			area2_val = this.value

			$('[name="chk_area"]').each(function() {
				if (this.value == area2_val) {
					this.checked = true;
				}
			});
			
		});

		checkboxFnc();//체크박스.
	}
	
}

// 2차지역 선택
function fn_set_area2(obj, _area1_cd, _area1_nm) {
	var area2_cd, area2_nm, area2_checked, area_check_cnt2, area_check_rank
	area2_cd = $(obj).val();
	area2_nm = $(obj).next().html();
	area2_checked = $(obj).is(":checked");
	area_check_cnt2 = $("#area_check_cnt2").val();
	area_check_rank = $("#area_check_rank").val();

	if (area2_checked) {
		var area_check_cnt = $('input:checkbox[name="chk_area"]:checked').length;

		if (area_check_cnt > 2) {
			alert("희망 근무지는 2개까지 등록이 가능합니다.");
			fn_set_area2_del(area2_cd);
			return;
		}
		else {
			var up_html = '';
			up_html += '<tr id="area_rank">';
			up_html += '	<input type="hidden" name="view_area" value="' + _area1_cd + '">';
			up_html += '	<input type="hidden" name="view_area_nm" value="' + _area1_nm + '">';
			up_html += '	<input type="hidden" name="view_area_sub" value="' + area2_cd + '">';
			up_html += '	<input type="hidden" name="view_area_sub_nm" value="' + area2_nm + '">';
			up_html += '	<th>' + (area_check_cnt2 == 0 ? area_check_cnt : area_check_rank) + '순위</th>';
			up_html += '	<td>' + _area1_nm + '<span>' + area2_nm + '</span></td>';
			up_html += '</tr>';

			$('#view_area_rank').append(up_html);
		}
	}
	else {
		fn_set_area2_del(area2_cd);
	}

}

// 선택한 지역삭제, 체크해제
function fn_set_area2_del(_val) {
	// 하단부 선택된 지역표기 삭제
	$('input[name="view_area_sub"]').each(function() {
		if (this.value == _val) {
			$(this).parents("#area_rank").remove();
			$("#area_check_rank").val($(this).nextAll("th").text().replace("순위", ""));
		}
	});
	// 지역2차 선택된 체크박스 해제
	$('input:checkbox[name="chk_area"]').each(function() {
		if (this.value == _val) {
			this.checked = false;
		}
	});

	$("#area_check_cnt2").val($('input:checkbox[name="chk_area"]:checked').length);

	checkboxFnc();//체크박스.
}

//지역값 초기화
function fn_reset() {
	// 하단부 지역표기 초기화
	$("#view_area_rank").html("");

	// 지역2차 체크박스 전체해제
	$('input:checkbox[name="chk_area"]').each(function() {
		this.checked = false;
	});
	
	$("#area_check_cnt2").val("0");
	$("#area_check_rank").val("0");

	checkboxFnc();//체크박스.
}

function fn_save() {
	var out_html = '';
	var set_area_cnt = $('[name="view_area"]').length;
	var hdn_area	= "";
	var hdn_area2	= "";
	
	if (set_area_cnt != 2) {
		alert("1순위, 2순위 희망근무지역을 모두 입력해 주세요.");
		return;
	}
	else {
		for (i=0; i<set_area_cnt; i++) {
			var set_num		= $('[name="view_area_sub"]').eq(i).nextAll("th").text().replace("순위", "");
			var area		= $('[name="view_area"]').eq(i).val();
			var area_nm		= $('[name="view_area_nm"]').eq(i).val();
			var area_sub	= $('[name="view_area_sub"]').eq(i).val();
			var area_sub_nm	= $('[name="view_area_sub_nm"]').eq(i).val();
			
			$('#area' + set_num).val(area_nm + ' > ' + area_sub_nm);

			if (set_num == 2) {
				hdn_area2 = area + "&" + area_sub;
			}
			else {
				hdn_area = area + "&" + area_sub;
			}

			if (i != 0) {
				hdn_area += "|";
			}

			hdn_area += hdn_area2;
		}
		
		$("#hdn_area").val(hdn_area);
		$('.popup, .pop_dim').hide();
	}
}
/* 희망 취업조건 end */

function textIn(obj, text, result_obj, val) {
	/*
	바로 위의 부모
	$("선택자").parent()

	모든 부모 찾기
	$("선택자").parents() 모든 부모

	모든 부모 중 선택자에 해당하는 부모 찾기
	$("선택자").parents("선택자")

	특정 자식노드 찾기
	$("선택자").children("선택자")
	*/

	if (result_obj == "jc_name")
	{
		$("#hdn_" + result_obj).val(val);
	}
	
	$("#" + result_obj).val(text);
	$(obj).parents('.sb_area').hide();
}

function fn_sel_val_set(obj, set_name, get_value) {
	$("#" + set_name).val(get_value);
}

function numbeComma(number) {
    return number.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

/*입력 값 체크 start*/
function fn_step2() {
	//------------------------------------------------------------------------------------------------------------------------ 회원정보입력
	var txtName			= $("#txtName").val();									// 이름
	var zipcode			= $("#zipcode").val();									// 우편번호
	var addr			= $("#addr").val();										// 주소
	var detailAddr		= $("#detailAddr").val();								// 상세주소
	var jumin1			= $("#jumin1").val();									// 주민앞자리
	var juminH			= $("#juminH").val();									// 주민뒷자리(마스킹전)
	var chk_num			= $("input:checkbox[name='chk_num']:checked").val();	// 주민등록번호수집동의
	
	//------------------------------------------------------------------------------------------------------------------------ 최종 학력사항
	var univ_etype		= $("input:radio[name='graduated']:checked").val();		// 졸업구분
	
	//------------------------------------------------------------------------------------------------------------------------ 희망취업조건
	var area			= $("#hdn_area").val();															// 희망근무지역	
	var home			= $("input:checkbox[name='home']:checked").val();								// 재택근무여부
	if (home) {
		$("#hdn_area").val("");
	}
	
	var employ			= "";																			// 고용형태
	$("input:checkbox[name='chk_employ']:checked").each(function(index) {
		if (index != 0) {
			employ += "|";
		}

		employ += $(this).val();
	});
	$("#hdn_employ").val(employ);

	var salary			= $("#hdn_salary").val();														// 희망입금형태
	var salary_txt		= $("#salary_txt").val().replace("," , "");										// 희망입금금액
	var hire_h2			= $("input:radio[name='hire_h2']:checked").val();								// 구직알선희망정도

	var hire_info			= "";																		// 구직정보제공동의여부
	$("input:checkbox[name='hire_info']:checked").each(function(index) {
		if (index != 0) {
			hire_info += "|";
		}

		hire_info += $(this).val();
	});
	$("#hdn_hire_info").val(hire_info);

	var individual_info	= $("input:radio[name='individual_info']:checked").val();						// 개인정보조회동의여부


	if(txtName==""){
		alert("이름을 입력해 주세요.");
		$("#txtName").focus();
		return;
	}

	if(addr==""){
		alert("주소를 입력해 주세요.");
		$("#addr").focus();
		return;
	}
	
	if(detailAddr==""){
		alert("상세주소를 입력해 주세요.");
		$("#detailAddr").focus();
		return;
	}

/*
	if(jumin1==""){
		alert("생년월일을 입력해 주세요.");
		$("#jumin1").focus();
		return;
	}

	if (jumin1!="") {
		if (jumin1.length<6) {
			alert("주민등록번호를 다시 확인해 주세요.");
			$("#jumin1").focus();
			return;
		}
		else if ((parseInt(jumin1.charAt(2) + jumin1.charAt(3)) > 12) || (parseInt(jumin1.charAt(4) + jumin1.charAt(5)) > 31)) {
			alert("생년월일을 다시 확인해 주세요.");
			$("#jumin1").focus();
			return;
		}
	}


	if(juminH==""){
		alert("주민등록번호 뒷자리를 입력해 주세요.");
		$("#jumin2").focus();
		return;
	}

	//* 9,0 : 국내 1800년대생 남,녀   1,2 : 국내 1900년대생 남,녀   3,4 : 국내 2000년대생 남,녀   5,6 : 외국 1900년대생 남,녀   7,8 : 외국 2000년대생 남,녀
	if (juminH.length!=7 || (juminH.substr(0,1) == 9 || juminH.substr(0,1) == 0)) {
		alert("주민등록번호를 다시 확인해 주세요.");
		$("#jumin2").focus();
		return;
	}
	
	if (!chk_num) {
		alert("주민등록번호 수집동의를 체크해 주세요.");
		$("input:checkbox[name='chk_num']").focus();
		return;
	}
*/

	if($("#univ_kind").val()==0) {
		alert("학력구분을 선택해 주세요.");
		$("#univ_gubun").focus();
		return;
	}

	if($("#univ_name").val()=="") {
		alert("학교명을 입력해 주세요.");
		$("#univ_name").focus();
		return;
	}

	if($("#univ_kind").val()=="univ" && $("#univ_major").val()=="") {
		alert("전공을 입력해 주세요.");
		$("#univ_major").focus();
		return;
	}

	if($("#univ_syear").val()=="" && $("#univ_smonth").val()=="") {
		alert("입학년월을 입력해 주세요.");
		$("#univ_sdate").focus();
		return;
	}

	if($("#univ_eyear").val()=="" && $("#univ_emonth").val()=="") {
		alert("졸업년월을 입력해 주세요.");
		$("#univ_edate").focus();
		return;
	}

	if(!univ_etype) {
		alert("졸업구분을 선택해 주세요.");
		$("input:radio[name='graduated']").focus();
		return;
	}

	if($("#hdn_jc_name").val()=="") {
		alert("희망직종을 선택해 주세요.");
		$("#jc_name").focus();
		return;
	}	
	
	if ((area=="" || area.split("|").length < 2) && !home) {
		alert("1순위, 2순위 희망근무지역을 모두 입력해 주세요.");
		$("input:checkbox[name='home']").focus();
		return;
	}

	if (employ=="" || employ=="00") {
		if (employ=="00") {
			alert("시간제만 단독으로 선택할수 없습니다.");
			$("input:checkbox[name='chk_employ']").focus();
			return;
		}
		else {
			alert("고용형태를 선택해 주세요.");
			$("input:checkbox[name='chk_employ']").focus();
			return;
		}
	}
	
	if (salary=="" || (salary!="98" && salary_txt=="")) {
		alert("희망입금형태 및 금액을 입력해 주세요.");
		$("#salary_txt").focus();
		return;
	}
	
	if (salary!="" && salary_txt!="") {
		if (salary=="1" && parseInt(salary_txt) < 2154){
			alert("최저 연봉 2,154만원 보다 높게 입력해 주세요.");
			$("#salary_txt").focus();
			return;
		}
		else if (salary=="2" && parseInt(salary_txt) < 179){
			alert("최저 월급 179만원 보다 높게 입력해 주세요.");
			$("#salary_txt").focus();
			return;
		}
		else if (salary=="3" && parseInt(salary_txt) < 68720){
			alert("최저 일급 68,720원 보다 높게 입력해 주세요.");
			$("#salary_txt").focus();
			return;
		}
		else if (salary=="4" && parseInt(salary_txt) < 8590) {
			alert("최저 시급 8,590원 보다 높게 입력해 주세요.");
			$("#salary_txt").focus();
			return;
		}
	}

	if (!hire_h2) {
		alert("구직알선희망정도를 선택해 주세요.");
		$("input:radio[name='hire_h2']").focus();
		return;
	}

	if (hire_info=="") {
		alert("구직정보제공동의여부를 선택해 주세요.");
		$("input:checkbox[name='hire_info']").focus();
		return;
	}

	if (!individual_info) {
		alert("개인정보조회동의여부를 선택해 주세요.");
		$("input:checkbox[name='individual_info']").focus();
		return;
	}


	var obj=document.frm1;

	obj.method = "post";
	obj.action = "proc_joinForm.asp";
	obj.submit();
}
/*입력 값 체크 end*/