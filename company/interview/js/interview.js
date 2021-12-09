function fn_set_interview_day(_val) {
	$('#set_interview_day').val(_val);
}


//서류합격자 리스트 불러오기
function fn_load_passer() {
	
	var _mode = $('#mode').val(); 
	var _jid = $('#jid').val();

	$.ajax({
		url: "/company/interview/ajax_interview_load_passer.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"mode": _mode
			,"jid": _jid
		}),
		success: function (data) {
			$('#ul_passer_list').html(data);
		},
		error: function (req, status, err) {
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
	document.charset = "euc-kr";
}

//달력 날짜선택시 미리보기(이미등록된 면접배정 데이터) 불러오기
function fn_load_preview(_val) {
	
	var _mode = $('#mode').val(); 
	var _jid = $('#jid').val();
	var _interview_day = _val;

	$.ajax({
		url: "/company/interview/ajax_interview_load_preview.asp",
		type: "POST",
		dataType: "text",
		data: ({
			"mode": _mode
			,"jid": _jid
			,"interview_day": _interview_day
		}),
		success: function (data) {
			$('#ul_preview_list').html(data);
			fn_interview_time_disable_reset(_interview_day);

		},
		error: function (req, status, err) {
			alert("처리 도중 오류가 발생하였습니다.\n" + err);
		}
	});
	document.charset = "euc-kr";
}

//서류합격자 4개이상 선택X
function fn_applyno_max_cnt(_obj) {
	var cnt = $('input:checkbox[name="set_interview_applyno"]:checked').length;
	if (cnt > 4) {
		alert("4개이상 선택할 수 없습니다.");
		$(_obj).attr("checked", false);
		checkboxFnc();
	}
}

//면접시간 선택클릭
function fn_time_set(_obj) {
	var set_day = $('#set_interview_day').val();
	var set_time = $(_obj).parent().next().html().substring(0, 5);

	if (set_day == "") {
		return;
	} else {
		var today_date = new Date();
		var set_date = new Date(set_day.split("-")[0], set_day.split("-")[1] -1, set_day.split("-")[2], set_time.split(":")[0], set_time.split(":")[1]);

		if (set_date < today_date) {
			alert("현재시간 이전의 시간은 선택이 불가능합니다.");
			fn_interview_time_reset();
		}
	}

}

//미리보기 클릭
function fn_set_preview() {
	var i_day = "";
	var i_time = "";
	var i_applyno = "";
	var i_apply_text = "";
	var i_online_yn = "";

	i_day = $('#set_interview_day').val();
	$('input[name="set_interview_time"]').each(function() {
		if (this.checked) {
			i_time = this.value;
		}
	});
	$('input[name="set_interview_applyno"]').each(function() {
		if (this.checked) {
			i_applyno += "," + this.value;
			//i_apply_text += "," + $(this).next().html().trim().replace("<br>", "").replace("<br>", " | ");
			i_apply_text += "," + $(this).next().html().trim().replace("<br>", "");
		}
	});
	i_online_yn = $('input[name="online_yn"]:checked').val();

	if (i_day == "") {
		alert("면접일자를 선택해주세요.");
		return;
	}
	if (i_time == "") {
		alert("면접시간을 선택해주세요.");
		return;
	}
	if (i_applyno == "") {
		alert("면접배정할 인원을 선택해주세요.");
		return;
	}

	i_applyno = i_applyno.substring(1).split(",");
	i_apply_text = i_apply_text.substring(1).split(",");

	//미리보기 영역 선택한 applyno 기존에 있는 데이터 삭제
	$('input[name="result_interview_applyno"]').each(function() {
		for (var i=0; i<i_applyno.length; i++) {
			if (this.value == i_applyno[i]) {
				$(this).parent().remove();
			}
		}
	});
	fn_interview_preview_reset();
	
	var tmp_html = '';
	for (var i=0; i<i_applyno.length; i++) {

		var max_cnt = $('#' + i_day + '_' + i_time).find('.pi_ul').children('li').length;
		if (max_cnt >= 4) {
			alert("시간당 4명이상 배정할 수 없습니다.");
			return;
		}

		tmp_html = '';
		tmp_html += '<li class="on">';
		tmp_html += '	<input type="hidden" name="result_interview_time" value="'+ i_time +'">';
		tmp_html += '	<input type="hidden" name="result_interview_applyno" value="'+ i_applyno[i] +'">';
		tmp_html += '	<input type="hidden" name="result_online_yn" value="'+ i_online_yn +'">';
		tmp_html +=		i_apply_text[i];
		tmp_html += '	<button type="button" onclick="fn_interview_applyno_del(this, 0)">삭제</button>';
		tmp_html += '</li>';
		$('#' + i_day + '_' + i_time).find('.pi_ul').append(tmp_html);
	}
	
	$('#' + i_day + '_' + i_time).show();
	$('.p_ment').hide();
	fn_interview_applyno_reset();
	fn_interview_time_disable_reset(i_day);
	fn_interview_time_reset();
}

//서류합격자 chk 초기화
function fn_interview_applyno_reset() {
	$('input[name="set_interview_applyno"]').each(function() {
		this.checked = false;
	});
	checkboxFnc();//체크박스.
}

//면접시간 disable reset
function fn_interview_time_disable_reset(_val) {
	for (var i=1; i<=16; i++) {
		var len = $('#' + _val + '_' + i).find('.pi_ul').children('li').length;
		if (len >= 4) {
			$('#time1_' + i).attr('disabled', true);
			$('#time1_' + i).parent().attr('class', 'radiobox off disable');
		} else {
			$('#time1_' + i).attr('disabled', false);
			$('#time1_' + i).parent().attr('class', 'radiobox off');
			$('#time1_' + i).parent().attr('disabled', false);
			$('#time1_' + i).parent().attr('readonly', false);
		}
		radioboxFnc();
	}
}

//면접시간 radio 초기화
function fn_interview_time_reset() {
	$('input[name="set_interview_time"]').each(function() {
		this.checked = false;
	});
	radioboxFnc();//라디오박스
}

//면접배정자 미리보기 초기화
function fn_interview_preview_reset() {
	var preview_tot_cnt = 0;
	$('#ul_preview_list').find('.pi_ul').each(function() {
		var len = $(this).children('li').length;
		if (len == 0) {
			$(this).parents('li').hide();
		} else {
			preview_tot_cnt += 1;
		}
	});

	if (preview_tot_cnt == 0) {
		$('.p_ment').show();
	}
}

//면접배정 저장
function fn_interview_save() {
	var cnt = $('input[name="result_interview_applyno"]').length;
	if (cnt == 0) {
		alert('미리보기 버튼을 클릭해주세요.');
		return;
	}

	$('#frm_pop').submit();
}


//면접배정자 삭제(날짜/시간 전체)
function fn_interview_applyno_del_all(_obj, _type) {
	var _jid = $("#jid").val();
	var _day = $("#set_interview_day").val();
	var _applyno = "";

	if (confirm("해당 시간의 면접배정자가 모두삭제됩니다.\n면접확정자는 삭제되지 않습니다.\n정말 삭제하시겠습니까?")) {
		if(_type == 1) {
			$(_obj).parents(".preview_info").find('.pi_ul').children("li").each(function() {
				_applyno += "," + $(this).children('input[name="result_interview_applyno"]').val();
			});
			_applyno = _applyno.substring(1);

			$.ajax({
				url: "/company/interview/proc_interview_del.asp",
				type: "POST",
				dataType: "text",
				data: ({
					"jid": _jid
					,"applyno": _applyno
				}),
				success: function(data) {

					$(_obj).parents(".preview_info").find('.pi_ul').children("li").each(function() {
						$(this).remove();
					});
					
					fn_interview_preview_reset();
					fn_interview_time_reset();
					fn_interview_time_disable_reset(_day);
					fn_load_passer();
				},
				error: function (req, status, err) {
					alert("처리 도중 오류가 발생하였습니다.\n" + err);
				}
			});
		} else {
			$(_obj).parents(".preview_info").find('.pi_ul').children("li").each(function() {
				$(this).remove();
			});
			fn_interview_preview_reset();
			fn_interview_time_reset();
			fn_interview_time_disable_reset(_day);
		}

	}
}


//면접배정자 삭제
function fn_interview_applyno_del(_obj, _type) {
	var _jid = $("#jid").val();
	var _day = $("#set_interview_day").val();
	var _time = $(_obj).parent().find('input[name="result_interview_time"]').val();
	var _applyno = $(_obj).parent().find('input[name="result_interview_applyno"]').val();

	if (confirm("정말 삭제하시겠습니까?")) {
		if (_type == 1) {
			$.ajax({
				url: "/company/interview/proc_interview_del.asp",
				type: "POST",
				dataType: "text",
				data: ({
					"jid": _jid
					,"interview_day": _day
					,"interview_time": _time
					,"applyno": _applyno
				}),
				success: function (data) {
					$(_obj).parent().remove();
					fn_interview_preview_reset();
					fn_interview_time_reset();
					fn_interview_time_disable_reset(_day);
					fn_load_passer();
				},
				error: function (req, status, err) {
					alert("처리 도중 오류가 발생하였습니다.\n" + err);
				}
			});
		} else {
			$(_obj).parent().remove();
			fn_interview_preview_reset();
			fn_interview_time_reset();
			fn_interview_time_disable_reset(_day);
		}
	}
}