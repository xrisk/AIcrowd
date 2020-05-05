import { Controller } from 'stimulus';
export default class extends Controller {

  getUserProfile(event){
    const avatar        = this.data.get('avatar');
    const location      = this.data.get('location');
    const username      = this.data.get('username');
    const truncate      = this.data.get('truncate');
    const participantId = this.data.get('participant');

    $.ajax({
      url: '/api/v1/participants/'+ participantId +'/user_profile',
      type: 'GET',
      data: {avatar: avatar, username: username, truncate: truncate},
      success:  function(result){
                  jQuery("#"+location).html(result);
                  $('[data-toggle="tooltip"]').tooltip();
                  $('[data-toggle="popover"]').popover();
                  hljs.initHighlightingOnLoad();
                }
    })
    console.log("Get user #" + participantId + " detail.");
  }
}
