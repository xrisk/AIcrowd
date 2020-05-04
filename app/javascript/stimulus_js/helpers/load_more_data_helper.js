export function load_more_data(selector, controller) {
  let page = selector.dataset.page;
  let challengeID = selector.dataset.challengeId;
  let requestCompleted = selector.dataset.requestCompleted;
  let nextPage = parseInt(page) + 1;
  let url = '';
  if(requestCompleted == 'true' && $(window).scrollTop() >= (parseInt(selector.offsetHeight) - (500 * parseInt(page)))) {
    selector.dataset.page = nextPage;
    selector.dataset.requestCompleted = false;
    $("#loader-container").removeAttr('style').addClass('centered').show();
    if (typeof challengeID === "undefined" || challengeID === null) {
      url += "/" + controller + ".js?page=" + nextPage;
    }else {
      url += "/challenges/" + challengeID + "/" + controller + ".js?page=" + nextPage;
    }
    $.ajax({
      url: url,
      type: 'GET'
    });
  }
}
