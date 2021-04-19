import { Controller } from 'stimulus';

$(document).ready(function(){
  function crop_banner_image_load(data) {
    data = data.detail;
    var $banner_coords_x = $("input#banner_coords_x")[0],
    $banner_coords_y = $("input#banner_coords_y")[0],
    $banner_coords_w = $("input#banner_coords_w")[0],
    $banner_coords_h = $("input#banner_coords_h")[0];
    $banner_coords_x.value = data.x;
    $banner_coords_y.value = data.y;
    $banner_coords_h.value = data.height;
    $banner_coords_w.value = data.width;
  }


  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#banner-image').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  var $banner_coords_x = $("input#banner_coords_x"),
  $banner_coords_y = $("input#banner_coords_y"),
  $banner_coords_w = $("input#banner_coords_w"),
  $banner_coords_h = $("input#banner_coords_h");
  $banner_coords_x.val('');
  $banner_coords_y.val('');
  $banner_coords_h.val('');
  $banner_coords_w.val('');

  var $image = $('#banner-image')[0];
  var croppable = false;
  let x;


  $('.banner-modal').on('shown.bs.modal', function () {
    x = new Cropper($image, {
    // aspectRatio: 1,
    viewMode: 1,
    ready: function () {
    croppable = true;
    },
    crop: function (event) {
    crop_banner_image_load(event)
    }
    });
  }).on('hidden.bs.modal', function () {
    x.destroy();
  });

  $(".crop_banner_image_file").change(function () {
    $('.banner-modal').modal('show');
    readURL(this);
  });

});