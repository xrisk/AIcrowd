import { Controller } from 'stimulus';
export default class extends Controller {
  connect() {
    if($('.ipynb-notebook-container').height() > 2000) {
      $('.ipynb-notebook-container').css('overflow', 'hidden');
      $('.ipynb-notebook-container').css('max-height', '1500px');
      $('.show-more-btn').removeClass('d-none');
    }
  }

  expandNotebook(event) {
    $('.show-more-btn').addClass('d-none');
    $('.ipynb-notebook-container').css('overflow', 'unset');
    $('.ipynb-notebook-container').css('max-height', 'unset');
  }

  validateExternalLink(event){
    const external_url = event.target.value;

    if (external_url.includes("colab.research.google.com")){
      var form = $(event.target.form)
      var submitButton  = form.find('button[type="submit"]');
      var loader = form.find('.fetch-loader')

      submitButton.prop('disabled', true);
      loader.removeClass('d-none')
      $.ajax({
          url: '/contributions/validate_external_link',
          type: 'POST',
          data: {external_link: external_url},
          success:  function(result){
              form.find('input[name="post[notebook_file_path]"]').val(result["notebook_file_path"]);
              submitButton.prop('disabled', false);
              loader.addClass('d-none')
          },

          error: function(){
            submitButton.prop('disabled', false);
            loader.addClass('d-none');
            $(`<div class="alert sticky-top alert-flash alert-dismissible show fade flash-message position-fixed w-100" role="alert">
                <div class="container-fluid">
                  <center>
                    Unable to download colab notebook. Please check the link and try again.
                  </center>
                  <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                </div>
              </div>`).prependTo('body')
          }
      });
    }
  }
}
