import { Controller } from 'stimulus';

export default class extends Controller {

  load_more_data(){
    let requestCompleted = this.element.dataset.requestCompleted;
    if(requestCompleted === 'false')
    {
      return false;
    }
    let page = this.element.dataset.page;
    let nextPage = parseInt(page) + 1;
    let url = '';
    let footerHeight = $('.app-footer').height();
    let heightTillFooter = document.body.scrollHeight - (footerHeight + 176);

    if($(window).scrollTop() >= (parseInt(this.element.offsetHeight) - (footerHeight + 20))) {
      this.element.dataset.page = nextPage;
      this.element.dataset.requestCompleted = false;
      $("#loader-container").removeAttr('style').addClass('spinner-above-footer').css('top', heightTillFooter).show();
      $.ajax({
        url: window.location.href,
        type: 'GET',
        data: { page: nextPage },
        dataType: 'script'
      });
    }
  }
}
