/**********************************************************************************
Setp1. ����ȸ�� ���� �Է�  �ۼ����� �Լ�
**********************************************************************************/

// ������ȣ ���� �Լ� ȣ��
function fnAuthNoChk(){
	fnAuth();
}

// ���ڸ� �Է�
function onlyNumber(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		return false;
}

// �����Է� ���ϰ�
function removeChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}

/* ������ȣ Ÿ�̸� ���� - 3�� start */
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
	$("#timeCntdown").text('(' + cmi + ' : ' + csc + ")");
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
/* ������ȣ Ÿ�̸� ���� - 3�� end */

/* SMS ���� ��ȣ ���� start */
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
			parm.sitename	= $.trim($("#site_short_name").val());	// sms �߼۽� �ش� �������� �Է� �˴ϴ�.
			parm.sitecode	= "37";		// sitecode(�� �ش� ����Ʈ �ڵ带 �Է��ϼ���) �߼� log �� email �߼۽� �����մϴ�. => �ڵ� ����(Ŀ���� : 2, �ڶ�ȸ : 37)
			parm.memkind	= "����";
			parm.ip			= "";		// ���� IP
			parm.callback	= "jsonp_sms_callback";

			$("#aMobile").html("������ȣ<br>������");
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
/* SMS ���� ��ȣ ���� end */

/* ������ȣ Ȯ�� start */
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
/* ������ȣ Ȯ�� end */

/* �޴�����ȣ �ߺ� ���� ���� start */
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
/* �޴�����ȣ �ߺ� ���� ���� end */

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

/*�Է� �� üũ start*/
function fn_step1(){
	var txtId			= $("#txtId").val();				// ���̵�
	var txtPass			= $("#txtPass").val();				// ���
	var txtPassChk		= $("#txtPassChk").val();			// ���Ȯ��
	var txtEmail		= $("#txtEmail").val();				// �̸���
	var txtPhone		= $("#txtPhone").val();				// �޴���
	var chkAgrPrv		= $("input:checkbox[name='chkAgrPrv']:checked").val();	// SMS/E-mail ���ſ���
	
/*
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
*/	

	var obj=document.frm1;

	obj.method = "post";
	obj.action = "joinForm_jobs_T.asp";
	obj.submit();
}
/*�Է� �� üũ end*/


/**********************************************************************************
Setp2. ������û�� �ۼ����� �Լ�
**********************************************************************************/
/* ���� �з»��� start */

//���г���Է½�
function fn_school_s_div(obj) {
	if (obj.value.length == 7) {
		$("#univ_syear").val(obj.value.substr(0, 4));
		$("#univ_smonth").val(obj.value.substr(5, 2));
	} else {
		$("#univ_syear").val("");
		$("#univ_smonth").val("");
	}
}

//��������Է½�
function fn_school_e_div(obj) {
	if (obj.value.length == 7) {
		$("#univ_eyear").val(obj.value.substr(0, 4));
		$("#univ_emonth").val(obj.value.substr(5, 2));
	} else {
		$("#univ_eyear").val("");
		$("#univ_emonth").val("");
	}
}

//�з±��м��ý�
function fn_school_univ_kind(obj, val) {
	//����б�, ���� �˻��ڵ��ϼ� �ڵ尪 ����
	$("#univ_name").attr('onkeyup','fn_kwSearchItem(this, \'' + val + '\')');

	if (val == "high") {
		$("#univ_major").val("");
		$("#univ_major").hide();
	}
	else {
		$("#univ_major").show();
	}
}

//�б��˻�
function fn_kwSearchItem(obj, _gubun) {
	/*
	���� ���� ��� ã��
	$("������").prev()
	$("������").prevAll("������");

	���� ���� ��� ã��
	$("������").next()
	$("������").nextAll("������");
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
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
	
	document.charset = "euc-kr";
	/*
	$.get("/my/resume/comm/search_result_school.asp", { "kw": _kw, "sGubun": _gubun, "idx": 0, "result_obj_id": _result_obj }, function (data) {
		$(obj).nextAll("#id_result_box").html(data);
	});
	*/
}
/* ���� �з»��� end */

/* ��� ������� start */

//�����˻�
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
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
	
	document.charset = "euc-kr";
}

// 1������ ����
function fn_set_area_change(obj, _i) {
	$('[name="da"]').attr('class', 'radiobox off'); //1������ class off
	$(obj).attr('class', 'radiobox on'); //������ 1������ class on

	$('[name="area_ul"]').hide(); //2������ ��ü����
	$("#area_ul_" + _i).show(); //������ 1�������� 2������ ����Ʈ ����
	
	// ����2�� üũ�ڽ�(�ε�� �� �������)
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

		checkboxFnc();//üũ�ڽ�.
	}
	
}

// 2������ ����
//var area_check_cnt2 = 0;
//var area_check_rank = 0;

function fn_set_area2(obj, _area1_cd, _area1_nm) {
	var area2_cd, area2_nm, area2_checked, area_check_cnt2, area_check_rank
	area2_cd = $(obj).val();
	area2_nm = $(obj).next().html();
	area2_checked = $(obj).is(":checked");
	area_check_cnt2 = $("#area_check_cnt2").val();
	area_check_rank = $("#area_check_rank").val();

	console.log("area_check_cnt2 : " + area_check_cnt2);
	console.log("area_check_rank : " + area_check_rank);
	

	if (area2_checked) {
		var area_check_cnt = $('input:checkbox[name="chk_area"]:checked').length;

		console.log("area_check_cnt : " + area_check_cnt);

		if (area_check_cnt > 2) {
			alert("��� �ٹ����� 2������ ����� �����մϴ�.");
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
			up_html += '	<th>' + (area_check_cnt2 == 0 ? area_check_cnt : area_check_rank) + '����</th>';
			up_html += '	<td>' + _area1_nm + '<span>' + area2_nm + '</span></td>';
			up_html += '</tr>';

			$('#view_area_rank').append(up_html);
		}
	}
	else {
		fn_set_area2_del(area2_cd);
	}

}

// ������ ��������, üũ����
function fn_set_area2_del(_val) {
	// �ϴܺ� ���õ� ����ǥ�� ����
	$('input[name="view_area_sub"]').each(function() {
		if (this.value == _val) {
			$(this).parents("#area_rank").remove();
			$("#area_check_rank").val($(this).nextAll("th").text().replace("����", ""));
		}
	});
	// ����2�� ���õ� üũ�ڽ� ����
	$('input:checkbox[name="chk_area"]').each(function() {
		if (this.value == _val) {
			this.checked = false;
		}
	});

	$("#area_check_cnt2").val($('input:checkbox[name="chk_area"]:checked').length);

	checkboxFnc();//üũ�ڽ�.
}

//������ �ʱ�ȭ
function fn_reset() {
	// �ϴܺ� ����ǥ�� �ʱ�ȭ
	$("#view_area_rank").html("");

	// ����2�� üũ�ڽ� ��ü����
	$('input:checkbox[name="chk_area"]').each(function() {
		this.checked = false;
	});
	
	$("#area_check_cnt2").val("0");
	$("#area_check_rank").val("0");

	checkboxFnc();//üũ�ڽ�.
}

function fn_save() {
	var out_html = '';
	var set_area_cnt = $('[name="view_area"]').length;
	var hdn_area	= "";
	var hdn_area2	= "";
	
	if (set_area_cnt != 2) {
		alert("1����, 2���� ����ٹ������� ��� �Է��� �ּ���.");
		return;
	}
	else {
		for (i=0; i<set_area_cnt; i++) {
			var set_num		= $('[name="view_area_sub"]').eq(i).nextAll("th").text().replace("����", "");
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
/* ��� ������� end */

function textIn(obj, text, result_obj, val) {
	/*
	�ٷ� ���� �θ�
	$("������").parent()

	��� �θ� ã��
	$("������").parents() ��� �θ�

	��� �θ� �� �����ڿ� �ش��ϴ� �θ� ã��
	$("������").parents("������")

	Ư�� �ڽĳ�� ã��
	$("������").children("������")
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

/*�Է� �� üũ start*/
function fn_step2() {
	//------------------------------------------------------------------------------------------------------------------------ ȸ�������Է�
	var txtName			= $("#txtName").val();									// �̸�
	var zipcode			= $("#zipcode").val();									// �����ȣ
	var addr			= $("#addr").val();										// �ּ�
	var detailAddr		= $("#detailAddr").val();								// ���ּ�
	var jumin1			= $("#jumin1").val();									// �ֹξ��ڸ�
	var juminH			= $("#juminH").val();									// �ֹε��ڸ�(����ŷ��)
	var chk_num			= $("input:checkbox[name='chk_num']:checked").val();	// �ֹε�Ϲ�ȣ��������
	
	//------------------------------------------------------------------------------------------------------------------------ ���� �з»���
	var univ_etype		= $("input:radio[name='graduated']:checked").val();		// ��������
	
	//------------------------------------------------------------------------------------------------------------------------ ����������
	var area			= $("#hdn_area").val();															// ����ٹ�����	
	var home			= $("input:checkbox[name='home']:checked").val();								// ���ñٹ�����
	if (home) {
		$("#hdn_area").val("");
	}
	
	var employ			= "";																			// �������
	$("input:checkbox[name='chk_employ']:checked").each(function(index) {
		if (index != 0) {
			employ += "|";
		}

		employ += $(this).val();
	});
	$("#hdn_employ").val(employ);

	var salary			= $("#hdn_salary").val();														// ����Ա�����
	var salary_txt		= $("#salary_txt").val().replace("," , "");										// ����Աݱݾ�
	var hire_h2			= $("input:radio[name='hire_h2']:checked").val();								// �����˼��������

	var hire_info			= "";																		// ���������������ǿ���
	$("input:checkbox[name='hire_info']:checked").each(function(index) {
		if (index != 0) {
			hire_info += "|";
		}

		hire_info += $(this).val();
	});
	$("#hdn_hire_info").val(hire_info);

	var individual_info	= $("input:radio[name='individual_info']:checked").val();						// ����������ȸ���ǿ���

/*
	if(txtName==""){
		alert("�̸��� �Է��� �ּ���.");
		$("#txtName").focus();
		return;
	}

	if(addr==""){
		alert("�ּҸ� �Է��� �ּ���.");
		$("#addr").focus();
		return;
	}
	
	if(detailAddr==""){
		alert("���ּҸ� �Է��� �ּ���.");
		$("#detailAddr").focus();
		return;
	}

	if(jumin1==""){
		alert("��������� �Է��� �ּ���.");
		$("#jumin1").focus();
		return;
	}

	if (jumin1!="") {
		if (jumin1.length<6) {
			alert("�ֹε�Ϲ�ȣ�� �ٽ� Ȯ���� �ּ���.");
			$("#jumin1").focus();
			return;
		}
		else if ((parseInt(jumin1.charAt(2) + jumin1.charAt(3)) > 12) || (parseInt(jumin1.charAt(4) + jumin1.charAt(5)) > 31)) {
			alert("��������� �ٽ� Ȯ���� �ּ���.");
			$("#jumin1").focus();
			return;
		}
	}

	if(juminH==""){
		alert("�ֹε�Ϲ�ȣ ���ڸ��� �Է��� �ּ���.");
		$("#jumin2").focus();
		return;
	}

	//* 9,0 : ���� 1800���� ��,��   1,2 : ���� 1900���� ��,��   3,4 : ���� 2000���� ��,��   5,6 : �ܱ� 1900���� ��,��   7,8 : �ܱ� 2000���� ��,��
	if (juminH.length!=7 || (juminH.substr(0,1) == 9 || juminH.substr(0,1) == 0)) {
		alert("�ֹε�Ϲ�ȣ�� �ٽ� Ȯ���� �ּ���.");
		$("#jumin2").focus();
		return;
	}
	
	if (!chk_num) {
		alert("�ֹε�Ϲ�ȣ �������Ǹ� üũ�� �ּ���.");
		$("input:checkbox[name='chk_num']").focus();
		return;
	}

	if($("#univ_kind").val()==0) {
		alert("�з±����� ������ �ּ���.");
		$("#univ_gubun").focus();
		return;
	}

	if($("#univ_name").val()=="") {
		alert("�б����� �Է��� �ּ���.");
		$("#univ_name").focus();
		return;
	}

	if($("#univ_kind").val()=="univ" && $("#univ_major").val()=="") {
		alert("������ �Է��� �ּ���.");
		$("#univ_major").focus();
		return;
	}

	if($("#univ_syear").val()=="" && $("#univ_smonth").val()=="") {
		alert("���г���� �Է��� �ּ���.");
		$("#univ_sdate").focus();
		return;
	}

	if($("#univ_eyear").val()=="" && $("#univ_emonth").val()=="") {
		alert("��������� �Է��� �ּ���.");
		$("#univ_edate").focus();
		return;
	}

	if(!univ_etype) {
		alert("���������� ������ �ּ���.");
		$("input:radio[name='graduated']").focus();
		return;
	}

	if($("#hdn_jc_name").val()=="") {
		alert("��������� ������ �ּ���.");
		$("#jc_name").focus();
		return;
	}	
*/	
	if ((area=="" || area.split("|").length < 2) && !home) {
		alert("1����, 2���� ����ٹ������� ��� �Է��� �ּ���.");
		$("input:checkbox[name='home']").focus();
		return;
	}
	console.log("area : " + area);
	return;
/*
	if (employ=="" || employ=="00") {
		if (employ=="00") {
			alert("�ð����� �ܵ����� �����Ҽ� �����ϴ�.");
			$("input:checkbox[name='chk_employ']").focus();
			return;
		}
		else {
			alert("������¸� ������ �ּ���.");
			$("input:checkbox[name='chk_employ']").focus();
			return;
		}
	}
	
	if (salary=="" || (salary!="98" && salary_txt=="")) {
		alert("����Ա����� �� �ݾ��� �Է��� �ּ���.");
		$("#salary_txt").focus();
		return;
	}
	
	if (salary!="" && salary_txt!="") {
		if (salary=="1" && parseInt(salary_txt) < 2154){
			alert("���� ���� 2,154���� ���� ���� �Է��� �ּ���.");
			$("#salary_txt").focus();
			return;
		}
		else if (salary=="2" && parseInt(salary_txt) < 179){
			alert("���� ���� 179���� ���� ���� �Է��� �ּ���.");
			$("#salary_txt").focus();
			return;
		}
		else if (salary=="3" && parseInt(salary_txt) < 68720){
			alert("���� �ϱ� 68,720�� ���� ���� �Է��� �ּ���.");
			$("#salary_txt").focus();
			return;
		}
		else if (salary=="4" && parseInt(salary_txt) < 8590) {
			alert("���� �ñ� 8,590�� ���� ���� �Է��� �ּ���.");
			$("#salary_txt").focus();
			return;
		}
	}

	if (!hire_h2) {
		alert("�����˼���������� ������ �ּ���.");
		$("input:radio[name='hire_h2']").focus();
		return;
	}

	if (hire_info=="") {
		alert("���������������ǿ��θ� ������ �ּ���.");
		$("input:checkbox[name='hire_info']").focus();
		return;
	}

	if (!individual_info) {
		alert("����������ȸ���ǿ��θ� ������ �ּ���.");
		$("input:checkbox[name='individual_info']").focus();
		return;
	}
*/

	var obj=document.frm1;

	obj.method = "post";
	obj.action = "proc_joinForm_T.asp";
	obj.submit();
}
/*�Է� �� üũ end*/