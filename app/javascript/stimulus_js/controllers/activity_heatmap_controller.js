import { Controller } from "stimulus";
import * as Plottable from 'plottable';

export default class extends Controller {
  connect() {
    const calendarData = JSON.parse(this.data.get('data'));

    this.drawCalendar(calendarData);
  }

  drawCalendar(calendarData) {
    const elementId  = this.data.get('element-id');
    const data       = calendarData.map(activity => { return { date: new Date(activity['date'].split('-')), val: activity['val'] } });
    const startYear  = calendarData[0]['date'].split('-')[0];
    const daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    const xScale     = new Plottable.Scales.Category();
    const yScale     = new Plottable.Scales.Category();

    yScale.domain(daysOfWeek);

    const colorScale = new Plottable.Scales.InterpolatedColor();

    colorScale.domain([0, 100]);
    colorScale.range(["#FCD8D6", "#FAC2BF", "#F8ACA8", "#F59592", "#F37F7B", "#F16964", "#EF534D"])
    colorScale.scale = activityHeatmapScale

    const plot = new Plottable.Plots.Rectangle()
      .addDataset(new Plottable.Dataset(data))
      .x(function(d) {
        const year = d.date.getFullYear();
        const week = getWeekOfTheYear(d.date);

        // Move first week of year back to remove the gap
        if (year > startYear && week === 0) {
          return [startYear, 52]
        } else {
          return [d.date.getFullYear(), getWeekOfTheYear(d.date)]
        }
      }, xScale)
      .y(function(d) { return daysOfWeek[d.date.getDay()] }, yScale)
      .attr("fill", function(d) { return d.val; }, colorScale)
      .attr("stroke", "#fff")
      .attr("stroke-width", 4);

    const table = new Plottable.Components.Table([
      [null, plot],
      [null,  null]
    ]);

    table.renderTo(`#${elementId}`);

    // Initializing tooltip anchor
    const tooltipAnchorSelection = plot.foreground().append("circle").attr({
      r: 3,
      opacity: 0
    });

    const tooltipAnchor = $(tooltipAnchorSelection.node());
    tooltipAnchor.tooltip({
      animation: false,
      container: "body",
      placement: "auto",
      title: "text",
      trigger: "manual"
    });

    // Setup Interaction.Pointer
    const pointer = new Plottable.Interactions.Pointer();
    pointer.onPointerMove(function(p) {
      const closest = plot.entityNearest(p);

      if (closest) {
        tooltipAnchorSelection.attr({
          cx: closest.position.x,
          cy: closest.position.y,
          "data-original-title": `${closest.datum.date.toISOString().substring(0, 10)}: ${closest.datum.val}`
        });
        tooltipAnchor.tooltip("show");
      }
    });

    pointer.onPointerExit(function() {
      tooltipAnchor.tooltip("hide");
    });

    pointer.attachTo(plot);
  }
}

// Gets the date of the top left square in the calendar, i.e. the first Sunday on / before Jan 1
function getFirstDisplayableSunday(date) {
  return new Date(
    date.getFullYear(),
    0,
    1 - new Date(date.getFullYear(), 0, 1).getDay()
  );
}

function getWeekOfTheYear(date) {
  const firstSunday = getFirstDisplayableSunday(date);
  const diff = date - firstSunday;
  const oneDay = 1000 * 60 * 60 * 24;
  return Math.floor(Math.ceil(diff / oneDay) / 7);
}

function monthFormatter() {
  const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  return function(yearAndWeek) {
    const year = yearAndWeek[0];
    const week = yearAndWeek[1];
    const startOfWeek = new Date(year, 0, (week + 1) * 7 - new Date(year, 0, 1).getDay());
    if (startOfWeek.getDate() > 7) {
      return "";
    }
    return months[startOfWeek.getMonth()];
  }
}

function activityHeatmapScale(value) {
  if (value === 0) {
    return '#F5F5F5';
  } else {
    return this._d3Scale(value);
  }
}
