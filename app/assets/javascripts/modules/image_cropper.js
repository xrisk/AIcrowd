$(document).ready(function(){
  function crop_image_load(data) {
    data = data.detail;
    var $crop_x = $("input#coords_x")[0],
    $crop_y = $("input#coords_y")[0],
    $crop_w = $("input#coords_w")[0],
    $crop_h = $("input#coords_h")[0];
    $crop_x.value = data.x;
    $crop_y.value = data.y;
    $crop_h.value = data.height;
    $crop_w.value = data.width;
  }


  function getRoundedCanvas(sourceCanvas) {
    var canvas = document.createElement('canvas');
    var context = canvas.getContext('2d');
    var width = sourceCanvas.width;
    var height = sourceCanvas.height;
    canvas.width = width;
    canvas.height = height;
    context.imageSmoothingEnabled = true;
    context.drawImage(sourceCanvas, 0, 0, width, height);
    context.globalCompositeOperation = 'destination-in';
    context.beginPath();
    context.arc(width / 2, height / 2, Math.min(width, height) / 2, 0, 2 * Math.PI, true);
    context.fill();
    return canvas;
  }


  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#image').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  var $crop_x = $("input#coords_x"),
  $crop_y = $("input#coords_y"),
  $crop_w = $("input#coords_w"),
  $crop_h = $("input#coords_h");
  $crop_x.val('');
  $crop_y.val('');
  $crop_h.val('');
  $crop_w.val('');

  var $image = $('#image')[0];
  var $button = $('#button');
  var croppable = false;
  let x;


  $('#upload-modal').on('shown.bs.modal', function () {
    x = new Cropper($image, {
    aspectRatio: 1,
    viewMode: 1,
    ready: function () {
    croppable = true;
    },
    crop: function (event) {
    crop_image_load(event)
    }
    });
  }).on('hidden.bs.modal', function () {
    x.destroy();
  });

  $button.on('click', function () {
    var croppedCanvas;
    var roundedCanvas;
    croppedCanvas = x.getCroppedCanvas();
    roundedCanvas = getRoundedCanvas(croppedCanvas);
    $('#avatar')[0].src = roundedCanvas.toDataURL();
    $('#avatar')[0].setAttribute("height", "100");
    $('#avatar')[0].setAttribute("width", "100");
  });

  $("#profile_pic_upload").change(function () {
    debugger;
    $('#upload-modal').modal('show');
    readURL(this);
  });
});