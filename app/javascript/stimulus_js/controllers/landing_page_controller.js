import { Controller } from 'stimulus'

export default class extends Controller {
  connect() {
    const currentUrl     = new URL(window.location);
    const referredByUUID = currentUrl.searchParams.get('referred_by_uuid');

    if (referredByUUID) {
      localStorage.setItem("referredByUUID", referredByUUID);
    }

    $.ajax({
      url: 'https://discourse.aicrowd.com/latest.json?ascending=false',
      type: 'GET',
      success:  function(result){
                  debugger;
                  var topicList = result.topic_list.topics.slice(0, 4)
                  $("#discourse-list-short").append("<%= escape_javascript({render :partial => 'shared/discourse/topics_list', locals: { topics: topicList }}).html_safe %>")
                }
    })
  }
}
