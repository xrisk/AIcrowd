import { Controller } from 'stimulus';
import linkifyHtml from 'linkifyjs/html';

function setupOembed(){
    document.querySelectorAll( 'oembed[url]' ).forEach(element => {
        // Create the <a href="..." class="embedly-card"></a> element that Embedly uses
        // to discover the media.
        const anchor = document.createElement('a');

        anchor.setAttribute('href', element.getAttribute( 'url' ));
        anchor.className = 'embedly-card';

        element.appendChild(anchor);
    });
};

function loadMathJax() {
  if (window.MathJax) {
    window.MathJax.Hub.Queue(["Typeset", window.MathJax.Hub]);
  }
  else {
    $.getScript(
      "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.7/MathJax.js?config=TeX-MML-AM_CHTML",
      function () {
        MathJax.Hub.Config({
          tex2jax: {
            inlineMath: [["$", "$"], ["\\(", "\\)"]],
            displayMath: [["$$", "$$"], ["\\[", "\\]"]],
            processEscapes: true
          }
        });
      }
    );
  }
}
export default class extends Controller {
    selectedLink;
    tocLinks;
    toc;
    hasUpdates;
    firstChild;
    headings;
    fullContent;
    scrollableTabs;

    connect() {
      this.element['controller'] = this;
      this.el = $(this.element);
      // Convert strikeouts!
      this.fullContent = this.el.html().replace(/~~(.*?)~~/gim, "<del>$1</del>");
      this.scrollableTabs = this.data.get('scrollable-tabs') === 'true'

      this.showTOC();
      // Linkify links inside challenge description
      this.el.html(linkifyHtml(this.el.html()));
    }

    updateContent(content) {
      this.el.html(content);
      hljs.initHighlighting.called = false;
      hljs.initHighlighting();
      loadMathJax();
      setupOembed();
    }

    showTOC() {
      if (this.scrollableTabs) {
        this.updateContent(this.fullContent);
      }

      if (window.matchMedia("(max-width: 991.98px)").matches) {
        return;
      }
      this.toc = $("#table-of-contents");
      this.firstChild = this.el.children().first();

      // If the first child is an h1 there is no "Updates" Text
      if (this.firstChild.is('h1') ) {
        $(this.el).find('h1').first().addClass('mt-2');
      }
      this.headings = this.el.find("h1").get();
      // Clear TOC
      this.toc.empty();

      if (this.scrollableTabs) {
        this.createTOC();
        $('body').scrollspy({target: "#table-of-contents", offset: 64});
        this.updateActive();
      } else {
        this.createTabularTOC();
        this.updateActive();

        this.el.children().first().remove();
        this.selectedLink.click()
      }
    }

    updateActive(index = 0){
      this.tocLinks.removeClass('active');
      this.selectedLink.addClass('active');
      if (index > 0) {
          document.documentElement.scrollTop = this.el.find(`#heading-${index}`).offset().top;
      }
    }

    createTOC() {
      $.each(this.headings, (index, heading) => {
        // URL friendly id
        var urlFriendly = $(heading).text().replace(/(^\W*)|(\W*$)/g, '').replace(' ', '-').toLowerCase();
        // Add id
        $(heading).attr('id', urlFriendly);

        // Create new list item in the TOC
        const li = $('<li/>', { class: 'nav-item'}).appendTo(this.toc);

        // Create a link tag to trigger content change
        const link = $('<a/>', {
            class: 'nav-link text-capitalize cursor-pointer',
            href: `#` + urlFriendly,
            text: _.capitalize($(heading).text().replace('¶', '')) }).appendTo(li);

      });

      this.tocLinks = this.toc.find('a');
      this.selectedLink = this.tocLinks.first();
    }

    createTabularTOC() {
      $.each(this.headings, (index, heading) => {
        // URL friendly id
        var urlFriendly = $(heading).text().replace(/(^\W*)|(\W*$)/g, '').replace(' ', '-').toLowerCase();
        // Add id
        $(heading).attr('id', urlFriendly);

        // Add mt-2 to headings
        $(heading).addClass('mt-2');

        // Create new list item in the TOC
        let li = $('<li/>', { class: 'nav-item'}).appendTo(this.toc);

        // Create a link tag to trigger content change
        let link = $('<a/>', {
            class: 'nav-link text-capitalize cursor-pointer',
            href: `#` + urlFriendly,
            text:  _.capitalize($(heading).text()) }).appendTo(li);

        // Calculate Content
        let content = this.getContent($(heading), index);

        // Setup click callback
        link.click(() => this.selectHeading(link, content));
       });

      this.tocLinks = this.toc.find('a');
      this.selectedLink = this.tocLinks.first();
    }

    getContent(start, index){
      let content = "";

      $(start)
        .nextUntil(' h1 ')
        .addBack() // Add selected heading to content
        .each( (i,x) => content += x.outerHTML );

      return content;
    }

    selectHeading(link, contentHTML) {
      this.selectedLink = link;

      $(this.element).html(contentHTML);
      this.updateActive();
    }
}
