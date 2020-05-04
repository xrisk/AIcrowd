import { Controller } from 'stimulus';
import { load_more_data } from '../helpers/load_more_data_helper'

export default class extends Controller {

  connect(){
    $(document).ready(function(){
      $(window).scroll(function() {
        let ratingLeaderboardList = document.querySelector(".table-leaderboard-body");
        load_more_data(ratingLeaderboardList, 'leaderboard');
      });
    });
  }
}
