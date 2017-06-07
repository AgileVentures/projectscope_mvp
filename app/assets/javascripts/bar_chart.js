/**
 * Created by Joe on 5/25/17.
 */

function bar_chart(containerID, data) {
    var container = d3.select('#' + containerID);
    if (!container.select('svg').empty()) {
        container.select('svg').remove();
    }
    var margin = {top: 1, right: 2, bottom: 1, left: 2};
    var height = d3.max([parseFloat(container.style('height').slice(0, -2)), 30]);
    var width = 150;
    // var width = d3.min([parseFloat(container.style('width').slice(0, -2)), 150]);
    var svg = container.append('svg')
        .style('height', height + margin.top + margin.bottom + 'px')
        .style('width', width + margin.left + margin.right + 'px');
    var tool_tip = d3.tip()
        .attr("class", "d3-tip")
        .offset([-8, 0])
        .html(function(d) { return d[1] + ": " + d[0]; });
    svg.call(tool_tip);
    data.data = data.data.map(function (d) {
        return parseFloat(d) > 0 ? parseFloat(d) : 0.1;
    });
    var data_with_label = data.data.map(function (d, i) {
        return [d, data.series[i]];
    });
    var x = d3.scaleBand()
            .rangeRound([0, width])
            .padding(0.1)
            .domain(data.series),
        y = d3.scaleLinear()
            .range([height, 0])
            .domain([0, d3.max(data.data) + 1]);

    var g = svg.append("g")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    g.selectAll(".bar")
        .data(data_with_label)
        .enter()
        .append("rect")
        .attr("class", "bar")
        .attr("x", function (d) {
            return x(d[1]);
        })
        .attr("y", function (d) {
            return y(d[0]);
        })
        .attr("width", x.bandwidth())
        .attr("height", function (d) {
            return height - y(d[0]);
        })
        .on('mouseover', tool_tip.show)
        .on('mouseout', tool_tip.hide);
}