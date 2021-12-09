
//������Ʈ ����(���̵�)
function fn_sel_consultant(_val) {
	
	//��¥ �� �ð� �ʱ�ȭ
	$('#set_interview_day').val("");
	fn_interview_time_reset();

	$.ajax({
		url: "./ajax_get_schedule.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"consultant_id": _val,
		}),
		success: function (data) {
			$('#set_consultant_id').val(_val);
			$('#str_set_interview_day').val(data);
			onLoad_Action(); //�޷·ε�
			fn_interview_time_disable();

			if (data == null || data == "") {
				$('#set_consultant_id').val("");
				alert("�ش� �������� ��û ������ ��¥�� �����ϴ�.");
			}
		},
		error: function (req, status, err) {
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
}


//��¥����
function day_btn_click_20211029(obj) {
	var day_value	= $(obj).val();

	// ���� ������ ��û ���� �ð��� ���� 11�� ������ ��쿡�� ���� ��û ���
	var hours		= (new Date()).getHours();
	var minutes		= (new Date()).getMinutes();

	var num			= hours.toString();
	var numDigit	= num.length;
	var num2		= minutes.toString();
	var numDigit2	= num2.length;
	var chkTm;

	if (numDigit == 1){
		chkH = "0"+hours;	
	}else{
		chkH = hours;
	}

	if (numDigit2 == 1){
		chkM = "0"+minutes;	
	}else{
		chkM = minutes;
	}

	chkTm = chkH+":"+chkM;
/*
	if (chkTm < "11:00"){
		if (day_value < todayToString) {
			alert("���� ��¥�� ������ �Ұ����մϴ�.");
			return false;
		}
	}else{
		if (day_value <= todayToString) {
			alert("������ ������ ���� ��¥�� ������ �Ұ����մϴ�.");
			return false;
		}
	}
*/

	if (day_value <= todayToString) {
		alert("������ ������ ���� ��¥�� ������ �Ұ����մϴ�.");
		return false;
	}

	var consultant_id = $('#set_consultant_id').val();
	if (consultant_id == "") {
		alert("��� �� �߿��� ��û�Ͻ� �������� ���� ������ �ּ���.");
		return false;
	}

	//���� Ŭ����
	$(obj).addClass('on');
	$('.day_btn').not(obj).removeClass('on');

	//���ó�¥ ������
	$('#set_interview_day').val(day_value);

	//�ð� �ʱ�ȭ
	fn_interview_time_reset();
	
	//�ش� ��¥�� �ð��� ��������
	$.ajax({
		url: "./ajax_get_schedule_time.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"consultant_id": consultant_id,
			"consultant_day": day_value,
		}),
		success: function (data) {
			$('#str_set_interview_time').val(data);
			fn_interview_time_disable();
			fn_interview_time_disable_reset(data);
			fn_chk_user_interview_time();
		},
		error: function (req, status, err) {
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
}

//��¥����
function day_btn_click(obj) {
	
	console.log($(obj).val());
	var day_value	= $(obj).val();
	
	// ���� ������ ��û ���� �ð��� ���� 11�� ������ ��쿡�� ���� ��û ���
	var hours		= (new Date()).getHours();
	var minutes		= (new Date()).getMinutes();

	var num			= hours.toString();
	var numDigit	= num.length;
	var num2		= minutes.toString();
	var numDigit2	= num2.length;
	var chkTm;

	if (numDigit == 1){
		chkH = "0"+hours;	
	}else{
		chkH = hours;
	}

	if (numDigit2 == 1){
		chkM = "0"+minutes;	
	}else{
		chkM = minutes;
	}

	chkTm = chkH+":"+chkM;
/*
	if (chkTm < "11:00"){
		if (day_value < todayToString) {
			alert("���� ��¥�� ������ �Ұ����մϴ�.");
			return false;
		}
	}else{
		if (day_value <= todayToString) {
			alert("������ ������ ���� ��¥�� ������ �Ұ����մϴ�.");
			return false;
		}
	}
*/

	if (day_value <= todayToString) {
		alert("������ ������ ���� ��¥�� ������ �Ұ����մϴ�.");
		return false;
	}
	var consul_name = $('#set_consultant_name').val();

	if (consul_name == "" ) {
		alert("�б��� ������ �ֽñ� �ٶ��ϴ�.");
		return false;
	}

	var consultant_id = $('#set_consultant_id').val();
	if (consultant_id == "") {
		alert("��� �� �߿��� ��û�Ͻ� �������� ���� ������ �ּ���.");
		return false;
	}

	//���� Ŭ����
	$(obj).addClass('on');
	$('.day_btn').not(obj).removeClass('on');

	//���ó�¥ ������
	$('#set_interview_day').val(day_value);
	
	//�ð� �ʱ�ȭ
	fn_interview_time_reset();

	//�ش� ��¥�� �ð��� ��������
	$.ajax({
		url: "./ajax_get_schedule_time_V2.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"consultant_id": consultant_id,
			"consultant_day": day_value,
			"consul_name": consul_name,
		}),
		success: function (data) {
			$('#str_set_interview_time').val(data);
			fn_interview_time_disable();
			fn_interview_time_disable_reset(data);
			fn_chk_user_interview_time();
		},
		error: function (req, status, err) {
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
}

//���� ��û�� �����ð� üũ
function fn_chk_user_interview_time() {
	var consultant_id	= $('#set_consultant_id').val();
	var consultant_day	= $('#set_interview_day').val();

	if (consultant_id == "" || consultant_id == null || consultant_day == "" || consultant_day == null) {
		return;
	}

	$.ajax({
		url: "./ajax_get_consulting_apply.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"consultant_id": consultant_id,
			"consultant_day": consultant_day,
		}),
		success: function (data) {
			var time_val = data.split(",");
			$('input[name="set_interview_time"]').each(function() {
				for (var i=0; i<time_val.length; i++) {
					if (time_val[i] == this.value) {
						$(this).parent().addClass('sel');
						//$(this).parent().next().children("p").text("����");
					}
				}
			});
			radioboxFnc();
		},
		error: function (req, status, err) {
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});

}


//�����ð� disable reset
function fn_interview_time_disable_reset(_val) {
	var time_val = _val.split(",");
	$('input[name="set_interview_time"]').each(function() {
		for (var i=0; i<time_val.length; i++) {
			if (time_val[i] == this.value) {
				$(this).parent().attr('disabled', false);
				$(this).parent().attr('readonly', false);
				$(this).parent().removeClass('disable');
				$(this).attr('disabled', false);
			}
		}
	});

	radioboxFnc();
}


//�����ð� radio ���� �ʱ�ȭ
function fn_interview_time_reset() {
	$('input[name="set_interview_time"]').each(function() {
		this.checked = false;
		$(".sel_area").children("p").text("���� �� �ð��� ������ �ּ���.");
	});
	radioboxFnc();//�����ڽ�
}


//�����ð� radio disable
function fn_interview_time_disable() {
	$('input[name="set_interview_time"]').each(function() {
		//$(this).attr('disabled', true);
		$(this).parent().attr('disabled', true);
		$(this).parent().attr('readonly', true);
		$(this).parent().addClass('disable');
		$(this).parent().removeClass('sel');
	});
	radioboxFnc();//�����ڽ�
}


//�����ð� ����Ŭ��
function fn_time_set(_obj) {
	var set_day			= $('#set_interview_day').val();
	var set_time		= $(_obj).parent().next().html().substring(0, 5);
	var set_time_full	= $(_obj).parent().next().html();
	var set_univ		= $('#set_univ').val();

	if (set_day == "") {
		return;
	} else {
		var today_date	= new Date();
		var set_date	= new Date(set_day.split("-")[0], set_day.split("-")[1] -1, set_day.split("-")[2], set_time.split(":")[0], set_time.split(":")[1]);

		if (set_date < today_date) {
			alert("����ð� ������ �ð��� ������ �Ұ����մϴ�.");
			fn_interview_time_reset();
			$(".sel_area").children("p").text("���б��� ���� �� �ð��� ������ �ּ���.");
		}else{
			$(".sel_area").children("p").text("��û�б� : "+ result_val(set_univ) + " / ��û�� : "+set_day+" / �ð� : "+set_time_full+"");
		}
	}
}

//���б� �ڵ�
function result_val(scode) {
	var result_val = "";
	
	switch(scode){
		case "1"	: result_val = "�����б�";					break;			 
		case "2"	: result_val = "�ѱ��ܱ�����б�";				break;		     
		case "3"	: result_val = "���հ����б�";					break;			 
		case "4"	: result_val = "�Ǳ����б�";					break;			 
		case "5"	: result_val = "�������б�";					break;			 
		case "6"	: result_val = "�����ڴ��б�";					break;			 
		case "7"	: result_val = "�������б�";					break;			 
		case "8"	: result_val = "���ϴ��б�";					break;			 
		case "9"	: result_val = "�������б�";					break;			 
		case "10"	: result_val = "���δ��б�";					break;			 
		case "11"	: result_val = "�δ����б�";					break;			 
		case "12"	: result_val = "�������ڴ��б�";					break;			 
		case "13"	: result_val = "������б�����б�";				break;			 
		case "14"	: result_val = "���￩�ڴ��б�";					break;			 
		case "15"	: result_val = "���ϴ��б�";					break;			 
		case "16"	: result_val = "��õ���б�";					break;			 
		case "17"	: result_val = "�������б�";					break;			 
		case "18"	: result_val = "�溹���б�";					break;			 
		case "19"	: result_val = "�ѱ��װ����б�";					break;			 
		case "20"	: result_val = "�������б�";					break;			 
		case "21"	: result_val = "�Ѽ����б�";					break;			 
		case "22"	: result_val = "����������б�";					break;			 
		case "23"	: result_val = "�Ⱦ���б�";					break;			 
		case "24"	: result_val = "�����б�";					break;			 
		case "25"	: result_val = "���ִ��б�";					break;			 
		case "26"	: result_val = "���ο������д��б�(��.���μ۴���б�)";	break;			 
		case "27"	: result_val = "�������б�";					break;			 
		case "28"	: result_val = "��ȴ��б�";					break;			 
		case "29"	: result_val = "��õ���б�";					break;			 
		case "30"	: result_val = "��������б�";					break;			 
		case "31"	: result_val = "û����ȭ������б�";				break;			 
		case "32"	: result_val = "������б�";					break;			 
		case "33"	: result_val = "�ѱ����������б�";				break;			 
		case "34"	: result_val = "������б�";					break;			 
		case "35"	: result_val = "�ѽŴ��б�";					break;			 
		case "36"	: result_val = "�Ѱ���б�";					break;			 
		case "37"	: result_val = "�������б�";					break;			 
		case "38"	: result_val = "�Ѹ����б�";					break;			 
		case "39"	: result_val = "�������б� �̷�ķ�۽�";				break;			 
		case "40"	: result_val = "�Ѷ���б�";					break;			 
		case "41"	: result_val = "���縯�������б�";				break;			 
		case "42"	: result_val = "���Ǵ��б�";					break;			 
		case "43"	: result_val = "��Ŵ��б�";					break;			 
		case "44"	: result_val = "�漺���б�";					break;			 
		case "45"	: result_val = "������б�";					break;			 
		case "46"	: result_val = "�ΰ���б�";					break;			 
		case "47"	: result_val = "���ƴ��б�";					break;			 
		case "48"	: result_val = "�λ�ܱ�����б�";				break;			 
		case "49"	: result_val = "�λ���б�����б�(���ִ�,�λ꿩��)";	break;			 
		case "50"	: result_val = "�泲�������б�";					break;			 
		case "51"	: result_val = "�������б�";					break;			 
		case "52"	: result_val = "â���������б�";					break;			 
		case "53"	: result_val = "�����д��б�";					break;			
		case "54"	: result_val = "������б�(���������)"; 			break;
		case "55"	: result_val = "��󱹸����б�"; 				break;
		case "56"	: result_val = "�泲���б�";					break;			 
		case "57"	: result_val = "�뱸���б�";					break;			 
		case "58"	: result_val = "�������б�";					break;			 
		case "59"	: result_val = "�����������б�"; 				break;
		case "60"	: result_val = "���ϴ��б�";					break;		 
		case "61"	: result_val = "�뱸���縯���б�";				break;				 
		case "62"	: result_val = "�����б�";					break;			 
		case "63"	: result_val = "�����б�";					break;			 
		case "64"	: result_val = "�����̰����б�"; 				break;
		case "65"	: result_val = "�������б� ����ķ�۽�"; 			break;
		case "66"	: result_val = "�������б�";					break;			 
		case "67"	: result_val = "�����б�";					break;			 
		case "68"	: result_val = "���̴��б�";					break;			 
		case "69"	: result_val = "�ȵ����б�";					break;			 
		case "70"	: result_val = "�ȵ����д��б�"; 				break;
		case "71"	: result_val = "���Ŵ��б�";					break;			 
		case "72"	: result_val = "�������б�";					break;			 
		case "73"	: result_val = "�������б�";					break;			 
		case "74"	: result_val = "�����������б�"; 				break;
		case "75"	: result_val = "���ִ��б�";					break;			 
		case "76"	: result_val = "ȣ�����б�";					break;			 
		case "77"	: result_val = "���ֿ��ڴ��б�"; 				break;
		case "78"	: result_val = "��õ���ϴ��б�"; 				break;
		case "79"	: result_val = "��õ���б�";					break;			 
		case "80"	: result_val = "���ִ��б�";					break;			 
		case "81"	: result_val = "�켮���б�";					break;			 
		case "82"	: result_val = "���ֱ������б�"; 				break;
		case "83"	: result_val = "�������б�";					break;			 
		case "84"	: result_val = "������б�";					break;			 
		case "85"	: result_val = "������б�";					break;			 
		case "86"	: result_val = "�������б�";					break;			 
		case "87"	: result_val = "���ִ��б�";					break;			   
	    case "88"	: result_val = "������б�";					break;			   
		case "89"	: result_val = "�ѳ����б�";					break;			   
		case "90"	: result_val = "�ѹ���б�";					break;			   
		case "91"	: result_val = "�泲���б�";					break;			   
		case "92"	: result_val = "������б�";					break;			   
		case "93"	: result_val = "�Ѽ����б�";					break;			   
		case "94"	: result_val = "������б� ����ķ�۽�";    			break;
		case "95"	: result_val = "�������б�";					break;			   
		case "96"	: result_val = "û�ִ��б�";					break;			   
		case "97"	: result_val = "ȣ�����б�";					break;			   
		case "98"	: result_val = "��������б�";					break;			 
		case "99"	: result_val = "��õ����б�";					break;			 
		case "100"	: result_val = "�ѱ�������б�";					break;	
	}

	return result_val;	
}

//���б� disable reset
function fn_univ_radio_add(_val) {
	$("#div_univ_id *").remove();
	var univ_val = _val.split(",");
	if (_val != "") {
		for (var i=0; i<univ_val.length; i++) {
			fn_univ_txt_add(univ_val[i],result_val(univ_val[i]));
		}
	}else {
		for (var i=1; i<=100; i++) {
			fn_univ_txt_add(i,result_val(String(i)));
		}
	}
}

function fn_univ_txt_add(no,txt) {

	var html = "";

	html += "<div class='tp'>";
	html += "	<label class='lb'>";
	html += "		<input type='radio' value='"+no+"' id='rdi_chk5_"+no+"' name='rdi_univ'  onclick='fn_rdi_univ(this);'>";
	html += "			<div class='slb'>";
	html += "				<span class='in'>"+txt+"</span>";
	html += "			</div>";
	html += "	</label>";
	html += "</div>";

	$("#div_univ_id").append(html);
}

//�������� ����
function fn_rdi_area_univ(obj) {
	fn_interview_time_disable();
	console.log(obj.value);
	$.ajax({
		url: "./ajax_get_univ.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"chk_areaUniv": obj.value,
		}),
		success: function (data) {
			$('#hid_chkareauniv').val(data);
			fn_univ_radio_add(data);
			if (data == null || data == "") {
				alert("�̹� �������� ��û �ϼ̰ų� �ش� �������� ��û ������ ��¥�� �����ϴ�.");
			}
		},
		error: function (req, status, err) {
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
	
}

//���� ����
function fn_rdi_univ(obj) {
	var sel_day = $('#set_interview_day').val();
	$("input[name=rdi_univ]").parents().removeClass("on");
	$(obj).parents().addClass("on");
	$.ajax({
		url: "./ajax_get_univ_consultant.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"chk_Univ": obj.value,
		}),
		success: function (data) {
			$('#set_consultant_name').val(data);
			day_btn_click(sel_day);
			if (data == null || data == "") {
				alert("�ش� �������� ��û ������ ��¥�� �����ϴ�.");
			}
		},
		error: function (req, status, err) {
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
	$("#set_univ").val(obj.value);
}
