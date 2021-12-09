function fn_set_interview_day(_val) {
	$('#set_interview_day').val(_val);
}


//�����հ��� ����Ʈ �ҷ�����
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
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
	document.charset = "euc-kr";
}

//�޷� ��¥���ý� �̸�����(�̵̹�ϵ� �������� ������) �ҷ�����
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
			alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
		}
	});
	document.charset = "euc-kr";
}

//�����հ��� 4���̻� ����X
function fn_applyno_max_cnt(_obj) {
	var cnt = $('input:checkbox[name="set_interview_applyno"]:checked').length;
	if (cnt > 4) {
		alert("4���̻� ������ �� �����ϴ�.");
		$(_obj).attr("checked", false);
		checkboxFnc();
	}
}

//�����ð� ����Ŭ��
function fn_time_set(_obj) {
	var set_day = $('#set_interview_day').val();
	var set_time = $(_obj).parent().next().html().substring(0, 5);

	if (set_day == "") {
		return;
	} else {
		var today_date = new Date();
		var set_date = new Date(set_day.split("-")[0], set_day.split("-")[1] -1, set_day.split("-")[2], set_time.split(":")[0], set_time.split(":")[1]);

		if (set_date < today_date) {
			alert("����ð� ������ �ð��� ������ �Ұ����մϴ�.");
			fn_interview_time_reset();
		}
	}

}

//�̸����� Ŭ��
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
		alert("�������ڸ� �������ּ���.");
		return;
	}
	if (i_time == "") {
		alert("�����ð��� �������ּ���.");
		return;
	}
	if (i_applyno == "") {
		alert("���������� �ο��� �������ּ���.");
		return;
	}

	i_applyno = i_applyno.substring(1).split(",");
	i_apply_text = i_apply_text.substring(1).split(",");

	//�̸����� ���� ������ applyno ������ �ִ� ������ ����
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
			alert("�ð��� 4���̻� ������ �� �����ϴ�.");
			return;
		}

		tmp_html = '';
		tmp_html += '<li class="on">';
		tmp_html += '	<input type="hidden" name="result_interview_time" value="'+ i_time +'">';
		tmp_html += '	<input type="hidden" name="result_interview_applyno" value="'+ i_applyno[i] +'">';
		tmp_html += '	<input type="hidden" name="result_online_yn" value="'+ i_online_yn +'">';
		tmp_html +=		i_apply_text[i];
		tmp_html += '	<button type="button" onclick="fn_interview_applyno_del(this, 0)">����</button>';
		tmp_html += '</li>';
		$('#' + i_day + '_' + i_time).find('.pi_ul').append(tmp_html);
	}
	
	$('#' + i_day + '_' + i_time).show();
	$('.p_ment').hide();
	fn_interview_applyno_reset();
	fn_interview_time_disable_reset(i_day);
	fn_interview_time_reset();
}

//�����հ��� chk �ʱ�ȭ
function fn_interview_applyno_reset() {
	$('input[name="set_interview_applyno"]').each(function() {
		this.checked = false;
	});
	checkboxFnc();//üũ�ڽ�.
}

//�����ð� disable reset
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

//�����ð� radio �ʱ�ȭ
function fn_interview_time_reset() {
	$('input[name="set_interview_time"]').each(function() {
		this.checked = false;
	});
	radioboxFnc();//�����ڽ�
}

//���������� �̸����� �ʱ�ȭ
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

//�������� ����
function fn_interview_save() {
	var cnt = $('input[name="result_interview_applyno"]').length;
	if (cnt == 0) {
		alert('�̸����� ��ư�� Ŭ�����ּ���.');
		return;
	}

	$('#frm_pop').submit();
}


//���������� ����(��¥/�ð� ��ü)
function fn_interview_applyno_del_all(_obj, _type) {
	var _jid = $("#jid").val();
	var _day = $("#set_interview_day").val();
	var _applyno = "";

	if (confirm("�ش� �ð��� ���������ڰ� ��λ����˴ϴ�.\n����Ȯ���ڴ� �������� �ʽ��ϴ�.\n���� �����Ͻðڽ��ϱ�?")) {
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
					alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
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


//���������� ����
function fn_interview_applyno_del(_obj, _type) {
	var _jid = $("#jid").val();
	var _day = $("#set_interview_day").val();
	var _time = $(_obj).parent().find('input[name="result_interview_time"]').val();
	var _applyno = $(_obj).parent().find('input[name="result_interview_applyno"]').val();

	if (confirm("���� �����Ͻðڽ��ϱ�?")) {
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
					alert("ó�� ���� ������ �߻��Ͽ����ϴ�.\n" + err);
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