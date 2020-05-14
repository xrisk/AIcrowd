function fileFieldVisibility(){
  var radioValue = $("input[name='dataset_file[hosting_location]']:checked").val();
  if (radioValue === 'crowdAI') {
    $('#dataset-file-s3-key').show();
    $('#external-url').hide();
    $('#own-s3').hide();
  } else if (radioValue === 'External') {
    $('#dataset-file-s3-key').hide();
    $('#external-url').show();
    $('#own-s3').hide();
  } else if (radioValue === 'Own S3') {
    $('#dataset-file-s3-key').hide();
    $('#external-url').hide();
    $('#own-s3').show();
  }
};

Paloma.controller('DatasetFiles', {
  new: function(){
    fileFieldVisibility();
    $("input[name='dataset_file[hosting_location]']").on('click', fileFieldVisibility);
  },
  edit: function(){
    fileFieldVisibility();
    $("input[name='dataset_file[hosting_location]']").on('click', fileFieldVisibility);
  },
  index: function(){
    $('.dataset-file-download').on('click', function (e) {
      var self = this;
      var dataset_file_id = $(this).data('dataset-file-id');
      $.ajax({
        url: '/dataset_files/' + dataset_file_id + '/dataset_file_downloads',
        type: 'POST',
        complete: function() { console.log('file download logged')},
        error: function() { console.log('file download errored ' + status)}
      })
    });
  }
});
