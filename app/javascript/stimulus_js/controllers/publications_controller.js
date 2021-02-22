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

  filterUrl(event){
    event.preventDefault();
    debugger;

    let yearList = document.querySelectorAll("input[name='year']:checked")
    let categoriesList = document.querySelectorAll("input[name='category']:checked")
    let venueList = document.querySelectorAll("input[name='venue']:checked")

    let years = []
    yearList.forEach((year) => {
      years.push(year.value);
    });

    let categories = []
    categoriesList.forEach((category) => {
      categories.push(category.value);
    });

    let venues = []
    venueList.forEach((venue) => {
      venues.push(venue.value);
    });

    let url = window.location.origin + window.location.pathname
    let params = ''

    if(years.length > 0){
      params = params.concat('&years=', years.join());
    }

    if(categories.length > 0){
      params = params.concat('&categories=', categories.join());
    }

    if(venues.length > 0){
      params = params.concat('&venues=', venues.join());
    }

    window.location.href = url.concat('?').concat(params);
  }
}