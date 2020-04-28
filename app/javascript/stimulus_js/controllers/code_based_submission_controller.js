import { Controller } from 'stimulus';
    
export default class extends Controller {
  connect() {
    if (localStorage.getItem("aceEditorTheme") === null) {
      localStorage.setItem("aceEditorTheme", "ace/theme/github");
    }
    
    $(document).ready(function() {
      const submission = ace.edit('ace-editor');
      submission.getSession().setMode("ace/mode/python");
    
      //--- Theme Handler ----//
      const userSelectedTheme = localStorage.getItem("aceEditorTheme");
      submission.setTheme(userSelectedTheme);
      $('#ace-editor-theme').val(userSelectedTheme);
      // Future theme changes
      $('#ace-editor-theme').change(function() {
        const selectedTheme = $(this).val();
        localStorage.setItem("aceEditorTheme", selectedTheme);
        submission.setTheme(selectedTheme);
      });
      //--- End Theme Handler ----//
    
      //--- Ace Editor to form field ---//
      const textarea = $('#ace-editor-value');
      submission.getSession().on("change", function () {
        textarea.val(submission.getSession().getValue());
      });
      //--- End Ace Editor to form field ---//
    });
  }
}
