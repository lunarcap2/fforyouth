<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
</head>
<body>
<!-- 상단 -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- 상단 -->

<!-- CONTENTS -->
<div id="career_container" class="searchIdWrap">

	<div class="sch_menu">
		<a href="/my/search/searchID.asp">아이디 찾기</a> &#124; 
		<a href="/my/search/searchPW.asp">비밀번호 재설정</a>
	</div>
    <div id="career_contents">
		
        <div class="memberTab">
			
            <ul class="spl2">
                <li class="on"><a><span>개인회원</span></a></li>
            </ul>

        </div><!-- .memberTab -->

        <div class="layoutBox">
			<input type="hidden" id="emailAuthNumChk" value="0" />
			<input type="hidden" id="mobileAuthNumChk" value="0" />
			<input type="hidden" id="AuthChk" value="0" />
			<input type="hidden" id="hd_kind" value="2" />
			<input type="hidden" id="hd_idx" value="" />
			<input type="hidden" id="userIP" value="<%=Request.ServerVariables("REMOTE_ADDR")%>">
			<input type="hidden" id="site_short_name" value="<%=site_short_name%>">

			<!-- 개인회원 -->
			<div id="memberPer" class="memberInfo sch">
				<div class="titArea">
					<h3>회원정보 입력</h3>
					<span class="txt">회원가입 시 입력한 본인 정보를 정확히 입력하세요.</span>
				</div><!-- .titArea -->
				<div class="inputArea">
					<div class="inp">
						<label for="user_nm">이름</label>
						<input type="text" id="user_nm" class="txt placehd" name="user_nm" placeholder="이름 (실명입력)" />
						<div class="rt" style="display:none;">
							<div class="alertBox">
								<span class="bad">이름에 특수문자, 숫자는 사용하실 수 없습니다.</span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="certiTab">
						<label class="radiobox" for="perCertiWay1">
							<input type="radio" id="perCertiWay1" class="rdi" name="perCertiWay" onclick="memberTabFnc(this,'#certiInfo1.per','#certiInfo2.per');return false;" checked /><span>휴대폰으로 인증받기</span>
						</label>
						<label class="radiobox" for="perCertiWay2">
							<input type="radio" id="perCertiWay2" class="rdi" name="perCertiWay" onclick="memberTabFnc(this,'#certiInfo2.per','#certiInfo1.per');return false;" /><span>이메일로 인증받기</span>
						</label>

						<div class="tabInfoArea">
							<div id="certiInfo1" class="tabInfo per">
								<div class="inp">
									<label for="hp_num">휴대폰 번호</label>
									<input type="text" id="hp_num" class="txt placehd" name="hp_num" placeholder="휴대폰 번호" />
									<div class="rt">
										<div class="alertBox">
											<span class="num" id="hp_count">(00:00)</span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" id="aMobile" onclick="fnAuthSms();">인증번호 전송</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

								<div class="inp">
									<label for="mobileAuthNumber">인증번호</label>
									<input type="text" id="mobileAuthNumber" class="txt placehd" name="mobileAuthNumber" placeholder="인증번호" />
									<div class="rt">
										<div class="alertBox">
											<span class="bad" id="alertBox_sms"></span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" onclick="fnAuth();">인증확인</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

							</div><!-- .tabInfo -->

							<div id="certiInfo2" class="tabInfo per">
								<div class="inp">
									<label for="email_id">이메일</label>
									<input type="text" id="email" class="txt placehd" name="email" placeholder="이메일" />
									<div class="rt">
										<button type="button" class="btn" id="aEmail" onclick="fnAuthemail();">인증번호 전송</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

								<div class="inp">
									<label for="mobileAuthNumber">인증번호</label>
									<input type="text" id="emailAuthNumber" class="txt placehd" name="emailAuthNumber" placeholder="인증번호" />
									<div class="rt">
										<div class="alertBox">
											<span class="bad" id="alertBox_email"></span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" onclick="fnAuth();">인증확인</button>
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
					<a href="#addInfoPer" class="btn typeSky" onclick="onSubmit_ID('USER');">아이디 찾기</a>
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
			<!--// 개인회원 -->

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
				<div id="addInfoPer" class="addLayout">
					<div class="titArea">
						<h3>회원님의 아이디 정보입니다.</h3>
					</div><!-- .titArea -->
					<div class="idArea">
						<ul class="idBox" id="compid_list">
						</ul><!-- .idBox -->
					</div><!-- .idArea -->
					<p class="notiArea">개인정보 보호를 위해 아이디의 일부분을 ‘*’로 표시합니다.</p><!-- .notiArea -->
					<div class="btnWrap">
						<button type="button" class="btn typeSky sizeDown" onclick="location.href = '/my/login.asp'">로그인 하기</button>
						<button type="button" class="btn typeGray sizeDown" onclick="location.href = '/my/search/searchPW.asp'">비밀번호 찾기</button>
					</div><!-- .btnWrap -->
				</div><!-- .addLayout -->
			</div>
		</div>
	</div>				
</div>
<!-- 아이디 찾기 결과 // -->
</body>
</html>