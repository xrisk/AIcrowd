import { Controller } from 'stimulus';
import { mermaid } from 'mermaid';

export default class extends Controller {
  connect() {
    $(document).ready(function() {
      if(mermaid) {
        mermaid.initialize();
      }
    });
  }
}
