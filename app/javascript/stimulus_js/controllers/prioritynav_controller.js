import { Controller } from "stimulus"

export default class extends Controller {
    connect() {
        PriorityNav.init();
    }
}

let PriorityNav = {
    init: function() {
        this.menu = $(".priority-nav");
        this.bindUIActions();
        this.setupMenu();
    },

    setupMenu: function() {
        PriorityNav.allNavElements = $(".priority-nav > ul > li:not('.overflow-nav')");
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
            let newSet = wrappedElements.clone().find('a');
            wrappedElements.addClass("d-none");
            newSet.addClass("dropdown-item");
            newSet.removeClass("nav-link");
            $(".overflow-nav-list").append(newSet);
            $(".overflow-nav").addClass("show-inline-block");
            $(".priority-nav").css("overflow", "visible");

            if($(window).width() < 500) {
                let navButtons = $('.sub-nav-bar a.btn:not(:last)');
                if(navButtons.length) {
                    let extraSet = navButtons.clone();
                    extraSet.removeClass();
                    extraSet.addClass("dropdown-item");
                    $('.overflow-nav-list').append('<hr class="m-0" />');
                    $('.overflow-nav-list').append(extraSet);
                    navButtons.addClass('d-none btn-none');
                    navButtons.removeClass('btn');
                }

                let navButtonsInDropdown = $('.priority-nav a.dropdown-item').not('.priority-nav ul.nav a.dropdown-item');
                if(navButtonsInDropdown.length) {
                    let extraSet = navButtonsInDropdown.clone();
                    extraSet.removeClass();
                    extraSet.addClass("dropdown-item");
                    $('.overflow-nav-list').append('<hr class="m-0" />');
                    $('.overflow-nav-list').append(extraSet);
                    navButtonsInDropdown.addClass('d-none dropdown-a-none');
                    navButtonsInDropdown.removeClass('btn');
                    navButtonsInDropdown.parent('.dropdown-menu').parent('.dropdown').addClass('d-none dropdown-a-none');
                }
            }

            let menuButton = $(".priority-nav ul.nav .dropdown-toggle");
            if($(".priority-nav > ul > li:not(.d-none)").length == 1 && menuButton) {
                menuButton.html(menuButton.html().replace('More','Menu'));
            }
        }
        else {
            $(".overflow-nav").addClass("d-none");
        }
    },

    tearDown: function() {
        $(".overflow-nav-list").empty();
        $(".overflow-nav").removeClass("d-none show-inline-block");
        $(".btn-none").addClass("btn").removeClass("btn-none d-none");
        $(".dropdown-a-none").removeClass("dropdown-a-none d-none");

        let menuButton = $(".priority-nav ul.nav .dropdown-toggle");
        if(menuButton) {
            menuButton.html(menuButton.html().replace('Menu','More'));
        }

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

window.nav_bar_reset = function() {
    PriorityNav.tearDown();
    PriorityNav.setupMenu();
    PriorityNav.menu.removeClass("overflow-hidden");
};
