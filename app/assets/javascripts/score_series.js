/**
 * Created by Joe on 6/1/17.
 */

function score_series(containerID, metric_samples) {
    var color = function (diff) {
        if (diff > 0.01) {
            return '#90ed7d';
        } else {
            if (diff < 0.01) {
                return '#f45b5b';
            } else {
                return '#f7a35c';
            }
        }
    };
    var symbol = function (diff) {
        if (diff > 0) {
            return '&uarr;';
        } else {
            if (diff < 0) {
                return '&darr;';
            } else {
                return '&rarr;';
            }
        }
    };
    var num_samples = metric_samples.length;
    var last_metric = metric_samples[num_samples-1];
    if(num_samples > 1) {
        var previous_metric = metric_samples[num_samples-2];
        var diff = last_metric.score - previous_metric.score;
        d3.select('#' + containerID)
            .style('width', '100%')
            .append('font')
            .attr('face', 'Verdana')
            .attr('color', color(diff))
            .html('Score: ' + last_metric.score + ' ' + symbol(diff));
    } else {
        d3.select('#' + containerID)
            .style('width', '100%')
            .append('font')
            .attr('face', 'Verdana')
            .html('Score: ' + last_metric.score);
    }
    // var parseTime = d3.utcParse("%Y-%m-%dT%H:%M");
    // var plotdata = metric_samples.map(function (d) {
    //     return { date: parseTime(d.datetime), score: parseFloat(d.score) };
    // });
    // var container = d3.select('#' + containerID);
    // var margin = {top: 1, right: 2, bottom: 1, left: 2};
    // var height = d3.max([parseFloat(container.style('height').slice(0, -2)), 30]);
    // var width = 150;
    // var svg = container.append('svg')
    //     .style('height', height + margin.top + margin.bottom + 'px')
    //     .style('width', width + margin.left + margin.right + 'px');
    // var line = d3.line()
    //     .x(function(d) { return x(d.date); })
    //     .y(function(d) { return y(d.score); });
    // var g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    // var x = d3.scaleTime()
    //     .rangeRound([0, width])
    //     .domain(d3.extent(plotdata, function (d) {
    //         return d.date;
    //     }));
    //
    // var y = d3.scaleLinear()
    //     .rangeRound([height, 0])
    //     .domain(d3.extent(plotdata, function (d) {
    //         return d.score;
    //     }));
    //
    // g.append("path")
    //     .datum(plotdata)
    //     .attr("fill", "none")
    //     .attr("stroke", "steelblue")
    //     .attr("stroke-linejoin", "round")
    //     .attr("stroke-linecap", "round")
    //     .attr("stroke-width", 1.5)
    //     .attr("d", line);
}
