import { Controller } from "stimulus"

export default class extends Controller {
    connect() {
        PriorityNav.init();
    }
}

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
            console.log(wrappedElements);
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