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
	Response.End 
End If

' 내부 인원 외 기업회원 가입 불가 처리 [2020-11-11 edit by star]
'If Left(Request.ServerVariables("REMOTE_ADDR"),11)<>"210.121.194" Then
'	Response.Write "<script language=javascript>"&_
'		"alert('해당 페이지에 대한 접근 권한이 없습니다.');"&_
'		"location.href='/';"&_
'		"</script>"
'	Response.End 
'End If
%>

<!--#include virtual = "/include/header/header.asp"-->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
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
				parm.memkind	= "기업";	
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

		parms.authCode	= $("#hd_kind").val(); // sms: 1 | email: 2

		parms.authvalue = strAuthKey;	// 발송된 인증 KEY Value

		parms.idx = $("#hd_idx").val();	// 발송된 인증 번호
		parms.callback = "jsonp_result_callback";
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
			//strAuthKey = $("#mobileAuthNumber").val();
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

	// 입력 값 체크
	function fn_sumbit(){
		var compno_check		= $("#compno_check").val();			// 사업자번호 인증 여부(0/1/2)
		var txtCompName			= $("#txtCompName").val();			// 기업명
		var txtBossName			= $("#txtBossName").val();			// 대표자명
		var txtCompAddr			= $("#txtCompAddr").val();			// 회사주소
		var txtCompAddrDetail	= $("#txtCompAddrDetail").val();	// 회사주소상세
		
		var txtEmpCnt			= $("#txtEmpCnt").val();	// 사원수	
		var selCompType			= $("#selCompType").val();	// 기업형태

		var txtId				= $("#txtId").val();					// 아이디
		var txtPass				= $("#txtPass").val();					// 비번
		var txtPassChk			= $("#txtPassChk").val();				// 비번확인
		var	txtName				= $("#txtName").val();					// 이름
		var txtEmail			= $("#txtEmail").val();					// 이메일
		var txtPhone			= $("#txtPhone").val();					// 휴대폰
		var chkAgrPrv			= $("#agreeallComp").is(":checked");	// 이용약관 및 개인정보 수집 동의


		if($("#txtCompNum").val()=="사업자등록번호 ( - 없이 입력)"){
			compno_check="";
		}

		if(compno_check==""){
			alert("사업자등록번호를 인증해 주세요.");
			$("#txtCompNum").focus();
			return;
		}

		if($("#chk_compno").val()!=$("#txtCompNum").val()){
			alert("사업자등록번호를 인증해 주세요.");
			$("#compno_check").val("");
			$("#txtCompNum").focus();
			return;		
		}

		if(compno_check=="2"){
			alert("입력하신 사업자번호로 기업회원에 가입된 내역이 존재합니다.\n아이디 찾기를 이용하여 기존 가입하신 계정을 확인해 주세요.\n(우측 최상단 기업 로그인 클릭> ID/PW찾기 이동)");
			$("#txtCompNum").focus();
			return;
		}

		if(compno_check=="0"){
			if(txtCompName==""){
				alert("기업명을 입력해 주세요.");
				$("#txtCompName").focus();
				return;
			}

			if(txtBossName==""){
				alert("대표자명을 입력해 주세요.");
				$("#txtBossName").focus();
				return;
			}

			if(txtCompAddr==""){
				alert("회사주소를 입력해 주세요.");
				$("#txtCompAddr").focus();
				return;
			}

			if(txtCompAddrDetail==""){
				alert("회사 상세주소를 입력해 주세요.");
				$("#txtCompAddrDetail").focus();
				return;
			}

			if(txtEmpCnt==""){
				alert("사원수를 입력해 주세요.");
				$("#txtEmpCnt").focus();
				return;
			}

			if(selCompType==""){
				alert("기업형태를 선택해 주세요.");
				$("#selCompType").focus();
				return;
			}
		}

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
			alert("채용 담당자명을 입력해 주세요.");
			$("#txtName").focus();
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

		if(chkAgrPrv){		
			var obj=document.frm1;
			if(confirm('입력하신 정보로 기업회원 가입을 하시겠습니까?')) {
				obj.method = "post";
				obj.action = "join_enterprise_proc.asp";
				obj.submit();
			}
		}else{
			alert("이용약관 및 개인정보 수집에 동의해 주세요.");
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

	/*기업회원 사업자번호 유효성 체크 시작*/
	function fn_checkCompNum() {
		if($("#txtCompNum").val()=="사업자등록번호 ( - 없이 입력)"){
			$("#txtCompNum").val()="";
		}

		$("#compno_box").text("");
		$("#compno_check").val("");
		$("#chk_compno").val($("#txtCompNum").val());

		if($("#txtCompNum").val() == ""){
			$("#compno_check").val("");
			alert("사업자번호를 입력해 주세요.");
			$("#txtCompNum").focus();
			return;
		}else if($("#txtCompNum").val().length < 10){
			$("#compno_check").val("");
			alert("정확한 사업자번호를 입력해 주세요.");
			$('#rsltCompArea').html("");
			return;
		}else{
			$.ajax({
				type: "POST"
				, url: "get_Company_Info.asp"
				, data: { comp_num: $("#txtCompNum").val() }
				, dataType: "text"					
				, async: true
				, success: function (data) {
					var rsltval = data.trim(); // 회사정보 조회 결과코드(X,O,I,N)+'§'+회사정보(신용평가기관 조회 성공 시 화면 노출용)
					var strSp	= rsltval.split('§');

					// 기업회원 가입 차단기업으로 분류: X, 신용평가기관 관리 테이블에 회사 정보 존재: O, 신용평가기관 관리 테이블에 회사 정보 비존재(수기 입력 대상): I, 기존 기업회원 가입 정보 존재: N   
					if (strSp[0] == "X") {
						$("#compno_check").val("");
						$("#compno_box").addClass('bad').removeClass('good');
						$("#compno_box").text("가입이 제한된 사업자번호입니다. 관리자에게 문의 바랍니다.");
						$('#rsltCompArea').html("");// 신용평가기관 회사정보 조회 결과 영역 미노출
						
						$("#instCompArea").hide();	// 회사정보 수기 등록 영역 숨김 처리 및 입력 값 초기화
						$("#txtCompName").val("");
						$("#txtBossName").val("");
						$("#txtCompAddr").val("");
						$("#txtCompAddrDetail").val("");
						$("#txtEmpCnt").val("");
						$("#selCompType").val("");

						$(".notiArea").hide();
						return;
					} else if (strSp[0] == "N") {	
						$("#compno_check").val("2");
						$("#compno_box").addClass('bad').removeClass('good');
						$("#compno_box").text("해당 사업자번호로 기업회원 가입된 내역이 존재합니다.");
						$('#rsltCompArea').html("");

						$("#instCompArea").hide();	// 회사정보 수기 등록 영역 숨김 처리 및 입력 값 초기화
						$("#txtCompName").val("");
						$("#txtBossName").val("");
						$("#txtCompAddr").val("");
						$("#txtCompAddrDetail").val("");
						$("#txtEmpCnt").val("");
						$("#selCompType").val("");

						$(".notiArea").hide();
						return;						
					} else if (strSp[0] == "I") {	
						$("#compno_check").val("0");
						$("#compno_box").addClass('bad').removeClass('good');
						$("#compno_box").text("신용평가기관에 해당 사업자번호가 등록되어 있지 않습니다.");
						$('#rsltCompArea').html("");
						
						$("#instCompArea").show();	// 회사정보 수기 등록 영역 보임 처리
						$("#txtCompName").val("");
						$("#txtBossName").val("");
						$("#txtCompAddr").val("");
						$("#txtCompAddrDetail").val("");
						$("#txtEmpCnt").val("");
						$("#selCompType").val("");

						var txtNotice = "NICE신용평가정보에 해당 사업자번호가 등록되어 있지 않습니다.\n기업정보를 직접 입력해 주시면 확인 후 반영 처리하겠습니다.";
						txtNotice = txtNotice.replace(/(?:\r\n|\r|\n)/g, '<br />');
						$(".notiArea").html(txtNotice);
						$(".notiArea").show();


						return;						
					} else {
						$("#compno_check").val("1");
						$("#compno_box").addClass('good').removeClass('bad');
						$("#compno_box").text("사업자등록번호 인증이 완료되었습니다.");
						$('#rsltCompArea').html(strSp[1]);

						$("#instCompArea").hide();	// 회사정보 수기 등록 영역 숨김 처리 및 입력 값 초기화
						$("#txtCompName").val("");
						$("#txtBossName").val("");
						$("#txtCompAddr").val("");
						$("#txtCompAddrDetail").val("");
						$("#txtEmpCnt").val("");
						$("#selCompType").val("");

						$(".notiArea").hide();
						return;
					}

				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
					alert(XMLHttpRequest.responseText);
				}

			});
		}
	}
	/*기업회원 사업자번호 유효성 체크 끝*/

	/*주소검색 시작*/
	function openPostCode() {
		new daum.Postcode({		
			oncomplete: function (data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
				var extraRoadAddr = ''; // 도로명 조합형 주소 변수

				// 법정동명이 있을 경우 추가한다. (법정리는 제외)
				// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
				if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
					extraRoadAddr += data.bname;
				}
				// 건물명이 있고, 공동주택일 경우 추가한다.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
				if (extraRoadAddr !== '') {
					extraRoadAddr = ' (' + extraRoadAddr + ')';
				}
				// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
				if (fullRoadAddr !== '') {
					fullRoadAddr += extraRoadAddr;
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.				
				document.getElementById('hidZipCode').value = data.zonecode; //5자리 신주소 우편번호
				document.getElementById('txtCompAddr').value = fullRoadAddr;
			}
		}).open({popupName: 'postcodePopup'});
	}
	/*주소검색 끝*/

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
					, url: "/my/signup/Id_CheckAll.asp"
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
		if ($('#txtPass').val().length == 0) {
			return;
		}else {
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
		//아이디 중복 체크
		$("#txtId").bind("keyup keydown", function () {
			fn_checkID();
		});

		// 비번 유효성 체크
		$("#txtPass").bind("keyup keydown", function () {
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
                <li class="on"><a><span>기업회원</span></a></li>
            </ul>
        </div><!-- .memberTab -->

        <div class="layoutBox">
			<div id="memberComp" class="memberInfo comp" style="display: block;">
<form method="post" name="frm1">
<input type="hidden" name="compno_check" id="compno_check" value="" /><!-- 사업자번호 검증 여부(0/1/2) -->
<input type="hidden" name="chk_compno" id="chk_compno" value="" /><!-- 사업자번호(최종 입력) -->
<input type="hidden" name="id_check" id="id_check" value="" /><!-- 아이디 검증 여부(0/1) -->
<input type="hidden" name="chk_id" id="chk_id" value="" /><!-- 사용(최종 입력) 아이디 -->
<input type="hidden" name="hd_idx" id="hd_idx" value="" /><!-- 번호인증 idx -->
<!-- 커리어 내부 아이피에 한하여 휴대폰 인증 절차없이 성공 결과 값 강제 설정 [2020-11-11] -->
<input type="hidden" name="mobileAuthNumChk" id="mobileAuthNumChk" value="<%If Left(Request.ServerVariables("REMOTE_ADDR"),11)="210.121.194" Then%>4<%Else%>4<%End If%>" />
<input type="hidden" name="hd_kind" id="hd_kind" value="2" />
<input type="hidden" name="authproc" id="authproc" value="" />
<input type="hidden" name="hidZipCode" id="hidZipCode" value="" />	
					<div class="titArea">
						<h3>사업자등록번호 입력</h3>
						<span class="txt">사업자등록번호 입력 후 인증확인을 클릭해 주세요.</span>
					</div><!-- .titArea -->

					<div class="inputArea">
						<div class="inp">
							<label for="comp_num">사업자등록번호</label>
							<input type="text" id="txtCompNum" name="txtCompNum" maxlength="12" class="txt placehd" placeholder="사업자등록번호 ( - 없이 입력)" onkeyup="removeChar(event)" onkeydown="<%If 1=2 then%>return onlyNumber(event)<%End if%>">
							<div class="rt">
								<div class="alertBox">
									<span class="good" id="compno_box"></span>
								</div><!-- .alertBox -->
								<button type="button" class="btn" onclick="fn_checkCompNum(); return false;" style="cursor:pointer">인증확인</button>
							</div><!-- .rt -->
						</div><!-- .inp -->

						<p class="notiArea">
							기업회원은 사업자등록번호 인증 후 가입 가능합니다.<br>
							사업자등록번호 입력 후 인증 버튼을 클릭하세요.
						</p><!-- .notiArea -->
						
						<div class="inputArea mt10" id="rsltCompArea"></div><!-- 신용평가기관X현대협력사 조회 결과가 있을 경우 회사정보 노출 영역 -->

						<div class="inputArea mt10" id="instCompArea" style="display:none;"><!-- 신용평가기관X현대협력사 조회 결과가 없을 경우 회사정보 수기 입력 영역 -->
							<div class="inp">
								<label for="company_name">기업명</label>
								<input type="text" id="txtCompName" name="txtCompName" maxlength="50" style="ime-mode:active;" class="txt placehd" placeholder="기업명">
							</div><!-- .inp -->
							<div class="inp">
								<label for="company_owner">대표자명</label>
								<input type="text" id="txtBossName" name="txtBossName" maxlength="30" style="ime-mode:active;" class="txt placehd" placeholder="대표자명">
							</div><!-- .inp -->
							<div class="inp">
								<label for="company_address">회사 주소</label>
								<input type="text" id="txtCompAddr" name="txtCompAddr" onclick="openPostCode();" class="txt placehd pr140" placeholder="회사주소" readOnly>
								<div class="rt">
									<button type="button" class="btn" onclick="openPostCode(); return false;" style="cursor:pointer">회사주소</button>
								</div>
							</div><!-- .inp -->
							<div class="inp">
								<label for="company_name">회사 상세주소</label>
								<input type="text" id="txtCompAddrDetail" name="txtCompAddrDetail" maxlength="100" style="ime-mode:active;" class="txt placehd" placeholder="회사 상세주소">
							</div><!-- .inp -->						
							<div class="inp">
								<label for="company_people">사원수</label>
								<input type="text" id="txtEmpCnt" name="txtEmpCnt" maxlength="8" class="txt placehd" placeholder="사원수" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)">
							</div><!-- .inp -->

							<div class="inp sel">
								<span class="selectbox">
									<span class="">기업형태</span>
									<select id="selCompType" name="selCompType" title="기업형태 선택">
										<option value="" selected="">기업형태 선택</option>
										<!-- <option value="0">공공기관</option> -->
										<option value="1">대기업</option>
										<option value="3">중견기업</option>
										<option value="5">강소기업</option>
										<option value="4">중소기업</option>
										<option value="6">일반기업</option>									
										<option value="2">기타</option>
									</select>
								</span>
							</div><!-- .inp -->
						</div><!-- .inputArea -->

						<div class="titArea">
							<h3>채용담당자 정보 입력</h3>
							<span class="txt">실제 채용관련 담당자 정보를 입력하세요.</span>
						</div><!-- .titArea -->

						<div class="inputArea">
							<div class="inp">
								<label for="mnger_Id">아이디</label>
								<input type="text" id="txtId" name="txtId" maxlength="12" style="ime-mode:disabled;" class="txt placehd" placeholder="아이디 (5~12자 영문, 숫자 입력)" autocomplete="off">
								<div class="rt">
									<div class="alertBox">
										<span class="good" id="id_box"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp">
								<label for="mnger_pw1">비밀번호</label>
								<input type="password" id="tempPwd" name="tempPwd" style="display:none;"/>
								<input type="password" id="txtPass" name="txtPass" maxlength="32" class="txt placehd" placeholder="비밀번호 (8~32자 영문, 숫자, 특수문자 입력)">
								<div class="rt">
									<div class="alertBox">
										<span class="bad" id="pw_box"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp">
								<label for="mnger_pw2">비밀번호 확인</label>
								<input type="password" id="txtPassChk" name="txtPassChk" maxlength="32" class="txt placehd" placeholder="비밀번호 확인">
								<div class="rt">
									<div class="alertBox">
										<span class="bad" id="pw_box2"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp">
								<label for="mnger_nm">채용담당자 이름</label>
								<input type="text" id="txtName" name="txtName" maxlength="10" style="ime-mode:active;" class="txt placehd" placeholder="채용담당자 이름 (실명입력)">
								<div class="rt">
									<div class="alertBox">
										<span class="bad"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp">
								<label for="mnger_mail">이메일</label>
								<input type="text" id="txtEmail" name="txtEmail" maxlength="100" style="ime-mode:disabled;" class="txt placehd" placeholder="이메일" autocomplete="off">
								<div class="rt">
									<div class="alertBox">
										<span class="bad" id="mail_box"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<!-- 2020.06.11
							<div class="receiveArea">
								<label class="checkbox off" for="compReceive"><input type="checkbox" id="chkAgrMail" name="chkAgrMail" class="chk" value="1"><span>맞춤 채용정보 / 정기 뉴스레터 / 이벤트 메일 수신에 동의합니다.</span></label>
							</div><!-- .receiveArea 
							-->
							<div class="inp">
								<label for="mnger_hp">휴대폰 번호</label>
								<input type="text" id="txtPhone" name="txtPhone" maxlength="13" class="txt placehd" placeholder="휴대폰 번호" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="<%If 1=2 then%>return onlyNumber(event)<%End if%>">
								<div class="rt">
									<div class="alertBox">
									<span class="num" id="timeCntdown" style="display:none;"><em>(2:59)</em></span>
								</div><!-- .alertBox -->
									<button type="button" class="btn" id="aMobile" onclick="fnAuthSms(); return false;" style="cursor:pointer">인증번호 전송</button>
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp" id="rsltAuthArea" style="display:none;">
								<label for="mnger_mobileAuthNumber">인증번호</label>
								<input type="text" id="mobileAuthNumber" name="mobileAuthNumber" maxlength="6" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" class="txt placehd" placeholder="인증번호">
								<div class="rt">
									<div class="alertBox">
										<p class="good" id="rsltMsg1" style="display:none;">인증번호가 정상 입력 됐습니다.</p>
										<p class="bad" id="rsltMsg2" style="display:none;">인증번호가 틀립니다.</p>
									</div><!-- .alertBox -->
									<button type="button" class="btn" onclick="fnAuthNoChk(); return false;">인증확인</button>
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="receiveArea">
								<label class="checkbox off" for="compReceive2"><input type="checkbox" id="chkAgrPrv" name="chkAgrPrv" class="chk" value="1"><span>채용관련 SMS 수신에 동의합니다.</span></label>
							</div><!-- .receiveArea -->
						</div><!-- .inputArea -->

					</div><!-- .inputArea -->
					<!-- 기업회원 이용약관 -->
					<div class="titArea">
						<h3>이용약관 및 개인정보 수집 동의</h3>
					</div><!-- .titArea -->
					<div class="agreeArea">
						<div class="rt">
							<label for="agreeallComp" class="off"><span>전체 동의 합니다.</span><input type="checkbox" id="agreeallComp" class="chk" onclick="agreeAllCompFnc(this,'agreechkComp')"></label>
						</div><!-- .rt -->
						<script type="text/javascript">
							$(document).ready(function () {
								$('input[name="agreechkComp"]').click(function () {	// 전체 선택
									if ($('#agreechkComp1').is(':checked') && $('#agreechkComp2').is(':checked')) {
										$('#agreeallComp').prop('checked', true).parent().removeClass('off').addClass('on');
									} else {
										$('#agreeallComp').prop('checked', false).parent().removeClass('on').addClass('off');
									};
								});
							});
							agreeAllCompFnc = function (obj, name) {	//	전체 선택
								var _this = $(obj);
								var _chk = $('input[name=' + name + ']');
								if (_this.is(':checked')) {
									_chk.each(function (index, value) {
										$(this).prop('checked', true).parent().removeClass('off').addClass('on');
									});
								} else {
									_chk.each(function (index, value) {
										$(this).prop('checked', false).parent().removeClass('on').addClass('off');
									});
								}
							}
						</script>
						<dl>
							<dt>
								<label for="agreechkComp1">이용약관 동의 <em>(필수)</em></label>
								<div class="rt">
									<label class="checkbox off"><input type="checkbox" id="agreechkComp1" class="chk" name="agreechkComp"></label>
									<button type="button" class="btn termsView" style="cursor:pointer"><span>약관보기</span></button>
								</div><!-- .rt -->
							</dt>
							<dd class="termsList">
								<div class="terms">
									<div class="termsInner" id="pri3">
										<!--#include virtual = "/include/join/terms_agree.asp"-->
									</div><!-- .termsInner -->
								</div><!-- .terms -->
							</dd>
							</dl><!-- .inp -->
							<dl>
								<dt>
									<label for="agreechkComp2">개인정보 수집 및 이용 동의 <em>(필수)</em></label>
									<div class="rt">
										<label class="checkbox off"><input type="checkbox" id="agreechkComp2" class="chk" name="agreechkComp"></label>
										<button type="button" class="btn termsView" style="cursor:pointer"><span>약관보기</span></button>
									</div><!-- .rt -->
								</dt>
								<dd class="termsList">
									<div class="terms">
										<div class="termsInner" id="pri4">
											<!--#include virtual = "/include/join/privacy_agree.asp"-->
										</div><!-- .termsInner -->
									</div><!-- .terms -->
								</dd>
							</dl><!-- .inp -->
						</div><!-- .agreeArea -->
						<!--// 기업회원 이용약관 -->


						<div class="btnWrap">
							<button type="button" class="btn typeSky" onclick="javascript:fn_sumbit();" style="cursor:pointer">박람회 기업 회원가입 하기</button>
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