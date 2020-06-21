$(document).on('click', '.challenge-invite-participant', function(){
  $('.email_invitation_form').show();
  $('.challenge-invite-participant').attr("disabled", true);
});

$(document).ready(function() {
  $('.select2').select2();
  $('.category_select2').select2({
    tags: true
  });
  $('input[name="status"]:radio').change(function(){
    $('#challenge-statuses').addClass('filter-active');
  });
  $('input[name="category"]:checkbox').change(function(){
    $('#challenge-categories').removeClass('filter-active');
    if ($('input[name="category"]').is(':checked'))
    {
      $('#challenge-categories').addClass('filter-active');
    }
  });
  $('input[name="prize"]:checkbox').change(function(){
    $('#challenge-prizes').removeClass('filter-active');
    if ($('input[name="prize"]').is(':checked'))
    {
      $('#challenge-prizes').addClass('filter-active');
    }
  });
  $('.form-dropdown').click(function(e) {
    e.stopPropagation();
  });
});
