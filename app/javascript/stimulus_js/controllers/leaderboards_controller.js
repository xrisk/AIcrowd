import { Controller } from 'stimulus';
import { load_more_data } from '../helpers/load_more_data_helper'

export default class extends Controller {

  connect(){
    $(document).ready(function(){
      $(window).scroll(function() {
        let leaderboardsList = document.querySelector("#leaderboards-div");
        load_more_data(leaderboardsList, 'participant_challenges');
      });
    });
  }
}
