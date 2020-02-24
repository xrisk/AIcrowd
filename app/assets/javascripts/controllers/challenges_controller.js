$(document).on('click', '.challenge-invite-participant', function(){
  $('.email_invitation_form').show();
  $('.challenge-invite-participant').attr("disabled", true);
});

function resetChallengesFormClientValidations() {
  // We need to wait till fields show up in browser
  setTimeout(function() { $('#challenges-form').enableClientSideValidations(); }, 1000);
}

Paloma.controller('Challenges', {
    reorder: function () {
        let calculateIndex = function () {
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
        };
        $(function () {
            let selected_sortable = $("#sortable");
            calculateIndex();
            selected_sortable.sortable({
                update: function (event, ui) {
                    calculateIndex();
                    let order = $("#sortable").sortable("toArray");
                    order[0] && $('#order').val(order.join(","));
                }
            });
            selected_sortable.disableSelection();
            let order = selected_sortable.sortable("toArray");
            order[0] && $('#order').val(order.join(","));
        });
    },
    edit: function () {
        const currentUrl  = new URL(window.location);
        const currentStep = currentUrl.searchParams.get('step');
        const currentTab  = $(`#challenge-edit-${currentStep}-tab`);

        let switch_handler = function () {
          $('.active-switch').each((event, checkbox) => {
              if (checkbox !== this) {
                  checkbox.checked = false;
              }
          });
        };

        $("#rounds").on('cocoon:after-insert', function(event, added_round) {
          added_round.find('.active-switch').on('click', switch_handler);
        });

        $('.challenges-form-tab-link').click(function(event) {
          const tabLink = $(event.target).tab('show');

          event.preventDefault();

          // Set step in URL address
          currentUrl.searchParams.set('step', event.target.dataset.currentTab);
          window.history.pushState(null, null, currentUrl.toString());

          resetChallengesFormClientValidations();
        });

        $('.active-switch').on('click', switch_handler);

        $('.challenges-form__toggle-expand').click(function(event) {
          resetChallengesFormClientValidations();
        });

        $('#replace-rules-button').click(function (event) {
          $(this).hide()
          resetChallengesFormClientValidations();
        });

        $('#challenges-form-add-partner').click(function() {
          resetChallengesFormClientValidations();
        });

        $('#challenges-form-add-round').click(function() {
          resetChallengesFormClientValidations();

          setTimeout(function() {
            $('.challenges-form__toggle-expand').click(function(event) {
              resetChallengesFormClientValidations();
            });
          }, 1000);
        });

        $('#leaderboard-export-rounds-select').on('change', function(event) {
          const leaderboardExportChallengeRoundId = event.target.value;
          const leaderboardExportLink             = $('#leaderboard-export-link').attr('href');
          const leaderboardExportUrl              = new URL(leaderboardExportLink);

          leaderboardExportUrl.searchParams.set('leaderboard_export_challenge_round_id', leaderboardExportChallengeRoundId);
          $('#leaderboard-export-link').attr('href', leaderboardExportUrl.toString());
        });

        $('#submissions-export-rounds-select').on('change', function(event) {
          const submissionsExportChallengeRoundId = event.target.value;
          const submissionsExportLink             = $('#submissions-export-link').attr('href');
          const submissionsExportUrl              = new URL(submissionsExportLink);

          submissionsExportUrl.searchParams.set('submissions_export_challenge_round_id', submissionsExportChallengeRoundId);
          $('#submissions-export-link').attr('href', submissionsExportUrl.toString());
        });

        if (currentTab) {
          currentTab.tab('show');
          resetChallengesFormClientValidations();
        }
    },
    show: function () {
        let update_table_of_contents = function (headings) {
        let toc = $("#table-of-contents");

        $.each(headings, (index, heading) => {
          // JQuery Object from DOM object
          heading = $(heading);
          let heading_content = heading.text();
          let heading_id = heading_content.replace(/ /g,"_") + index;
          heading.attr('id', heading_id);

          let li = $('<li/>', {
            "class": 'nav-item',
          }).appendTo(toc);

          $('<a/>', {
            "class": 'nav-link',
            href: "#"+heading_id,
            text: _.capitalize(heading_content)
          }).appendTo(li);

          // Attach ScrollSpy only after the TOC has been generated.
          if (index === headings.length - 1) {
            $('body').scrollspy({target: "#table-of-contents", offset: 64});
          }
        });
      };
        // NATE: Apparently challenges#show is not using turbolinks
        $(document).ready(function () {
          let headings = $("#description-wrapper h2").get();
          update_table_of_contents(headings);
        });
    }
});
