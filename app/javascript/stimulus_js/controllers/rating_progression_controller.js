import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    let chart           = Chartkick.charts["line-chart"];
    const newOptions    = chartOptions(chart);
    const mergedOptions = jQuery.extend(chart.options, newOptions);

    chart.setOptions(mergedOptions);

    let pointarray = new Array(chart.chart.data.datasets[0].data.length).fill(0)
    let data_array = chart.chart.data.datasets[0].data

    for (let j in data_array) {
      const challenge_round_name = chart.dataSource[indexOfArray(data_array[j], chart.dataSource)][2]

      if (challenge_round_name != '' && (data_array[j]!== data_array[j+1])) {
        pointarray[j] = 4
      }
    }

    chart.chart.data.datasets[0].pointRadius = pointarray
    chart.chart.update()
  }
}

function indexOfArray(val, array) {
  for (let i = 0; i < array.length; i++) {
    if (array[i][1] == val) {
      return i
    }
  }
}

function chartOptions(chart){
  return {
    library: {
      tooltips: {
        callbacks: {
          label: function(tooltipItem, data) {
            const challenge_round_name = chart.dataSource[indexOfArray(tooltipItem.yLabel, chart.dataSource)][2]

            if (challenge_round_name == '') {
              return tooltipItem.yLabel
            } else {
              return tooltipItem.yLabel + "\nchallenge round name:" + challenge_round_name;
            }
          }
        }
      }
    }
  };
}
