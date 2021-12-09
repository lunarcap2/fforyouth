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
<script type="text/javascript">
	// SMS ���� ��ȣ ����
	/* start */
	function fnAuthSms() {
		if ($("#mobileAuthNumChk").val() == "4") {
			alert("������ �Ϸ�Ǿ����ϴ�.");
			return;
		}

		$("#hd_idx").val("");

		var strEmail;
		var contact = $("#txtPhone").val();

		if (Authchk_ing) {
			alert("ó���� �Դϴ�. ��ø� ��ٷ� �ּ���.");
		} else {
			if(contact=="��-�� �����ϰ� ���ڸ� �Է��� �ּ���."){
				contact="";
			}

			if(contact==""){
				alert("����ó�� �Է��� �ּ���.");
				$("#txtPhone").focus();
				return;
			}

			if(contact.length<10){
				alert("��Ȯ�� ����ó�� �Է��� �ּ���.");
				$("#txtPhone").focus();
				return;
			}
			else {
				Authchk_ing = true;

				var strUrl = "https://app.career.co.kr/sms/career/Authentication";

				var parm = {};

				parm.authCode	= "1";		// sms:1 | email:2
				parm.authvalue	= $("#txtPhone").val();		// �ڵ��� no( - �� �Է� �ص� �ǰ� ���ص� �˴ϴ�.)
				parm.sitename	= "<%=site_short_name%>";	// sms �߼۽� �ش� �������� �Է� �˴ϴ�.
				parm.sitecode	= "37";		// sitecode(�� �ش� ����Ʈ �ڵ带 �Է��ϼ���) �߼� log �� email �߼۽� �����մϴ�. => �ڵ� ����(Ŀ���� : 2, �ڶ�ȸ : 37)
				parm.memkind	= "����";
				parm.ip			= "";		// ���� IP
				parm.callback	= "jsonp_sms_callback";

				$("#aMobile").text("������ȣ ������");
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

	// Result ó���� �̰����� �մϴ�.
	function jsonp_sms_callback(data) {
		Authchk_ing = false;
		if ($.trim(data.result) == "true") {
			$("#mobileAuthNumChk").val("1");

			$("#timeCntdown").show();
			fnDpFirst();
			fncDpTm(); //ī��Ʈ

			$("#hd_idx").val(data.result_idx);
			alert("������ȣ�� �߼۵Ǿ����ϴ�.");
			$("#rsltAuthArea").show();
			$("#mobileAuthNumber").val("");
			$("#mobileAuthNumber").focus();
			$("#hd_kind").val("1");
		} else {
			$("#timeCntdown").hide();
			$("#rsltAuthArea").hide();
			$("#emailAuthNumChk").val("0");
			alert("������ȣ �߼��� �����Ͽ����ϴ�.");
		}
	}
	/* end */

	// ������ȣ Ȯ��
	/* start */
	function fnAuth() {
		if ($("#hd_kind").val() == "1" && $("#mobileAuthNumChk").val() == "4") {
			alert("������ �Ϸ�Ǿ����ϴ�.");
			return;

		} else if ($.trim($("#hd_idx").val()) == "") {
			alert("������ȣ�� ���� �ʽ��ϴ�. ������ȣ�� Ȯ���� �ּ���.");
			return;
		}

		$("#mobileAuthNumber").val($.trim($("#mobileAuthNumber").val()));
		if  ($("#hd_kind").val() == "1") {
			if ($.trim($("#mobileAuthNumber").val()) == "") {
				alert("������ȣ�� �Է��� �ּ���.");
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

		parms.authvalue	= strAuthKey;			// �߼۵� ���� KEY Value

		parms.idx		= $("#hd_idx").val();	// �߼۵� ���� ��ȣ
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

	//Result ó���� �̰����� �մϴ�.
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
	var ctm;			// ǥ�� �ð�
	var inputtime = 3;	// �Էº�
	var tstop;			// Ÿ�̸� ����

	Number.prototype.dptm = function () { return this < 10 ? '0' + this : this; } //�п� "0" �ֱ�

	function fnDpFirst() {
		clearTimeout(tstop);
		ctm = sec * inputtime;
	}

	function fncDpTm() {
		var cmi = Math.floor((ctm % (min * sec)) / sec).dptm();
		var csc = Math.floor(ctm % sec).dptm();

		//document.getElementById("ctm1").innerText = cmi + ' : ' + csc; //�� ������
		//document.getElementById("").innerText = '�����ð� ' + cmi + ' : ' + csc; //�� ������
		$("#timeCntdown em:eq(0)").text('(' + cmi + ' : ' + csc + ")");
		if ((ctm--) <= 0) {
			ctm = sec * inputtime;
			clearTimeout(tstop);
			//�����۹�ư
			//�����ð� �ʰ� meassage
		}
		else {
			tstop = setTimeout("fncDpTm()", 1000);
		}
	}

	// ������ȣ ���� �Լ� ȣ��
	function fnAuthNoChk(){
		fnAuth();
	}

	// �޴�����ȣ �ߺ� ���� ����
	function fn_chkJoin(){
		if($("#txtPhone").val()=="��-�� �����ϰ� ���ڸ� �Է��� �ּ���."){
			$("#txtPhone").val("");
		}

		if($("#txtPhone").val()==""){
			alert("����ó�� �Է��� �ּ���.");
			$("#txtPhone").focus();
			return;
		}

		if($("#txtPhone").val().length<10){
			alert("��Ȯ�� ����ó�� �Է��� �ּ���.");
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
					// ���� ��ϵ� �޴�����ȣ�� �����ϸ� X, ������ O
					if (data.trim() == "X") {
						alert("�Է��Ͻ� �޴�����ȣ�� ȸ�� ���Ե� ������ �����մϴ�.\n���̵� ã�⸦ �̿��Ͽ� ���� �����Ͻ� ������ Ȯ���� �ּ���.\n(���� �ֻ�� ������ �α��� Ŭ��> ID/PWã�� �̵�)");
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

	// �Է� �� üũ
	function fn_sumbit(){
		var txtId		= $("#txtId").val();				// ���̵�
		var txtPass		= $("#txtPass").val();				// ���
		var txtPassChk	= $("#txtPassChk").val();			// ���Ȯ��
		var	txtName		= $("#txtName").val();				// �̸�

		var	sel_birthY	= $("#sel_birthY").val();			// �������
		var	sel_birthM	= $("#sel_birthM").val();			// �����
		var	sel_birthD	= $("#sel_birthD").val();			// �����

		var txtEmail	= $("#txtEmail").val();				// �̸���
		var txtPhone	= $("#txtPhone").val();				// �޴���
//		var chkAgrPrv	= $("#agreeallPer").is(":checked");	// �̿��� �� �������� ���� ����
		var agreeCheck	= $("input[name='agreeCheck']:checked").val();

		if(txtId==""){
			alert("���̵� �Է��� �ּ���.");
			$("#txtId").focus();
			return;
		}

		if($("#id_box").text()!="��� ������ ���̵��Դϴ�."){
			alert("���̵� �ٽ� Ȯ���� �ּ���.");
			$("#txtId").focus();
			return;
		}

		if(txtPass==""){
			alert("��й�ȣ�� �Է��� �ּ���.");
			$("#txtPass").focus();
			return;
		}

		if($("#pw_box").text()!=""){
			alert("�Է��Ͻ� ��й�ȣ�� ���Ȼ� �ſ� ����մϴ�.\n8~32�ڱ��� ����, ����, Ư������ ���� ��������\n���̵�� ������ ���ڿ��� �Է��� �ּ���.");
			$("#txtPass").focus();
			return;
		}

		if(txtPassChk==""){
			alert("��й�ȣ Ȯ�ζ��� �Է��� �ּ���.");
			$("#txtPassChk").focus();
			return;
		}

		if(txtPassChk!=txtPass){
			alert("��й�ȣ�� ��й�ȣ Ȯ�ζ��� �Է��� ������\n��ġ���� �ʽ��ϴ�. �ٽ� Ȯ���� �ּ���.");
			$("#txtPassChk").focus();
			return;
		}

		if(txtName==""){
			alert("�̸��� �Է��� �ּ���.");
			$("#txtName").focus();
			return;
		}

		if(sel_birthY==""){
			alert("��������� ������ �ּ���.");
			$("#sel_birthY").focus();
			return;
		}

		if(sel_birthM==""){
			alert("������� ������ �ּ���.");
			$("#sel_birthM").focus();
			return;
		}

		if(sel_birthD==""){
			alert("������ڸ� ������ �ּ���.");
			$("#sel_birthD").focus();
			return;
		}

		if($("#txtEmail").val() == "") {
			alert("�̸����� �Է��� �ּ���.");
			$("#txtEmail").focus();
			return;
		}

		if($("#mail_box").text()=="�߸��� �̸��� �����Դϴ�."){
			alert("�̸����� �ٽ� Ȯ���� �ּ���.");
			$("#mail_box").focus();
			return;
		}

		if(txtPhone==""){
			alert("�޴�����ȣ�� �Է��� �ּ���.");
			$("#txtPhone").focus();
			return;
		}

		if ($("#mobileAuthNumChk").val() != "4") {
			alert("�޴�����ȣ�� �����ϼž� ������ �����մϴ�.");
			$("#txtPhone").focus();
			return;
		}

		if (agreeCheck == "1"){
			var obj=document.frm1;
			if(confirm('�Է��Ͻ� ������ ȸ�� ���� �Ͻðڽ��ϱ�?')) {
				obj.method = "post";
				obj.action = "join_individual_proc.asp";
				obj.submit();
			}
		}else{
			alert("�������� ���� �� �̿뿡 ������ �ּ���.");
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

	/*���̵� �ߺ� üũ ����*/
	function fn_checkID() {
		$("#txtId").val($("#txtId").val().toLowerCase());

		$("#id_box").text("");
		$("#id_check").val("0");

		var checkNumber		= $("#txtId").val().search(/[0-9]/g);	// ���� �Է� üũ
		var checkEnglish	= $("#txtId").val().search(/[a-z]/ig);	// ���� �Է� üũ

		if($("#txtId").val() == ""){
			$("#id_box").text("���̵� �Է��� �ּ���.");
			$("#txtId").focus();
			return;
		}else if(!Validchar($("#txtId").val(), num + alpha)){
			$("#id_box").text("���̵�� �ѱ� �� Ư�����ڸ� �������� �ʽ��ϴ�. �ٽ� �Է��� �ּ���.");
			$("#txtId").focus();
			return;
		}else if($("#txtId").val().length < 5){
			$("#id_box").text("���̵�� �ּ� 5�� �̻��̾�� �մϴ�.");
			return;
		}else if(checkNumber <0 || checkEnglish <0){
			$("#id_box").text("������ ���ڸ� ȥ���Ͽ� �Է��� �ּ���.");
			return;
		}else{
			if (/(\w)\1\1\1/.test($("#txtId").val())){	// �������� ���� 4���� �̻� ��� ����
				$("#id_box").text("������ ���� ���� 4���� �̻��� ��� �����մϴ�.");
				return;
			} else {
				$.ajax({
					type: "POST"
					, url: "Id_CheckAll.asp"
					, data: { user_id: $("#txtId").val() }
					, dataType: "text"
					, async: true
					, success: function (data) {
						// ���� ��ϵ� ���̵� �����ϸ� X, ������ O
						if (data.trim() == "X") {
							$("#id_box").addClass('bad').removeClass('good');
							$("#id_box").text("Ż���� ���̵� �Ǵ� �̹� ������� ���̵��, �̿��Ͻ� �� �����ϴ�.");
							return;
						} else {
							$("#id_check").val("1");
							$("#chk_id").val($("#txtId").val());
							$("#id_box").addClass('good').removeClass('bad');
							$("#id_box").text("��� ������ ���̵��Դϴ�.");
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
	/*���̵� �ߺ� üũ ��*/

	/*��й�ȣ üũ ����*/
	function fn_checkPW() {
		var chk = false;
		var id	= $("#txtId").val();
		if ($('#txtPass').val().length == 0 ) {
			return;
		} else {
			if ($('#txtPass').val().length < 8 || $('#txtPass').val().length > 32) {
				$("#pw_box").text("��й�ȣ�� 8~32�� ������ ���˴ϴ�.");
				return false;
			}

			if (id != "" && $('#txtPass').val().search(id) > -1) {
				$("#pw_box").text("��й�ȣ�� ���̵� ���ԵǾ� �ֽ��ϴ�.");
				return false;
			}

			var pattern1 = /[0-9]/;		// ����
			var pattern2 = /[a-zA-Z]/;	// ����
			var pattern3 = /[~!@#$%^&*()_+|<>?:{}]/; // Ư������

			//if (!$('#txtPass').val().match(/([a-zA-Z0-9].*[!,@,#,$,%,^,&,*,?,_,~])|([!,@,#,$,%,^,&,*,?,_,~].*[a-zA-Z0-9])/)) {
			//if (!$('#txtPass').val().match(/^.*(?=.{6,20})(?=.*[0-9])(?=.*[a-zA-Z]).*$/)) {
			//if (!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/.test($('#txtPass').val())) {
			if(!pattern1.test($('#txtPass').val()) || !pattern2.test($('#txtPass').val()) || !pattern3.test($('#txtPass').val())) {
				$("#pw_box").text("��й�ȣ�� ����, ���� �� Ư�������� �������� �����ؾ� �մϴ�");
				return;
			}else{
				if($('#txtPass').val().search(id) > -1) {
					$("#pw_box").text("��й�ȣ�� ���̵� ���ԵǾ� �ֽ��ϴ�.");
					return false;
				}else{
					$("#pw_box").text("");
				}
			}
		}

		if ($('#txtPassChk').val().split(" ").join("") == "") {
			$("#pw_box2").text("��й�ȣ Ȯ���� �Է��� �ּ���.");
			return;
		}

		if ($('#txtPass').val() != $('#txtPassChk').val()) {
			$("#pw_box2").text("��й�ȣ�� ��ġ���� �ʽ��ϴ�.");
			return;
		} else {
			$("#pw_box").text("");
			$("#pw_box2").text("");
		}
		return chk;
	}
	/*��й�ȣ üũ ��*/

	/*�̸��� üũ ����*/
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
		$("#mail_box").text("�߸��� �̸��� �����Դϴ�.");
		return false;
	  }
	  else {
		$("#mail_box").text("");
		return false;
	  }
	}
	/*�̸��� üũ ��*/

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
        <div class="memberTab">
            <ul class="spl2">
                <li class="on"><a><span>����ȸ��</span></a></li>
            </ul>
        </div><!-- .memberTab -->

        <div class="layoutBox">
			<div id="memberPer" class="memberInfo per">

<form method="post" name="frm1" autocomplete="off">
<input type="hidden" name="id_check" id="id_check" value="" /><!-- ���̵� ���� ����(0/1) -->
<input type="hidden" name="chk_id" id="chk_id" value=""><!-- ���(�Է�) ���̵� -->
<input type="hidden" name="hd_idx" id="hd_idx" value="" /><!-- ��ȣ���� idx -->
<input type="hidden" name="mobileAuthNumChk" id="mobileAuthNumChk" value="0" />
<input type="hidden" name="hd_kind" id="hd_kind" value="2" />
<input type="hidden" name="authproc" id="authproc" value="" />

				<div class="titArea">
					<h3>ȸ������ �Է�</h3>
					<!-- <span class="txt">�Ʒ� ȸ�������� �Է��Ͻø� Ŀ���� ȸ������ ������ �Ϸ�˴ϴ�.</span> -->
				</div><!-- .titArea -->
				<div class="inputArea">
<input type="password" id="tempPwd" name="tempPwd" style="display:none;"/>
<input type="text" id="tempId" name="tempId" style="display:none;"/>

					<div class="inp">
						<label for="user_id">���̵�</label>
						<input type="text" id="txtId" name="txtId" maxlength="12" style="ime-mode:disabled;" class="txt placehd" placeholder="���̵� (5~12�� ����, ���� �Է�)" autocomplete="off">
						<div class="rt">
							<div class="alertBox">
								<span class="good" id="id_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_pw1">��й�ȣ</label>
						<input type="password" id="txtPass" name="txtPass" maxlength="32" class="txt placehd" placeholder="��й�ȣ (8~32�� ����, ����, Ư������ �Է�)" autocomplete="new-password">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="pw_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_pw2">��й�ȣ Ȯ��</label>
						<input type="password" id="txtPassChk" name="txtPassChk" maxlength="32" class="txt placehd" placeholder="��й�ȣ Ȯ��" autocomplete="new-password">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="pw_box2"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_nm">�̸�</label>
						<input type="text" id="txtName" name="txtName" maxlength="10" style="ime-mode:active;" class="txt placehd" placeholder="�̸� (�Ǹ��Է�)" autocomplete="off">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="nm_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->

					<div class="inp"><!-- �ʼ� �Է� �׸� ������� �߰� [2020-11-30] -->
						<div class="birth" id="birth">
							<span class="selectbox" style="width:100px">
								<span>�⵵</span>
								<select id="sel_birthY" name="sel_birthY" title="�⵵ ����">
									<option value="">�������</option>
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
								<span>��</span>
								<select id="sel_birthM" name="sel_birthM" title="�� ����">
									<option value="">��</option>
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
								<span>��</span>
								<select id="sel_birthD" name="sel_birthD" title="�� ����">
									<option value="">��</option>
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
								ȸ�� ���� �� �� 15�� �̸��� ���� �Ұ��մϴ�.
								<br>
								���� ���� ���ɿ� ���� ����(�ٷα��ع� �� 64�� 1��)
							</font>
						</div><!-- .birth -->
					</div><!-- .inp -->

					<div class="inp">
						<label for="email_id">�̸���</label>
						<input type="text" id="txtEmail" name="txtEmail" maxlength="100" style="ime-mode:disabled;" class="txt placehd" placeholder="�̸���" autocomplete="off">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="mail_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<!-- 2020.06.11
					<div class="receiveArea">
						<label class="checkbox off" for="compReceive1"><input type="checkbox" id="chkAgrMail" name="chkAgrMail" class="chk" value="1"><span>���� ä������ / ���� �������� / �̺�Ʈ ���� ���ſ� �����մϴ�.</span></label>
					</div><!-- .receiveArea
					-->
					<div class="inp">
						<label for="hp_num">�޴��� ��ȣ</label>
						<input type="text" id="txtPhone" name="txtPhone" maxlength="13" class="txt placehd" placeholder="�޴��� ��ȣ" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="return onlyNumber(event)">
						<div class="rt">
							<div class="alertBox">
								<span class="num" id="timeCntdown" style="display:none;"><em>(2:59)</em></span>
							</div><!-- .alertBox -->
							<button type="button" class="btn" id="aMobile" onclick="fn_chkJoin(); return false;">������ȣ ����</button>
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp" id="rsltAuthArea" style="display:none;">
						<label for="mobileAuthNumber">������ȣ</label>
						<input type="text" id="mobileAuthNumber" name="mobileAuthNumber" maxlength="6" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" class="txt placehd" placeholder="������ȣ">
						<div class="rt">
							<div class="alertBox">
								<p class="good" id="rsltMsg1" style="display:none;">������ȣ�� ���� �Է� �ƽ��ϴ�.</p>
								<p class="bad" id="rsltMsg2" style="display:none;">������ȣ�� Ʋ���ϴ�.</p>
							</div><!-- .alertBox -->
							<button type="button" class="btn" onclick="fnAuthNoChk(); return false;">����Ȯ��</button>
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="receiveArea" style="display:none;">
						<label class="checkbox off" for="perReceive2"><input type="checkbox" id="chkAgrSms" name="chkAgrSms" class="chk" value="1"><span>ä����� SMS ���ſ� �����մϴ�.</span></label>
					</div><!-- .receiveArea -->
				</div><!-- .inputArea -->

				<div class="privacy">
					<dl>
						<dt>�������� ���� �� �̿뵿��</dt>
						<dd>
							<strong>�������� ��������</strong> : <%=site_name%> ä�뼳��ȸ �α��� �� ������ ���� �ĺ�, �����ǻ� Ȯ��, �Ի������� ����,
        						  �������� ����, �Ի� �����ڿ��� ��Ȱ�� �ǻ����, �����̷� Ȯ��, �̺�Ʈ �����ڴ�÷�� ��ǥ �� ���뵿�� ������ Ȱ�� ����<br>
							<strong>�������� �����׸�</strong> : ���̵�, ��й�ȣ, �̸�, �������, �̸���, �޴�����ȣ <br>
							<strong>�������� �̿�Ⱓ</strong> : ����Ʈ ���� ���ۺ��� ��� ����ñ���.<br />(����Ʈ ���� �ĺ��� ��� ����ñ���
							- ���� ������ ���� ������� ��� ������ �Ϸ��ϱ� ���� ȸ���� �̿������� ������ �ʿ䰡 ����) <br>
							<strong>�������� �ı�</strong> : ��� ���� �� ��� ������� ���� ���� �� �ı� (���� ���� ��)
							<p style="font-weight:500; margin:10px 0 10px 0;">* �������� ���� �� �̿뿡 ���ؼ��� �ź��� �� ������, �ź� �ÿ��� �ڶ�ȸ ����Ʈ �̿���<br />
								&nbsp;&nbsp;&nbsp;�Ұ��մϴ�.</p>
								<label class="radiobox" style="padding-right:10px;">
									<input class="rdi" name="agreeCheck" value="1" type="radio"><span style="font-size:1rem;">�����մϴ�.</span>
								</label>
								<label class="radiobox">
									<input class="rdi" name="agreeCheck" value="2" type="radio"><span style="font-size:1rem;">�������� �ʽ��ϴ�.</span>
								</label>
						</dd>
					</dl>
					<!--<label class="checkbox off" for="agreeallPer">
						<input type="checkbox" id="agreeallPer" name="agreeallPer" class="chk" value="">
						<span>�������� ���� �� �̿뿡 �����Ͻʴϱ�?</span>
					</label>-->
				</div><!-- .privacy -->

				<div class="btnWrap">
					<button type="button" class="btn typeSky pop" onclick="javascript:fn_sumbit();" style="cursor:pointer">ȸ�� ����</button>
				</div><!-- .btnWrap -->

</form>
		</div>
		</div><!-- .layoutBox -->
    </div><!-- #career_contents -->
</div><!-- #career_container -->
<!--// CONTENTS -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

</body>
</html>
