import { Controller } from "stimulus"

export default class extends Controller {
    static targets = ["selectScore", "selectedScore"];
    chartType;
    index;

    connect() {
        this.index = this.data.get('index');
        this.chartType = this.data.get('chartType');
    }

    updateChartUrl(event){
        let url = event.target.dataset.chartUrl;
        console.log(url);
        this.selectedScoreTarget.innerText = event.target.innerText;
        new Chartkick[this.chartType]("chart-" + this.index, url, {"colors":["#44B174"]});
    }
}
