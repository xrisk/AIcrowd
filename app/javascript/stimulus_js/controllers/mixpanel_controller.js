import { Controller } from 'stimulus';
import mixpanel from 'mixpanel-browser';

export default class extends Controller {
    initialize() {
        if(!mixpanel_initialized) {
            mixpanel_initialized = true;
            mixpanel.init(mixpanel_token,{"ignore_dnt": true});
            if (typeof mixpanel_person !== 'undefined') {
                var current_mixpanel_id = mixpanel.get_distinct_id();
                if(current_mixpanel_id !== mixpanel_person) {
                    mixpanel.identify(mixpanel_person);

                }
            }
            mixpanel.track("Visit", mixpanel_visit);
        }
    }

    connect() {
        var eventType = this.data.element.getAttribute('data-type');
        if(eventType) {
            this[eventType](this.data.element);
        }
    }

    signupExternal(element, method) {
        mixpanel.track_links(element, 'Registration Start', {
            'Registration Method': method
        });
    }

    signupGitHub(element) {
        this.signupExternal(element, 'GitHub')
    }

    signupGoogle(element) {
        this.signupExternal(element, 'Google')
    }

    signupEmail(element) {
        mixpanel.track_forms(element, 'Registration Start', {
            'Registration Method': 'Email'
        });
    }

    loginExternal(element, method) {
        mixpanel.track_links(element, 'Login Start', {
            'Login Method': method
        });
    }

    loginGitHub(element) {
        this.loginExternal(element, 'GitHub')
    }

    loginGoogle(element) {
        this.loginExternal(element, 'Google')
    }

    loginEmail(element) {
        mixpanel.track_forms(element, 'Login Start', {
            'Login Method': 'Email'
        });
    }

    challengeLoginGitHub(element) {
        this.loginExternal(element, 'Challenge Page GitHub')
    }

    challengeLoginGoogle(element) {
        this.loginExternal(element, 'Challenge Page Google')
    }

    logout() {
        mixpanel.track('Logout', {
            "Logged In": false
        }, function () {
            mixpanel.reset();
        })
    }

    challenge_participation_start() {
        mixpanel.track('Challenge Participation Start');
    }
}