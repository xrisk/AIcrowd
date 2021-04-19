import { Controller } from 'stimulus';
$(document).ready(function(){
  function crop_social_media_image_load(data) {
    data = data.detail;
    var $social_media_coords_x = $("input#social_media_coords_x")[0],
    $social_media_coords_y = $("input#social_media_coords_y")[0],
    $social_media_coords_w = $("input#social_media_coords_w")[0],
    $social_media_coords_h = $("input#social_media_coords_h")[0];
    $social_media_coords_x.value = data.x;
    $social_media_coords_y.value = data.y;
    $social_media_coords_h.value = data.height;
    $social_media_coords_w.value = data.width;
  }


  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#social-media-image').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  var $social_media_coords_x = $("input#social_media_coords_x"),
  $social_media_coords_y = $("input#social_media_coords_y"),
  $social_media_coords_w = $("input#social_media_coords_w"),
  $social_media_coords_h = $("input#social_media_coords_h");
  $social_media_coords_x.val('');
  $social_media_coords_y.val('');
  $social_media_coords_h.val('');
  $social_media_coords_w.val('');

  var $image = $('#social-media-image')[0];
  var croppable = false;
  let x;


  $('.social-media-modal').on('shown.bs.modal', function () {
    x = new Cropper($image, {
    // aspectRatio: 1,
    viewMode: 1,
    ready: function () {
    croppable = true;
    },
    crop: function (event) {
    crop_social_media_image_load(event)
    }
    });
  }).on('hidden.bs.modal', function () {
    x.destroy();
  });

  $(".crop_social_media_image_file").change(function () {
    $('.social-media-modal').modal('show');
    readURL(this);
  });


});