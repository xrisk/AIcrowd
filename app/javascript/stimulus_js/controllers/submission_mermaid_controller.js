import { Controller } from 'stimulus';
import mermaid from 'mermaid';

export default class extends Controller {
  connect() {
    $(document).ready(function() {
      if(mermaid) {
        mermaid.init(".aicrowd-mermaid");
      }
      setInterval(function () {
        $('#submission-mermaid-div').load(window.location.href + " #submission-mermaid-div > *" );
        if(mermaid) {
          mermaid.init(".aicrowd-mermaid");
        }
      }, 30000);
    });
  }
}
