$(function(){
	var company_swiper = new Swiper('#company_swiper .swiper-container', {
		loop:false,
		speed:700,
		slidesPerView: 'auto',
		spaceBetween: 0,
		slidesPerColumn: 2,
		slidesPerGroup: 1,
		loopFillGroupWithBlank: true,
		pagination: {
			el: '#company_swiper .swiper-pagination',
			clickable:true,
		},
		navigation: {
			nextEl: '#company_swiper .swiper-button-next',
			prevEl: '#company_swiper .swiper-button-prev',
		},
		autoplay: {
			delay: 3000,
			disableOnInteraction: false,
		},
	});

	var pop_swiper = new Swiper('#pop_swiper .swiper-container', {
		loop:false,
		speed:700,
		slidesPerView: 1,
		spaceBetween: 0,
		pagination: {
			el: '#pop_swiper .swiper-pagination',
			clickable:true,
		},
		autoplay: {
			delay: 3000,
			disableOnInteraction: false,
		},
	});
	$('#pop_swiper .btn_play').on('click', function(e) {
		var b = $('#pop_swiper .btn_play').hasClass('pause');
		if(b){

			$('#pop_swiper .btn_play').removeClass('pause');
			$('#pop_swiper .btn_play').attr('aria-label','');
			pop_swiper.autoplay.start();
		}else{

			$('#pop_swiper .btn_play').addClass('pause');
			$('#pop_swiper .btn_play').attr('aria-label','');
			pop_swiper.autoplay.stop();
		}
	});


	$('#company .btn_play').on('click', function(e) {
		var b = $('#company .btn_play').hasClass('pause');
		if(b){

			$('#company .btn_play').removeClass('pause');
			$('#company .btn_play').attr('aria-label','');
			company_swiper.autoplay.start();
		}else{

			$('#company .btn_play').addClass('pause');
			$('#company .btn_play').attr('aria-label','');
			company_swiper.autoplay.stop();
		}
	});

	$('.btn_calendar_pop').on('click',function(e){
		e.preventDefault();
		$('#calendar_pop').show();
		$('#calendar_pop .pbox').focus();
	});
	$('.btn_pop_close').on('click',function(e){
		e.preventDefault();
		$('#calendar_pop').hide();
	});

});
