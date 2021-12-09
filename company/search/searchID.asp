<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<script type="text/javascript">
	$(document).ready(function () {
			$("#comp_nm").bind("keyup keydown", function () {
				var pattern_spc = /[~!@#$%^&*()_+|<>?:{}]/; // 특수문자
				var pattern_num = /[0-9]/;	// 숫자

				if($("#comp_nm").val() == "" || pattern_spc.test($("#comp_nm").val()) || pattern_num.test($("#comp_nm").val())){
					$("#nm_box").css("display", "block");
					$("#nm_box").text("이름에 특수문자, 숫자는 사용하실 수 없습니다.");
					$("#comp_nm").focus();
					return;
				}
				else {
					$("#nm_box").css("display", "none");
					return;
				}
			});
		});
</script>
</head>

<body>
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- 상단 -->

<!-- CONTENTS -->
<div id="career_container" class="searchIdWrap">

	<div class="sch_menu">
		<a href="/company/search/searchID.asp">아이디 찾기</a> &#124; <a href="/company/search/searchPW.asp">비밀번호 재설정</a>	
    </div>
    <div id="career_contents">

        <div class="memberTab">
            <ul class="spl2">
                <li class="on"><a><span>기업회원</span></a></li>
            </ul>
        </div><!-- .memberTab -->

        <div class="layoutBox">

			<!-- 기업회원 -->
			<input type="hidden" id="comp_type" value="5">
			<input type="hidden" id="emailAuthNumChk_biz" value="0" />
			<input type="hidden" id="mobileAuthNumChk_biz" value="0" />
			<input type="hidden" id="AuthChk_biz" value="0" />
			<input type="hidden" id="hd_kind_biz" value="2" />
			<input type="hidden" id="hd_idx_biz" value="" />
			<input type="hidden" id="site_short_name" value="<%=site_short_name%>">

			<div id="memberComp" class="memberInfo comp" style="display:block;">
				<div class="titArea">
					<h3>회원정보 입력</h3>
					<span class="txt">회원가입 시 입력한 본인 정보를 정확히 입력하세요.</span>
				</div><!-- .titArea -->
				<div class="inputArea">
					<div class="inp">
						<label for="comp_num">사업자등록번호</label>
						<input type="text" id="comp_num" class="txt placehd" name="comp_num" placeholder="사업자등록번호 ( - 없이 입력)"  onkeypress="return numkeyCheck(event);" />
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_nm">이름</label>
						<input type="text" id="comp_nm" class="txt placehd" name="comp_nm" placeholder="가입당시 채용담당자 (실명) 입력" />
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="nm_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="certiTab">
						<label class="radiobox" for="compCertiWay1">
							<input type="radio" id="compCertiWay1" class="rdi" name="compCertiWay" onclick="memberTabFnc(this,'#certiInfo1.comp','#certiInfo2.comp');return false;" checked /><span>휴대폰으로 인증받기</span>
						</label>
						<label class="radiobox" for="compCertiWay2">
							<input type="radio" id="compCertiWay2" class="rdi" name="compCertiWay" onclick="memberTabFnc(this,'#certiInfo2.comp','#certiInfo1.comp');return false;" /><span>이메일로 인증받기</span>
						</label>
						<div class="tabInfoArea">
							<div id="certiInfo1" class="tabInfo comp">
								<div class="inp">
									<label for="hp_num">휴대폰 번호</label>
									<input type="text" id="hp_num_biz" class="txt placehd" name="hp_num_biz" placeholder="휴대폰 번호" />
									<div class="rt">
										<div class="alertBox">
											<span class="num" id="hp_count_biz">(00:00)</span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" id="aMobile_biz" onclick="fnAuthSms_biz();">인증번호 전송</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

								<div class="inp">
									<label for="mobileAuthNumber">인증번호</label>
									<input type="text" id="mobileAuthNumber_biz" class="txt placehd" name="mobileAuthNumber_biz" placeholder="인증번호" />
									<div class="rt">
										<div class="alertBox">
											<span class="bad" id="alertBox_sms_biz"></span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" onclick="fnAuth_biz();">인증확인</button>
									</div><!-- .rt -->
								</div><!-- .inp -->
							</div><!-- .tabInfo -->
							<div id="certiInfo2" class="tabInfo comp">
								<div class="inp">
									<label for="email_id">이메일</label>
									<input type="text" id="email_biz" class="txt placehd" name="email_biz" placeholder="이메일" />
									<div class="rt">
										<button type="button" class="btn" id="aEmail_biz" onclick="fnAuthemail_biz();">인증번호 전송</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

								<div class="inp">
									<label for="mobileAuthNumber">인증번호</label>
									<input type="text" id="emailAuthNumber_biz" class="txt placehd" name="emailAuthNumber_biz" placeholder="인증번호" />
									<div class="rt">
										<div class="alertBox">
											<span class="bad" id="alertBox_email_biz"></span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" onclick="fnAuth_biz();">인증확인</button>
									</div><!-- .rt -->
								</div><!-- .inp -->
							</div><!-- .tabInfo -->
						</div><!-- .tabInfoArea -->

						<script type="text/javascript">
							function memberTabFnc(obj, obj1, obj2) {//탭메뉴
								var _this = $(obj);
								var _tab = _this.parent('li')
								var _index = _tab.index()
								var _areaN = $(obj1)
								var _area = $(obj2)
								_tab.addClass('on').siblings("li").removeClass("on")
								_areaN.css("display","block");
								_area.css("display","none");
							}//탭메뉴
						</script>
					</div><!-- .certiTab -->
				</div><!-- .inputArea -->

				<div class="btnWrap">
					<a href="#addInfoComp" class="btn typeSky" onclick="onSubmit_ID('Biz');">아이디 찾기</a>
				</div><!-- .btnWrap -->

				<div class="customCenter">
					<dl>
						<dt><%=site_name%> 운영사무국</dt>
						<dd><%=site_name%> 운영사무국</dd>
						<dd class="tel">
							<span>TEL) <strong class="num">02-2006-9512</strong></span>
							<span>FAX) 02-2006-9594</span>
						</dd><!-- .tel -->
						<dd class="time">
							<em>상담운영시간 :</em> 평일 10시~18시 까지 (주말, 공휴일 휴무)
						</dd><!-- .time -->
						<dd class="email">
							<span>e-mail)</span> <a href="mailto:<%=site_helpdesk_mail%>"><%=site_helpdesk_mail%></a>
						</dd><!-- .email -->
					</dl>
				</div><!-- .customCenter -->

			</div><!-- .memberInfo -->
			<!--// 기업회원 -->

        </div><!-- .layoutBox -->
    </div><!-- #career_contents -->
</div><!-- #career_container -->
<!--// CONTENTS -->

<!-- 하단 -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- 하단 -->

<!-- // 아이디 찾기 결과  -->
<div class="pop_dim"></div>
<div class="popup">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>아이디 찾기 결과</h3>
			<a href="javaScript:;" class="layer_close">&#215;</a>	
		</div>
		<div class="pop_con">
			<div class="pop_tb">
				<div id="addInfoComp" class="addLayout">
					<div class="titArea">
						<h3>회원님의 기업아이디 정보입니다.</h3>
					</div><!-- .titArea -->
					<div class="idArea">
						<ul class="idBox" id="compid_list">
						</ul><!-- .idBox -->
					</div><!-- .idArea -->
					<p class="notiArea"></p><!-- .notiArea -->
					<div class="btnWrap">
						<button type="button" class="btn typeSky sizeDown" onclick="location.href = '/company/login.asp'">로그인 하기</button>
						<button type="button" class="btn typeGray sizeDown" onclick="location.href = '/company/search/searchPW.asp'">비밀번호 찾기</button>
					</div><!-- .btnWrap -->
				</div><!-- .addLayout -->
			</div>
		</div>	
	</div>				
</div>
<!-- 아이디 찾기 결과 // -->

</body>
</html>