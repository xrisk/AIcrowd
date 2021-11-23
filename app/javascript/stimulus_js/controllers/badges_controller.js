import { Controller } from 'stimulus';

export default class extends Controller {
  sharedNotebook(event){
    const postId = this.data.get('post-id')
    const participantId = this.data.get('participant-id')
    $.ajax({
        url: '/badges/shared_notebook',
        type: 'POST',
        data: {id: participantId},
        success:  function(result){},
        error: function(){}
    });

    $.ajax({
        url: '/badges/notebook_was_shared',
        type: 'POST',
        data: {id: postId},
        success:  function(result){},
        error: function(){}
    });
  }

  downloadNotebook(event){
    const postId = this.data.get('post-id')
    const participantId = this.data.get('participant-id')
    $.ajax({
        url: '/badges/downloaded_notebook',
        type: 'POST',
        data: {id: participantId},
        success:  function(result){},
        error: function(){}
    });

    $.ajax({
        url: '/badges/notebook_received_download',
        type: 'POST',
        data: {id: postId},
        success:  function(result){},
        error: function(){}
    });
  }

  executedNotebook(event){
    const postId = this.data.get('post-id')
    $.ajax({
        url: '/badges/executed_notebook',
        type: 'POST',
        data: {id: postId},
        success:  function(result){},
        error: function(){}
    });
  }
}