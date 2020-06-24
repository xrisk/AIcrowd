import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    this.fileFieldVisibility();
    $("input[name='dataset_file[hosting_location]']").on('click', this.fileFieldVisibility);
  }

  fileFieldVisibility(){
    const radioValue = $("input[name='dataset_file[hosting_location]']:checked").val();

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
}
