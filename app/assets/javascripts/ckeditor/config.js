/*
Copyright (c) 2003-2011, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/

CKEDITOR.plugins.addExternal( 'markdown', '/assets/ckeditor/plugins/markdown/plugin.js' );
CKEDITOR.plugins.addExternal( 'codesnippet', '/assets/ckeditor/plugins/codesnippet/plugin.js' );
CKEDITOR.plugins.addExternal( 'divarea', '/assets/ckeditor/plugins/divarea/plugin.js' );
CKEDITOR.plugins.addExternal( 'mathjax', '/assets/ckeditor/plugins/mathjax/plugin.js' );

CKEDITOR.editorConfig = function( config )
{
  // Lots of customization available!
  // Relevant docs
  // https://github.com/galetahub/ckeditor
  // https://ckeditor.com/docs/ckeditor4/latest/
  // http://cdn.ckeditor.com/

  config.skin = 'n1theme,/assets/ckeditor/skins/n1theme/';

  config.extraPlugins = 'markdown,codesnippet,divarea,mathjax,emoji';
  config.resize_dir = 'both';
  config.format_tags = 'p;h2;h3;h4;pre;address;div';

  config.mathJaxLib = '//cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML';

  /* Filebrowser routes */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
  config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

  // The location of a script that handles file uploads in the Flash dialog.
  config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/ckeditor/pictures?";

  // The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/ckeditor/attachment_files";

  config.allowedContent = true;
  config.filebrowserUploadMethod = 'form';

  // Toolbar groups configuration.
  config.toolbar = [[
      'Format','-', 'TextColor', 'BGColor', '-', 'Bold', 'Italic', 'Underline', 'Strike', '-',
      'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'NumberedList', 'BulletedList', '-',
      'Outdent', 'Indent', '-', 'Find', 'Replace', '-', 'Scayt', '-', 'Undo', 'Redo', '-', 'Link', 'Unlink','-',
      'RemoveFormat', '-', 'Source', 'Markdown'], '/', ['Cut', 'Copy', 'Paste', 'PasteText', 'PasteFromWord', '-',
      'EmojiPanel', '-', 'Blockquote','-', 'CodeSnippet','-', 'Mathjax','-', 'Image','-', 'Table','-', 'HorizontalRule'
  ]];

};
