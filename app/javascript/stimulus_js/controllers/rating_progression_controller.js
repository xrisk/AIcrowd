import { Controller } from "stimulus";

export default class extends Controller {
  connect() {
    let chart           = Chartkick.charts["line-chart"];
    const newOptions    = chartOptions(chart);
    const mergedOptions = jQuery.extend(chart.options, newOptions);

    chart.setOptions(mergedOptions);

    let pointarray = new Array(chart.chart.data.datasets[0].data.length).fill(0)
    let data_array = chart.chart.data.labels
    for (let j in data_array) {
      let challenge_round_name = '';
      let received_index = indexOfArray(data_array[j], chart.dataSource)
      if(chart.dataSource[received_index]){
         challenge_round_name = chart.dataSource[received_index][2]
      }
      if (challenge_round_name != '' && (new Date(data_array[j]).getTime()/1000!== new Date(data_array[j+1]).getTime()/1000)) {
        pointarray[j] = 4
      }
    }

    chart.chart.data.datasets[0].pointRadius = pointarray
    chart.chart.update()
  }
}

function indexOfArray(val, array) {
  for (let i = 0; i < array.length; i++) {
    let array_value = new Date(array[i][0])
    let date_value = new Date(val)
    if (Math.floor(array_value.getTime()/1000) === Math.floor(date_value.getTime()/1000)) {
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
            const challenge_round_name = chart.dataSource[indexOfArray(tooltipItem.xLabel, chart.dataSource)][2]

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
