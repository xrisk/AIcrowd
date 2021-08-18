import { Controller } from 'stimulus';

export default class extends Controller {
  expandAbstract(event) {
    let elementDNone = $(event.target.parentElement)
    if($(elementDNone.find('.d-none')).length > 0){
      elementDNone.find('.abstract').removeClass('fa-caret-right')
      elementDNone.find('.abstract').addClass('fa-caret-down')
      elementDNone.find('.d-none').removeClass('d-none')
    }else{
      elementDNone.find('.abstract').removeClass('fa-caret-down')
      elementDNone.find('.abstract').addClass('fa-caret-right')
      elementDNone.find('.text-justify').addClass('d-none')
    }
  }

  filterUrl(event){
    event.preventDefault();

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

  clearFilter(){
    window.location.replace(window.location.origin + window.location.pathname)
  }

  toggleAuthors(event){
    let element = event.target;
    element.innerHTML = (element.innerHTML === 'Show All Authors' ? 'Hide Authors' : 'Show All Authors');
  }
}