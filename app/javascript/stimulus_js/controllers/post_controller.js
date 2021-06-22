import { Controller } from 'stimulus';

function setupNotebook(){
  if($('.ipynb-notebook-container').height() > 2000) {
    $('.ipynb-notebook-container').css('overflow', 'hidden');
    $('.ipynb-notebook-container').css('max-height', '1500px');
    $('.show-more-btn').removeClass('d-none');
  }
}

export default class extends Controller {
  connect() {
    setupNotebook();

    $(".nav-link").click(function () {
      $(this).delay(1000).queue(function()
        {
          setupNotebook();
        });
    })
  }

  expandNotebook(event) {
    $('.show-more-btn').addClass('d-none');
    $('.ipynb-notebook-container').css('overflow', 'unset');
    $('.ipynb-notebook-container').css('max-height', 'unset');
  }

  validateColabLink(event){
    const colab_link = event.target.value;
    var form = $(event.target.form)
    var submitButton  = form.find('button[type="submit"]');
    var loader = form.find('.fetch-loader')
    var greenTick = form.find('.green-tick')
    var previewButton = $('.preview-button')
    var notebookPreviewDiv = document.getElementById('notebook-preview-container')

    if (!!colab_link && !colab_link.includes("colab.research.google.com")){
      $(`<div class="alert sticky-top alert-flash alert-dismissible show fade flash-message position-fixed w-100" role="alert">
          <div class="container-fluid">
            <center>
              Please input a colab notebook link.
            </center>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
        </div>`).prependTo('body')
    }

    if (colab_link.includes("colab.research.google.com")){
      submitButton.prop('disabled', true);
      loader.removeClass('d-none')
      greenTick.addClass('d-none')
      previewButton.addClass('d-none')
      $.ajax({
          url: '/showcase/validate_colab_link',
          type: 'POST',
          data: {colab_link: colab_link},
          success:  function(result){
              form.find('input[name="post[notebook_s3_url]"]').val(result["notebook_s3_url"]);
              form.find('input[name="post[notebook_html]"]').val(result["notebook_html"]);
              form.find('input[name="post[gist_id]"]').val(result["gist_id"]);
              notebookPreviewDiv.insertAdjacentHTML('afterbegin', result["notebook_html"]);


              submitButton.prop('disabled', false);
              loader.addClass('d-none')
              greenTick.removeClass('d-none')
              previewButton.removeClass('d-none')
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

  validateNotebook(event){
    const notebook_file = event.target.value;
    var form = $(event.target.form)
    var fileForm = document.querySelector('.posts-form')
    var formData = new FormData();
    formData.append('post[notebook_file]', $('#post_notebook_file')[0].files[0]);
    var submitButton  = form.find('button[type="submit"]');
    var loader = form.find('.file-fetch-loader')
    var greenTick = form.find('.file-green-tick')
    var previewButton = $('.file-preview-button')
    var notebookPreviewDiv = document.getElementById('notebook-preview-container')

    submitButton.prop('disabled', true);
    loader.removeClass('d-none')
    greenTick.addClass('d-none')
    previewButton.addClass('d-none')
    $.ajax({
        url: '/showcase/validate_notebook',
        type: 'POST',
        data: formData,
        contentType: false,
        processData: false,
        success:  function(result){
            form.find('input[name="post[notebook_s3_url]"]').val(result["notebook_s3_url"]);
            form.find('input[name="post[notebook_html]"]').val(result["notebook_html"]);
            form.find('input[name="post[gist_id]"]').val(result["gist_id"]);
            notebookPreviewDiv.insertAdjacentHTML('afterbegin', result["notebook_html"]);


            submitButton.prop('disabled', false);
            loader.addClass('d-none')
            greenTick.removeClass('d-none')
            previewButton.removeClass('d-none')
        },

        error: function(){
          submitButton.prop('disabled', false);
          loader.addClass('d-none');

          $(`<div class="alert sticky-top alert-flash alert-dismissible show fade flash-message position-fixed w-100" role="alert">
              <div class="container-fluid">
                <center>
                  Unable to process the notebook. Please check the file and try again.
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
