<script type="text/javascript">
	// ����뺸�ϱ� ����
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
							Tmp = "[ <%=jid_NM%> ���� ���� ��� �ȳ� ]\r\n\r\n"
							Tmp += "�ȳ��ϼ���. <%=comname%> ä������ �Դϴ�.\r\n\r\n"
							Tmp += "�����Ͻ� [ <%=jid_NM%> ] ������ �հ��ϼ̽��ϴ�.\r\n\r\n"
							Tmp += "���� ��������� ������ �����帱 �����Դϴ�.\r\n\r\n"
							Tmp += "�ٽ� �ѹ� ���ϵ帳�ϴ�.\r\n\r\n"
							Tmp += "�����մϴ�."
							break;	
						case "6":
							Tmp = "[ <%=jid_NM%> ���� ���� ��� �ȳ� ]\r\n\r\n"
							Tmp += "�ȳ��ϼ���. <%=comname%> ä������ �Դϴ�.\r\n\r\n"
							Tmp += "�����Ͻ� [ <%=jid_NM%> ] ������ �ƽ��Ե� ���հ� �Ǽ̽��ϴ�.\r\n\r\n"
							Tmp += "������ �ɷ��� ������ �� ���� ��ŭ ����������,\r\n"
							Tmp += "�̹� ä�뿡�� �Բ� �� �� ���� �Ǿ� �ſ� �ƽ����ϴ�.\r\n\r\n"
							Tmp += "������ �ճ��� ��â�Ͻñ⸦ �׻� �����ϰڽ��ϴ�.\r\n\r\n"
							Tmp += "�����մϴ�."
							break;
						case "5":
							Tmp = "[ <%=jid_NM%> ���� ���� ��� �ȳ� ]\r\n\r\n"
							Tmp += "�ȳ��ϼ���. <%=comname%> ä������ �Դϴ�.\r\n\r\n"
							Tmp += "[ <%=jid_NM%> ] ���� ������ �ּż� �����մϴ�.\r\n\r\n"
							Tmp += "������ �ɷ��� ������ �� ���� ��ŭ ����������,\r\n"
							Tmp += "�̹� ä�뿡�� �Բ� �� �� ���� �Ǿ� �ſ� �ƽ����ϴ�.\r\n\r\n"
							Tmp += "������ �ճ��� ��â�Ͻñ⸦ �׻� �����ϰڽ��ϴ�.\r\n\r\n"
							Tmp += "�����մϴ�."
							break;
					}
				}
				
				$("#rece_tit").val("[<%=site_name%>] " + "<%=jid_NM%> " + rece_sch.replace("5", "����").replace("6", "����").replace("7", "����") + "���� ��� �ȳ�");
				$("#"+TmpID).val(Tmp);
				fn_letters_count($("#"+TmpID));

				$('#receList').html(arr[1]);
				
			}, error: function (XMLHttpRequest, textStatus, errorThrown) {
				 //alert("code:"+XMLHttpRequest.textStatus+"\n"+"error:"+errorThrown);
			}
		});
	}
	
	// �����ϱ�
	function fn_sumbit() {
		var chk				= $(".checkbox.on > input[name=rece_list]");

		var receiver		= "";																		// �޴»��
		var rece_type		= $('input:radio[name=tb1_1]:checked').val();								// �뺸���
		var rece_tit		= $("#rece_tit").val();														// ����
		var rece_con		= (rece_type == "email") ? $("#rece_con_E").val() : $("#rece_con_S").val();	// ����
		var smsYN			= $('input:checkbox[id=sms_YN]:checked').val();								// sms�Բ�������
		var rece_sch		= $("#schManager option:selected").val();									// �޴»�� ����
		
		var jid				= "<%=jid%>"
		
		if (rece_tit == "" && rece_type == "email") {
			alert("������ �Է��� �ּ���.");
			return;
		}

		if (rece_con == "") {
			alert("������ �Է��� �ּ���.");
			return;
		}

		if (chk.length == 0) {
			alert("�޴»���� ������ �ּ���.");
			return;
		}
		else {
			for (i = 0; i < chk.length; i++) {
				receiver = (i == 0) ? chk.eq(i).val() : receiver + "," + chk.eq(i).val();
			}
		}

		if(confirm('����� �����Ͻðڽ��ϱ�?')) {
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
	
	// �̸�����
	function fn_preview() {
		var rece_type		= $('input:radio[name=tb1_1]:checked').val();
		var rece_sch		= $("#schManager option:selected").val();
		var rece_tit		= (rece_type == "email") ? $("#rece_tit").val() : rece_sch.replace("5", "����").replace("6", "����").replace("7", "����") + "���� ��� �ȳ�";
		var rece_con		= (rece_type == "email") ? $("#rece_con_E").val() : $("#rece_con_S").val();
		
		$("#pre_div_tit").html(rece_tit);
		$("#pre_div_con").html(rece_con.replace(/(\n|\r\n)/g, '<br>'));
		$("#preview").show();
	}
	
	// ��������
	function fn_con_save() {
		var rece_type		= $('input:radio[name=tb1_1]:checked').val();
		var rece_sch		= $("#schManager option:selected").val();
		var rece_con		= (rece_type == "email") ? $("#rece_con_E").val() : $("#rece_con_S").val();

		if(confirm('������ �����Ͻðڽ��ϱ�?')) {
			$.ajax({
				type: "POST"
				, url: "/company/applyjob/ajax_apply_result_saveCon.asp"
				, data: { comid: "<%=comid%>", rece_type: rece_type, rece_sch: rece_sch, rece_con: escape(rece_con) }
				, dataType: "html"
				, async: true
				, success: function (data) {
					if(data == "1") {
						alert("����Ǿ����ϴ�.");
						
						$("#rece_con_Save").parent().removeClass('on').addClass('off');						
					}
				}
				, error: function (XMLHttpRequest, textStatus, errorThrown) {
				    //alert(XMLHttpRequest.responseText);
				}
			});
		}
	}
	
	//���ڼ� �ǽð� ī����
	function fn_letters_count(obj) {
		obj = obj || $("#rece_con_S").val();
		var content = $(obj).val();
		$('#counter').html(content.length);    

		if (content.length > 2000){
			alert("�ִ� 2000�ڱ��� �Է� �����մϴ�.");
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
			<h3>��� �뺸</h3>
			<a href="#none" class="layer_close">�ݱ�</a>
		</div> 
		
		<div class="pop_con">
			<div class="tabs">
				<ul>
					<li><a href="#tc1">����뺸�ϱ�</a></li>
					<li><a href="#tc2">�뺸����</a></li>
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
								<th class="th_tit">����</th>
								<td>
									<input type="text" id="rece_tit" name="name" class="txt" style="width:100%;" placeholder="���� ���� ������ �Է��� �ּ���">
								</td>
							</tr>
							<tr>
								<th class="th_txt">����</th>
								<td>
									<textarea style="height:276px;" id="rece_con_E" placeholder="������ �Է��� �ּ���."></textarea>
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
								<th class="th_txt">����</th>
								<td>
									<div class="td_count">
										<textarea style="height:276px;" id="rece_con_S" placeholder="������ �Է��� �ּ���." onkeyup="fn_letters_count(this);" onkeypress="fn_letters_count(this);"></textarea>
										<div class="count">
											<p><span id="counter">0</span>/2,000<p>
										</div>
									</div>
									<ul class="ment">
										<li>�� �߰��߼� ���� ��å�� ���� ���� 9�� ������ SMS�� ���� ����9�ÿ� �ϰ��߼� �˴ϴ�.</li>
										<li>
											�� 2015�� 10��16�Ϻ��� ������Ż���� ��84���� �ǰ� �߽Ź�ȣ ����������� ����ǰ� �ֽ��ϴ�.<br>
										   ���� �߼��� ���� �߽Ź�ȣ�� ����� �ּ���. �߽Ź�ȣ �̵�� �� ���ڹ߼� ���� �̿��� �Ұ��� �մϴ�.
										</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>

					<div class="chk_area">
						<label class="checkbox off left" id="chk_sms">
							<input class="chk" id="sms_YN" name="" type="checkbox" value="Y">
							<span>�����Բ� ������</span>
						</label>
						<label class="checkbox off right">
							<input class="chk" id="rece_con_Save" name="" type="checkbox" onclick="fn_con_save();">
							<span>���� ����</span>
						</label>
					</div>
				</div>

				<div class="pop_footer">
					<div class="btn_area">
						<a href="javaScript:;" onclick="javascript:fn_preview();"  class="btn gray pop3">�̸�����</a>
						<a href="javaScript:;" onclick="javascript:fn_sumbit();"  class="btn blue">�����ϱ�</a>
					</div>
				</div>
			</div>
			
			<iframe src="/company/applyjob/apply_result_history.asp?jid=<%=jid%>" id="tc2" class="tab_content" border="0" cellspacing="0" frameborder="0" width="100%"></iframe>	
		</div>
	</div>				
</div>
</div>

<!-- �̸����� -->
<!--#include file = "./apply_result_preview.asp"-->
<!-- �̸����� -->