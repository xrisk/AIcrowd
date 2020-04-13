import { Controller } from 'stimulus';

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

    replaceContent(content){
        this.fullContent = content.replace(/~~(.*?)~~/gim, "<del>$1</del>");
        this.showTOC();
    }

    updateContent(content) {
        this.el.html(content);
        hljs.initHighlighting.called = false;
        hljs.initHighlighting();
        loadMathJax();
        setupOembed();
    }

    initialize() {
        this.element['controller'] = this;
        this.el = $(this.element);
        // Convert strikeouts!
        this.fullContent = this.el.html().replace(/~~(.*?)~~/gim, "<del>$1</del>");
        this.showTOC();
    }

    showTOC() {
        this.updateContent(this.fullContent);
        if (window.matchMedia("(max-width: 991.98px)").matches) {
            return;
        }
        this.toc = $("#table-of-contents");
        this.firstChild = this.el.children().first();

        // If the first child is an h2 there is no "Updates" Text
        if (this.firstChild.is('h2') ) {
            $(this.el).find('h2').first().addClass('mt-2');
        }
        this.headings = this.el.find("h2").get();
        // Clear TOC
        this.toc.empty();
        this.createTOC();

        $('body').scrollspy({target: "#table-of-contents", offset: 64});
    }

    createTOC(){
        $.each(this.headings, (index, heading) => {
            // URL friendly id
            var urlFriendly = $(heading).text().replace(/(^\W*)|(\W*$)/g, '').replace(' ', '-').toLowerCase();
            // Add id
            $(heading).attr('id', urlFriendly);

            // Create new list item in the TOC
            const li = $('<li/>', { class: 'nav-item'}).appendTo(this.toc);

            // Create a link tag to trigger content change
            const link = $('<a/>', {
                class: 'nav-link text-capitalize',
                href: `#` + urlFriendly,
                text: $(heading).text() }).appendTo(li);

        });
        this.tocLinks = this.toc.find('a');
        this.selectedLink = this.tocLinks.first();
    }

}
