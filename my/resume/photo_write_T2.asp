<!--#include virtual = "/common/common.asp"-->
<!--include virtual = "/include/header/header_photo_write.asp"-->





<link rel="stylesheet" href="/css/cropper.css">
<style>
.btn {
  padding-left: 0.75rem;
  padding-right: 0.75rem;
}

label.btn {
  margin-bottom: 0;
}

.d-flex > .btn {
  flex: 1;
}

.carbonads {
  border: 1px solid #ccc;
  border-radius: 0.25rem;
  font-size: 0.875rem;
  overflow: hidden;
  padding: 1rem;
}

.carbon-wrap {
  overflow: hidden;
}

.carbon-img {
  clear: left;
  display: block;
  float: left;
}

.carbon-text,
.carbon-poweredby {
  display: block;
  margin-left: 140px;
}

.carbon-text,
.carbon-text:hover,
.carbon-text:focus {
  color: #fff;
  text-decoration: none;
}

.carbon-poweredby,
.carbon-poweredby:hover,
.carbon-poweredby:focus {
  color: #ddd;
  text-decoration: none;
}

@media (min-width: 768px) {
  .carbonads {
    float: right;
    margin-bottom: -1rem;
    margin-top: -1rem;
    max-width: 360px;
  }
}

.footer {
  font-size: 0.875rem;
}

.heart {
  color: #ddd;
  display: block;
  height: 2rem;
  line-height: 2rem;
  margin-bottom: 0;
  margin-top: 1rem;
  position: relative;
  text-align: center;
  width: 100%;
}

.heart:hover {
  color: #ff4136;
}

.heart::before {
  border-top: 1px solid #eee;
  content: " ";
  display: block;
  height: 0;
  left: 0;
  position: absolute;
  right: 0;
  top: 50%;
}

.heart::after {
  background-color: #fff;
  content: "♥";
  padding-left: 0.5rem;
  padding-right: 0.5rem;
  position: relative;
  z-index: 1;
}

.docs-demo {
  margin-bottom: 1rem;
  overflow: hidden;
  padding: 2px;
}

.img-container,
.img-preview {
  background-color: #f7f7f7;
  text-align: center;
  width: 100%;
}

.img-container {
  max-height: 497px;
  min-height: 200px;
}

@media (min-width: 768px) {
  .img-container {
    min-height: 497px;
  }
}

.img-container > img {
  max-width: 100%;
}

.docs-preview {
  margin-right: -1rem;
}

.img-preview {
  float: left;
  margin-bottom: 0.5rem;
  margin-right: 0.5rem;
  overflow: hidden;
}

.img-preview > img {
  max-width: 100%;
}

.preview-lg {
  height: 9rem;
  width: 16rem;
}

.preview-md {
  height: 4.5rem;
  width: 8rem;
}

.preview-sm {
  height: 2.25rem;
  width: 4rem;
}

.preview-xs {
  height: 1.125rem;
  margin-right: 0;
  width: 2rem;
}

.docs-data > .input-group {
  margin-bottom: 0.5rem;
}

.docs-data .input-group-prepend .input-group-text {
  min-width: 4rem;
}

.docs-data .input-group-append .input-group-text {
  min-width: 3rem;
}

.docs-buttons > .btn,
.docs-buttons > .btn-group,
.docs-buttons > .form-control {
  margin-bottom: 0.5rem;
  margin-right: 0.25rem;
}

.docs-toggles > .btn,
.docs-toggles > .btn-group,
.docs-toggles > .dropdown {
  margin-bottom: 0.5rem;
}

.docs-tooltip {
  display: block;
  margin: -0.5rem -0.75rem;
  padding: 0.5rem 0.75rem;
}

.docs-tooltip > .icon {
  margin: 0 -0.25rem;
  vertical-align: top;
}

.tooltip-inner {
  white-space: normal;
}

.btn-upload .tooltip-inner,
.btn-toggle .tooltip-inner {
  white-space: nowrap;
}

.btn-toggle {
  padding: 0.5rem;
}

.btn-toggle > .docs-tooltip {
  margin: -0.5rem;
  padding: 0.5rem;
}

@media (max-width: 400px) {
  .btn-group-crop {
    margin-right: -1rem !important;
  }

  .btn-group-crop > .btn {
    padding-left: 0.5rem;
    padding-right: 0.5rem;
  }

  .btn-group-crop .docs-tooltip {
    margin-left: -0.5rem;
    margin-right: -0.5rem;
    padding-left: 0.5rem;
    padding-right: 0.5rem;
  }
}

.docs-options .dropdown-menu {
  width: 100%;
}

.docs-options .dropdown-menu > li {
  font-size: 0.875rem;
  padding: 0.125rem 1rem;
}

.docs-options .dropdown-menu .form-check-label {
  display: block;
}

.docs-cropped .modal-body {
  text-align: center;
}

.docs-cropped .modal-body > img,
.docs-cropped .modal-body > canvas {
  max-width: 100%;
}

</style>



<script src="/js/jquery-1.11.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>

<script src="/js/cropper.js"></script>


<script type="text/javascript">

	window.onload = function () {
	  'use strict';

	  var Cropper = window.Cropper;
	  var URL = window.URL || window.webkitURL;
	  var container = document.querySelector('.img-container');
	  var image = container.getElementsByTagName('img').item(0);
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
		aspectRatio: 2 / 3,
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

		  console.log(e.type);
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

	  // Methods
	  actions.querySelector('.docs-buttons').onclick = function (event) {
		var e = event || window.event;
		var target = e.target || e.srcElement;
		var cropped;
		var result;
		var input;
		var data;

		if (!cropper) {
		  return;
		}

		while (target !== this) {
		  if (target.getAttribute('data-method')) {
			break;
		  }

		  target = target.parentNode;
		}

		if (target === this || target.disabled || target.className.indexOf('disabled') > -1) {
		  return;
		}

		data = {
		  method: target.getAttribute('data-method'),
		  target: target.getAttribute('data-target'),
		  option: target.getAttribute('data-option') || undefined,
		  secondOption: target.getAttribute('data-second-option') || undefined
		};

		cropped = cropper.cropped;

		if (data.method) {
		  if (typeof data.target !== 'undefined') {
			input = document.querySelector(data.target);

			if (!target.hasAttribute('data-option') && data.target && input) {
			  try {
				data.option = JSON.parse(input.value);
			  } catch (e) {
				console.log(e.message);
			  }
			}
		  }

		  switch (data.method) {
			case 'rotate':
			  if (cropped && options.viewMode > 0) {
				cropper.clear();
			  }

			  break;

			case 'getCroppedCanvas':
			  try {
				data.option = JSON.parse(data.option);
			  } catch (e) {
				console.log(e.message);
			  }

			  if (uploadedImageType === 'image/jpeg') {
				if (!data.option) {
				  data.option = {};
				}

				data.option.fillColor = '#fff';
			  }

			  break;
		  }

		  result = cropper[data.method](data.option, data.secondOption);

		  switch (data.method) {
			case 'rotate':
			  if (cropped && options.viewMode > 0) {
				cropper.crop();
			  }

			  break;

			case 'scaleX':
			case 'scaleY':
			  target.setAttribute('data-option', -data.option);
			  break;

			case 'destroy':
			  cropper = null;

			  if (uploadedImageURL) {
				URL.revokeObjectURL(uploadedImageURL);
				uploadedImageURL = '';
				image.src = originalImageURL;
			  }

			  break;
		  }

		  if (typeof result === 'object' && result !== cropper && input) {
			try {
			  input.value = JSON.stringify(result);
			} catch (e) {
			  console.log(e.message);
			}
		  }
		}
	  };

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

			  image.src = uploadedImageURL = URL.createObjectURL(file);

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
        var initialAvatarURL;
        var canvas;


        if (cropper) {
          canvas = cropper.getCroppedCanvas({
            width: 160,
            height: 160,
          });
          initialAvatarURL = image.src;
          image.src = canvas.toDataURL();
          //$progress.show();
          //$alert.removeClass('alert-success alert-warning');
          canvas.toBlob(function (blob) {
            var formData = new FormData();

            formData.append('uploadFile', blob, 'avatar.jpg');

			console.log(initialAvatarURL);
			console.log(canvas.toDataURL());
			console.log(blob);

			console.log(formData);


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
                    //$progressBar.width(percentage).attr('aria-valuenow', percent).text(percentage);
                  }
                };

                return xhr;
              },

              success: function (data) {
                //$alert.show().addClass('alert-success').text('Upload success');
				console.log('Upload success');
				console.log(data);
              },

              error: function () {
                avatar.src = initialAvatarURL;
                $alert.show().addClass('alert-warning').text('Upload error');
              },

              complete: function () {
				  console.log('complete');
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


				<div class="col-md-9">
					<!-- <h3>Demo:</h3> -->
					<div class="docs-demo">
						<div class="img-container">
							<img src="">
						</div>
					</div>
				</div>
				
				<div class="col-md-3">
					<!-- <h3>Preview:</h3> -->
					<div class="docs-preview clearfix">
						<div class="img-preview preview-lg"></div>
					</div>
				</div>

				<div class="row" id="actions">
					<div class="col-md-9 docs-buttons">
						<!-- <h3>Toolbar:</h3> -->
						<div class="btn-group">
							<input type="file" class="sr-only" id="inputImage" name="file" accept="image/*">
							<button id="crop">저장</button>
						</div>
					</div>
				</div>


			</div>
		</div>				
	</div>	
</div>
<!--// 사진등록 팝업-->

</body>
</html>