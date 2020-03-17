$(document).on('click', '.challenge-invite-participant', function(){
  $('.email_invitation_form').show();
  $('.challenge-invite-participant').attr("disabled", true);
});


$(document).ready(function() {
  $('input[name="status"]:radio').change(function(){
    $('#challenge-statuses').addClass('filter-active');
  });
  $('input[name="category[category_names][]"]:checkbox').change(function(){
    $('#challenge-categories').removeClass('filter-active');
    if ($('input[name="category[category_names][]"').is(':checked'))
    {
      $('#challenge-categories').addClass('filter-active');
    }
  });
  $('input[name="prize[prize_type][]"]:checkbox').change(function(){
    $('#challenge-prizes').removeClass('filter-active');
    if ($('input[name="prize[prize_type][]"').is(':checked'))
    {
      $('#challenge-prizes').addClass('filter-active');
    }
  });
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
        $(document).ready(function() {
            $('.select2').select2();
        });
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

            const inputs_to_copy = [
                'score_title',
                'score_secondary_title',
                'primary_sort_order',
                'secondary_sort_order',
                'submission_limit_period',
                'minimum_score',
                'minimum_score_secondary',
                'submission_limit',
                'failed_submissions',
                'parallel_submissions',
                'ranking_highlight',
                'ranking_window',
                'score_precision',
                'score_secondary_precision',
            ];

            // Get the round just above current round
            const old_rounds = $($(added_round).prevAll('.round'));
            const round_to_copy = old_rounds.first();

            // Set name of new round to number of rounds + 1
            added_round.find($("input[id$='challenge_round']")).val( `Round ${old_rounds.length + 1}`);

            // Copy inputs
            inputs_to_copy.forEach( function(identifier) {
                    let selector = $(`[id$='${identifier}']`);
                    let old_input = round_to_copy.find(selector);
                    let new_input = added_round.find(selector);
                    $(new_input).val($(old_input).val());
                }
            );
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
    }
});
