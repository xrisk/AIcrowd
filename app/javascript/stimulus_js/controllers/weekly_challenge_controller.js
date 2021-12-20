import { Controller } from "stimulus"

export default class extends Controller {

  interactedPopup(){
    const participant_id = this.data.get('participant-id')
    if(participant_id !== '' ){
      $.ajax({
        url: "/participants/interacted_with_popup?participant_id="+participant_id,
        success: function(){}
      });
    }
  }
}