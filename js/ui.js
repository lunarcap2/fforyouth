var toggle2Fnc,inputFnc;
$(function() {

	$(document).ready(function() {
		tabFnc();//탭
		accordionFnc();//아코디언
		chkFnc();//라디오,체크 여부
        fileboxFnc();//파일박스
        if($('input.txt').length > 0) inputFnc();//인풋박스 2020.07.07
		inevtFnc();//인풋텍스트 리셋
        selectboxFnc();//셀렉트박스
		selectDown();//셀렉트형 UL
		selectStyle();//셀렉트스타일 2020.07.03
		hiddenOpen();//숨김영역
        checkboxFnc();//체크박스.
		chkpassFnc();//체크박스 비밀번호 보이기/감추기
        radioboxFnc();//라디오박스
		disableFnc();//비활성시키기
		popFnc();//팝업
		popFnc2();//팝업
		popFnc3();//팝업
		menuboxFnc();//메뉴박스
		noncheckallFnc();//체크박스 전체
		//checkAllFnc();//체크박스 전체 선택,해제 2020.07.03

        if($('.rnb .navi_ul li').length > 0) scrollMove();//스크롤 이동
		if($('.rnb_wrap .rnb_con').length > 0) scrollFixed();//스크롤 퀵메뉴
		if ($('.toggle').length > 0) toggle2Fnc();//공고관리툴팁
		if ($('.datepicker').length > 0) useDatePicker();//달력
		/* 2020.06.10
		검색후 검색날짜,검색키워드 남아있게 하기 위해 주석 처리함
		if ($('.datePick .btn.reset').length > 0) dateReset();//달력 초기화
		*/
		if ($('input.placehd, textarea.placehd').length > 0) $('input.placehd, textarea.placehd').placeholder();//input,textarea placehd

		function scrollMove() { //스크롤 이동
			(function (global, $) {
				var $menu = $('.rnb .navi_ul li'),
					  $contents = $('.view_box'),
					  $doc = $('html, body');
				$(function () { // 해당 섹션으로 스크롤 이동
					$menu.on('click','a', function(e){
						$menu.eq(e).addClass('on');
						var $target = $(this).parent(),
							  idx = $target.index(),
							  section = $contents.eq(idx),
							  offsetTop = section.offset().top;
							  $doc.stop().animate({scrollTop :offsetTop});
						return false;
					});
				});

				// menu class 추가
				$(window).scroll(function(){
					var scltop = $(window).scrollTop();
					var scltop2 = $(window).scrollTop() + $(window).height();
					$.each($contents, function(idx, item){
						var $target = $contents.eq(idx),
							i = $target.index(),
							targetTop = $target.offset().top - $(window).height() / 2;

						if ( $(window).scrollTop() >= $(document).height() - $(window).height() - 10 ) {
							$menu.removeClass('on');
							$('.rnb .navi_ul li:last-child').addClass('on');
						}
						else if (targetTop < scltop) {
							$menu.removeClass('on');
							$menu.eq(idx).addClass('on');
						}

					})
				});

			}(window, window.jQuery));
		};//스크롤 이동

		function scrollFixed() {
			$(document ).ready( function() {
				var jbOffset = $( '.rnb_wrap .rnb_con' ).offset();
					$( window ).scroll( function() {
					if ( $(document ).scrollTop() > jbOffset.top ) {
						$( '.rnb_wrap .rnb_con' ).addClass( 's_f' );
					}
					else {
						$( '.rnb_wrap .rnb_con' ).removeClass( 's_f' );
					}
				});
			});
		}


		$(window).load(function() {
			if($("#table-id-1").length > 0) calMoreShow();//캘린더 레이어 위치값 가져오기
		});

		//희망서비스 등록팝업
		$(".applicantBtn").click(function(){
			location.href="applicant.asp";
			$(".applicantPop").hide();
		});

	});

	$(document).ready(function() {
		$('input, textarea').placeholder();
	});//placeholder

	tabFnc = function(){
		$(".tab_content").hide();
		$(".tabs li:first").addClass("on").show();
		$(".tab_content:first").show();

		$(".tabs li").click(function() {
			$(".tabs li").removeClass("on");
			$(".acco li a").removeClass("on")
			$(".acco_txt").hide();
			$(this).addClass("on");
			$(".tab_content").hide();
			var activeTab = $(this).find("a").attr("href");
			$(activeTab).fadeIn();
			return false;
		});
	}

	accordionFnc = function(){
		$(".acco li a").click(function(){
			$(this).toggleClass('on');
			$(this).next().slideToggle(300);
			$(".acco li a").not(this).next().slideUp(300);
			$(".acco li a").not(this).removeClass('on');
			return false;
		});
		//$("ul li a").eq(0).trigger("click");
	}

	chkFnc = function (){
		$(".sel_box input").click(function(){
			if($(".sel_box .radiobox").hasClass("on") === true) {
				$(this).parents('.sel_box').prev().addClass('sel');
			}else{
				$(this).parents('.sel_box').prev().removeClass('sel');
			}
		});
	}

    function fileboxFnc() {//찾아보기
        $('.filebox input:file').each(function (index, value) {
            $(this).prev().val($(this).val());
        }).bind('click change', function () {
            $(this).prev().val($(this).val());
        }).bind('focus', function () {
            $(this).prev().addClass('on');
        }).bind('blur', function () {
            $(this).prev().removeClass('on');
        });
    }//찾아보기
    inputFnc = function (obj) {//인풋박스
        var _obj = $('.contentWrap');
        var _input = _obj.find('input.pwd');
        var _this, _tmp, _bg = null;
        if (!obj)
            _this = $('input.txt, textarea.area');
        else
            _this = $(obj).find('input.txt, textarea.area');
        _this.unbind('focus blur').bind('focus', function () {
            _bg = ($(this).attr('class').indexOf('bg') > -1) ? true : false;
            $(this).addClass('on');//클래스 방식
            if(_bg) $(this).removeClass('bg');
        }).bind('blur', function () {
            $(this).removeClass('on');//클래스 방식
            if (_bg && $(this).val() == '') $(this).addClass('bg');
        });

        _input.bind('focus', function() {//인풋배경
            if (!$(this).val() || $(this).val()) $(this).addClass('bgnone');
        }).bind('blur', function() {
            if ($(this).val()) $(this).addClass('bgnone');
            else $(this).removeClass('bgnone');
        });
    }//인풋박스

	/*
    $.fn.check = function(index) {//인풋텍스트 체크
        return this.each(function(index, value) {
            var _default = $(this).attr('default');

			this.value = _default;

            if(this.value == '' || this.value == _default) {
                $(this).attr('value', _default);
            } else {
                $(this).removeClass('value');
            }
            $(this).bind('focus', function() {
                if(this.value == _default) {
                    this.value = '';
                }
                $(this).removeClass('value');

            }).bind('blur', function() {
                if(this.value == '' || this.value == _default) {
                    this.value = _default;
                    $(this).addClass('value');
					$(this).siblings('.in_txt .txt_reset').hide();
                }else {
					$(this).addClass('on');
				}
            });
        });
    };//인풋텍스트 체크
	*/

	inevtFnc = function() { //인풋 포커스, 클릭, val 효과
		var _re = $('.in_txt .txt_reset');
		var _inTxt = $('.in_txt .txt');
		var _inPass = $('.in_txt .pass');

		/*
		$(_inTxt).keydown(function() {
			$(this).siblings(_re).show();
		});
		*/

		$(_re).click(function () {
			$(this).hide();
			$(this).siblings(_inTxt).removeClass('on');
			$(this).parents('.in_txt').css('border','2px solid #d0d0d0');
			$(this).parents('.in_txt').css('z-index','0');
		});

		$('.in_txt .txt, .in_txt .pass').focus(function() {
			$(this).parents('.in_txt').css('border','2px solid #333');
			$(this).parents('.in_txt').css('z-index','50');
		});
		$('.in_txt .txt, .in_txt .pass').blur(function() {
			if($(this).val() !== '') {
				$(this).parents('.in_txt').css('border','2px solid #333');
				$(this).parents('.in_txt').css('z-index','50');
			}else {
				$(this).parents('.in_txt').css('border','2px solid #d0d0d0');
				$(this).parents('.in_txt').css('z-index','0');
			}
		});
	} //인풋 텍스트 리셋 버튼

    $.fn.inputnumFnc = function(index) {//인풋전화번호 체크
        if (!$("#hd_pop").children().hasClass('hd_pops')) {
			$("#dim_pop_bg").css("display", "none");
		}
    };
    function numeric(value) {//문자제거
        return value.toString().replace(/[^\d$]/gi, "");
    }//인풋전화번호 체크

	selectboxFnc = function (obj) {//셀렉트박스
		var _select = null
		if (!obj)
			_select = $('.selectbox select');
		else
			_select = ($(obj).find('.selectbox select').length > 0) ? $(obj).find('.selectbox select') : $(obj);
		_select.unbind().each(function (index, value) {
			$(this).prev().html($(this).children('option:selected').text());
			if ($(this).val() == 'direct') {//직접입력
				$(this).parent().prev().css('display', 'inline');
			}
		}).bind('change keyup', function (evt) {
			$(this).prev().html($(this).children('option:selected').text());
			if ($(this).prev().is('.ellipsis')) $(this).prev().ellipsis();//글줄임 설정
			if ($(this).find("option[value='direct']").length == 1) {//직접입력 설정
				if ($(this).val() == 'direct') {
					$(this).parent().prev().css('display', 'inline');
					if (evt.type == 'change') $(this).parent().prev().focus();//직접입력 포커스 이동
				} else {
					$(this).parent().prev().css('display', 'none');
				}
			}
		}).bind('focus', function () {
			$(this).prev().addClass('on');
		}).bind('blur', function () {
			$(this).prev().removeClass('on');
		});
	}//셀렉트박스

	selectDown = function() {
		$(".select_down .name a").click(function() {
			$(this).parents('.name').next('.sel').find('ul').show();
		});

		$(".select_down .sel ul li a").click(function() {
			var text = $(this).html();
			$(this).parents('.sel').prev('.name').find('span').html(text);
			$(this).parents('.sel').find('ul').hide();
		});

		$(document).bind('click', function(e) {
			var $clicked = $(e.target);
			if (! $clicked.parents().hasClass("select_down"))
				$(".select_down .sel ul").hide();
		});
	}

	selectStyle = function() {
		$(".select_box .name a").click(function() {
			var sel_a = $(".select_box .name a");
			if (!$(this).parents('.select_box').hasClass('on')) {
				$(this).parents('.select_box').addClass( 'on' );
				$(sel_a).not(this).parents('.select_box').removeClass('on');
			}else{
				$(this).parents('.select_box').removeClass( 'on' );
			}
		});

		$(".select_box .sel ul li a").click(function() {
			var text = $(this).html();
			$(this).parents('.sel').prev('.name').find('span').html(text);
			//(this).parents('.sel').find('ul').hide();
			$(this).parents('.select_box').removeClass( 'on' );
		});

		/*
		$(document).bind('click', function(e) {
			var $clicked = $(e.target);
			console.log($clicked);
			if (! $clicked.parents().hasClass("select_box")){
				$('.select_box').removeClass( 'on' );
			}
		});
		*/

		$(document).bind('click', function(e) {
			var $clicked = $(e.target);
			if (!$clicked.parents().hasClass("select_box") ) {
				if ($($clicked).attr('class') != null && !$($clicked).attr('class').match('btn')) {
					$('.select_box').removeClass( 'on' );
				}
			}
		});

	}//셀렉트 스타일

	selectCalendar = function() {
		$(".select_box.calendar .name a").click(function() {
			var sel_a = $(".select_box .name a");
			if (!$(this).parents('.select_box').hasClass('on')) {
				$(this).parents('.select_box').addClass( 'on' );
				$(sel_a).not(this).parents('.select_box').removeClass('on');
			}else{
				$(this).parents('.select_box').removeClass( 'on' );
			}
		});

		$(".select_box.calendar .sel .calendar_box button").click(function() {
			$(this).parents('.select_box').addClass( 'on' );
		});

		$(document).bind('click', function(e) {
			var $clicked = $(e.target);
			if (! $clicked.parents().hasClass("select_box"))
				$('.select_box').removeClass( 'on' );

		});
	}//셀렉트 스타일

	hiddenOpen = function() {
		$(".hidden_open button").click(function() {
			$(this).next('.ho_area').find('.cols').show();
		});

		$(".select_down .sel ul li a").click(function() {
			var text = $(this).html();
			$(this).parents('.sel').prev('.name').find('span').html(text);
			$(this).parents('.sel').find('ul').hide();
		});

		$(document).bind('click', function(e) {
		var $clicked = $(e.target);
		if (! $clicked.parents().hasClass("hidden_open"))
			$(".hidden_open .ho_area .cols").hide();
		});

		$(".hidden_open .btm_btn .save").click(function() {
			$(".hidden_open .ho_area .cols").hide();
		});
	}


    checkallFnc = function (obj, name) {//전체선택
        var _this = $(obj);
        var _chk = $('input[name='+name+']');
        if(_this.is(':checked')) {
            _chk.each(function(index, value) {
                $(this).attr('checked', true).parent().removeClass('off').addClass('on');
            });
        } else {
            _chk.each(function(index, value) {
                $(this).attr('checked', false).parent().removeClass('on').addClass('off');
            });
        }
    }//전체선택

    checkboxFnc = function () {//체크박스
        var _chk = $('.chk').parent();
        _chk.each(function() {
            if ($(this).find('input').is(':checked')) {
                $(this).removeClass('off').addClass('on');

            } else {
                $(this).removeClass('on').addClass('off');
            }
        }).click(function() {
            if ($(this).find('input').is(':checked')) {
                $(this).removeClass('off').addClass('on');
            } else {
                $(this).removeClass('on').addClass('off');
            }
        });
    }//체크박스

	chkpassFnc = function () { //패스워드 보이기/감추기
		$("#passChk").change(function(){
			// Check the checkbox state
			if($(this).is(':checked')){
				// Changing type attribute
				$("#inPass").attr("type","text");

				// Change the Text
				//$(".pass_txt").text("비밀번호 보이기");
			}else{
				// Changing type attribute
				$("#inPass").attr("type","password");

				// Change the Text
				//$(".pass_txt").text("비밀번호 감추기");
			}
		});
	} //패스워드 보이기/감추기

    radioboxFnc = function () {//라디오박스

		//비활성화 클래스명
		$(".disable").attr("readonly",true);
		$(".disable , .disable input").attr("disabled","disabled");

        var _rdi = $('.rdi').parent();
        _rdi.unbind().each(function() {
            if ($(this).find('input').is(':checked')) {
                $(this).removeClass('off').addClass('on');
            }else if ($(this).find('input').is('[disabled=disabled]'))//비활성화시킬때
			{
				//$(this).find("span").css({'color':'#a8a8a8','cursor':'default'});
				//$(this).find('input').attr('name','disable')
			} else {
                $(this).removeClass('on').addClass('off');
            }
        }).bind('click', function() {
            var _name = $(this).find('input').attr('name');
            var _radio = $('label input[name$='+_name+']');
            var _index = _radio.parent().index(this);
            _radio.each(function(index, value) {
                if (_index == index) {
                    $(this).checked = true;
                    $(this).parent().removeClass('off').addClass('on');
					if ($(this).is('[disabled=disabled]'))
					{
						$(this).parent().removeClass('on');
						$(this).find('input').is('[disabled=disabled]').attr("disabled","disabled");
					}
                } else {
                    $(this).checked = false;
                    $(this).parent().removeClass('on').addClass('off');
                }
            });
        });

        $('input:radio').click(function() {
            $('input:radio[name='+$(this).attr('name')+']').parent().removeClass('on');
            $(this).parent().addClass('on');
        });

    }//라디오박스

	moreFnc = function() {//주간 더보기
		var _obj = $('.weekly-area .more a');
		_obj.bind('click', function() {
			var _more = $(this).parent();
			_more.prev().css('max-height','none');
			_more.find('a:first-child').hide();
			_more.append('<a class="close" href="#">접기</a>').bind('click', function() {
				_more.prev().removeAttr('style');
				_more.find('a:first-child').show();
				_more.find('a.close').remove();
				return false;
			});
			return false;
		});
	}//주간 더보기

	expandFnc = function (obj, closeTxt, openTxt, count) {//펼치기 버튼
		var _obj = $(obj);
		var _target = $(obj).prev().find(".limit");
		var _closeTxt = closeTxt;
		var _openTxt = openTxt;
		var _count = count;

		_obj.toggleClass("open");

		if(_obj.hasClass("open")) {
			if (_target.get(0).tagName == 'TABLE') {
			_target.nextAll().css('display','table');
			} else if (_target.get(0).tagName == 'TR') {
				_target.nextAll().css('display','table-row');
			} else {
				_target.nextAll().css('display','block');
			}
			_obj.find("span").text(_closeTxt)
		} else {
			_obj.prev().find(".limit").nextAll().hide()
			_obj.find("span").text(_openTxt);

			//인담
			if(_obj.parents().hasClass("tip")) {
				var _html = '<span>인.담 TIP <strong>'+_count+'</strong>개의질문/답변이 더 있습니다.</span>';
				_obj.html(_html);
			}

			//인담COOL
			if(_obj.parents().hasClass("cool")) {
				var _html = '<span>인.담 COOL리뷰가 <strong>'+_count+'</strong>건 더 있습니다.</span>';
				_obj.html(_html);
			}

			//자기소개서항목
			if(_obj.parents().hasClass("introduction")) {
				var _html = '<span>자기소개서 항목이 <strong>'+_count+'</strong>건 더 있습니다.</span>';
				_obj.html(_html);
			}
		}

		/*$('html, body').animate({
			scrollTop: (_obj.parent().prev().offset().top) - 80
		}, 200);*/
	};//펼치기 버튼

	showLayerFnc = function(obj) {//캘린더 레이어 v1 2016-06-21 skydown@career.co.kr
		var _table = $('#table-id');
		var _tr = _table.find('tbody tr');
		var _more = _table.find('tbody td').not('td.none, td.nodata').find('.more a');
		var _layer = $('#layer-id');
		var _inner = _layer.find('.inner');
		var _close = _layer.find('.close');
		if(!obj) {
			_more.unbind('click').bind('click', function() {
				var _td = $(this).parents('td');
				var _width = parseInt(_td.outerWidth()) + ((_td.next().length > 0) ? parseInt(_td.next().outerWidth()) : parseInt(_td.prev().outerWidth())) - 1;
				var _x = _td.offset().left - 1;
				var _y = _td.offset().top - 1;
				_layer.css({'width':_width + 'px','left':_x, 'top':_y}).show(200);
				return false;
			});
		} else {
			var _td = $(obj).parents('td');
			var _width = parseInt(_td.outerWidth()) + ((_td.next().length > 0) ? parseInt(_td.next().outerWidth()) : parseInt(_td.prev().outerWidth())) - 1;
			var _x = _td.offset().left - 1;
			var _y = _td.offset().top - 1;
			_layer.css({'width':_width + 'px','left':_x, 'top':_y}).show(200);
			return false;
		}
		$('#layer-id .close').unbind('click').bind('click', function () {
			_more.unbind('click');
			$('#layer-id').hide(200, function() {
				$(this).removeAttr('style');
				showLayerFnc();
			});
			return false;
		});
	}//캘린더 레이어

	hideLayerFnc = function() {//캘린더 레이어 감추기
		$('#layer-id').hide(200, function() {
			$(this).removeAttr('style');
		});
	}//캘린더 레이어 감추기

	/* 달력 2014-09-17 skydown@career.co.kr */
	_calArray = {
		Box: null,
		Month: null,
		Body: null,
		Prev: null,
		Next: null,
		Input: null,
		calClose: null,
		calButton: null,
		calToday: null,
		calDate: null,
		calMonth: null,
		calNow: null,
		calYear: null,
		Weekday: null,
		MonthA: null,
		Mdays: null
	};
	calendarBoxFnc = {
		init: function() {
			_calArray.Box = $('#calendarBox');
			_calArray.Month = $('#calendarMonth');
			_calArray.Body = $('#calendarBody');
			_calArray.Prev = _calArray.Box.find('.calHead .prev');
			_calArray.Next = _calArray.Box.find('.calHead .next');
			_calArray.calClose = _calArray.Box.find('.calClose');
			_calArray.calButton = _calArray.Box.find('td > button');
			_calArray.calClose.click(function() {
				_calArray.Box.hide();
				_calArray.Input.focus();
				calendarBoxFnc.set();
			});
			_calArray.Prev.click(function() {
				_calArray.calToday.setMonth( _calArray.calToday.getMonth() - 1 );
				calendarBoxFnc.set();
			});
			_calArray.Next.click(function() {
				_calArray.calToday.setMonth( _calArray.calToday.getMonth() + 1 );
				calendarBoxFnc.set();
			});
			calendarBoxFnc.set();
		},
		input: function(d) {
			var month = _calArray.MonthA[_calArray.calMonth];
			var day = d;
			(month < 10) ? month = '0' + month : month;
			(day < 10) ? day = '0' + day : day;

			_calArray.calDate = d;
			_calArray.Input.val(_calArray.calYear + '-' + month + '-' + day).focus();
			_calArray.Box.hide();
		},
		show: function(p, obj) {
			_calArray.Input = $('#' + p);
			var _pos = _calArray.Input.position();
			calendarBoxFnc.set(obj.value);
			_calArray.Box.show().css({
				'left': _pos.left,
				'top': _pos.top
			}).find('#calendarBody button.on').focus();
		},
		set: function(v) {
		// this array gives the weekday names
			_calArray.Weekday = new Array();
			_calArray.Weekday[0] = "Sunday";
			_calArray.Weekday[1] = "Monday";
			_calArray.Weekday[2] = "Tuesday";
			_calArray.Weekday[3] = "Wednesday";
			_calArray.Weekday[4] = "Thursday";
			_calArray.Weekday[5] = "Friday";
			_calArray.Weekday[6] = "Saturday";
		// this array gives month names
			_calArray.MonthA = new Array();
			_calArray.MonthA[0] = "1" //January";
			_calArray.MonthA[1] = "2" //February";
			_calArray.MonthA[2] = "3" //March";
			_calArray.MonthA[3] = "4" //April";
			_calArray.MonthA[4] = "5" //May";
			_calArray.MonthA[5] = "6" //June";
			_calArray.MonthA[6] = "7" //July";
			_calArray.MonthA[7] = "8" //August";
			_calArray.MonthA[8] = "9" //September";
			_calArray.MonthA[9] = "10" //October";
			_calArray.MonthA[10] = "11" //November";
			_calArray.MonthA[11] = "12" //December";
		// this array gives the number of days in each month
			_calArray.Mdays = new Array();
			_calArray.Mdays[0] = 31;
			_calArray.Mdays[1] = 28;
			_calArray.Mdays[2] = 31;
			_calArray.Mdays[3] = 30;
			_calArray.Mdays[4] = 31;
			_calArray.Mdays[5] = 30;
			_calArray.Mdays[6] = 31;
			_calArray.Mdays[7] = 31;
			_calArray.Mdays[8] = 30;
			_calArray.Mdays[9] = 31;
			_calArray.Mdays[10] = 30;
			_calArray.Mdays[11] = 31;
		// this code gets current date information
			if (_calArray.calToday == null) {
				_calArray.calToday = new Date();
				_calArray.calNow = _calArray.calToday.getDate();
			}
			if (v == undefined || v == '') {
				_calArray.calYear = _calArray.calToday.getYear();
				_calArray.calMonth = _calArray.calToday.getMonth();
				_calArray.calDate = _calArray.calToday.getDate();
			} else {
				var _v = v.split('-');
				var _vyear = _v[0];
				var _vmonth = (_v[1] < 10) ? _v[1].split('0')[1] : _v[1];
				var _vdate = (_v[2] < 10) ? _v[2].split('0')[1] : _v[2];
				_calArray.calYear = _vyear;
				_calArray.calMonth = _vmonth - 1;
				_calArray.calDate = _vdate;
				_calArray.calNow = _vdate;
			}
		// these are variables for
			var day = 1;
			var i, j;
		// adjust year for browser differences
			if (_calArray.calYear < 2000) {
				_calArray.calYear += 1900;
			}
		// account for leap year
			if ((_calArray.calYear % 400 == 0) || ((_calArray.calYear % 4 == 0) && (_calArray.calYear % 100 !=0)))
				_calArray.Mdays[1] = 29;
		// determine day of week for first day of the month
			var Mfirst = _calArray.calToday;
			Mfirst.setDate(1);
			var dow1 = Mfirst.getDay();
		// write out current date
			var _month = _calArray.calYear + "." + _calArray.MonthA[_calArray.calMonth];
			_calArray.Month.html(_month);

		// construct calendar for current month
			var _tbody = "";
			for (i = 0; i < 6; i++) {
		// this loop writes one row of days Sun-Sat
				_tbody += ("<tr>");
				for (j = 0; j < 7; j++) {
		// this loop determines which dates to display and in which column
					if ((i == 0 && j < dow1) || (day > _calArray.Mdays[_calArray.calMonth])) {
		// this puts in blank cells at the beginning an end of the month
						_tbody += ("<td>&nbsp;</td>");
					} else {
						if (day == _calArray.calNow) {
		// highlight the current day and display the date for this cell
							_tbody += ("<td><button class='on' type='button' value='"+ day +"' onclick='calendarBoxFnc.input(this.value);'>" + day + "</button></td>");
						} else {
		// display the date for this cell
							_tbody += ("<td><button type='button' value='"+ day +"' onclick='calendarBoxFnc.input(this.value);'>" + day + "</button></td>");
						}
		// increment day counter
						day++;
					}
				}
		// end of row; determine if more rows needed
				_tbody += ("</tr>");
				if (day > _calArray.Mdays[_month]) {
					i = 6;
				}
			}
		// end of table
			_calArray.Body.html(_tbody);

		}
	};/* //달력 */

	//캘린더 레이어 위치값 가져오기
	calMoreShow = function(){
		$(".plusIcon").click(function(){

			$(".openPop").hide();//클릭시 해당 팝업 제외 히든처리

			$(this).next("div").show(0,function(){
				$(this).css({
					"left": "-1px",
					"top" : "-7px"
				});
			});
		});
	}
	disableFnc = function (obj, param) {//비활성
		var _obj = $(obj);
		var _input = _obj.find('input.txt, input.rdi, input.chk, textarea.area');
		switch(param) {
			case 'disable':
				_obj.addClass('disable');
				if (_input.length > 0) _input.attr('readonly','readonly');
				if (_input.length > 0) _input.attr('disabled','disabled');
				selectboxFnc();
				break;
			case 'active':
				_obj.removeClass('disable');
				if (_input.length > 0) _input.removeAttr('readonly');
				break;
			case 'check'://체크박스
				if ((_obj.attr('class')) ? (_obj.attr('class') == 'disable') : false) {
					_obj.removeClass('disable');
					if (_input.length > 0) _input.removeAttr('readonly');
				} else {
					_obj.addClass('disable');
					if (_input.length > 0) _input.attr('readonly','readonly');
				}
				break;
			default:
				return false;
		}
	};//비활성


	popFnc = function (obj) {//팝업
		$('.pop').click(function(){
			$('.popup, .pop_dim').show();
			$('.popup.double, .pop_dim.double').hide();

			$poHeight = $('.popup').height();
			$poHeight2 = $('#pop_result_apply .popup').height();
			$poHeight3 = $('#pop_result_interview .popup').height();

			docWidth = $(document).width();
			winHeight = $(window).height();
			//alert("너비 : "+ $poHeight3);
			if ($poHeight > winHeight/*&& $poWidth < docWidth*/) {
				$('.popup').css("top", Math.max(0, $(window).scrollTop()));
				$('.popup').css({
					marginTop:0});
					//,marginLeft:-$poWidth / 2});
				return this;
			}

			else if ($poHeight2 > winHeight/*&& $poWidth < docWidth*/) {
				$('.popup').css("top", Math.max(0, $(window).scrollTop()));
				$('.popup').css({
					marginTop:0});
					//,marginLeft:-$poWidth / 2});
				return this;
			}

			else{
				$('.popup').css("top", Math.max(0,  $(window).scrollTop() + $(window).height() / 2) + "px");
				$('.popup').css({
					marginTop: -$poHeight / 2});
					//,marginLeft: -$poWidth / 2});

				$('#pop_result_interview .popup').css({
				marginTop: -$poHeight3 / 2});
				//,marginLeft: -$poWidth / 2});
			   return this;
			}

		});


		$('.layer_close').click(function(e){
			e.preventDefault();
			$(this).parents('.popup').hide().prev('.pop_dim').hide();
		});

		$('.pop_dim').click(function(e){
			e.preventDefault();
			$(this).hide().next('.popup').hide();
		});

		$('.popup .btn_area .btn.close').click(function(){
			$(this).parents('.popup').hide().prev('.pop_dim').hide();
		});

    }//팝업

	popFnc2 = function () {//팝업
		$('.pop2').click(function(){
			$('#popup2, #pop_dim2').delay( 2000 ).show();
			$poHeight = $('#popup2').outerHeight();
			$poHeight2 = $('#pop_result_interview .popup').height();
			docWidth = $(document).width(),
			winHeight = $(window).height();



			if ($poHeight > winHeight/*&& $poWidth < docWidth*/) {
				$('#popup2').css("top", Math.max(0, $(window).scrollTop()));
				$('#popup2').css({
					marginTop:0});
					//,marginLeft:-$poWidth / 2});
				return this;
			}
			else if ($poHeight2 > winHeight/*&& $poWidth < docWidth*/) {
				$('#popup2').css("top", Math.max(0, $(window).scrollTop()));
				$('#popup2').css({
					marginTop:0});
					//,marginLeft:-$poWidth / 2});
				return this;
			}
			else{
				$('#popup2').css("top", Math.max(0,  $(window).scrollTop() + jQuery(window).height() / 2) + "px");
				$('#popup2').css({
					marginTop: -$poHeight / 2});
					//,marginLeft: -$poWidth / 2});
			   return this;
			}

		});

		$('#popup2 .layer_close, #pop_dim2').click(function(e){
			e.preventDefault();
			$('#popup2, #pop_dim2').hide();
		});

		$('#popup2 .btn_area .btn.close').click(function(){
			$('#popup2, #pop_dim2').hide();
		});

    }//팝업2

	popFnc3 = function () {//팝업
		$('.pop3').click(function(){
			$('#popup3, #pop_dim3').delay( 2000 ).show();
			$poHeight = $('#popup3').outerHeight();
			docWidth = $(document).width(),
			winHeight = $(window).height();
			if ($poHeight > winHeight/*&& $poWidth < docWidth*/) {
				$('#popup3').css("top", Math.max(0, $(window).scrollTop()));
				$('#popup3').css({
					marginTop:0});
					//,marginLeft:-$poWidth / 2});
				return this;
			}
			else{
				$('#popup3').css("top", Math.max(0,  $(window).scrollTop() + jQuery(window).height() / 2) + "px");
				$('#popup3').css({
					marginTop: -$poHeight / 2});
					//,marginLeft: -$poWidth / 2});
			   return this;
			}

		});

		$('#popup3 .layer_close, #pop_dim3').click(function(e){
			e.preventDefault();
			$('#popup3, #pop_dim3').hide();
		});

		$('#popup3 .btn_area .btn.close').click(function(){
			$('#popup3, #pop_dim3').hide();
		});

    }//팝업3

	menuboxFnc = function () {

		var mbOpen = $('.btn_menu .open');
		var mbClose = $('.btn_menu .close');
		var container = $(".mb_menu");

		$(mbOpen).click(function () {
			$(this).hide();
			$(this).siblings('.close').show();
			$(this).parent().next(container).show();
		});
		$(mbClose).click(function () {
			$(this).hide();
			$(this).siblings('.open').show();
			$(this).parent().next(container).hide();
		});
		$(document).mouseup(function (e) {

			if ($(container).is(':visible'))
			{
				if (!container.is(e.target) && container.has(e.target).length === 0){
				container.css("display","none");
				}
				$(mbClose).hide();
				$(mbOpen).show();
			}

		});
	}

	function toggle2Fnc() {//공고관리툴팁

	};//공고관리툴팁


	noncheckallFnc = function (obj, chk, rdi) {//전체해제
		var _this = $(obj);
		var _chk = $('input[name='+chk+']');
		var _rdi = $('input[name='+rdi+']');
		if(_this.is(':checked')) {
			_chk.each(function(index, value) {
				$(this).attr('checked', true).parent().removeClass('off').addClass('on');
			});
			_rdi.each(function(index, value) {
				$(this).attr('checked', true).parent().removeClass('off').addClass('on');
			});
			return false;
		} else {
			_chk.each(function(index, value) {
				$(this).attr('checked', false).parent().removeClass('on').addClass('off');
			});
			_rdi.each(function(index, value) {
				$(this).attr('checked', false).parent().removeClass('on').addClass('off');
			});
			return false;
		}
	}//전체해제

	checkAllFnc =function() {
		var $checkHead = $(".tb thead th input[type='checkbox']"); // thead에서 체크박스인 input을 찾는다.
		var $checkBody = $(".tb tbody td input[type='checkbox']"); // tbody에서 체크박스인 input을 찾는다.

		/* 전체선택 */
		$checkHead.click(function(){
			var $bodyPutCk = $checkHead.is(":checked");

			if ( $bodyPutCk == true ) {
				//$lastActive.addClass("active");
				$checkBody.attr("checked", true).parent().removeClass('off').addClass('on');
				$checkBody.prop("checked", true).parent().removeClass('off').addClass('on');
			}else {
				//$lastActive.removeClass("active");
				$checkBody.attr("checked", false).parent().removeClass('on').addClass('off');
				$checkBody.prop("checked", false).parent().removeClass('on').addClass('off');
			}
		});

		/* 하위 전체 선택시 전체버튼 선택 */
		$checkBody.click(function(){
			var tdInput_Length = $checkBody.length; // td 에 있는 input 갯수
			var tdInput_Check_Length = $(".tb tbody td input[type='checkbox']:checked").length; // td 에 있는 선택된 input 갯수

			console.log(tdInput_Length);
			console.log(tdInput_Check_Length);

			if ( tdInput_Length == tdInput_Check_Length ) {
				//$checkHead.addClass("active");
				$checkHead.attr("checked", true).parent().removeClass('off').addClass('on');
				$checkHead.prop("checked", true).parent().removeClass('off').addClass('on');
			}else {
				//$checkHead.removeClass("active");
				$checkHead.attr("checked", false).parent().removeClass('on').addClass('off');
				$checkHead.prop("checked", false).parent().removeClass('on').addClass('off');
			}
		});
	}



	useDatePicker = function() {

		$(document).ready(function() {

			//datepicker 한국어로 사용하기 위한 언어설정
			$.datepicker.setDefaults($.datepicker.regional['ko']);

			// Datepicker
			$(".datepicker").datepicker({
				dateFormat: "yy-mm-dd",
				dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
				monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
				monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
				changeMonth: true,
				changeYear: true,
				showButtonPanel: true,
				closeText: '닫기',
				currentText: '오늘',
				onClose : function ( selectedDate ) {
					var eleId = $(this).attr("id");
					var optionName = "";
					if(eleId.indexOf("StartDate") > 0) {
						eleId = eleId.replace("StartDate", "EndDate");
						optionName = "minDate";
					} else {
						eleId = eleId.replace("EndDate", "StartDate");
						optionName = "maxDate";
					}
					$("#"+eleId).datepicker( "option", optionName, selectedDate);
					$(".searchDate").find(".chkbox2").removeClass("on");
				}

			});

			$.datepicker._gotoToday = function(id) {
				$(id).datepicker('setDate', new Date()).datepicker('hide').blur();
			};

			$(".dateclick").dateclick();    // DateClick
			$(".searchDate").schDate();        // searchDate

		});

		// Search Date
		jQuery.fn.schDate = function(){
			var $obj = $(this);
			var $chk = $obj.find("input[type=radio]");
			$chk.click(function(){
				$('input:not(:checked)').parent(".chkbox2").removeClass("on");
				$('input:checked').parent(".chkbox2").addClass("on");
			});
		};

		// DateClick
		jQuery.fn.dateclick = function(){
			var $obj = $(this);
			$obj.click(function(){
				$(this).parent().find("input").focus();
			});
		}

	}

	/* 2020.06.10
	초기화시 검색키워드도 포함, 목록 새로고침 추가
	dateReset = function() {
		var $datepicker = $('.datepicker');
		$datepicker.val('');
		$datepicker.datepicker('option', {minDate: null, maxDate: null});
	}
	*/

	dateReset = function() {
		var $datepicker = $('.datepicker');
		$datepicker.val('');
		$datepicker.datepicker('option', {minDate: null, maxDate: null});

		$("#schKeyword").val("");

		$('#frm_list').submit();
	}


	/* 2020.11.03 */
	view_layer = function (_val){
		var popUp = $("#pop_area_question_" + _val);
		popUp.show().find(".pop_dim").show();
	}

	view_layer_hide = function (_val) {
		var popUp = $("#pop_area_question_" + _val);
		popUp.show().hide(".pop_dim").hide();
	}


});



function fn_pop_show() {
	$('.popup, .pop_dim').show();
	$poHeight = $('.popup').outerHeight();
	docWidth = $(document).width(),
	winHeight = $(window).height();
	if ($poHeight > winHeight/*&& $poWidth < docWidth*/) {
		$('.popup').css("top", Math.max(0, $(window).scrollTop()));
		$('.popup').css({
			marginTop:0});
			//,marginLeft:-$poWidth / 2});
		return this;
	}
	else{
		$('.popup').css("top", Math.max(0,  $(window).scrollTop() + jQuery(window).height() / 2) + "px");
		$('.popup').css({
			marginTop: -$poHeight / 2});
			//,marginLeft: -$poWidth / 2});
	   return this;
	}
}



;(function(){
	$.fn.extend({
		uiSwiper: function(obj) {
		/*
		* slick.js 기반의 플러그인(http://kenwheeler.github.io/slick/) slick 옵션+커스텀옵션 추가, 제작자 : 임희재 버전 : v.01
		*/
		var $this = $(this);
		var $slide = null;
		var defaults = {
			/** slickJS 전용객체 */
			slideObj: {
				draggable: false,
			},
			/** 페이징+버튼 */
			uiBtnsApp: {
				target: 'contr',
				uiDot: true,
				uiShortDot: false,
				uiPrev: null,
				uiNext: null,
				uiPause: null,
				uiPlay: null,
			},
			/** dot관련 */
			dotThumb: false,
			dotTabs: false,
			dotTabsLst: '',
			uicallback: function() {},
			/** 슬라이드 콜백관련 */
			beforeCallback: function() {},
			afterCallback: function() {},
		};

		function CmmUiSwiper() {
			this.obj = $exObj;
			this.acallb = function(o) {
				var cb = {
					duration: 300,
					ease: 'easeInExpo',
					complete: function() {}
				};
				if(typeof o === 'object') {
					var $exCb = $.extend(true, cb, o);
					return $exCb;
				}
			};
			if($.fn.slick) this.init();
		};
		CmmUiSwiper.prototype = {
			init: function() {
				this.slickSlide();
			},
			slickSlide: function() {
				var _this = this;
				$slide = $.fn.slick ? $this.slick($.extend(true, {}, this.obj.slideObj)) : null;
				if(!$slide) {
					console.error('slickJS임포트해주세요');
				}
				if(typeof this.obj.afterCallback === 'function' && typeof this.obj.beforeCallback === 'function') {
					$this.on({
						'afterChange': function(a, b, c) {
							_this.obj.afterCallback(a, b, c);
						},
						'beforeChange': function(a, b, c) {
							_this.obj.beforeCallback(a, b, c);
						}
					});
				}
				this.initButtons();
			},
			initButtons: function() {
				if(typeof this.obj.uiBtnsApp !== 'object') {
					$this.find('.slick-prev').show();
					$this.find('.slick-next').show();
					return;
				}
				$this.find('.slick-prev').hide();
				$this.find('.slick-next').hide();
				this.buttons();
			},
			buttons: function() {
				var uiBtnsAppTarget = this.obj.uiBtnsApp.target;
				var buttons = {
					uiDot: this.obj.uiBtnsApp.uiDot ? $this.find('.slick-dots') : null,
					uiPrev: this.obj.uiBtnsApp.uiPrev ? this.obj.uiBtnsApp.uiPrev : 'uiSlidePrev',
					uiNext: this.obj.uiBtnsApp.uiNext ? this.obj.uiBtnsApp.uiNext : 'uiSlideNext',
					uiPause: this.obj.uiBtnsApp.uiPause ? this.obj.uiBtnsApp.uiPause : 'uiSlidePause',
					uiPlay: this.obj.uiBtnsApp.uiPlay ? this.obj.uiBtnsApp.uiPlay : 'uiSlidePlay',
					uiShortDot: this.obj.uiBtnsApp.uiShortDot ? 'uiSlideShortDot' : null,
				};
				$this.parent().append('<div class="' + uiBtnsAppTarget + '"></div>');
				var $uiBtnsAppTarget = $this.parent().find('.' + uiBtnsAppTarget);
				for(var i in buttons) {
					var buttonsVal = buttons[i];
					var html = '';
					switch (i) {
						case 'uiPrev':
						html = $('<a href="#" class="uislide_prev ' + buttonsVal + '" title="이전슬라이드"></a>');
						break;
						case 'uiNext':
						html = $('<a href="#" class="uislide_next ' + buttonsVal + '" title="다음슬라이드"></a>');
						break;
						case 'uiPause':
						if(this.obj.slideObj.autoplay) {
							html = $('<a href="#" class="uislide_pause ' + buttonsVal + '" title="슬라이드 일시정지"></a>');
						}
						break;
						case 'uiPlay':
						if(this.obj.slideObj.autoplay) {
							html = $('<a href="#" class="uislide_play ' + buttonsVal + '" title="슬라이드 재생"></a>');
						}
						break;
						case 'uiShortDot':
						if(this.obj.uiBtnsApp.uiShortDot) {
							html = $('<div class="uislide_shortdot ' + buttonsVal + '"></div>');
						}
						break;
						default:
						html = buttonsVal;
					}
					$uiBtnsAppTarget.append(html);
				}
				if(this.obj.slideObj.dots) {
					if(this.obj.dotThumb) {
						this.dotThumb(buttons);
					} else if(this.obj.dotTabs && this.obj.dotTabsLst) {
						var _this = this;
						this.dotTabs();
						$this.on({
							'afterChange swipe edge': function() {
								_this.dotTabs();
							}
						});
					}
				}
				if(this.obj.uiBtnsApp.uiShortDot) {
					var _this = this;
					this.dotShort(buttons);
					$this.on({
						'afterChange swipe edge': function() {
							_this.dotShort(buttons);
						}
					});
				}
				this.buttonsEvent(buttons);
			},
			dotThumb: function(buttons) {
				var imgSrc = null;
				buttons.uiDot.find('>li').each(function() {
					var $thisIdx = $(this).index();
					var imgSrc = '';
					$this.find('.slick-slide').each(function() {
						if($(this).data('slick-index') == $thisIdx) {
							imgSrc = $(this).find('img').attr('src');
						}
					});
					$(this).find('button').html('<img src="' + imgSrc + '" alt="슬라이드이미지 썸네일" class="uislide_dotimg" />');
				});
			},
			dotShort: function(buttons) {
				var $dots = $this.parent().find('.slick-dots li');
				var $activeDot = null;
				var allTxt = $dots.length;
				$dots.each(function() {
					if($(this).is('.slick-active')) {
						$activeDot = $(this).index() + 1;
					}
				});
				if(!$activeDot) $activeDot = 0;
				$this.parent().find('.' + buttons.uiShortDot).text($activeDot + '/' + allTxt);
			},
			dotTabs: function() {
				var _this = this;
				var $ul = $(this.obj.dotTabsLst);
				var $li = $ul.find('li');
				var $dots = $this.parent().find('.slick-dots');
				var $activeDot = null;
				$dots.find('li').each(function() {
					if($(this).is('.slick-active')) {
						$activeDot = $(this).index();
					}
				});
				$li.removeClass('active');
				$ul.find('li:eq(' + $activeDot + ')').addClass('active');
				$li.off().on({
					'mouseenter click': function() {
						var $thisIdx = $(this).closest('li').index();
						$li.removeClass('active');
						$dots.find('li:eq(' + $thisIdx + ')').click();
						return false;
					},
				});
			},
			buttonsEvent: function(buttons) {
				// $this.parent().find('.' + buttons.uiPause).css('opacity', 1);
				$this.parent().find('.' + buttons.uiPlay).hide();
				$this.parent().find('.' + buttons.uiPrev).on({
					'click': function() {
						$this.find('.slick-prev').click();
						return false;
					}
				});
				$this.parent().find('.' + buttons.uiNext).on({
					'click': function() {
						$this.find('.slick-next').click();
						return false;
					}
				});
				$this.parent().find('.' + buttons.uiPause).on({
					'click': function() {
						$this.slick('slickPause');
						$(this).hide();
						$this.parent().find('.' + buttons.uiPlay).show();
						return false;
					}
				});
				$this.parent().find('.' + buttons.uiPlay).on({
					'click': function() {
						$this.slick('slickPlay');
						$(this).hide();
						$this.parent().find('.' + buttons.uiPause).show();
						return false;
					}
				});
				if(typeof this.obj.uicallback === 'function') {
					this.obj.uicallback();
				}
			},
		};
		var $exObj = $.extend(true, defaults, obj);
		this.each(function() {
			$.data(this, new CmmUiSwiper($exObj));
		});
		return $slide;
	},
	});

})($);


var MainDigCusFun = function () {};;
(function ($) {
	MainDigCusFun = function (_this, idx, params) {
		this.el = _this;
		this.obj = $.extend(true, {
			style: {
				'z-index': 100,
			},
			start: 0,
			end: 0,
			drag: false,
		}, params);
		this.cookieNm = 'close' + idx;
		this.closeBtn = '.fnDayPopCloseBtn';
		this.chkbox = '.fnDayPopCheckbox';

	};
	MainDigCusFun.prototype = {
		init: function () {
			var _this = this;
			this.set();
			this.bind();
			return {
				show: function () {
					$(_this.el).show();
				},
				hide: function () {
					$(_this.el).hide();
				}
			}
		},
		set: function () {
			var server_today = window.SERVER_TODAY || serverToday();
			if ($.ui) {
				if (this.obj.drag && $.ui.draggable) {
					$(this.el).draggable();
				}
			}
			$(this.el).css($.extend(true, {
				'position': 'absolute',
			}, this.obj.style));
			if (this.obj.start && this.obj.end && (this.obj.start < this.obj.end)) {
				var st = server_today;
				if (st >= this.obj.start && st < this.obj.end) {
					this.get();
				} else {
					$(this.el).hide();
				}
			} else {
				this.get();
			}
		},
		get: function () {
			if (this.getCookie(this.cookieNm) != "done") {
				$(this.el).show();
			} else {
				$(this.el).hide();
			}
		},
		setCookie: function (name, value, expiredays) {
			var todayDate = new Date();
			todayDate.setDate(todayDate.getDate() + expiredays);
			document.cookie = name + "=" + escape(value) + "; path=/; expires=" + todayDate.toGMTString() + ";"
		},
		getCookie: function (name) {
			var nameOfCookie = name + "=";
			var x = 0;
			while (x <= document.cookie.length) {
				var y = (x + nameOfCookie.length);
				if (document.cookie.substring(x, y) == nameOfCookie) {
					if ((endOfCookie = document.cookie.indexOf(";", y)) == -1) endOfCookie = document.cookie.length;
					return unescape(document.cookie.substring(y, endOfCookie));
				}
				x = document.cookie.indexOf(" ", x) + 1;
				if (x == 0) {
					break;
				}
			}
			return "";
		},
		bind: function () {
			var _this = this;
			$(this.el).find(this.closeBtn).on({
				'click': function () {
					_this.show();
				},
			});
			$(this.el).find(this.chkbox).on({
				'click': function () {
					_this.show();
				},
			});
		},
		show: function () {
			if ($(this.el).find(this.chkbox).is(":checked") == true) {
				this.setCookie(this.cookieNm, "done", 1);
			}
			$(this.el).hide();
		},
	};
})(jQuery);



function serverToday(year, month, day, hours, minutes) {
	var curDate = new Date();
	var curDateFmt;
	var year = year || curDate.getFullYear();
	var month = month || curDate.getMonth() + 1;
	var day = day || curDate.getDate();
	var hours = hours || curDate.getHours();
	var minutes = minutes || curDate.getMinutes();
	if (parseInt(month) < 10) {
		month = 0 + "" + month;
	}
	if (parseInt(day) < 10) {
		day = 0 + "" + day;
	}
	if (parseInt(hours) < 10) {
		hours = 0 + "" + hours;
	}
	if (parseInt(minutes) < 10) {
		minutes = 0 + "" + minutes;
	}
	curDateFmt = parseInt(year + "" + month + "" + day + "" + hours + "" + minutes);
	//	curDateFmt = "201910021919";
	//	alert(curDateFmt);

	return curDateFmt;
}
