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
	Response.End 
End If

' ���� �ο� �� ���ȸ�� ���� �Ұ� ó�� [2020-11-11 edit by star]
'If Left(Request.ServerVariables("REMOTE_ADDR"),11)<>"210.121.194" Then
'	Response.Write "<script language=javascript>"&_
'		"alert('�ش� �������� ���� ���� ������ �����ϴ�.');"&_
'		"location.href='/';"&_
'		"</script>"
'	Response.End 
'End If
%>

<!--#include virtual = "/include/header/header.asp"-->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
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
				parm.memkind	= "���";	
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

		parms.authCode	= $("#hd_kind").val(); // sms: 1 | email: 2

		parms.authvalue = strAuthKey;	// �߼۵� ���� KEY Value

		parms.idx = $("#hd_idx").val();	// �߼۵� ���� ��ȣ
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

	//Result ó���� �̰����� �մϴ�.
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

	// �Է� �� üũ
	function fn_sumbit(){
		var compno_check		= $("#compno_check").val();			// ����ڹ�ȣ ���� ����(0/1/2)
		var txtCompName			= $("#txtCompName").val();			// �����
		var txtBossName			= $("#txtBossName").val();			// ��ǥ�ڸ�
		var txtCompAddr			= $("#txtCompAddr").val();			// ȸ���ּ�
		var txtCompAddrDetail	= $("#txtCompAddrDetail").val();	// ȸ���ּһ�
		
		var txtEmpCnt			= $("#txtEmpCnt").val();	// �����	
		var selCompType			= $("#selCompType").val();	// �������

		var txtId				= $("#txtId").val();					// ���̵�
		var txtPass				= $("#txtPass").val();					// ���
		var txtPassChk			= $("#txtPassChk").val();				// ���Ȯ��
		var	txtName				= $("#txtName").val();					// �̸�
		var txtEmail			= $("#txtEmail").val();					// �̸���
		var txtPhone			= $("#txtPhone").val();					// �޴���
		var chkAgrPrv			= $("#agreeallComp").is(":checked");	// �̿��� �� �������� ���� ����


		if($("#txtCompNum").val()=="����ڵ�Ϲ�ȣ ( - ���� �Է�)"){
			compno_check="";
		}

		if(compno_check==""){
			alert("����ڵ�Ϲ�ȣ�� ������ �ּ���.");
			$("#txtCompNum").focus();
			return;
		}

		if($("#chk_compno").val()!=$("#txtCompNum").val()){
			alert("����ڵ�Ϲ�ȣ�� ������ �ּ���.");
			$("#compno_check").val("");
			$("#txtCompNum").focus();
			return;		
		}

		if(compno_check=="2"){
			alert("�Է��Ͻ� ����ڹ�ȣ�� ���ȸ���� ���Ե� ������ �����մϴ�.\n���̵� ã�⸦ �̿��Ͽ� ���� �����Ͻ� ������ Ȯ���� �ּ���.\n(���� �ֻ�� ��� �α��� Ŭ��> ID/PWã�� �̵�)");
			$("#txtCompNum").focus();
			return;
		}

		if(compno_check=="0"){
			if(txtCompName==""){
				alert("������� �Է��� �ּ���.");
				$("#txtCompName").focus();
				return;
			}

			if(txtBossName==""){
				alert("��ǥ�ڸ��� �Է��� �ּ���.");
				$("#txtBossName").focus();
				return;
			}

			if(txtCompAddr==""){
				alert("ȸ���ּҸ� �Է��� �ּ���.");
				$("#txtCompAddr").focus();
				return;
			}

			if(txtCompAddrDetail==""){
				alert("ȸ�� ���ּҸ� �Է��� �ּ���.");
				$("#txtCompAddrDetail").focus();
				return;
			}

			if(txtEmpCnt==""){
				alert("������� �Է��� �ּ���.");
				$("#txtEmpCnt").focus();
				return;
			}

			if(selCompType==""){
				alert("������¸� ������ �ּ���.");
				$("#selCompType").focus();
				return;
			}
		}

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
			alert("ä�� ����ڸ��� �Է��� �ּ���.");
			$("#txtName").focus();
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

		if(chkAgrPrv){		
			var obj=document.frm1;
			if(confirm('�Է��Ͻ� ������ ���ȸ�� ������ �Ͻðڽ��ϱ�?')) {
				obj.method = "post";
				obj.action = "join_enterprise_proc.asp";
				obj.submit();
			}
		}else{
			alert("�̿��� �� �������� ������ ������ �ּ���.");
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

	/*���ȸ�� ����ڹ�ȣ ��ȿ�� üũ ����*/
	function fn_checkCompNum() {
		if($("#txtCompNum").val()=="����ڵ�Ϲ�ȣ ( - ���� �Է�)"){
			$("#txtCompNum").val()="";
		}

		$("#compno_box").text("");
		$("#compno_check").val("");
		$("#chk_compno").val($("#txtCompNum").val());

		if($("#txtCompNum").val() == ""){
			$("#compno_check").val("");
			alert("����ڹ�ȣ�� �Է��� �ּ���.");
			$("#txtCompNum").focus();
			return;
		}else if($("#txtCompNum").val().length < 10){
			$("#compno_check").val("");
			alert("��Ȯ�� ����ڹ�ȣ�� �Է��� �ּ���.");
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
					var rsltval = data.trim(); // ȸ������ ��ȸ ����ڵ�(X,O,I,N)+'��'+ȸ������(�ſ��򰡱�� ��ȸ ���� �� ȭ�� �����)
					var strSp	= rsltval.split('��');

					// ���ȸ�� ���� ���ܱ������ �з�: X, �ſ��򰡱�� ���� ���̺� ȸ�� ���� ����: O, �ſ��򰡱�� ���� ���̺� ȸ�� ���� ������(���� �Է� ���): I, ���� ���ȸ�� ���� ���� ����: N   
					if (strSp[0] == "X") {
						$("#compno_check").val("");
						$("#compno_box").addClass('bad').removeClass('good');
						$("#compno_box").text("������ ���ѵ� ����ڹ�ȣ�Դϴ�. �����ڿ��� ���� �ٶ��ϴ�.");
						$('#rsltCompArea').html("");// �ſ��򰡱�� ȸ������ ��ȸ ��� ���� �̳���
						
						$("#instCompArea").hide();	// ȸ������ ���� ��� ���� ���� ó�� �� �Է� �� �ʱ�ȭ
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
						$("#compno_box").text("�ش� ����ڹ�ȣ�� ���ȸ�� ���Ե� ������ �����մϴ�.");
						$('#rsltCompArea').html("");

						$("#instCompArea").hide();	// ȸ������ ���� ��� ���� ���� ó�� �� �Է� �� �ʱ�ȭ
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
						$("#compno_box").text("�ſ��򰡱���� �ش� ����ڹ�ȣ�� ��ϵǾ� ���� �ʽ��ϴ�.");
						$('#rsltCompArea').html("");
						
						$("#instCompArea").show();	// ȸ������ ���� ��� ���� ���� ó��
						$("#txtCompName").val("");
						$("#txtBossName").val("");
						$("#txtCompAddr").val("");
						$("#txtCompAddrDetail").val("");
						$("#txtEmpCnt").val("");
						$("#selCompType").val("");

						var txtNotice = "NICE�ſ��������� �ش� ����ڹ�ȣ�� ��ϵǾ� ���� �ʽ��ϴ�.\n��������� ���� �Է��� �ֽø� Ȯ�� �� �ݿ� ó���ϰڽ��ϴ�.";
						txtNotice = txtNotice.replace(/(?:\r\n|\r|\n)/g, '<br />');
						$(".notiArea").html(txtNotice);
						$(".notiArea").show();


						return;						
					} else {
						$("#compno_check").val("1");
						$("#compno_box").addClass('good').removeClass('bad');
						$("#compno_box").text("����ڵ�Ϲ�ȣ ������ �Ϸ�Ǿ����ϴ�.");
						$('#rsltCompArea').html(strSp[1]);

						$("#instCompArea").hide();	// ȸ������ ���� ��� ���� ���� ó�� �� �Է� �� �ʱ�ȭ
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
	/*���ȸ�� ����ڹ�ȣ ��ȿ�� üũ ��*/

	/*�ּҰ˻� ����*/
	function openPostCode() {
		new daum.Postcode({		
			oncomplete: function (data) {
				// �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.

				// ���θ� �ּ��� ���� ��Ģ�� ���� �ּҸ� �����Ѵ�.
				// �������� ������ ���� ���� ��쿣 ����('')���� �����Ƿ�, �̸� �����Ͽ� �б� �Ѵ�.
				var fullRoadAddr = data.roadAddress; // ���θ� �ּ� ����
				var extraRoadAddr = ''; // ���θ� ������ �ּ� ����

				// ���������� ���� ��� �߰��Ѵ�. (�������� ����)
				// �������� ��� ������ ���ڰ� "��/��/��"�� ������.
				if (data.bname !== '' && /[��|��|��]$/g.test(data.bname)) {
					extraRoadAddr += data.bname;
				}
				// �ǹ����� �ְ�, ���������� ��� �߰��Ѵ�.
				if (data.buildingName !== '' && data.apartment === 'Y') {
					extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
				}
				// ���θ�, ���� ������ �ּҰ� ���� ���, ��ȣ���� �߰��� ���� ���ڿ��� �����.
				if (extraRoadAddr !== '') {
					extraRoadAddr = ' (' + extraRoadAddr + ')';
				}
				// ���θ�, ���� �ּ��� ������ ���� �ش� ������ �ּҸ� �߰��Ѵ�.
				if (fullRoadAddr !== '') {
					fullRoadAddr += extraRoadAddr;
				}

				// �����ȣ�� �ּ� ������ �ش� �ʵ忡 �ִ´�.				
				document.getElementById('hidZipCode').value = data.zonecode; //5�ڸ� ���ּ� �����ȣ
				document.getElementById('txtCompAddr').value = fullRoadAddr;
			}
		}).open({popupName: 'postcodePopup'});
	}
	/*�ּҰ˻� ��*/

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
					, url: "/my/signup/Id_CheckAll.asp"
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
		if ($('#txtPass').val().length == 0) {
			return;
		}else {
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
		//���̵� �ߺ� üũ
		$("#txtId").bind("keyup keydown", function () {
			fn_checkID();
		});

		// ��� ��ȿ�� üũ
		$("#txtPass").bind("keyup keydown", function () {
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
                <li class="on"><a><span>���ȸ��</span></a></li>
            </ul>
        </div><!-- .memberTab -->

        <div class="layoutBox">
			<div id="memberComp" class="memberInfo comp" style="display: block;">
<form method="post" name="frm1">
<input type="hidden" name="compno_check" id="compno_check" value="" /><!-- ����ڹ�ȣ ���� ����(0/1/2) -->
<input type="hidden" name="chk_compno" id="chk_compno" value="" /><!-- ����ڹ�ȣ(���� �Է�) -->
<input type="hidden" name="id_check" id="id_check" value="" /><!-- ���̵� ���� ����(0/1) -->
<input type="hidden" name="chk_id" id="chk_id" value="" /><!-- ���(���� �Է�) ���̵� -->
<input type="hidden" name="hd_idx" id="hd_idx" value="" /><!-- ��ȣ���� idx -->
<!-- Ŀ���� ���� �����ǿ� ���Ͽ� �޴��� ���� �������� ���� ��� �� ���� ���� [2020-11-11] -->
<input type="hidden" name="mobileAuthNumChk" id="mobileAuthNumChk" value="<%If Left(Request.ServerVariables("REMOTE_ADDR"),11)="210.121.194" Then%>4<%Else%>4<%End If%>" />
<input type="hidden" name="hd_kind" id="hd_kind" value="2" />
<input type="hidden" name="authproc" id="authproc" value="" />
<input type="hidden" name="hidZipCode" id="hidZipCode" value="" />	
					<div class="titArea">
						<h3>����ڵ�Ϲ�ȣ �Է�</h3>
						<span class="txt">����ڵ�Ϲ�ȣ �Է� �� ����Ȯ���� Ŭ���� �ּ���.</span>
					</div><!-- .titArea -->

					<div class="inputArea">
						<div class="inp">
							<label for="comp_num">����ڵ�Ϲ�ȣ</label>
							<input type="text" id="txtCompNum" name="txtCompNum" maxlength="12" class="txt placehd" placeholder="����ڵ�Ϲ�ȣ ( - ���� �Է�)" onkeyup="removeChar(event)" onkeydown="<%If 1=2 then%>return onlyNumber(event)<%End if%>">
							<div class="rt">
								<div class="alertBox">
									<span class="good" id="compno_box"></span>
								</div><!-- .alertBox -->
								<button type="button" class="btn" onclick="fn_checkCompNum(); return false;" style="cursor:pointer">����Ȯ��</button>
							</div><!-- .rt -->
						</div><!-- .inp -->

						<p class="notiArea">
							���ȸ���� ����ڵ�Ϲ�ȣ ���� �� ���� �����մϴ�.<br>
							����ڵ�Ϲ�ȣ �Է� �� ���� ��ư�� Ŭ���ϼ���.
						</p><!-- .notiArea -->
						
						<div class="inputArea mt10" id="rsltCompArea"></div><!-- �ſ��򰡱��X�������»� ��ȸ ����� ���� ��� ȸ������ ���� ���� -->

						<div class="inputArea mt10" id="instCompArea" style="display:none;"><!-- �ſ��򰡱��X�������»� ��ȸ ����� ���� ��� ȸ������ ���� �Է� ���� -->
							<div class="inp">
								<label for="company_name">�����</label>
								<input type="text" id="txtCompName" name="txtCompName" maxlength="50" style="ime-mode:active;" class="txt placehd" placeholder="�����">
							</div><!-- .inp -->
							<div class="inp">
								<label for="company_owner">��ǥ�ڸ�</label>
								<input type="text" id="txtBossName" name="txtBossName" maxlength="30" style="ime-mode:active;" class="txt placehd" placeholder="��ǥ�ڸ�">
							</div><!-- .inp -->
							<div class="inp">
								<label for="company_address">ȸ�� �ּ�</label>
								<input type="text" id="txtCompAddr" name="txtCompAddr" onclick="openPostCode();" class="txt placehd pr140" placeholder="ȸ���ּ�" readOnly>
								<div class="rt">
									<button type="button" class="btn" onclick="openPostCode(); return false;" style="cursor:pointer">ȸ���ּ�</button>
								</div>
							</div><!-- .inp -->
							<div class="inp">
								<label for="company_name">ȸ�� ���ּ�</label>
								<input type="text" id="txtCompAddrDetail" name="txtCompAddrDetail" maxlength="100" style="ime-mode:active;" class="txt placehd" placeholder="ȸ�� ���ּ�">
							</div><!-- .inp -->						
							<div class="inp">
								<label for="company_people">�����</label>
								<input type="text" id="txtEmpCnt" name="txtEmpCnt" maxlength="8" class="txt placehd" placeholder="�����" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)">
							</div><!-- .inp -->

							<div class="inp sel">
								<span class="selectbox">
									<span class="">�������</span>
									<select id="selCompType" name="selCompType" title="������� ����">
										<option value="" selected="">������� ����</option>
										<!-- <option value="0">�������</option> -->
										<option value="1">����</option>
										<option value="3">�߰߱��</option>
										<option value="5">���ұ��</option>
										<option value="4">�߼ұ��</option>
										<option value="6">�Ϲݱ��</option>									
										<option value="2">��Ÿ</option>
									</select>
								</span>
							</div><!-- .inp -->
						</div><!-- .inputArea -->

						<div class="titArea">
							<h3>ä������ ���� �Է�</h3>
							<span class="txt">���� ä����� ����� ������ �Է��ϼ���.</span>
						</div><!-- .titArea -->

						<div class="inputArea">
							<div class="inp">
								<label for="mnger_Id">���̵�</label>
								<input type="text" id="txtId" name="txtId" maxlength="12" style="ime-mode:disabled;" class="txt placehd" placeholder="���̵� (5~12�� ����, ���� �Է�)" autocomplete="off">
								<div class="rt">
									<div class="alertBox">
										<span class="good" id="id_box"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp">
								<label for="mnger_pw1">��й�ȣ</label>
								<input type="password" id="tempPwd" name="tempPwd" style="display:none;"/>
								<input type="password" id="txtPass" name="txtPass" maxlength="32" class="txt placehd" placeholder="��й�ȣ (8~32�� ����, ����, Ư������ �Է�)">
								<div class="rt">
									<div class="alertBox">
										<span class="bad" id="pw_box"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp">
								<label for="mnger_pw2">��й�ȣ Ȯ��</label>
								<input type="password" id="txtPassChk" name="txtPassChk" maxlength="32" class="txt placehd" placeholder="��й�ȣ Ȯ��">
								<div class="rt">
									<div class="alertBox">
										<span class="bad" id="pw_box2"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp">
								<label for="mnger_nm">ä������ �̸�</label>
								<input type="text" id="txtName" name="txtName" maxlength="10" style="ime-mode:active;" class="txt placehd" placeholder="ä������ �̸� (�Ǹ��Է�)">
								<div class="rt">
									<div class="alertBox">
										<span class="bad"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp">
								<label for="mnger_mail">�̸���</label>
								<input type="text" id="txtEmail" name="txtEmail" maxlength="100" style="ime-mode:disabled;" class="txt placehd" placeholder="�̸���" autocomplete="off">
								<div class="rt">
									<div class="alertBox">
										<span class="bad" id="mail_box"></span>
									</div><!-- .alertBox -->
								</div><!-- .rt -->
							</div><!-- .inp -->
							<!-- 2020.06.11
							<div class="receiveArea">
								<label class="checkbox off" for="compReceive"><input type="checkbox" id="chkAgrMail" name="chkAgrMail" class="chk" value="1"><span>���� ä������ / ���� �������� / �̺�Ʈ ���� ���ſ� �����մϴ�.</span></label>
							</div><!-- .receiveArea 
							-->
							<div class="inp">
								<label for="mnger_hp">�޴��� ��ȣ</label>
								<input type="text" id="txtPhone" name="txtPhone" maxlength="13" class="txt placehd" placeholder="�޴��� ��ȣ" onkeyup="removeChar(event); changePhoneType(this);" onkeydown="<%If 1=2 then%>return onlyNumber(event)<%End if%>">
								<div class="rt">
									<div class="alertBox">
									<span class="num" id="timeCntdown" style="display:none;"><em>(2:59)</em></span>
								</div><!-- .alertBox -->
									<button type="button" class="btn" id="aMobile" onclick="fnAuthSms(); return false;" style="cursor:pointer">������ȣ ����</button>
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="inp" id="rsltAuthArea" style="display:none;">
								<label for="mnger_mobileAuthNumber">������ȣ</label>
								<input type="text" id="mobileAuthNumber" name="mobileAuthNumber" maxlength="6" onkeyup="removeChar(event)" onkeydown="return onlyNumber(event)" class="txt placehd" placeholder="������ȣ">
								<div class="rt">
									<div class="alertBox">
										<p class="good" id="rsltMsg1" style="display:none;">������ȣ�� ���� �Է� �ƽ��ϴ�.</p>
										<p class="bad" id="rsltMsg2" style="display:none;">������ȣ�� Ʋ���ϴ�.</p>
									</div><!-- .alertBox -->
									<button type="button" class="btn" onclick="fnAuthNoChk(); return false;">����Ȯ��</button>
								</div><!-- .rt -->
							</div><!-- .inp -->
							<div class="receiveArea">
								<label class="checkbox off" for="compReceive2"><input type="checkbox" id="chkAgrPrv" name="chkAgrPrv" class="chk" value="1"><span>ä����� SMS ���ſ� �����մϴ�.</span></label>
							</div><!-- .receiveArea -->
						</div><!-- .inputArea -->

					</div><!-- .inputArea -->
					<!-- ���ȸ�� �̿��� -->
					<div class="titArea">
						<h3>�̿��� �� �������� ���� ����</h3>
					</div><!-- .titArea -->
					<div class="agreeArea">
						<div class="rt">
							<label for="agreeallComp" class="off"><span>��ü ���� �մϴ�.</span><input type="checkbox" id="agreeallComp" class="chk" onclick="agreeAllCompFnc(this,'agreechkComp')"></label>
						</div><!-- .rt -->
						<script type="text/javascript">
							$(document).ready(function () {
								$('input[name="agreechkComp"]').click(function () {	// ��ü ����
									if ($('#agreechkComp1').is(':checked') && $('#agreechkComp2').is(':checked')) {
										$('#agreeallComp').prop('checked', true).parent().removeClass('off').addClass('on');
									} else {
										$('#agreeallComp').prop('checked', false).parent().removeClass('on').addClass('off');
									};
								});
							});
							agreeAllCompFnc = function (obj, name) {	//	��ü ����
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
								<label for="agreechkComp1">�̿��� ���� <em>(�ʼ�)</em></label>
								<div class="rt">
									<label class="checkbox off"><input type="checkbox" id="agreechkComp1" class="chk" name="agreechkComp"></label>
									<button type="button" class="btn termsView" style="cursor:pointer"><span>�������</span></button>
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
									<label for="agreechkComp2">�������� ���� �� �̿� ���� <em>(�ʼ�)</em></label>
									<div class="rt">
										<label class="checkbox off"><input type="checkbox" id="agreechkComp2" class="chk" name="agreechkComp"></label>
										<button type="button" class="btn termsView" style="cursor:pointer"><span>�������</span></button>
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
						<!--// ���ȸ�� �̿��� -->


						<div class="btnWrap">
							<button type="button" class="btn typeSky" onclick="javascript:fn_sumbit();" style="cursor:pointer">�ڶ�ȸ ��� ȸ������ �ϱ�</button>
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