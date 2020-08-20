import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    const that = this;

    $(document).ready(function() {
      if ($(".select2").length > 0) {
        $('.select2').select2();
        $('.category_select2').select2({
          tags: true
        });
      }
    });

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
      const currentUrl = new URL(window.location);

      event.preventDefault();

      // Set step in URL address
      currentUrl.searchParams.set('step', event.target.dataset.currentTab);
      window.history.pushState(null, null, currentUrl.toString());

      that.resetChallengesFormClientValidations();
    });

    $('.active-switch').on('click', switch_handler);

    $('.challenges-form__toggle-expand').click(function(event) {
      that.resetChallengesFormClientValidations();
    });

    $('#replace-rules-button').click(function (event) {
      $(this).hide()
      that.resetChallengesFormClientValidations();
    });

    $('#challenges-form-add-partner').click(function() {
      that.resetChallengesFormClientValidations();
    });

    $('#challenges-form-add-round').click(function() {
      that.resetChallengesFormClientValidations();

      setTimeout(function() {
        $('.challenges-form__toggle-expand').click(function(event) {
          that.resetChallengesFormClientValidations();
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

    // Change here need to be copied to update.js.erb as well!
    $('.challenge-edit-submit').on('click', function (event) {
      for (let selector in CKEDITOR.instances){
        CKEDITOR.instances[selector].setMode('wysiwyg');
      }
    });

    $('#preview-modal').on('show.bs.modal', function (event) {
      let editor = CKEDITOR.instances["challenge_description"];
      let modal = $(this);
      editor.fire('saveSnapshot');
      if (editor.mode === 'markdown') {
        editor.setMode('wysiwyg', function () {
          let data = editor.getData();
          modal.find('.ck-content').get(0)['controller'].replaceContent(data);
          editor.setMode('markdown');
        });
      } else {
        let data = editor.getData();
        modal.find('.ck-content').get(0)['controller'].replaceContent(data);
      }
    });
  }

  resetChallengesFormClientValidations() {
    // We need to wait till fields show up in browser
    setTimeout(function() { $('#challenges-form').enableClientSideValidations(); }, 1000);
  }
}
