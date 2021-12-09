
//컨설턴트 선택(아이디값)
function fn_sel_consultant(_val) {
	
	//날짜 및 시간 초기화
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
			onLoad_Action(); //달력로드
			fn_interview_time_disable();

			if (data == null || data == "") {
				$('#set_consultant_id').val("");
				alert("해당 컨설팅은 신청 가능한 날짜가 없습니다.");
			}
		},
		error: function (req, status, err) {
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
}


//날짜선택
function day_btn_click_20211029(obj) {
	var day_value	= $(obj).val();

	// 당일 컨설팅 신청 가능 시간인 오전 11시 이전일 경우에만 당일 신청 허용
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
			alert("이전 날짜는 선택이 불가능합니다.");
			return false;
		}
	}else{
		if (day_value <= todayToString) {
			alert("오늘을 포함한 이전 날짜는 선택이 불가능합니다.");
			return false;
		}
	}
*/

	if (day_value <= todayToString) {
		alert("오늘을 포함한 이전 날짜는 선택이 불가능합니다.");
		return false;
	}

	var consultant_id = $('#set_consultant_id').val();
	if (consultant_id == "") {
		alert("상단 탭 중에서 신청하실 컨설팅을 먼저 선택해 주세요.");
		return false;
	}

	//선택 클래스
	$(obj).addClass('on');
	$('.day_btn').not(obj).removeClass('on');

	//선택날짜 값설정
	$('#set_interview_day').val(day_value);

	//시간 초기화
	fn_interview_time_reset();
	
	//해당 날짜의 시간값 가져오기
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
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
}

//날짜선택
function day_btn_click(obj) {
	
	console.log($(obj).val());
	var day_value	= $(obj).val();
	
	// 당일 컨설팅 신청 가능 시간인 오전 11시 이전일 경우에만 당일 신청 허용
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
			alert("이전 날짜는 선택이 불가능합니다.");
			return false;
		}
	}else{
		if (day_value <= todayToString) {
			alert("오늘을 포함한 이전 날짜는 선택이 불가능합니다.");
			return false;
		}
	}
*/

	if (day_value <= todayToString) {
		alert("오늘을 포함한 이전 날짜는 선택이 불가능합니다.");
		return false;
	}
	var consul_name = $('#set_consultant_name').val();

	if (consul_name == "" ) {
		alert("학교를 선택해 주시기 바랍니다.");
		return false;
	}

	var consultant_id = $('#set_consultant_id').val();
	if (consultant_id == "") {
		alert("상단 탭 중에서 신청하실 컨설팅을 먼저 선택해 주세요.");
		return false;
	}

	//선택 클래스
	$(obj).addClass('on');
	$('.day_btn').not(obj).removeClass('on');

	//선택날짜 값설정
	$('#set_interview_day').val(day_value);
	
	//시간 초기화
	fn_interview_time_reset();

	//해당 날짜의 시간값 가져오기
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
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
}

//내가 신청한 면접시간 체크
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
						//$(this).parent().next().children("p").text("내꺼");
					}
				}
			});
			radioboxFnc();
		},
		error: function (req, status, err) {
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});

}


//면접시간 disable reset
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


//면접시간 radio 선택 초기화
function fn_interview_time_reset() {
	$('input[name="set_interview_time"]').each(function() {
		this.checked = false;
		$(".sel_area").children("p").text("일자 및 시간을 선택해 주세요.");
	});
	radioboxFnc();//라디오박스
}


//면접시간 radio disable
function fn_interview_time_disable() {
	$('input[name="set_interview_time"]').each(function() {
		//$(this).attr('disabled', true);
		$(this).parent().attr('disabled', true);
		$(this).parent().attr('readonly', true);
		$(this).parent().addClass('disable');
		$(this).parent().removeClass('sel');
	});
	radioboxFnc();//라디오박스
}


//면접시간 선택클릭
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
			alert("현재시간 이전의 시간은 선택이 불가능합니다.");
			fn_interview_time_reset();
			$(".sel_area").children("p").text("대학교와 일자 및 시간을 선택해 주세요.");
		}else{
			$(".sel_area").children("p").text("신청학교 : "+ result_val(set_univ) + " / 신청일 : "+set_day+" / 시간 : "+set_time_full+"");
		}
	}
}

//대학교 코드
function result_val(scode) {
	var result_val = "";
	
	switch(scode){
		case "1"	: result_val = "상명대학교";					break;			 
		case "2"	: result_val = "한국외국어대학교";				break;		     
		case "3"	: result_val = "성균관대학교";					break;			 
		case "4"	: result_val = "건국대학교";					break;			 
		case "5"	: result_val = "세종대학교";					break;			 
		case "6"	: result_val = "숙명여자대학교";					break;			 
		case "7"	: result_val = "명지대학교";					break;			 
		case "8"	: result_val = "서일대학교";					break;			 
		case "9"	: result_val = "삼육대학교";					break;			 
		case "10"	: result_val = "국민대학교";					break;			 
		case "11"	: result_val = "인덕대학교";					break;			 
		case "12"	: result_val = "덕성여자대학교";					break;			 
		case "13"	: result_val = "서울과학기술대학교";				break;			 
		case "14"	: result_val = "서울여자대학교";					break;			 
		case "15"	: result_val = "인하대학교";					break;			 
		case "16"	: result_val = "부천대학교";					break;			 
		case "17"	: result_val = "대진대학교";					break;			 
		case "18"	: result_val = "경복대학교";					break;			 
		case "19"	: result_val = "한국항공대학교";					break;			 
		case "20"	: result_val = "김포대학교";					break;			 
		case "21"	: result_val = "한세대학교";					break;			 
		case "22"	: result_val = "계원예술대학교";					break;			 
		case "23"	: result_val = "안양대학교";					break;			 
		case "24"	: result_val = "경기대학교";					break;			 
		case "25"	: result_val = "아주대학교";					break;			 
		case "26"	: result_val = "용인예술과학대학교(구.용인송담대학교)";	break;			 
		case "27"	: result_val = "협성대학교";					break;			 
		case "28"	: result_val = "장안대학교";					break;			 
		case "29"	: result_val = "가천대학교";					break;			 
		case "30"	: result_val = "동서울대학교";					break;			 
		case "31"	: result_val = "청강문화산업대학교";				break;			 
		case "32"	: result_val = "성결대학교";					break;			 
		case "33"	: result_val = "한국산업기술대학교";				break;			 
		case "34"	: result_val = "오산대학교";					break;			 
		case "35"	: result_val = "한신대학교";					break;			 
		case "36"	: result_val = "한경대학교";					break;			 
		case "37"	: result_val = "강원대학교";					break;			 
		case "38"	: result_val = "한림대학교";					break;			 
		case "39"	: result_val = "연세대학교 미래캠퍼스";				break;			 
		case "40"	: result_val = "한라대학교";					break;			 
		case "41"	: result_val = "가톨릭관동대학교";				break;			 
		case "42"	: result_val = "동의대학교";					break;			 
		case "43"	: result_val = "고신대학교";					break;			 
		case "44"	: result_val = "경성대학교";					break;			 
		case "45"	: result_val = "동명대학교";					break;			 
		case "46"	: result_val = "부경대학교";					break;			 
		case "47"	: result_val = "동아대학교";					break;			 
		case "48"	: result_val = "부산외국어대학교";				break;			 
		case "49"	: result_val = "부산과학기술대학교(동주대,부산여대)";	break;			 
		case "50"	: result_val = "경남정보대학교";					break;			 
		case "51"	: result_val = "동서대학교";					break;			 
		case "52"	: result_val = "창원문성대학교";					break;			 
		case "53"	: result_val = "울산과학대학교";					break;			
		case "54"	: result_val = "영산대학교(동원과기대)"; 			break;
		case "55"	: result_val = "경상국립대학교"; 				break;
		case "56"	: result_val = "경남대학교";					break;			 
		case "57"	: result_val = "대구대학교";					break;			 
		case "58"	: result_val = "영남대학교";					break;			 
		case "59"	: result_val = "영진전문대학교"; 				break;
		case "60"	: result_val = "경일대학교";					break;		 
		case "61"	: result_val = "대구가톨릭대학교";				break;				 
		case "62"	: result_val = "대경대학교";					break;			 
		case "63"	: result_val = "계명대학교";					break;			 
		case "64"	: result_val = "영남이공대학교"; 				break;
		case "65"	: result_val = "동국대학교 경주캠퍼스"; 			break;
		case "66"	: result_val = "위덕대학교";					break;			 
		case "67"	: result_val = "경운대학교";					break;			 
		case "68"	: result_val = "구미대학교";					break;			 
		case "69"	: result_val = "안동대학교";					break;			 
		case "70"	: result_val = "안동과학대학교"; 				break;
		case "71"	: result_val = "동신대학교";					break;			 
		case "72"	: result_val = "조선대학교";					break;			 
		case "73"	: result_val = "전남대학교";					break;			 
		case "74"	: result_val = "전남도립대학교"; 				break;
		case "75"	: result_val = "광주대학교";					break;			 
		case "76"	: result_val = "호남대학교";					break;			 
		case "77"	: result_val = "광주여자대학교"; 				break;
		case "78"	: result_val = "순천제일대학교"; 				break;
		case "79"	: result_val = "순천대학교";					break;			 
		case "80"	: result_val = "전주대학교";					break;			 
		case "81"	: result_val = "우석대학교";					break;			 
		case "82"	: result_val = "전주기전대학교"; 				break;
		case "83"	: result_val = "원광대학교";					break;			 
		case "84"	: result_val = "군산대학교";					break;			 
		case "85"	: result_val = "군장대학교";					break;			 
		case "86"	: result_val = "목포대학교";					break;			 
		case "87"	: result_val = "제주대학교";					break;			   
	    case "88"	: result_val = "배재대학교";					break;			   
		case "89"	: result_val = "한남대학교";					break;			   
		case "90"	: result_val = "한밭대학교";					break;			   
		case "91"	: result_val = "충남대학교";					break;			   
		case "92"	: result_val = "목원대학교";					break;			   
		case "93"	: result_val = "한서대학교";					break;			   
		case "94"	: result_val = "고려대학교 세종캠퍼스";    			break;
		case "95"	: result_val = "서원대학교";					break;			   
		case "96"	: result_val = "청주대학교";					break;			   
		case "97"	: result_val = "호서대학교";					break;			   
		case "98"	: result_val = "남서울대학교";					break;			 
		case "99"	: result_val = "순천향대학교";					break;			 
		case "100"	: result_val = "한국교통대학교";					break;	
	}

	return result_val;	
}

//대학교 disable reset
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

//대학지역 선택
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
				alert("이미 컨설팅을 신청 하셨거나 해당 컨설팅은 신청 가능한 날짜가 없습니다.");
			}
		},
		error: function (req, status, err) {
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
	
}

//대학 선택
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
				alert("해당 컨설팅은 신청 가능한 날짜가 없습니다.");
			}
		},
		error: function (req, status, err) {
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
	$("#set_univ").val(obj.value);
}
