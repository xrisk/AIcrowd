// https://css-tricks.com/diy-priority-plus-nav/
let PriorityNav = {
    init: function() {
        this.menu = $(".priority-nav");
        this.allNavElements = $(".priority-nav > ul > li:not('.overflow-nav')");
        this.bindUIActions();
        this.setupMenu();
    },

    setupMenu: function() {
        let firstPos = $(".priority-nav > ul > li:first").position();
        let wrappedElements = $();
        let first = true;
        PriorityNav.allNavElements.each(function(i) {
            let el = $(this);
            let pos = el.position();
            if (pos.top !== firstPos.top) {
                wrappedElements = wrappedElements.add(el);
                if (first) {
                    wrappedElements = wrappedElements.add(PriorityNav.allNavElements.eq(i-1));
                    first = false;
                }
            }
        });

        if (wrappedElements.length) {
            let newSet = wrappedElements.clone();
            wrappedElements.addClass("d-none");
            newSet.addClass("dropdown-item");
            $(".overflow-nav-list").append(newSet);
            $(".overflow-nav").addClass("show-inline-block");
            $(".priority-nav").css("overflow", "visible");
        }
        else {
            $(".overflow-nav").addClass("d-none");
        }
    },

    tearDown: function() {
        $(".overflow-nav-list").empty();
        $(".overflow-nav").removeClass("d-none show-inline-block");
        PriorityNav.allNavElements.removeClass("d-none");
    },

    bindUIActions: function() {
        $(".overflow-nav-title").on("click", function() {
            this.toggleClass("show");
        });

        $(window)
            .resize(function() {PriorityNav.menu.addClass("overflow-hidden");})
            .resize(_.debounce(function() {
                PriorityNav.tearDown();
                PriorityNav.setupMenu();
                PriorityNav.menu.removeClass("overflow-hidden");
            }, 500));
    }
};

function resetChallengesFormClientValidations() {
  // We need to wait till fields show up in browser
  setTimeout(function() { $('#challenges-form').enableClientSideValidations(); }, 1000);
}

Paloma.controller('Challenges', {
    reorder: function () {
        let calculateIndex = function () {
            let landingPageIdx = 6;
            let l = $(".challenge-list-row .new-seq");
            for (let i = 0; i < l.length; i++) {
                l[i].innerText = i.toString();
                let current = $(l[i].parentNode);
                // Hidden and Private challenges have a badge!
                let hasBadge = current.has('.badge').length > 0;
                let draftChallenge = current.children()[1].textContent === "draft";
                if (i < landingPageIdx) {
                    if (hasBadge || draftChallenge) {
                        landingPageIdx++;
                        continue;
                    }
                    $(current).addClass('table-success');
                } else {
                    $(current).removeClass('table-success');
                }
            }
        };
        $(function () {
            let selected_sortable = $("#sortable");
            calculateIndex();
            selected_sortable.sortable({
                update: function (event, ui) {
                    calculateIndex();
                    let order = $("#sortable").sortable("toArray");
                    order[0] && $('#order').val(order.join(","));
                }
            });
            selected_sortable.disableSelection();
            let order = selected_sortable.sortable("toArray");
            order[0] && $('#order').val(order.join(","));
        });
    },
    edit: function () {
        const currentUrl  = new URL(window.location);
        const currentStep = currentUrl.searchParams.get('step');
        const currentTab  = $(`#challenge-edit-${currentStep}-tab`);

        let switch_handler = function () {
          $('.active-switch').each((event, checkbox) => {
              if (checkbox !== this) {
                  checkbox.checked = false;
              }
          });
        };

        $("#rounds").on('cocoon:after-insert', function(event, added_round) {
          added_round.find('.active-switch').on('click', switch_handler);
        });

        $('.challenges-form-tab-link').click(function(event) {
          const tabLink = $(event.target).tab('show');

          event.preventDefault();

          // Set step in URL address
          currentUrl.searchParams.set('step', event.target.dataset.currentTab);
          window.history.pushState(null, null, currentUrl.toString());

          resetChallengesFormClientValidations();
        });

        $('.active-switch').on('click', switch_handler);

        $('.challenges-form__toggle-expand').click(function(event) {
          resetChallengesFormClientValidations();
        });

        $('#replace-rules-button').click(function (event) {
          $(this).hide()
          resetChallengesFormClientValidations();
        });

        $('#challenges-form-add-partner').click(function() {
          resetChallengesFormClientValidations();
        });

        $('#challenges-form-add-round').click(function() {
          resetChallengesFormClientValidations();

          setTimeout(function() {
            $('.challenges-form__toggle-expand').click(function(event) {
              resetChallengesFormClientValidations();
            });
          }, 1000);
        });

        if (currentTab) {
          currentTab.tab('show');
          resetChallengesFormClientValidations();
        }
    },
    show: function () {
        PriorityNav.init();
        let update_table_of_contents = function (headings) {
        let toc = $("#table-of-contents");

        $.each(headings, (index, heading) => {
          // JQuery Object from DOM object
          heading = $(heading);
          let heading_content = heading.text();
          heading.attr('id', heading_content);

          let li = $('<li/>', {
            "class": 'nav-link',
          }).appendTo(toc);

          $('<a/>', {
            "class": 'nav-item',
            href: "#"+heading_content,
            text: _.capitalize(heading_content)
          }).appendTo(li);

          // Attach ScrollSpy only after the TOC has been generated.
          if (index === headings.length) {
            $('body').scrollspy({target: "#table-of-contents", offset: 64});
          }
        });
      };
        // NATE: Apparently challenges#show is not using turbolinks
        $(document).ready(function () {
          let headings = $("#description-wrapper h2").get();
          update_table_of_contents(headings);
        });
    }
});
