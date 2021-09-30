import { Controller } from "stimulus"

export default class extends Controller {

  achievementTabClick(){
    const currentTab = this.data.get('current-tab-id')
    const challengeTab = $('#achievement_tab_challenge')
    const notebookTab = $('#achievement_tab_notebook')
    const discussionTab = $('#achievement_tab_discussion')
    const firstTab = $('#achievement_tab_first')
    const participant_id = this.data.get('participant-id')

    $.ajax({
      url: "/participants/"+ participant_id + "/switch_tab/" + currentTab + ".js",
      success: function(){
        challengeTab.removeClass('active')
        notebookTab.removeClass('active')
        discussionTab.removeClass('active')
        firstTab.removeClass('active')
        $("#" + currentTab).addClass('active')
      }
    });
  }
}


