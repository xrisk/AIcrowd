import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    const challengeId = this.data.get('challenge-id');

    $('#eua-file').on('click', function(e) {
      const self = this;
      const clefTaskId = $(self).data('clef-task-id');

      $.ajax({
        url: '/participant_clef_tasks/',
        type: 'POST',
        data: { "participant_clef_task": { "clef_task_id": clefTaskId, "challenge_id": challengeId } },
        complete: function() { console.log('download of eua logged')},
        error: function() { console.log('download logging of eua errored ' + status)}
      });
    });
  }
}
