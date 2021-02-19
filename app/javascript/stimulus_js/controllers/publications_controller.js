import { Controller } from 'stimulus';

export default class extends Controller {
  expandAbstract(event) {
    if($('.d-none').length > 0){
      $('.abstract').removeClass('fa-caret-right')
      $('.abstract').addClass('fa-caret-down')
      $('.text-justify').removeClass('d-none')
    }else{
      $('.abstract').removeClass('fa-caret-down')
      $('.abstract').addClass('fa-caret-right')
      $('.text-justify').addClass('d-none')
    }
  }
}