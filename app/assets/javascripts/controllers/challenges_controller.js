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

      let table_of_content_as_tabs = function () {
        if ($('#description-wrapper .md-content').length > 0) {
          let force_scroll = false;
          let content = $('#description-wrapper .md-content')[0].innerHTML;
          $('<style>.force-active { color: #DE4B46 !important; font-weight: 700;}</style>').appendTo('body');
          let first_link_in_content = $('#table-of-contents a').first().attr('href').split('#')[1];
          let first_link_content = $(content).filter('h2#'+first_link_in_content)[0].outerHTML;
          let notification_data = content.split(first_link_content)[0];
          let reset_content_to_everything_if_mobile = function() {
            // sub-nav-vertical-container's css display:none happens when screen size is small
            if ($('#table-of-contents').parent('div.sub-nav-vertical-container').css('display') == "none") {
              $('#description-wrapper .md-content')[0].innerHTML = content;
              return true;
            }
            return false;
          }

          $('#table-of-contents a').click(function(event) {
            if (reset_content_to_everything_if_mobile()) {
              // This functionality should only work for desktop screens
              return;
            }
            clicked_id = $(this).attr('href').split('#')[1];
            try {
              next_to_clicked_id = $($(this).parent().next().find('a')[0]).attr('href').split('#')[1];
            } catch(err) {
              next_to_clicked_id = null;
            }

            start_content = $(content).filter('h2#'+clicked_id)[0].outerHTML;
            if (next_to_clicked_id) {
              end_content = $(content).filter('h2#'+next_to_clicked_id)[0].outerHTML;
              newcontent = start_content + content.split(start_content)[1].split(end_content)[0];
            }
            else {
              newcontent = start_content + content.split(start_content)[1];
            }

            if (clicked_id == first_link_in_content) {
              newcontent = notification_data + newcontent;
            }
            $('#description-wrapper .md-content')[0].innerHTML = newcontent;

            $('#table-of-contents a').removeClass('active');
            $('#table-of-contents a').removeClass('force-active');
            $('a[href$="'+clicked_id+'"]').addClass('force-active');
            if (force_scroll) {
              document.documentElement.scrollTop = $('#' + clicked_id).offset().top;
            }
            return false;
          });

          // Final initialization
          $('#table-of-contents a').first().click();
          force_scroll = true;

          // Started handling on the go screen resizes, to show all content when needed
          $(window).resize(function(){
            if (reset_content_to_everything_if_mobile()) {
              return;
            }
            force_scroll = false;
            $('#table-of-contents a').first().click();
            force_scroll = true;
          });
        }
      }

        // NATE: Apparently challenges#show is not using turbolinks
        $(document).ready(function () {
          let headings = $("#description-wrapper h2").get();
          update_table_of_contents(headings);
          table_of_content_as_tabs();
        });
    }
});
