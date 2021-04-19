import { Controller } from 'stimulus';
$(document).ready(function(){
  function crop_image_load(data) {
    data = data.detail;
    var $coords_x = $("input#coords_x")[0],
    $coords_y = $("input#coords_y")[0],
    $coords_w = $("input#coords_w")[0],
    $coords_h = $("input#coords_h")[0];
    $coords_x.value = data.x;
    $coords_y.value = data.y;
    $coords_h.value = data.height;
    $coords_w.value = data.width;
  }


  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#card-image').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  var $coords_x = $("input#coords_x"),
  $coords_y = $("input#coords_y"),
  $coords_w = $("input#coords_w"),
  $coords_h = $("input#coords_h");
  $coords_x.val('');
  $coords_y.val('');
  $coords_h.val('');
  $coords_w.val('');

  var $image = $('#card-image')[0];
  var croppable = false;
  let x;


  $('.challenge-modal').on('shown.bs.modal', function () {
    x = new Cropper($image, {
    // aspectRatio: 1,
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

  $(".crop_image_file").change(function () {
    $('.challenge-modal').modal('show');
    readURL(this);
  });


});