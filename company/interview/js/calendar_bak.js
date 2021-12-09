
function makeCalendar_B(_type) {

	var tmpCalendarHTML;
	var tmpCalendarDate;
	var tmpClass; 
	var tmpTodayClass;

	tmpCalendarHTML = "";
	tmpCalendarDate = "";

	
	// 월,날짜 타이틀 입력
	if (_type == "sch") {
		tmpCalendarDate += '<button type="button" class="btn left" onclick="prev_b_Action(\'sch\');">왼쪽</button>'
		tmpCalendarDate += '<p><span>'+CalBigNowYY.substring(0,4)+'</span>.<span>'+CalBigNowMM.substring(0,2)+'</span>.</p>'
		tmpCalendarDate += '<button type="button" class="btn right" onclick="next_b_Action(\'sch\');">오른쪽</button>'
		$("#sel_calendar_box").html(tmpCalendarDate);
	} else {
		tmpCalendarDate += '<button type="button" class="btn left" onclick="prev_b_Action();">왼쪽</button>'
		tmpCalendarDate += '<p><span>'+CalBigNowYY.substring(0,4)+'</span>.<span>'+CalBigNowMM.substring(0,2)+'</span>.</p>'
		tmpCalendarDate += '<button type="button" class="btn right" onclick="next_b_Action();">오른쪽</button>'
		$("#calendar_date_in").html(tmpCalendarDate);
	}

	// 실제 달력부분 입력
	tmpCalendarHTML += '<table class="calendar_tb">';
	tmpCalendarHTML += '	<colgroup>';
	tmpCalendarHTML += '		<col style="width:38px;">';
	tmpCalendarHTML += '		<col style="width:38px;">';
	tmpCalendarHTML += '		<col style="width:38px;">';
	tmpCalendarHTML += '		<col style="width:38px;">';
	tmpCalendarHTML += '		<col style="width:38px;">';
	tmpCalendarHTML += '		<col style="width:38px;">';
	tmpCalendarHTML += '		<col>';
	tmpCalendarHTML += '	</colgroup>';
	tmpCalendarHTML += '	<thead>';
	tmpCalendarHTML += '		<tr>';
	tmpCalendarHTML += '			<th>일</th>';
	tmpCalendarHTML += '			<th>월</th>';
	tmpCalendarHTML += '			<th>화</th>';
	tmpCalendarHTML += '			<th>수</th>';
	tmpCalendarHTML += '			<th>목</th>';
	tmpCalendarHTML += '			<th>금</th>';
	tmpCalendarHTML += '			<th>토</th>';
	tmpCalendarHTML += '		</tr>';
	tmpCalendarHTML += '	</thead>';
	tmpCalendarHTML += '	<tbody>';

	tmpCalendarHTML += '<tr>';

	//월 1일이전 일요일부터 빈공간 채우기
	for (i=1; i<=parseInt(CalBigStartWW); i++) {
		tmpCalendarHTML += '<td></td>';
	}
	
	//면접배정자 있는 날짜 리스트
	var chk_day = $('#str_set_interview_day').val();

	for (i=1; i<=parseInt(CalBigEndDD); i++) {
		var nowWeek = new Date(CalBigNowYY,CalBigNowMM-1,i).getDay();
		var tmpDTVal = getDateToString(new Date(CalBigNowYY,CalBigNowMM-1,i));
		if(nowWeek == 0){tmpClass = 'day sun'}else if (nowWeek == 6){tmpClass = 'day sat'}else{tmpClass = 'day'}
		if(tmpDTVal == todayToString){tmpTodayClass = 'on'}else{tmpTodayClass = 'none'}

		var class_dot = '';
		if (chk_day.indexOf(tmpDTVal) >= 0) {
			class_dot = ' dot';
		}
		

		if (_type == "sch") {
			tmpCalendarHTML += '<td>';
			tmpCalendarHTML += '	<button type="button" class="day_btn'+ class_dot +'" value="'+ tmpDTVal +'">'+ i +'</button>';
			tmpCalendarHTML += '</td>';
		} else {
			tmpCalendarHTML += '<td>';
			tmpCalendarHTML += '	<button type="button" class="day_btn'+ class_dot +'" value="'+ tmpDTVal +'" onclick="day_btn_click(this)">'+ i +'</button>';
			tmpCalendarHTML += '</td>';
		}

		//토요일 생성 후 줄바꿈
		if (nowWeek == 6) {
			tmpCalendarHTML += "</tr><tr>";
		}
	}
	
	//월 마지막일 이후 토요일까지 빈공간 채우기
	if (parseInt(CalBigLastDD) <= 6) {
		for (i=1; i<=parseInt(CalBigLastDD); i++){
			tmpCalendarHTML += '<td></td>';
		}
	}
	
	tmpCalendarHTML += "</tr>";
	tmpCalendarHTML += "</tbody>";
	tmpCalendarHTML += "</table>";

	if (_type == "sch") {
		document.getElementById("sel_calendar_table").innerHTML = tmpCalendarHTML;
	} else {
		document.getElementById("table-id").innerHTML = tmpCalendarHTML;
	}
	
	//document.getElementById("sel_calendar_table").innerHTML = tmpCalendarHTML;

}

//날짜 클릭
function day_btn_click(obj) {
	var day_value = $(obj).val();

	if (day_value < todayToString) {
		alert("오늘 이전날짜는 선택이 불가능합니다.");
		return false;
	}

	//선택 클래스
	$(obj).addClass('on');
	$('.day_btn').not(obj).removeClass('on');

	fn_set_interview_day(day_value);
	fn_load_preview(day_value);

	fn_interview_applyno_reset();
	fn_interview_time_reset();
}


function getAddDate(DT, iYear, iMonth, iDay){//add날짜(Calendar용)
	var tmpDate = DT;
	var yy = tmpDate.getFullYear();
	var mm = tmpDate.getMonth();
	var dd = tmpDate.getDate();
	var d = new Date();
	//기본 일 선택(29일이나 31일 같은경우 2월이나 기타 30일만 있는경우 month 먼저 변경되면 달이 다음달로 넘어가버리는거 방지)
	d.setFullYear(2000);
	d.setMonth(1);
	d.setDate(1);

	d.setFullYear(yy + iYear);
	d.setMonth(mm + iMonth);
	d.setDate(dd + iDay);

	return d;
}

function getDateToString(DT){//Datetime형 => String 형식으로 형변환
	var tmpDate = DT;
	var yy = tmpDate.getFullYear();
	var mm = getDateAddZero(tmpDate.getMonth()+1);
	var dd = getDateAddZero(tmpDate.getDate());
	var d = yy + '-' + mm + '-' +dd
	return d;
}

function getDateAddZero(val){//월이나 날짜가 10보다 작은경우 앞에 '0' 넣어줌
	var rtn;
	if (val < 10){
		val = '0' + val;
	}
	return val.toString();
}

function getDayOfTheWeek(language, val){
	var tmpVal;
	if (language=='K'){
		switch(val) { 
			case 0 : //일
				tmpVal = '일';
				break;
			case 1 : //월
				tmpVal = '월';
				break;
			case 2 : //화
				tmpVal = '화';
				break;
			case 3 : //수
				tmpVal = '수';
				break;
			case 4 : //목
				tmpVal = '목';
				break;
			case 5 : //금
				tmpVal = '금';
				break;
			case 6 : //토
				tmpVal = '토';
				break;
		}
	}

	if (language=='E'){
		switch(val) { 
			case 0 : //일
				tmpVal = 'sun';
				break;
			case 1 : //월
				tmpVal = 'mon';
				break;
			case 2 : //화
				tmpVal = 'tue';
				break;
			case 3 : //수
				tmpVal = 'wed';
				break;
			case 4 : //목
				tmpVal = 'thu';
				break;
			case 5 : //금
				tmpVal = 'fri';
				break;
			case 6 : //토
				tmpVal = 'sat';
				break;
		}
	}
	
	return tmpVal;
}

//다음버튼
function next_b_Action(_type){//Big Calendar 월 이동
	makeCalendar_B_Action('next', '', _type);
}

//이전버튼
function prev_b_Action(_type){//Big Calendar 월 이동
	makeCalendar_B_Action('prev', '', _type);
}


function makeCalendar_B_Action(act, setDT, _type){
	setDateTime(act, 'Big', setDT);
	makeCalendar_B(_type);

	//날짜클릭 이벤트(선택 클래스)
	/*
	$('.day_btn').click(function() {
		$(this).addClass('on');
		$('.day_btn').not(this).removeClass('on');
		return false;
	});
	*/
}

function makeCalendar_Reset_Action(act, setdate, _type){//날짜 리셋(현재일 기준)
	makeCalendar_B_Action(act, setdate, _type);
}

//##Calendar 구성 스크립트
function setDateTime(act, obj, setDT){	//Calendar 날짜 셋팅

	if (obj == 'Big'){	
		//Big Calendar	
		if (act == 'Today'){//기본값 현재
			switch(tabGubun) { 
				case 'M' : //월간
					//CalBigNowDate				= new Date(today.getFullYear(), today.getMonth(), 1)		//현재 캘린더 기준월의 1일
					CalBigNowDate				= today;													//오늘기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigNowOneDay, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= getAddDate(CalBigStartDate, 0, 0, -CalBigStartWW);		//달력에 출력되는 시작되는날(전달 혹은 시작일)
					CalBigLastDate				= getAddDate(CalBigEndDate, 0, 0, 6-CalBigEndWW);			//달력에 출력되는 종료되는날(다음달 혹은 종료일)
					break;
				case 'W' : //주간
					CalBigNowDate				= today;													//처음엔 오늘기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= getAddDate(CalBigNowDate, 0, 0, -CalBigNowDate.getDay());	//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigNowDate, 0, 0, 6-CalBigNowDate.getDay());//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigStartDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(전달,다음달 구분 필요 없으므로)
					CalBigLastDate				= CalBigEndDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(전달,다음달 구분 필요 없으므로)
					break;
				case 'D' : //일간
					//아래 임시(수정해야함)
					CalBigNowDate				= today;													//처음엔 오늘기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowDate;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= CalBigNowDate;											//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigNowDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(무조건 하루뿐)
					CalBigLastDate				= CalBigNowDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(무조건 하루뿐)
					break;
				case 'L' : //목록
				//아래 임시(수정해야함)
					CalBigNowDate				= today;													//처음엔 오늘기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigStartDate, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigStartDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(해당 월 데이터만 나옴)
					CalBigLastDate				= CalBigEndDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(해당 월 데이터만 나옴)
					break;
			}
		}

		if (act == 'n_date'){//기본값 현재
			switch(tabGubun) { 
				case 'M' : //월간
					CalBigNowDate				= setDT;		//현재 캘린더 기준월의 1일

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigNowOneDay, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= getAddDate(CalBigStartDate, 0, 0, -CalBigStartWW);		//달력에 출력되는 시작되는날(전달 혹은 시작일)
					CalBigLastDate				= getAddDate(CalBigEndDate, 0, 0, 6-CalBigEndWW);			//달력에 출력되는 종료되는날(다음달 혹은 종료일)
					break;
				case 'W' : //주간
					CalBigNowDate				= setDT;													//처음엔 오늘기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= getAddDate(CalBigNowDate, 0, 0, -CalBigNowDate.getDay());	//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigNowDate, 0, 0, 6-CalBigNowDate.getDay());//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigStartDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(전달,다음달 구분 필요 없으므로)
					CalBigLastDate				= CalBigEndDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(전달,다음달 구분 필요 없으므로)
					break;
				case 'D' : //일간
					//아래 임시(수정해야함)
					CalBigNowDate				= setDT;													//처음엔 오늘기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowDate;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= CalBigNowDate;											//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigNowDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(무조건 하루뿐)
					CalBigLastDate				= CalBigNowDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(무조건 하루뿐)
					break;
				case 'L' : //목록
				//아래 임시(수정해야함)
					CalBigNowDate				= setDT;													//처음엔 오늘기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigStartDate, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigStartDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(해당 월 데이터만 나옴)
					CalBigLastDate				= CalBigEndDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(해당 월 데이터만 나옴)
					break;
			}
		}


		if (act=='prev'){//전달 혹은 전주 혹은 전일
			switch(tabGubun) { 
				case 'M' : //월간
					CalBigNowDate				= getAddDate(CalBigNowOneDay, 0, -1, 0);					//Big 현재 캘린더의 기준일(캘린더의 월 표시될 달의 날짜)

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigNowOneDay, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= getAddDate(CalBigStartDate, 0, 0, -CalBigStartWW);		//달력에 출력되는 시작되는날(전달 혹은 시작일)
					CalBigLastDate				= getAddDate(CalBigEndDate, 0, 0, 6-CalBigEndWW);			//달력에 출력되는 종료되는날(다음달 혹은 종료일)


					break;
				case 'W' : //주간
					CalBigNowDate				= getAddDate(CalBigFirstDate, 0, 0, -7);					//이전으로 이동시 현재 첫날 기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= getAddDate(CalBigNowDate, 0, 0, -CalBigNowDate.getDay());	//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigNowDate, 0, 0, 6-CalBigNowDate.getDay());	//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigStartDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(월 구분 없이 7일만큼만 출력되므로)
					CalBigLastDate				= CalBigEndDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(월 구분 없이 7일만큼만 출력되므로)
					break;
				case 'D' : //일간
					CalBigNowDate				= getAddDate(CalBigFirstDate, 0, 0, -1);					//이전날 기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowDate;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= CalBigNowDate;											//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigNowDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(무조건 하루뿐)
					CalBigLastDate				= CalBigNowDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(무조건 하루뿐)
					break;
				case 'L' : //목록
					CalBigNowDate				= getAddDate(CalBigFirstDate, 0, -1, 0);					//이전달 기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigStartDate, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigStartDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(해당 월 데이터만 나옴)
					CalBigLastDate				= CalBigEndDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(해당 월 데이터만 나옴)
					break;
			}
		}
		
		if (act=='next'){//다음달 혹은 다음주 혹은 다음일
			switch(tabGubun) { 
				case 'M' : //월간
					CalBigNowDate				= getAddDate(CalBigNowOneDay, 0, +1, 0);					//Big 현재 캘린더의 기준일(캘린더의 월 표시될 달의 날짜)

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigStartDate, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= getAddDate(CalBigStartDate, 0, 0, -CalBigStartWW);		//달력에 출력되는 시작되는날(전달 혹은 시작일)
					CalBigLastDate				= getAddDate(CalBigEndDate, 0, 0, 6-CalBigEndWW);			//달력에 출력되는 종료되는날(다음달 혹은 종료일)


					break;
				case 'W' : //주간
					CalBigNowDate				= getAddDate(CalBigFirstDate, 0, 0, +7);					//다음으로 이동시 현재 첫날 기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= getAddDate(CalBigNowDate, 0, 0, -CalBigNowDate.getDay());	//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigNowDate, 0, 0, 6-CalBigNowDate.getDay());	//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigStartDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(월 구분 없이 7일만큼만 출력되므로)
					CalBigLastDate				= CalBigEndDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(월 구분 없이 7일만큼만 출력되므로)
					break;
				case 'D' : //일간
					CalBigNowDate				= getAddDate(CalBigFirstDate, 0, 0, +1);					//다음날 기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowDate;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= CalBigNowDate;											//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigNowDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(무조건 하루뿐)
					CalBigLastDate				= CalBigNowDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(무조건 하루뿐)
					break;
				case 'L' : //목록
					CalBigNowDate				= getAddDate(CalBigFirstDate, 0, +1, 0);					//이전달 기준

					CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

					CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
					CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

					CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
					CalBigEndDate				= getAddDate(CalBigStartDate, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

					CalBigFirstDate				= CalBigStartDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(해당 월 데이터만 나옴)
					CalBigLastDate				= CalBigEndDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(해당 월 데이터만 나옴)
					break;
			}
		}

		if (act == 'day'){//SmallCalendar에서 날짜 선택시
			CalBigNowDate				= setDT;														//선택일자 기준

			CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

			CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
			CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

			CalBigStartDate				= CalBigNowDate;											//Big 캘린더의 시작일(이달의 몇일)
			CalBigEndDate				= CalBigNowDate;											//Big 캘린더의 마지막일(이달의 몇일)

			CalBigFirstDate				= CalBigNowDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(무조건 하루뿐)
			CalBigLastDate				= CalBigNowDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(무조건 하루뿐)
		}

		if (act == 'n_month'){//SmallCalendar에서 날짜 선택시
			CalBigNowDate				= setDT;														//선택일자 기준

			CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

			CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
			CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

			CalBigStartDate				= CalBigNowOneDay;											//Big 캘린더의 시작일(이달의 몇일)
			CalBigEndDate				= getAddDate(CalBigStartDate, 0, +1, -1);					//Big 캘린더의 마지막일(이달의 몇일)

			CalBigFirstDate				= getAddDate(CalBigStartDate, 0, 0, -CalBigStartWW);		//달력에 출력되는 시작되는날(전달 혹은 시작일)
			CalBigLastDate				= getAddDate(CalBigEndDate, 0, 0, 6-CalBigEndWW);			//달력에 출력되는 종료되는날(다음달 혹은 종료일)
		}

		if (diart_date != 'empty' && diart_date_clear != 'clear'){
			var set_diart_date = new Date(diart_date.substring(0,4), parseInt(diart_date.substring(5,7)-1), diart_date.substring(8,10));
			CalBigNowDate				= set_diart_date;														//선택일자 기준

			CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);//현재 캘린더 기준월의 1일

			CalBigStartWW				= CalBigNowOneDay.getDay();									//현재월 1일의 요일
			CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();			//현재월 마지막일의 요일

			CalBigStartDate				= CalBigNowDate;											//Big 캘린더의 시작일(이달의 몇일)
			CalBigEndDate				= CalBigNowDate;											//Big 캘린더의 마지막일(이달의 몇일)

			CalBigFirstDate				= CalBigNowDate;											//달력에 출력되는 시작되는날(전달 혹은 시작일) - 상동(무조건 하루뿐)
			CalBigLastDate				= CalBigNowDate;											//달력에 출력되는 종료되는날(다음달 혹은 종료일) - 상동(무조건 하루뿐)

			CalSmallNowDate				= set_diart_date;

			diart_date_clear = 'clear';
		}
		
		CalBigNowDateToString		= getDateToString(CalBigNowDate);
		CalBigNowOneDayToString		= getDateToString(CalBigNowOneDay);

		CalBigStartDateToString		= getDateToString(CalBigStartDate);
		CalBigEndDateToString		= getDateToString(CalBigEndDate);

		CalBigFirstDateToString		= getDateToString(CalBigFirstDate);
		CalBigLastDateToString		= getDateToString(CalBigLastDate);

		CalBigNowYY					= CalBigNowDate.getFullYear().toString();			//Big 현재 켈린더의 기준일 년
		CalBigNowMM					= getDateAddZero(CalBigNowDate.getMonth()+1);		//Big 현재 켈린더의 기준일 월
		CalBigNowDD 				= getDateAddZero(CalBigNowDate.getDate());			//Big 현재 켈린더의 기준일 일

		CalBigStartYY				= CalBigStartDate.getFullYear().toString();			//Big 캘린더의 시작일 년
		CalBigStartMM 				= getDateAddZero(CalBigStartDate.getMonth()+1);		//Big 캘린더의 시작일 월
		CalBigStartDD				= getDateAddZero(CalBigStartDate.getDate());		//Big 캘린더의 시작일 일
		CalBigEndYY					= CalBigEndDate.getFullYear().toString();			//Big 캘린더의 마지막일 년(이번달 말일)
		CalBigEndMM					= getDateAddZero(CalBigEndDate.getMonth()+1);		//Big 캘린더의 마지막일 월
		CalBigEndDD					= getDateAddZero(CalBigEndDate.getDate());			//Big 캘린더의 마지막일 일

		CalBigFirstYY				= CalBigFirstDate.getFullYear().toString();			//Big 캘린더의 마지막일 년(전달 혹은 시작일)
		CalBigFirstMM 				= getDateAddZero(CalBigFirstDate.getMonth()+1);		//Big 캘린더의 마지막일 월
		CalBigFirstDD				= getDateAddZero(CalBigFirstDate.getDate());		//Big 캘린더의 마지막일 일
		CalBigLastYY				= CalBigLastDate.getFullYear().toString();			//Big 캘린더의 마지막일 년(다음달 혹은 종료일)
		CalBigLastMM 				= getDateAddZero(CalBigLastDate.getMonth()+1);		//Big 캘린더의 마지막일 월
		CalBigLastDD				= getDateAddZero(CalBigLastDate.getDate());			//Big 캘린더의 마지막일 일
			
		//Big 달력 이동시 Small 달력도 같은 기준으로 이동하기 위함(setDateTime(act, 'Small') 호출시 +-1 달씩 이동되므로 동기화 위해 미리 +-1달을 해줌)
		if (act=='prev'){//전달 혹은 전주 혹은 전일
			CalSmallNowOneDay			= getAddDate(CalBigNowOneDay, 0, +1, 0);
		}	
		if (act=='next'){//다음달 혹은 다음주 혹은 다음일
			CalSmallNowOneDay			= getAddDate(CalBigNowOneDay, 0, -1, 0); 
		}
	}
}

//버튼액션
function onLoad_Action(_type) {	
	//Calendar 구성
	makeCalendar_B_Action('', '', _type);
}

//전역변수 셋팅(맨 처음 현재 기준으로 셋팅 #월간기준)
var tabGubun = 'M';
var tabGubun2 = '00';


function loadingBarCall(obj, TF,str){
	//이동할 위치 obj X, Y값 구하여 이동
	if (TF){
		var objX = $(obj).offset().left-($('#loading_'+str+'DIV').width()/2)+($(obj).width()/2);
		var objY = $(obj).offset().top+($(obj).height()/2)-($('#loading_'+str+'DIV').height()/2);
		//var objX = 450;
		//var objY = 300;
		//if (document.body.clientWidth >= $("#career_wrap").width()){//중앙정렬이라서...
		//	objX = objX - (document.body.clientWidth - $("#career_wrap").width())/2;
		//}

		var objXY = {"top":objY, "left":objX};
		$('#loading_'+str+'DIV').animate(objXY, 0);
		$('#loading_'+str+'DIV').fadeIn("normal");
	}else{
		$('#loading_'+str+'DIV').fadeOut("normal");
	}
}



var btn_slide_click_chk = 1;
//var small_action_chk = 1;			//작은달력 안보일때 큰달력에서 액션값 무시
var diart_date_clear = 'empty';		//커리어 다이어리에서 넘어온 일자 초기화 세팅
var today						= new Date();										//현재일
var todayToString				= getDateToString(today);							//String형 현재일	

//Big Calendar
var CalBigNowDate				= today;											//big 현재 캘린더의 기준일(캘린더의 월 표시될 달의 날짜)
var CalBigNowDateToString		= getDateToString(CalBigNowDate);
var CalBigNowOneDay				= new Date(CalBigNowDate.getFullYear(), CalBigNowDate.getMonth(), 1);	//현재 캘린더 기준월의 1일
var CalBigNowOneDayToString		= getDateToString(CalBigNowOneDay);

var CalBigStartWW				= CalBigNowOneDay.getDay();							//현재월 1일의 요일
var CalBigEndWW					= getAddDate(CalBigNowOneDay, 0, +1, -1).getDay();	//현재월 마지막일의 요일

var CalBigStartDate				= CalBigNowOneDay;									//Big 캘린더의 시작일(이달의 몇일)
var CalBigStartDateToString		= getDateToString(CalBigStartDate);
var CalBigEndDate				= getAddDate(CalBigStartDate, 0, +1, -1);			//Big 캘린더의 마지막일(이달의 몇일)
var CalBigEndDateToString		= getDateToString(CalBigEndDate);

var CalBigFirstDate				= getAddDate(CalBigNowOneDay, 0, 0, -CalBigStartWW);//달력에 출력되는 시작되는날(전달 혹은 시작일)
var CalBigFirstDateToString		= getDateToString(CalBigFirstDate);
var CalBigLastDate				= getAddDate(CalBigEndDate, 0, 0, +6-CalBigEndWW);	//달력에 출력되는 종료되는날(다음달 혹은 종료일)
var CalBigLastDateToString		= getDateToString(CalBigLastDate);

var CalBigNowYY					= CalBigNowDate.getFullYear().toString();			//Big 현재 켈린더의 기준일 년
var CalBigNowMM					= getDateAddZero(CalBigNowDate.getMonth()+1);		//Big 현재 켈린더의 기준일 월
var CalBigNowDD 				= getDateAddZero(CalBigNowDate.getDate());			//Big 현재 켈린더의 기준일 일

var CalBigStartYY				= CalBigStartDate.getFullYear().toString();			//big 캘린더의 시작일 년
var CalBigStartMM 				= getDateAddZero(CalBigStartDate.getMonth()+1);		//big 캘린더의 시작일 월
var CalBigStartDD				= getDateAddZero(CalBigStartDate.getDate());		//big 캘린더의 시작일 일
var CalBigEndYY					= CalBigEndDate.getFullYear().toString();			//big 캘린더의 마지막일 년(이번달 말일)
var CalBigEndMM					= getDateAddZero(CalBigEndDate.getMonth()+1);		//big 캘린더의 마지막일 월
var CalBigEndDD					= getDateAddZero(CalBigEndDate.getDate());			//big 캘린더의 마지막일 일

var CalBigFirstYY				= CalBigFirstDate.getFullYear().toString();			//big 캘린더의 마지막일 년(전달 혹은 시작일)
var CalBigFirstMM 				= getDateAddZero(CalBigFirstDate.getMonth()+1);		//big 캘린더의 마지막일 월
var CalBigFirstDD				= getDateAddZero(CalBigFirstDate.getDate());		//big 캘린더의 마지막일 일
var CalBigLastYY				= CalBigLastDate.getFullYear();						//big 캘린더의 마지막일 년(다음달 혹은 종료일)
var CalBigLastMM 				= getDateAddZero(CalBigLastDate.getMonth()+1);		//big 캘린더의 마지막일 월
var CalBigLastDD				= getDateAddZero(CalBigLastDate.getDate());			//big 캘린더의 마지막일 일


//Small Calendar
var CalSmallNowDate				= today;											//Small 현재 캘린더의 기준일(캘린더의 월 표시될 달의 날짜)
var CalSmallNowDateToString		= getDateToString(CalSmallNowDate);
var CalSmallNowOneDay			= new Date(CalSmallNowDate.getFullYear(), CalSmallNowDate.getMonth(), 1);	//현재 캘린더 기준월의 1일
var CalSmallNowOneDayToString	= getDateToString(CalSmallNowOneDay);

var CalSmallStartWW				= CalSmallNowOneDay.getDay();						//현재월 1일의 요일
var CalSmallEndWW				= getAddDate(CalSmallNowOneDay, 0, +1, -1).getDay();//현재월 마지막일의 요일

var CalSmallStartDate			= CalSmallNowOneDay;								//Small 캘린더의 시작일(이달의 몇일)
var CalSmallStartDateToString	= getDateToString(CalSmallStartDate);
var CalSmallEndDate				= getAddDate(CalSmallStartDate, 0, +1, -1);			//Small 캘린더의 마지막일(이달의 몇일)
var CalSmallEndDateToString		= getDateToString(CalSmallEndDate);

var CalSmallFirstDate			= getAddDate(CalSmallNowOneDay, 0, 0, -CalSmallStartWW);	//달력에 출력되는 시작되는날(전달 혹은 시작일)
var CalSmallFirstDateToString	= getDateToString(CalSmallFirstDate);
var CalSmallLastDate			= getAddDate(CalSmallEndDate, 0, 0, 6-CalSmallEndWW);//달력에 출력되는 종료되는날(다음달 혹은 종료일)
var CalSmallLastDateToString	= getDateToString(CalSmallLastDate);

var CalSmallNowYY				= CalSmallNowDate.getFullYear().toString();			//Small 현재 켈린더의 기준일 년
var CalSmallNowMM				= getDateAddZero(CalSmallNowDate.getMonth()+1);		//Small 현재 켈린더의 기준일 월
var CalSmallNowDD 				= getDateAddZero(CalSmallNowDate.getDate());		//Small 현재 켈린더의 기준일 일

var CalSmallStartYY				= CalSmallStartDate.getFullYear().toString();		//Small 캘린더의 시작일 년
var CalSmallStartMM 			= getDateAddZero(CalSmallStartDate.getMonth()+1);	//Small 캘린더의 시작일 월
var CalSmallStartDD				= getDateAddZero(CalSmallStartDate.getDate());		//Small 캘린더의 시작일 일
var CalSmallEndYY				= CalSmallEndDate.getFullYear().toString();			//Small 캘린더의 마지막일 년(이번달 말일)
var CalSmallEndMM				= getDateAddZero(CalSmallEndDate.getMonth()+1);		//Small 캘린더의 마지막일 월
var CalSmallEndDD				= getDateAddZero(CalSmallEndDate.getDate());		//Small 캘린더의 마지막일 일

var CalSmallFirstYY				= CalSmallFirstDate.getFullYear().toString();		//Small 캘린더의 마지막일 년(전달 혹은 시작일)
var CalSmallFirstMM 			= getDateAddZero(CalSmallFirstDate.getMonth()+1);	//Small 캘린더의 마지막일 월
var CalSmallFirstDD				= getDateAddZero(CalSmallFirstDate.getDate());		//Small 캘린더의 마지막일 일
var CalSmallLastYY				= CalSmallLastDate.getFullYear().toString();		//Small 캘린더의 마지막일 년(다음달 혹은 종료일)
var CalSmallLastMM 				= getDateAddZero(CalSmallLastDate.getMonth()+1);	//Small 캘린더의 마지막일 월
var CalSmallLastDD				= getDateAddZero(CalSmallLastDate.getDate());		//Small 캘린더의 마지막일 일

var dt = new Date();
var nn_year = dt.getFullYear();
var nn_month = dt.getMonth()+1;
if (nn_month < 10)
{
	nn_month= "0"+nn_month;
}
var nn_day = dt.getDate();
if (nn_day < 10)
{
	nn_day= "0"+nn_day;
}
var nn_hour = dt.getHours();
if (nn_hour < 10)
{
	nn_hour= "0"+nn_hour;
}
var nn_minute = dt.getMinutes();
if (nn_minute < 10)
{
	nn_minute= "0"+nn_minute;
}
var nn_second = dt.getSeconds();
if (nn_second < 10)
{
	nn_second= "0"+nn_second;
}
var nn_s_state = nn_year+nn_month+nn_day+nn_hour+nn_minute+nn_second;
var summary_layout_v = "t";
var summary_layout_seq = "";