
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta http-equiv="x-ua-compatible" content="ie=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Cropper.js</title>
  <link rel="stylesheet" href="/css/cropper.css">
  <style>
    .container {
      margin: 20px auto;
      max-width: 960px;
    }

    img {
      max-width: 100%;
    }

    .row,
    .preview {
      overflow: hidden;
    }

    .col {
      float: left;
    }

    .col-6 {
      width: 50%;
    }

    .col-3 {
      width: 25%;
    }

    .col-2 {
      width: 16.7%;
    }

    .col-1 {
      width: 8.3%;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Customize preview for Cropper</h1>
    <div class="row">
      <div class="col col-6">


        <img id="image" src="/files/temp/NaverBlog_20140707_224234_01.jpg" alt="Picture">



      </div>

      <div class="col col-3">
        <div class="preview"></div>
      </div>



    </div>
  </div>

  <script src="/js/jquery-1.11.1.min.js"></script>
  <script src="/js/cropper.js"></script>
  <script>
    function each(arr, callback) {
      var length = arr.length;
      var i;

      for (i = 0; i < length; i++) {
        callback.call(arr, arr[i], i, arr);
      }

      return arr;
    }










    window.addEventListener('DOMContentLoaded', function () {





      var image = document.querySelector('#image');
      var previews = document.querySelectorAll('.preview');
      var previewReady = false;








      var cropper = new Cropper(image, {
		  aspectRatio: 9 / 12,
          ready: function () {
            var clone = this.cloneNode();

            clone.className = '';
            clone.style.cssText = (

              'display: block;' +
              'width: 100%;' +
			  'height: 100%;' +
              'min-width: 0;' +
              'min-height: 0;' +
              'max-width: none;' +
              'max-height: none;'
            );

            each(previews, function (elem) {
              elem.appendChild(clone.cloneNode());
            });
            previewReady = true;
          },

          crop: function (event) {
            if (!previewReady) {
              return;
            }

            var data = event.detail;
            var cropper = this.cropper;
            var imageData = cropper.getImageData();
            var previewAspectRatio = data.width / data.height;

            each(previews, function (elem) {
              var previewImage = elem.getElementsByTagName('img').item(0);
              var previewWidth = elem.offsetWidth;
              var previewHeight = previewWidth / previewAspectRatio;
              var imageScaledRatio = data.width / previewWidth;

              elem.style.height = previewHeight + 'px';
              previewImage.style.width = imageData.naturalWidth / imageScaledRatio + 'px';
              previewImage.style.height = imageData.naturalHeight / imageScaledRatio + 'px';
              previewImage.style.marginLeft = -data.x / imageScaledRatio + 'px';
              previewImage.style.marginTop = -data.y / imageScaledRatio + 'px';
            });
          },
        });







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







    });
  </script>

	
	<a id="crop" onclick="" >asdfasdf</a>
	

</body>
</html>
