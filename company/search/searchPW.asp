<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header.asp"-->

<script type="text/javascript">
	$(document).ready(function () {
			$("#comp_nm").bind("keyup keydown", function () {
				var pattern_spc = /[~!@#$%^&*()_+|<>?:{}]/; // Ư������
				var pattern_num = /[0-9]/;	// ����

				if($("#comp_nm").val() == "" || pattern_spc.test($("#comp_nm").val()) || pattern_num.test($("#comp_nm").val())){
					$("#nm_box").css("display", "block");
					$("#nm_box").text("�̸��� Ư������, ���ڴ� ����Ͻ� �� �����ϴ�.");
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
<!-- ��� -->
<!--#include virtual = "/include/gnb/topMenu.asp"-->
<!-- ��� -->

<!-- CONTENTS -->
<div id="career_container" class="searchIdWrap">

	<div class="sch_menu">
		<a href="/company/search/searchID.asp">���̵� ã��</a> &#124; <a href="/company/search/searchPW.asp">��й�ȣ �缳��</a>
    </div>
    <div id="career_contents">

        <div class="memberTab">
            <ul class="spl2">
                <li class="on"><a><span>���ȸ��</span></a></li>
            </ul>
        </div><!-- .memberTab -->

        <div class="layoutBox">
			<input type="hidden" id="comp_type" value="5">
			<input type="hidden" id="emailAuthNumChk_biz" value="0" />
			<input type="hidden" id="mobileAuthNumChk_biz" value="0" />
			<input type="hidden" id="AuthChk_biz" value="0" />
			<input type="hidden" id="hd_kind_biz" value="2" />
			<input type="hidden" id="hd_idx_biz" value="" />
			<input type="hidden" id="site_short_name" value="<%=site_short_name%>">

			<!-- ���ȸ�� -->
			<div id="memberComp" class="memberInfo comp" style="display:block;">
				<div class="titArea">
					<h3>ȸ������ �Է�</h3>
					<span class="txt">ȸ������ �� �Է��� ���� ������ ��Ȯ�� �Է��ϼ���.</span>
				</div><!-- .titArea -->
				
				<div class="inputArea">
					<div class="inp">
						<label for="comp_num">����ڵ�Ϲ�ȣ</label>
						<input type="text" id="comp_num" class="txt placehd" name="comp_num" placeholder="����ڵ�Ϲ�ȣ ( - ���� �Է�)">
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_id">���̵�</label>
						<input type="text" id="com_id" class="txt placehd" name="com_id" placeholder="���̵� (5~12�� ����, ���� �Է�)">

						<div class="rt">
							<div class="alertBox">
								<span class="good" id="id_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="inp">
						<label for="user_nm">�̸�</label>
						<input type="text" id="comp_nm" class="txt placehd" name="com_nm" placeholder="���Դ�� ä������ (�Ǹ�) �Է�">
						<div class="rt">
							<div class="alertBox">
								<span class="bad" id="nm_box"></span>
							</div><!-- .alertBox -->
						</div><!-- .rt -->
					</div><!-- .inp -->
					<div class="certiTab">
						<label class="radiobox on" for="compCertiWay1">
							<input type="radio" id="compCertiWay1" class="rdi" name="compCertiWay" onclick="memberTabFnc(this,'#certiInfo1.comp','#certiInfo2.comp');return false;" checked=""><span>�޴������� �����ޱ�</span>
						</label>
						<label class="radiobox off" for="compCertiWay2">
							<input type="radio" id="compCertiWay2" class="rdi" name="compCertiWay" onclick="memberTabFnc(this,'#certiInfo2.comp','#certiInfo1.comp');return false;"><span>�̸��Ϸ� �����ޱ�</span>
						</label>
						<div class="tabInfoArea">
							<div id="certiInfo1" class="tabInfo comp">
								<div class="inp">
									<label for="hp_num">�޴��� ��ȣ</label>
									<input type="text" id="hp_num_biz" class="txt placehd" name="hp_num_biz" placeholder="�޴��� ��ȣ">
									<div class="rt">
										<div class="alertBox">
											<span class="num" id="hp_count_biz">(00:00)</span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" id="aMobile_biz" onclick="fnAuthSms_biz();">������ȣ ����</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

								<div class="inp" id="aMobile_bizNum" style="display:none;">
									<label for="mobileAuthNumber">������ȣ</label>
									<input type="text" id="mobileAuthNumber_biz" class="txt placehd" name="mobileAuthNumber_biz" placeholder="������ȣ">
									<div class="rt">
										<div class="alertBox">
											<span class="bad" id="alertBox_sms_biz"></span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" onclick="fnAuth_biz();">����Ȯ��</button>
									</div><!-- .rt -->
								</div><!-- .inp -->
							</div><!-- .tabInfo -->
							<div id="certiInfo2" class="tabInfo comp">
								<div class="inp">
									<label for="email_id">�̸���</label>
									<input type="text" id="email_biz" class="txt placehd" name="email_biz" placeholder="�̸���">
									<div class="rt">
										<button type="button" class="btn" id="aEmail_biz" onclick="fnAuthemail_biz();">������ȣ ����</button>
									</div><!-- .rt -->
								</div><!-- .inp -->

								<div class="inp" id="aEmail_bizNum" style="display:none;">
									<label for="mobileAuthNumber">������ȣ</label>
									<input type="text" id="emailAuthNumber_biz" class="txt placehd" name="emailAuthNumber_biz" placeholder="������ȣ">
									<div class="rt">
										<div class="alertBox">
											<span class="bad" id="alertBox_email_biz"></span>
										</div><!-- .alertBox -->
										<button type="button" class="btn" onclick="fnAuth_biz();">����Ȯ��</button>
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
					<a href="#addInfoComp" class="btn typeSky" onclick="onSubmit_PW('Biz');">��й�ȣ �缳��</a>
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
			<!--// ���ȸ�� -->

        </div><!-- .layoutBox -->
    </div><!-- #career_contents -->
</div><!-- #career_container -->
<!--// CONTENTS -->

<!-- �ϴ� -->
<!--#include virtual = "/include/footer/footer.asp"-->
<!-- �ϴ� -->

<!-- // ��й�ȣ �缳��  -->
<div class="pop_dim"></div>
<div class="popup">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>��й�ȣ �缳��</h3>
			<a href="javaScript:;" class="layer_close">&#215;</a>	
		</div>
		<div class="pop_con">
			<div class="pop_tb">
				<div id="addInfoComp" class="addLayout" style="display: block;">
					<div class="titArea">
						<h3>���ο� ��й�ȣ�� �Է��ϼ���.</h3>
					</div><!-- .titArea -->
					<div class="inputArea">
						<div class="inp">
							<label for="new_pw1">���ο� ��й�ȣ</label>
							<input type="password" id="new_pw1_biz" class="txt placehd" name="new_pw1" placeholder="���ο� ��й�ȣ �Է�">
						</div><!-- .inp -->
						<div class="inp">
							<label for="new_pw2">���ο� ��й�ȣ Ȯ��</label>
							<input type="password" id="new_pw2_biz" class="txt placehd" name="new_pw2" placeholder="���ο� ��й�ȣ �Է� Ȯ��">
						</div><!-- .inp -->
					</div><!-- .inputArea -->
					<p class="notiArea">����, ����, Ư�����ڸ� ������ 8~32��, ���ӵ� ����(a,b,c / 1,2,3) ��� �Ұ�</p><!-- .notiArea -->
					<div class="btnWrap">
						<button type="button" class="btn typeSky sizeDown" onclick="PW_Modify('Biz');">��й�ȣ ����</button>
						<button type="button" class="btn typeGray sizeDown"onclick="javascript:$('.popup, .pop_dim').hide();">����ϱ�</button>
					</div><!-- .btnWrap -->
				</div><!-- .addLayout -->
			</div>
		</div>
	</div>				
</div>
<!-- ��й�ȣ �缳�� // -->

</body>
</html>