<script type="text/javascript">
	// 결과통보하기 셋팅
	function fn_rece_set() {
		var gubun	= "";
		var kw		= "";
		var Tem		= "";

		var rece_type		= $('input:radio[name=tb1_1]:checked').val();
		var rece_sch		= $("#schManager option:selected").val();
		var TmpID			= (rece_type == "email") ? "rece_con_E" : "rece_con_S";

		gubun	= $("#schManager option:selected").val();
		kw		= $("#kw_nm").val();
		
		$.ajax({
			type: "POST",
			url: "/company/applyjob/ajax_apply_result_rece_set.asp",
			data: { mode: "<%=mode%>", jid: "<%=jid%>", gubun: gubun, kw: escape(kw), rece_type: rece_type, rece_sch: rece_sch },
			dataType: "text",
			async: true,
			success: function (data) {
				var arr	= data.split('@');
				
				if (arr[0] != "") {
					Tmp = arr[0];
				}
				else {
					switch(gubun)
					{
						case "7":
							Tmp = "[ <%=jid_NM%> 면접 전형 결과 안내 ]\r\n\r\n"
							Tmp += "안녕하세요. <%=comname%> 채용담당자 입니다.\r\n\r\n"
							Tmp += "지원하신 [ <%=jid_NM%> ] 면접에 합격하셨습니다.\r\n\r\n"
							Tmp += "이후 진행사항은 개별로 연락드릴 예정입니다.\r\n\r\n"
							Tmp += "다시 한번 축하드립니다.\r\n\r\n"
							Tmp += "감사합니다."
							break;	
						case "6":
							Tmp = "[ <%=jid_NM%> 면접 전형 결과 안내 ]\r\n\r\n"
							Tmp += "안녕하세요. <%=comname%> 채용담당자 입니다.\r\n\r\n"
							Tmp += "지원하신 [ <%=jid_NM%> ] 면접에 아쉽게도 불합격 되셨습니다.\r\n\r\n"
							Tmp += "개인의 능력은 흠잡을 수 없을 만큼 출중하지만,\r\n"
							Tmp += "이번 채용에는 함께 할 수 없게 되어 매우 아쉽습니다.\r\n\r\n"
							Tmp += "귀하의 앞날이 번창하시기를 항상 응원하겠습니다.\r\n\r\n"
							Tmp += "감사합니다."
							break;
						case "5":
							Tmp = "[ <%=jid_NM%> 서류 전형 결과 안내 ]\r\n\r\n"
							Tmp += "안녕하세요. <%=comname%> 채용담당자 입니다.\r\n\r\n"
							Tmp += "[ <%=jid_NM%> ] 공고에 지원해 주셔서 감사합니다.\r\n\r\n"
							Tmp += "개인의 능력은 흠잡을 수 없을 만큼 출중하지만,\r\n"
							Tmp += "이번 채용에는 함께 할 수 없게 되어 매우 아쉽습니다.\r\n\r\n"
							Tmp += "귀하의 앞날이 번창하시기를 항상 응원하겠습니다.\r\n\r\n"
							Tmp += "감사합니다."
							break;
					}
				}
				
				$("#rece_tit").val("[<%=site_name%>] " + "<%=jid_NM%> " + rece_sch.replace("5", "서류").replace("6", "면접").replace("7", "면접") + "전형 결과 안내");
				$("#"+TmpID).val(Tmp);
				fn_letters_count($("#"+TmpID));

				$('#receList').html(arr[1]);
				
			}, error: function (XMLHttpRequest, textStatus, errorThrown) {
				 //alert("code:"+XMLHttpRequest.textStatus+"\n"+"error:"+errorThrown);
			}
		});
	}
	
	// 전송하기
	function fn_sumbit() {
		var chk				= $(".checkbox.on > input[name=rece_list]");

		var receiver		= "";																		// 받는사람
		var rece_type		= $('input:radio[name=tb1_1]:checked').val();								// 통보방법
		var rece_tit		= $("#rece_tit").val();														// 제목
		var rece_con		= (rece_type == "email") ? $("#rece_con_E").val() : $("#rece_con_S").val();	// 내용
		var smsYN			= $('input:checkbox[id=sms_YN]:checked').val();								// sms함께보내기
		var rece_sch		= $("#schManager option:selected").val();									// 받는사람 구분
		
		var jid				= "<%=jid%>"
		
		if (rece_tit == "" && rece_type == "email") {
			alert("제목을 입력해 주세요.");
			return;
		}

		if (rece_con == "") {
			alert("내용을 입력해 주세요.");
			return;
		}

		if (chk.length == 0) {
			alert("받는사람을 선택해 주세요.");
			return;
		}
		else {
			for (i = 0; i < chk.length; i++) {
				receiver = (i == 0) ? chk.eq(i).val() : receiver + "," + chk.eq(i).val();
			}
		}

		if(confirm('결과를 전송하시겠습니까?')) {
			$.ajax({
				type: "POST"
				, url: "/company/applyjob/ajax_apply_result_send.asp"
				, data: { receiver: receiver, rece_type: rece_type, rece_tit: escape(rece_tit), rece_con: escape(rece_con.replace(/(\n|\r\n)/g, '<br>')), smsYN: smsYN, jid: jid, rece_sch: rece_sch }
				, dataType: "html"
				, async: true
				, success: function (data) {
					location.reload(true);
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
				    //alert(XMLHttpRequest.responseText);
				}
			});
		}
	}
	
	// 미리보기
	function fn_preview() {
		var rece_type		= $('input:radio[name=tb1_1]:checked').val();
		var rece_sch		= $("#schManager option:selected").val();
		var rece_tit		= (rece_type == "email") ? $("#rece_tit").val() : rece_sch.replace("5", "서류").replace("6", "면접").replace("7", "면접") + "전형 결과 안내";
		var rece_con		= (rece_type == "email") ? $("#rece_con_E").val() : $("#rece_con_S").val();
		
		$("#pre_div_tit").html(rece_tit);
		$("#pre_div_con").html(rece_con.replace(/(\n|\r\n)/g, '<br>'));
		$("#preview").show();
	}
	
	// 내용저장
	function fn_con_save() {
		var rece_type		= $('input:radio[name=tb1_1]:checked').val();
		var rece_sch		= $("#schManager option:selected").val();
		var rece_con		= (rece_type == "email") ? $("#rece_con_E").val() : $("#rece_con_S").val();

		if(confirm('내용을 저장하시겠습니까?')) {
			$.ajax({
				type: "POST"
				, url: "/company/applyjob/ajax_apply_result_saveCon.asp"
				, data: { comid: "<%=comid%>", rece_type: rece_type, rece_sch: rece_sch, rece_con: escape(rece_con) }
				, dataType: "html"
				, async: true
				, success: function (data) {
					if(data == "1") {
						alert("저장되었습니다.");
						
						$("#rece_con_Save").parent().removeClass('on').addClass('off');						
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
				    //alert(XMLHttpRequest.responseText);
				}
			});
		}
	}
	
	//글자수 실시간 카운팅
	function fn_letters_count(obj) {
		obj = obj || $("#rece_con_S").val();
		var content = $(obj).val();
		$('#counter').html(content.length);    

		if (content.length > 2000){
			alert("최대 2000자까지 입력 가능합니다.");
			$(this).val(content.substring(0, 2000));
			$('#counter').html("2000");
		}
	}
</script>

<div id="pop_result_apply">
<div id="pop_dim" class="pop_dim"></div>
<div id="popup" class="popup">
	<div class="pop_wrap">
		<div class="pop_head">
			<h3>결과 통보</h3>
			<a href="#none" class="layer_close">닫기</a>
		</div> 
		
		<div class="pop_con">
			<div class="tabs">
				<ul>
					<li><a href="#tc1">결과통보하기</a></li>
					<li><a href="#tc2">통보내역</a></li>
				</ul>
			</div>
			<div id="tc1" class="tab_content">
				<div class="tb_area result" style="padding:30px 0 55px;">
					<!--#include file="./apply_result_receiver.asp"-->

					<table class="tb" id="tb_email">
						<colgroup>
							<col style="width:180px;"/>
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th class="th_tit">제목</th>
								<td>
									<input type="text" id="rece_tit" name="name" class="txt" style="width:100%;" placeholder="보낼 메일 제목을 입력해 주세요">
								</td>
							</tr>
							<tr>
								<th class="th_txt">내용</th>
								<td>
									<textarea style="height:276px;" id="rece_con_E" placeholder="내용을 입력해 주세요."></textarea>
								</td>
							</tr>
						</tbody>
					</table>

					<table class="tb" id="tb_sms">
						<colgroup>
							<col style="width:180px;"/>
							<col />
						</colgroup>
						<tbody>
							<tr>
								<th class="th_txt">내용</th>
								<td>
									<div class="td_count">
										<textarea style="height:276px;" id="rece_con_S" placeholder="내용을 입력해 주세요." onkeyup="fn_letters_count(this);" onkeypress="fn_letters_count(this);"></textarea>
										<div class="count">
											<p><span id="counter">0</span>/2,000<p>
										</div>
									</div>
									<ul class="ment">
										<li>※ 야간발송 금지 정책에 의해 오후 9시 이후의 SMS는 익일 오전9시에 일괄발송 됩니다.</li>
										<li>
											※ 2015년 10월16일부터 전기통신사업법 제84조에 의거 발신번호 사전등록제가 시행되고 있습니다.<br>
										   문자 발송을 위해 발신번호를 등록해 주세요. 발신번호 미등록 시 문자발송 서비스 이용이 불가능 합니다.
										</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="chk_area">
						<label class="checkbox off left" id="chk_sms">
							<input class="chk" id="sms_YN" name="" type="checkbox" value="Y">
							<span>문자함께 보내기</span>
						</label>
						<label class="checkbox off right">
							<input class="chk" id="rece_con_Save" name="" type="checkbox" onclick="fn_con_save();">
							<span>내용 저장</span>
						</label>
					</div>
				</div>

				<div class="pop_footer">
					<div class="btn_area">
						<a href="javaScript:;" onclick="javascript:fn_preview();"  class="btn gray pop3">미리보기</a>
						<a href="javaScript:;" onclick="javascript:fn_sumbit();"  class="btn blue">전송하기</a>
					</div>
				</div>
			</div>
			
			<iframe src="/company/applyjob/apply_result_history.asp?jid=<%=jid%>" id="tc2" class="tab_content" border="0" cellspacing="0" frameborder="0" width="100%"></iframe>	
		</div>
	</div>				
</div>
</div>

<!-- 미리보기 -->
<!--#include file = "./apply_result_preview.asp"-->
<!-- 미리보기 -->