import { Controller } from 'stimulus';
import mermaid from 'mermaid';

export default class extends Controller {
  connect() {
    $(document).ready(function() {
      if(mermaid) {
        mermaid.init(".aicrowd-mermaid");
      }
    });
    this.refreshMermaidGraph();
  }

  refreshMermaidGraph(){
    const submissionId = this.data.get('id');
    const challengeId = this.data.get('challenge_id')
    setInterval(function () {
      $.ajax({
        url: "/challenges/" + challengeId + "/submissions/mermaid_data",
        dataType: "JSON",
        data: {submission_id: submissionId},
        method: "GET",
        complete: function(result) {
          $('#mermaid-container').html(result.responseText);
          mermaid.init(".aicrowd-mermaid");
        }
        // success: function(result){
        //   $('#mermaid-container').html("result");
        // }
      });
    }, 20000);
  };
}
