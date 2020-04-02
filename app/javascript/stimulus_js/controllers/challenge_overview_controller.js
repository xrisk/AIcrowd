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
    window.MathJax = null;
    $.getScript(
        "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-MML-AM_CHTML",
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
export default class extends Controller {
    selectedLink;
    tocLinks;
    toc;
    updates;
    firstChild;
    headings;
    fullContent;

    updateContent(content) {
        this.el.html(content);
    }

    initialize() {
        this.el = $(this.element);
        // Convert strikeouts!
        this.fullContent = this.el.html().replace(/~~(.*?)~~/gim, "<del>$1</del>");
        this.showTOC();

        loadMathJax();
        setupOembed();
    }

    showTOC() {
        let update_table_of_contents = function (headings) {
            let toc = $("#table-of-contents");
            $.each(headings, (index, heading) => {
                // JQuery Object from DOM object
                heading = $(heading);
                let heading_content = heading.text();
                let heading_id = heading_content.replace(/ /g,"_") + index;
                heading.attr('id', heading_id);

                let li = $('<li/>', {
                    "class": 'nav-item',
                }).appendTo(toc);

                $('<a/>', {
                    "class": 'nav-link',
                    href: "#"+heading_id,
                    text: _.capitalize(heading_content)
                }).appendTo(li);

                // Attach ScrollSpy only after the TOC has been generated.
                if (index === headings.length - 1) {
                    $('body').scrollspy({target: "#table-of-contents", offset: 64});
                }
            });
        };

        $(document).ready(function () {
            var headings = $("#description-wrapper h2").get();
            update_table_of_contents(headings);
        });
    }

    showTabularTOC() {
        if (window.matchMedia("(max-width: 991.98px)").matches) {
            this.updateContent(this.fullContent);
            return;
        }
        this.updateContent(this.fullContent);
        this.toc = $("#table-of-contents");
        this.firstChild = this.el.children().first();

        // If the first child is an h2 there is no "Updates" Text
        this.updates = null;
        if (! this.firstChild.is('h2') ) {
            this.updates = this.getContent(this.firstChild);
            this.el.prepend( $('<h2/>', { text: 'Updates' }) )
        }
        this.headings = this.el.find("h2").get();
        // Clear TOC
        this.toc.empty();
        this.createTOC();
        this.updateActive();
        this.el.children().first().remove();
        this.selectedLink.click();
    }

    createTOC(){
        $.each(this.headings, (index, heading) => {
            // Add mt-0 to headings
            $(heading).addClass('mt-0');
            // Add id
            $(heading).attr('id', `heading-${index}`);

            // Create new list item in the TOC
            const li = $('<li/>', { class: 'nav-item'}).appendTo(this.toc);

            // Create a link tag to trigger content change
            const link = $('<a/>', { class: 'nav-link', text:  _.capitalize($(heading).text()) }).appendTo(li);

            // Calculate Content
            const content = this.getContent($(heading), index);

            // Setup click callback
            link.click(() => this.selectHeading(link, content, index));
        });
        this.tocLinks = this.toc.find('a');
        this.selectedLink = this.tocLinks.first();
    }

    selectHeading(link, contentHTML, index) {
        this.selectedLink = link;
        this.updateContent(contentHTML);
        this.updateActive(index);
    }

    getContent(start, index){
        let content = "";

        if (index === 0){
            $(start)
                .nextUntil(' h2 ')
                .each( (i,x) => content += x.outerHTML );
        } else {
            $(start).nextUntil(' h2 ')
                .addBack() // Add back the 'start' element to the array
                .each( (i,x) => content += x.outerHTML );
        }

        return content;
    }

    updateActive(index = 0){
        this.tocLinks.removeClass('active');
        this.selectedLink.addClass('active');
        if (index > 0) {
            document.documentElement.scrollTop = this.el.find(`#heading-${index}`).offset().top;
        }
    }
}
