/**
 * Created by Joe on 6/1/17.
 */

function score_series(containerID, metric_samples) {
    var parseTime = d3.utcParse("%Y-%m-%dT%H:%M");
    var plotdata = metric_samples.map(function (d) {
        return { date: parseTime(d.datetime), score: parseFloat(d.score) };
    });
    var container = d3.select('#' + containerID);
    var margin = {top: 1, right: 2, bottom: 1, left: 2};
    var height = d3.max([parseFloat(container.style('height').slice(0, -2)), 30]);
    var width = 150;
    var svg = container.append('svg')
        .style('height', height + margin.top + margin.bottom + 'px')
        .style('width', width + margin.left + margin.right + 'px');
    var line = d3.line()
        .x(function(d) { return x(d.date); })
        .y(function(d) { return y(d.score); });
    var g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    var x = d3.scaleTime()
        .rangeRound([0, width])
        .domain(d3.extent(plotdata, function (d) {
            return d.date;
        }));

    var y = d3.scaleLinear()
        .rangeRound([height, 0])
        .domain(d3.extent(plotdata, function (d) {
            return d.score;
        }));

    g.append("path")
        .datum(plotdata)
        .attr("fill", "none")
        .attr("stroke", "steelblue")
        .attr("stroke-linejoin", "round")
        .attr("stroke-linecap", "round")
        .attr("stroke-width", 1.5)
        .attr("d", line);
}
