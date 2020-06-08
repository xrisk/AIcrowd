function indexOfArray(val, array) {
    for(i = 0; i < array.length; i++) {
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
                        challenge_round_name = chart.dataSource[indexOfArray(tooltipItem.yLabel, chart.dataSource)][2]
                        if(challenge_round_name == '') {
                            return tooltipItem.yLabel
                        }
                        return tooltipItem.yLabel + "\nchallenge round name:" + challenge_round_name;

                    }
                }
            }
        }
    };
}
function addPointRadius(j, data_array, chart) {
    challenge_round_name = chart.dataSource[indexOfArray(data_array[j], chart.dataSource)][2]
    if(challenge_round_name != '' && (data_array[j]!== data_array[j+1])) {
        pointarray[j] = 4
    }
}
Paloma.controller('Participants', {
  edit: function(){
    $(document).on('turbolinks:load', function() {
      $('.url').blur(function() {
        var self = this;
        $(self).val($(self).val().toLowerCase());
        var url = $(self).val();
        if (url && (url.substr(0,7) !== 'http://') && (url.substr(0,8) !== 'https://')){
          $(self).val('https://' + url);
        }
      });
    });
  },
  show: function () {
      var chart = Chartkick.charts["line-chart"];
      var newOptions = chartOptions(chart);
      var mergedOptions = jQuery.extend(chart.options,newOptions);
      chart.setOptions(mergedOptions);
      pointarray = new Array(chart.chart.data.datasets[0].data.length).fill(0)
      data_array = chart.chart.data.datasets[0].data
      for(j in data_array) {
          addPointRadius(j, data_array, chart)
      }
      chart.chart.data.datasets[0].pointRadius = pointarray
      chart.chart.update()
  }
});
