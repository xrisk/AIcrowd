import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    const that = this;

    $(function () {
        let selected_sortable = $("#sortable");
        that.calculateIndex();
        selected_sortable.sortable({
          update: function (event, ui) {
            that.calculateIndex();
              let order = $("#sortable").sortable("toArray");
              order[0] && $('#order').val(order.join(","));
          }
        });
        selected_sortable.disableSelection();
        let order = selected_sortable.sortable("toArray");
        order[0] && $('#order').val(order.join(","));
    });
  }

  calculateIndex() {
    let landingPageIdx = 6;
    let l = $(".challenge-list-row .new-seq");

    for (let i = 0; i < l.length; i++) {
      l[i].innerText = i.toString();
      let current = $(l[i].parentNode);
      // Hidden and Private challenges have a badge!
      let hasBadge = current.has('.badge').length > 0;
      let draftChallenge = current.children()[1].textContent === "draft";
      if (i < landingPageIdx) {
        if (hasBadge || draftChallenge) {
          landingPageIdx++;
          continue;
        }
        $(current).addClass('table-success');
      } else {
        $(current).removeClass('table-success');
      }
    }
  }
}
