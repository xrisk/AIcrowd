import { Controller } from "stimulus"
import * as d3 from "d3";

export default class extends Controller {
  connect() {
    const calendarData = [
      {day: "2020-05-12", count: "171"},
      {day: "2020-06-17", count: "139"},
      {day: "2020-05-02", count: "556"}
    ];

    this.drawCalendar(calendarData);
  }

  drawCalendar(dateData){
    const weeksInMonth = function(month) {
      const m = d3.timeMonth.floor(month)
      return d3.timeWeeks(d3.timeWeek.floor(m), d3.timeMonth.offset(m,1)).length;
    }

    // const daysInLastMonth = function(month) {
    //   const m = d3.timeMonth.floor(month)
    // }

    const minDate = new Date(new Date().getFullYear(), 0, 1);
    const maxDate = new Date(new Date().getFullYear(), 11, 31);

    const cellMargin = 2;
    const cellSize = 14;

    const day = d3.timeFormat("%w");
    const week = d3.timeFormat("%U");
    const format = d3.timeFormat("%Y-%m-%d");
    const titleFormat = d3.utcFormat("%a, %d-%b");
    const monthName = d3.timeFormat("%B");
    const months = d3.timeMonth.range(d3.timeMonth.floor(minDate), maxDate);

    const svg = d3.select("#calendar").selectAll("svg")
      .data(months)
      .enter().append("svg")
      .attr("class", "month")
      .attr("height", ((cellSize * 7) + (cellMargin * 8) + 20) ) // the 20 is for the month labels
      .attr("style", "margin-right: 16px;")
      .attr("width", function(d) {
        var columns = weeksInMonth(d);
        return ((cellSize * columns) + (cellMargin * (columns + 1)));
      })
      .append("g")

    svg.append("text")
      .attr("class", "month-name")
      .attr("y", (cellSize * 7) + (cellMargin * 8) + 15 )
      .attr("x", function(d) {
        var columns = weeksInMonth(d);
        return (((cellSize * columns) + (cellMargin * (columns + 1))) / 2);
      })
      .attr("text-anchor", "middle")
      .text(function(d) { return monthName(d); })

    const rect = svg.selectAll("rect.day")
      .data(function(d, i) { return d3.timeDays(d, new Date(d.getFullYear(), d.getMonth()+1, 1)); })
      .enter().append("rect")
      .attr("class", "day")
      .attr("width", cellSize)
      .attr("height", cellSize)
      .attr("rx", 3).attr("ry", 3) // rounded corners
      .attr("fill", '#FFF7EB')
      .attr("y", function(d) { return (day(d) * cellSize) + (day(d) * cellMargin) + cellMargin; })
      .attr("x", function(d) { return ((week(d) - week(new Date(d.getFullYear(),d.getMonth(),1))) * cellSize) + ((week(d) - week(new Date(d.getFullYear(),d.getMonth(),1))) * cellMargin) + cellMargin ; })
      .on("mouseover", function(d) {
        d3.select(this).classed('hover', true);
      })
      .on("mouseout", function(d) {
        d3.select(this).classed('hover', false);
      })
      .datum(format);

    rect.append("title")
      .text(function(d) { return titleFormat(new Date(d)); });

    const lookup = d3.nest()
      .key(function(d) { return d.day; })
      .rollup(function(leaves) {
        return d3.sum(leaves, function(d){ return parseInt(d.count); });
      })
      .object(dateData);

    const scale = d3.scaleLinear()
      .domain(d3.extent(dateData, function(d) { return parseInt(d.count); }))
      .range([0.4,1]);

    rect.filter(function(d) { return d in lookup; })
      .style("fill", function(d) { return d3.interpolateOrRd(scale(lookup[d])); })
      .select("title")
      .text(function(d) { return titleFormat(new Date(d)) + ":  " + lookup[d]; });
  }
}
