

<link href="/css/Jcrop.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="http://www4.career.co.kr/js/jquery-1.5.1.js"></script>
<script type="text/javascript" src="/js/tools.js"></script>
<script type="text/javascript" src="/js/photo_cropper.js"></script>
<script type="text/javascript" src="/js/Jcrop.js"></script>

<!-- 사진등록 팝업 -->
<div id="photo">
	<div class="pop_dim"></div>
	<div class="popup file">
		<div class="pop_wrap">
			<div class="pop_head">
				<h3>파일업로드</h3>
					
			</div>
			<div class="pop_con">
				<fieldset>
					<legend class="blind">이력서 사진등록하기</legend>
					<div class="picAdd">
						<div class="picWrap">
							<form id="uploadForm" name="uploadForm" method="post" enctype="multipart/form-data" action="/my/resume/photo_upload.asp" target="procFrame" onsubmit="return false;">
							<input type="hidden" name="curDomain" value="<%=request.servervariables("server_name")%>">
							<div class="filebox">
								<!-- 보여 지는 부분 -->
								<input type="text" readonly="readonly" id="fileRoute" class="txt_type">
								<!-- // 보여 지는 부분 -->
								<span class="fileWrap">
									찾아보기
									<input type="file" id="uploadFile" name="uploadFile" class="file file_type" onchange="javascript:document.uploadForm.submit();">
								</span>
							</div>
							<p class="file_txt">
								권장 사진 사이즈는 103*132픽셀이며,<br>
								gif, jpg, jpge(1,000Kb미만) 이미지 파일만 등록 가능합니다.
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
								<h5>원본사진</h5>
								<div class="box">
									<div class="photo_view"></div>
								</div>
							</div>
							<div class="right">
								<h5>이력서용 사진</h5>
								<div class="edit_photo">
									<div class="view_photo">
									</div>
									<p style="width:132px;height:172px;overflow:hidden;"><img id="previewimg" /></p>
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
						<a href="javaScript:;" onclick="fn_resume_apply();return false;"  class="btn sky">이력서 사진등록하기</a>
					</div>
				</div>
				<iframe id="procFrame" name="procFrame" style="position:absolute; top:0; left:0; width:0;height:0;border:0;" frameborder="0" src="about:blank"></iframe>
			</fieldset>
		</div>				
	</div>
</div>
<!--// 사진등록 팝업-->