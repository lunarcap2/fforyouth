<!--#include virtual = "/common/common.asp"-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta name="keywords" content="<%=site_name%>" />
<meta name="description" content="<%=site_name%>" />
<meta name="author" content="커리어" />
<meta name="Copyright" content="희망을 전하는 취업 포털 커리어" />

<title><%=site_name%></title>

<link rel="shortcut icon" href="favicon.ico" />
<link rel="stylesheet" type="text/css" href="/css/reset.css" />
<link rel="stylesheet" type="text/css" href="/css/common.css" />
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.css">
<link rel="stylesheet" type="text/css" href="/css/busan_my.css" /><!-- 이력서 등록 -->

<link rel="stylesheet" href="/css/cropper.css">
<script src="/js/jquery-1.11.1.min.js"></script>
<script src="/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
<script src="/js/cropper.js"></script>

<script type="text/javascript">
	$(document).ready(function () {
		$('.popup').show();
	}); 
</script>

<script type="text/javascript">
	window.onload = function () {
		var Cropper = window.Cropper;
		var URL = window.URL || window.webkitURL;
		//var container = document.querySelector('.img-container');
		var image = document.getElementById('photo_view_img');
		var download = document.getElementById('download');
		var actions = document.getElementById('actions');
		var dataX = document.getElementById('dataX');
		var dataY = document.getElementById('dataY');
		var dataHeight = document.getElementById('dataHeight');
		var dataWidth = document.getElementById('dataWidth');
		var dataRotate = document.getElementById('dataRotate');
		var dataScaleX = document.getElementById('dataScaleX');
		var dataScaleY = document.getElementById('dataScaleY');
		var options = {
			aspectRatio: 13 / 17,
			preview: '.img-preview',
			viewMode: 3,
			ready: function (e) {
				console.log(e.type);
			},
			cropstart: function (e) {
				console.log(e.type, e.detail.action);
			},
			cropmove: function (e) {
				console.log(e.type, e.detail.action);
			},
			cropend: function (e) {
				console.log(e.type, e.detail.action);
			},
			crop: function (e) {
				var data = e.detail;
				dataX.value = Math.round(data.x);
				dataY.value = Math.round(data.y);
				dataHeight.value = Math.round(data.height);
				dataWidth.value = Math.round(data.width);
				dataRotate.value = typeof data.rotate !== 'undefined' ? data.rotate : '';
				dataScaleX.value = typeof data.scaleX !== 'undefined' ? data.scaleX : '';
				dataScaleY.value = typeof data.scaleY !== 'undefined' ? data.scaleY : '';
			},
			zoom: function (e) {
				console.log(e.type, e.detail.ratio);
			}
		};
		var cropper = new Cropper(image, options);
		var originalImageURL = image.src;
		var uploadedImageType = 'image/jpeg';
		var uploadedImageName = 'cropped.jpg';
		var uploadedImageURL;

		// Buttons
		if (!document.createElement('canvas').getContext) {
			$('button[data-method="getCroppedCanvas"]').prop('disabled', true);
		}

		if (typeof document.createElement('cropper').style.transition === 'undefined') {
			$('button[data-method="rotate"]').prop('disabled', true);
			$('button[data-method="scale"]').prop('disabled', true);
		}


		document.body.onkeydown = function (event) {
			var e = event || window.event;

			if (e.target !== this || !cropper || this.scrollTop > 300) {
				return;
			}

			switch (e.keyCode) {
				case 37:
					e.preventDefault();
					cropper.move(-1, 0);
					break;
				case 38:
					e.preventDefault();
					cropper.move(0, -1);
					break;
				case 39:
					e.preventDefault();
					cropper.move(1, 0);
					break;
				case 40:
					e.preventDefault();
					cropper.move(0, 1);
					break;
			}
		};

		// Import image
		var inputImage = document.getElementById('inputImage');

		if (URL) {
			inputImage.onchange = function () {
				var files = this.files;
				var file;

				if (files && files.length) {
					file = files[0];

					if (/^image\/\w+/.test(file.type)) {
						uploadedImageType = file.type;
						uploadedImageName = file.name;

						if (uploadedImageURL) {
							URL.revokeObjectURL(uploadedImageURL);
						}

						var img_width, img_height, limit_width, limit_height;
						limit_width = 300;

						var img = new Image();
						img.src = uploadedImageURL = URL.createObjectURL(file);

						$(img).load(function() {
							img_width = this.width;
							img_height = this.height;

							img_height = (img_width > limit_width) ? Math.round(limit_width/img_width*img_height) : img_height;
							img_width = (img_width > limit_width) ? limit_width : img_width;

							image.src = uploadedImageURL = URL.createObjectURL(file);
							$(image).css({
								width : String(img_width) + 'px',
								height : String(img_height) + 'px'
							});
						});

						image.src = uploadedImageURL = URL.createObjectURL(file);
						$(image).css({
							width : String(img_width) + 'px',
							height : String(img_height) + 'px'
						});

						if (cropper) {
							cropper.destroy();
						}

						cropper = new Cropper(image, options);
						inputImage.value = null;
					} else {
						window.alert('Please choose an image file.');
					}
				}
			};
		} else {
			inputImage.disabled = true;
			inputImage.parentNode.className += ' disabled';
		}


		document.getElementById('crop').addEventListener('click', function () {
			if ($("#photo_view_img").attr("src") == "") {
				alert("사진파일을 첨부해주세요");
				return;
			}
			if (!confirm("이력서 사진을 등록하시겠습니까?")) {
				return;
			}

			var initialAvatarURL;
			var canvas;

			if (cropper) {
				canvas = cropper.getCroppedCanvas({
					width: 160,
					height: 160,
				});

				initialAvatarURL = image.src;
				image.src = canvas.toDataURL();

				canvas.toBlob(function (blob) {
					var formData = new FormData();
					formData.append('uploadFile', blob, 'avatar.jpg');
					formData.append('uid', '<%=user_id%>');
					

					//$.ajax('https://www2.career.co.kr/tools/thumb_resume_apply_fair.asp', {
					$.ajax('/my/resume/photo_write_upload.asp', {
						method: 'POST',
						data: formData,
						processData: false,
						contentType: false,

						xhr: function () {
							var xhr = new XMLHttpRequest();

							xhr.upload.onprogress = function (e) {
								var percent = '0';
								var percentage = '0%';

								if (e.lengthComputable) {
									percent = Math.round((e.loaded / e.total) * 100);
									percentage = percent + '%';
								}
							};
						return xhr;
						},

						success: function (data) {
							var result_data = data.split('|');
							if (result_data[0] == "1") {
								alert('이력서에 적용되었습니다.');
								self.close();
								opener.location.reload();
							} else {
								alert(result_data[1]);
							}
						},

						error: function (data) {
							console.log(data);
							/*
							avatar.src = initialAvatarURL;
							$alert.show().addClass('alert-warning').text('Upload error');
							*/
						},

						complete: function () {
						},

					});
				});
			}
		});

	};
</script>
</head>

<body>
<input type="hidden" id="dataX" value="" />
<input type="hidden" id="dataY" value="" />
<input type="hidden" id="dataHeight" value="" />
<input type="hidden" id="dataWidth" value="" />
<input type="hidden" id="dataRotate" value="" />
<input type="hidden" id="dataScaleX" value="" />
<input type="hidden" id="dataScaleY" value="" />

<!-- 사진등록 팝업 -->
<div id="photo">
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
							<!-- <form id="uploadForm" name="uploadForm" method="post" enctype="multipart/form-data" action="/my/resume/photo_upload.asp" target="procFrame" onsubmit="return false;"> -->
							<input type="hidden" name="curDomain" value="<%=request.servervariables("server_name")%>">
							<div class="filebox">
								<!-- 보여 지는 부분 -->
								<input type="text" readonly="readonly" id="fileRoute" class="txt_type">
								<!-- // 보여 지는 부분 -->
								<span class="fileWrap">
									찾아보기
									<input type="file" id="inputImage" name="uploadFile" class="file file_type" onchange="/*javascript:document.uploadForm.submit();*/">
								</span>
							</div>
							<p class="file_txt">
								권장 사진 사이즈는 136*177픽셀이며,<br>
								gif, jpg, jpge(1,000Kb미만) 이미지 파일만 등록 가능합니다.
							</p>
							<!-- </form> -->

							<!--
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
							-->
						</div>
						<div class="picAdd2">
							<div class="left">
								<h5>원본사진</h5>
								<div class="box">
									<div class="photo_view">
										<img id="photo_view_img" src="">
									</div>
								</div>
							</div>
							<div class="right">
								<h5>이력서용 사진</h5>
								<div class="edit_photo">
									<!--
									<div class="view_photo">
									</div>
									-->
									<div class="img-preview preview-lg"></div>
									<p style="width:103px;height:132px;overflow:hidden;"><img id="previewimg" /></p>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="pop_footer">
					<div class="btn_area">
						<a href="javaScript:;" id="crop" class="btn sky">이력서 사진등록하기</a>
					</div>
				</div>
				<iframe id="procFrame" name="procFrame" style="position:absolute; top:0; left:0; width:0;height:0;border:0;" frameborder="0" src="about:blank"></iframe>
			</fieldset>
		</div>				
	</div>	
</div>
<!--// 사진등록 팝업-->

</body>
</html>