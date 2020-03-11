import { Controller } from 'stimulus';

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
    }

    showTOC() {
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

