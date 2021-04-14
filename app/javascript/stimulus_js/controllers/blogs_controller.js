import { Controller } from 'stimulus';
export default class extends Controller {
  scrollToComments(event){
    $('.button-scroll').click(function() {
        $('html,body').animate({
            scrollTop: $(".blog-comments").offset().top},
            'slow');
    });
  }
}