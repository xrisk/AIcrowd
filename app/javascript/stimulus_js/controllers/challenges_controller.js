import { Controller } from 'stimulus';
export default class extends Controller {

  filterUrl(event){
    event.preventDefault();

    let status = document.querySelector("input[name='status']:checked")
    let categoriesList = document.querySelectorAll("input[name='category']:checked")
    let prizeList = document.querySelectorAll("input[name='prize']:checked")

    let categories = []
    categoriesList.forEach((category) => {
      categories.push(category.value);
    });

    let prizes = []
    prizeList.forEach((prize) => {
      prizes.push(prize.value);
    });

    let url = window.location.origin + window.location.pathname
    let params = ''

    if(status.value !== undefined){
      params = params.concat('status=', status.value);
    }

    if(categories.length > 0){
      params = params.concat('&categories=', categories.join());
    }

    if(prizes.length > 0){
      params = params.concat('&prizes=', prizes.join());
    }

    window.location.href = url.concat('?').concat(params);
  }
}
