<!--#include virtual = "/common/common.asp"-->
<!--#include virtual = "/include/header/header_photo_write.asp"-->

<script type="text/javascript">
	$(document).ready(function () {
		$('.popup').show();
	}); 
</script>

</head>

<body>

<!-- ������� �˾� -->
<div id="photo">
	<div class="popup file">
		<div class="pop_wrap">
			<div class="pop_head">
				<h3>���Ͼ��ε�</h3>	
			</div>
			<div class="pop_con">
				<fieldset>
					<legend class="blind">�̷¼� ��������ϱ�</legend>
					<div class="picAdd">
						<div class="picWrap">
							<form id="uploadForm" name="uploadForm" method="post" enctype="multipart/form-data" action="/my/resume/photo_upload.asp" target="procFrame" onsubmit="return false;">
							<input type="hidden" name="curDomain" value="<%=request.servervariables("server_name")%>">
							<div class="filebox">
								<!-- ���� ���� �κ� -->
								<input type="text" readonly="readonly" id="fileRoute" class="txt_type">
								<!-- // ���� ���� �κ� -->
								<span class="fileWrap">
									ã�ƺ���
									<input type="file" id="uploadFile" name="uploadFile" class="file file_type" onchange="javascript:document.uploadForm.submit();">
								</span>
							</div>
							<p class="file_txt">
								���� ���� ������� 136*177�ȼ��̸�,<br>
								gif, jpg, jpge(1,000Kb�̸�) �̹��� ���ϸ� ��� �����մϴ�.
							</p>
							</form>
							<form id="sendForm" name="sendForm" method="post" action="/my/resume/thumb_clientsave.asp">
							<input type="hidden" id="x1" name="x1">
							<input type="hidden" id="y1" name="y1">
							<input type="hidden" id="x2" name="x2">
							<input type="hidden" id="y2" name="y2">
							<input type="hidden" id="orgnWidth" name="orgnWidth">
							<input type="hidden" id="orgnHeight" name="orgnHeight">
							<input type="hidden" id="dispWidth" name="dispWidth">
							<input type="hidden" id="dispHeight" name="dispHeight">
							<input type="hidden" id="cropWidth" name="cropWidth">
							<input type="hidden" id="cropHeight" name="cropHeight">
							<input type="hidden" id="oldimgpath" name="oldimgpath">
							<input type="hidden" id="dummy" name="dummy">
							<input type="hidden" id="uid" name="uid" value="<%if g_LoginChk=1 then response.write user_id%>">
							<input type="hidden" name="curDomain" value="<%=request.servervariables("server_name")%>">
							</form>
						</div>
						<div class="picAdd2">
							<div class="left">
								<h5>��������</h5>
								<div class="box">
									<div class="photo_view"></div>
								</div>
							</div>
							<div class="right">
								<h5>�̷¼��� ����</h5>
								<div class="edit_photo">
									<div class="view_photo">
									</div>
									<p style="width:103px;height:132px;overflow:hidden;"><img id="previewimg" /></p>
								</div>
								<input type="hidden" id="daum_agree" value="-1">
								<input type="hidden" id="rid" value="2881604">
								<input type="hidden" id="rstep" value="5">
								
							</div>
						</div>
					</div>
				</div>
				<div class="pop_footer">
					<div class="btn_area">
						<a href="javaScript:;" onclick="fn_resume_apply();return false;"  class="btn sky">�̷¼� ��������ϱ�</a>
					</div>
				</div>
				<iframe id="procFrame" name="procFrame" style="position:absolute; top:0; left:0; width:0;height:0;border:0;" frameborder="0" src="about:blank"></iframe>
			</fieldset>
		</div>				
	</div>	
</div>
<!--// ������� �˾�-->

</body>
</html>