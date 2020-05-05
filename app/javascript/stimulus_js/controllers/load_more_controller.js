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
    if($(window).scrollTop() >= (parseInt(this.element.offsetHeight) - (500 * parseInt(page)))) {
      this.element.dataset.page = nextPage;
      this.element.dataset.requestCompleted = false;
      $("#loader-container").removeAttr('style').addClass('spinner-above-footer').show();
      $.ajax({
        url: window.location.href + '.js?page=' + nextPage,
        type: 'GET'
      });
    }
  }
}
