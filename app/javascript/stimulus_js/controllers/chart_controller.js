import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["updateRound", "progressBar", 'displayScore'];

    connect() {
        this.index = this.data.get('index');
        this.type = this.data.get('type');
        this.currentRound = this.data.get('round');
        this.baseUrl = this.data.get('url');
        this.defaultYTitle = this.data.get('defaultYtitle');
        this.currentScore = 'score';
        this.updateChartUrl();
    }

    updateScore(event){
        event.preventDefault();
        this.currentScore = event.target.dataset.score;
        this.selectedScoreTitle = $(`.dropdown-item.chart-${this.index}.round-${this.currentRound}.${this.currentScore}`).text();
        this.updateChartUrl();
    }

    updateRound(event){
        event.preventDefault();
        this.currentRound = event.target.dataset.round;
        this.updateRoundTargets.forEach(target => { $(target).removeClass('active') });
        $(event.target).addClass('active');

        this.selectedScoreTitle = $(`.dropdown-item.chart-${this.index}.round-${this.currentRound}.${this.currentScore}`).text();
        if (!this.selectedScoreTitle){
            this.currentScore = 'score';

        }
        this.updateChartUrl();
    }


    updateChartUrl(){
        if (this.hasDisplayScoreTarget) {
            this.displayScoreTargets.forEach(target => {
                if (target.dataset.round === this.currentRound) {
                    $(target).removeClass('display-none');
                    $(target).children("button").text(this.selectedScoreTitle);
                } else {
                    $(target).addClass('display-none');
                }
            });
        }

        let params = {challenge_round_id: this.currentRound};

        if (this.currentScore) {
            params = {
                challenge_round_id: this.currentRound,
                score: this.currentScore
            };
        }

        let url = `${this.baseUrl}?${$.param(params)}`;
        let progressBar = this.progressBarTarget;
        progressBar.value = 0.05;
        $(progressBar).removeClass('display-none');
        
        new Chartkick[this.type]("chart-" + this.index, url,
            {
                colors: ["#44B174"],
                xtitle: 'Time',
                ytitle: this.selectedScoreTitle || this.defaultYTitle,
                library: { animation: {
                        duration: 2000,
                        onProgress: function(animation) {
                            progressBar.value = 0.05 + animation.currentStep / animation.numSteps;
                        },
                        onComplete: function(animation) {
                            progressBar.value = 0;
                            $(progressBar).addClass('display-none');
                        }
                    }
                }});
    }
}
