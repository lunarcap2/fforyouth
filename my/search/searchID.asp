<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->
</head>
<body>
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- CONTENTS -->
<div id="career_container" class="searchIdWrap">

	<div class="sch_menu">
		<a href="/my/search/searchID.asp">���̵� ã��</a> &#124; 
		<a href="/my/search/searchPW.asp">��й�ȣ �缳��</a>
	</div>
    <div id="career_contents">
		
        <div class="memberTab">
			
            <ul class="spl2">
                <li class="on"><a><span>����ȸ��</span></a></li>
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

			<!-- ����ȸ�� -->
			<div id="memberPer" class="memberInfo sch">
				<div class="titArea">
					<h3>ȸ������ �Է�</h3>
					<span class="txt">ȸ������ �� �Է��� ���� ������ ��Ȯ�� �Է��ϼ���.</span>
				</div><!-- .titArea -->
				<div class="inputArea">
					<div class="inp">
						<label for="user_nm">�̸�</label>
						<input type="text" id="user_nm" class="txt placehd" name="user_nm" placeholder="�̸� (�Ǹ��Է�)" />
						<div class="rt" style="display:none;">
							<div class="alertBox">
								<span class="bad">�̸��� Ư������, ���ڴ� ����Ͻ� �� �����ϴ�.</span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="certiTab">
						<label class="radiobox" for="perCertiWay1">
							<input type="radio" id="perCertiWay1" class="rdi" name="perCertiWay" onclick="memberTabFnc(this,'#certiInfo1.per','#certiInfo2.per');return false;" checked /><span>�޴������� �����ޱ�</span>
						</label>
						<label class="radiobox" for="perCertiWay2">
							<input type="radio" id="perCertiWay2" class="rdi" name="perCertiWay" onclick="memberTabFnc(this,'#certiInfo2.per','#certiInfo1.per');return false;" /><span>�̸��Ϸ� �����ޱ�</span>
						</label>

						<div class="tabInfoArea">
							<div id="certiInfo1" class="tabInfo per">
								<div class="inp">
									<label for="hp_num">�޴��� ��ȣ</label>
									<input type="text" id="hp_num" class="txt placehd" name="hp_num" placeholder="�޴��� ��ȣ" />
									<div class="rt">
										<div class="alertBox">
											<span class="num" id="hp_count">(00:00)</span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" id="aMobile" onclick="fnAuthSms();">������ȣ ����</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

								<div class="inp">
									<label for="mobileAuthNumber">������ȣ</label>
									<input type="text" id="mobileAuthNumber" class="txt placehd" name="mobileAuthNumber" placeholder="������ȣ" />
									<div class="rt">
										<div class="alertBox">
											<span class="bad" id="alertBox_sms"></span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" onclick="fnAuth();">����Ȯ��</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

							</div><!-- .tabInfo -->

							<div id="certiInfo2" class="tabInfo per">
								<div class="inp">
									<label for="email_id">�̸���</label>
									<input type="text" id="email" class="txt placehd" name="email" placeholder="�̸���" />
									<div class="rt">
										<button type="button" class="btn" id="aEmail" onclick="fnAuthemail();">������ȣ ����</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

								<div class="inp">
									<label for="mobileAuthNumber">������ȣ</label>
									<input type="text" id="emailAuthNumber" class="txt placehd" name="emailAuthNumber" placeholder="������ȣ" />
									<div class="rt">
										<div class="alertBox">
											<span class="bad" id="alertBox_email"></span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" onclick="fnAuth();">����Ȯ��</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

							</div><!-- .tabInfo -->
						</div><!-- .tabInfoArea -->

						<script type="text/javascript">
							function memberTabFnc(obj, obj1, obj2) {//�Ǹ޴�
								var _this = $(obj);
								var _tab = _this.parent('li')
								var _index = _tab.index()
								var _areaN = $(obj1)
								var _area = $(obj2)
								_tab.addClass('on').siblings("li").removeClass("on")
								_areaN.css("display","block");
								_area.css("display","none");
							}//�Ǹ޴�
						</script>
					</div><!-- .certiTab -->
				</div><!-- .inputArea -->

				<div class="btnWrap">
					<a href="#addInfoPer" class="btn typeSky" onclick="onSubmit_ID('USER');">���̵� ã��</a>
				</div><!-- .btnWrap -->

				<div class="customCenter">
					<dl>
						<dt><%=site_name%> ��繫��</dt>
						<dd><%=site_name%> ��繫��</dd>
						<dd class="tel">
							<span>TEL) <strong class="num">02-2006-9512</strong></span>
							<span>FAX) 02-2006-9594</span>
						</dd><!-- .tel -->
						<dd class="time">
							<em>����ð� :</em> ���� 10��~18�� ���� (�ָ�, ������ �޹�)
						</dd><!-- .time -->
						<dd class="email">
							<span>e-mail)</span> <a href="mailto:<%=site_helpdesk_mail%>"><%=site_helpdesk_mail%></a>
						</dd><!-- .email -->
					</dl>
				</div><!-- .customCenter -->

			</div><!-- .memberInfo -->
			<!--// ����ȸ�� -->

        </div><!-- .layoutBox -->
    </div><!-- #career_contents -->
</div><!-- #career_container -->
<!--// CONTENTS -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

<!-- // ���̵� ã�� ���  -->
<div class="pop_dim"></div>
<div class="popup">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>���̵� ã�� ���</h3>
			<a href="javaScript:;" class="layer_close">&#215;</a>	
		</div>
		<div class="pop_con">
			<div class="pop_tb">
				<div id="addInfoPer" class="addLayout">
					<div class="titArea">
						<h3>ȸ������ ���̵� �����Դϴ�.</h3>
					</div><!-- .titArea -->
					<div class="idArea">
						<ul class="idBox" id="compid_list">
						</ul><!-- .idBox -->
					</div><!-- .idArea -->
					<p class="notiArea">�������� ��ȣ�� ���� ���̵��� �Ϻκ��� ��*���� ǥ���մϴ�.</p><!-- .notiArea -->
					<div class="btnWrap">
						<button type="button" class="btn typeSky sizeDown" onclick="location.href = '/my/login.asp'">�α��� �ϱ�</button>
						<button type="button" class="btn typeGray sizeDown" onclick="location.href = '/my/search/searchPW.asp'">��й�ȣ ã��</button>
					</div><!-- .btnWrap -->
				</div><!-- .addLayout -->
			</div>
		</div>
	</div>				
</div>
<!-- ���̵� ã�� ��� // -->
</body>
</html>