/**
 * Created by Joe on 4/26/17.
 */

function story_transition(containerID, plotdata) {
    //create brush function redraw scatterplot with selection
    if (!d3.select("#" + containerID).select('svg').empty()) {
        return;
    }
    function brushed() {
        var selection = d3.event.selection;
        x.domain(selection.map(x2.invert, x2));
        focus.selectAll(".dot")
            .attr("cx", function(d) { return x(d.occurred_at); })
            .attr("cy", function(d) { return y(d.story_id); })
            .on("mouseover", function(d) {
                div.transition()
                    .duration(200)
                    .style("opacity", .9);
                div.html(d.story_id + "<br/>" + d.state)
                    .style("left", (d3.event.pageX-320) + "px")
                    .style("top", (d3.event.pageY-80) + "px");
            })
            .on("mouseout", function(d) {
                div.transition()
                    .duration(500)
                    .style("opacity", 0);
            });
        focus.select(".axis--x").call(xAxis);
        focus.selectAll('.valueline')
            .attr("d", valueline_1)
            .style("stroke", function(d) { return colors[d[0].state]; })
            .on("mouseover", function(d) {
                div.transition()
                    .duration(200)
                    .style("opacity", .9);
                div.html(d[0].state + " to " + d[1].state)
                    .style("left", (d3.event.pageX-320) + "px")
                    .style("top", (d3.event.pageY-80) + "px");
            })
            .on("mouseout", function(d) {
                div.transition()
                    .duration(500)
                    .style("opacity", 0);
            });
    }
    var colors = {'unscheduled': '#7cb5ec', 'unstarted': '#90ed7d', 'started': '#f7a35c', 'finished': '#8085e9',
        'delivered': '#f15c80', 'accepted': '#e4d354', 'default': '#2b908f'};

    var margin = {top: 10, right: 10, bottom: 110, left: 50},
        margin2 = {top: 430, right: 10, bottom: 30, left: 40},
        width = 800 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom,
        height2 = 500 - margin2.top - margin2.bottom;

    var parseDate = d3.timeParse("%Y-%m-%dT%H:%M:%SZ");

    var x = d3.scaleTime().range([0, width]),
        x2 = d3.scaleTime().range([0, width], 1),
        y = d3.scalePoint().range([height, 0]).padding([0.2]),
        y2 = d3.scalePoint().range([height2, 0]).padding([0.2]);

    var xAxis = d3.axisBottom(x),
        xAxis2 = d3.axisBottom(x2),
        yAxis = d3.axisLeft(y);

    var brush = d3.brushX()
        .extent([[0, 0], [width, height2]])
        .on("brush", brushed);
    var container = d3.select("#" + containerID);
    container.style('width', width + margin.left + margin.right + "px")
        .style("height", height + margin.top + margin.bottom + "px");

    var div = d3.select("#" + containerID).append("div")
        .attr("class", "tooltip")
        .style("opacity", 0);

    var svg = container.append("svg")
        .attr("id", "fig-" + containerID)
        .attr("width", width + margin.left + margin.right)
        .attr("height", height + margin.top + margin.bottom);

    svg.append("defs").append("clipPath")
        .attr("id", "clip")
        .append("rect")
        .attr("width", width)
        .attr("height", height);

    var focus = svg.append("g")
        .attr("class", "focus")
        .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

    var context = svg.append("g")
        .attr("class", "context")
        .attr("transform", "translate(" + margin2.left + "," + margin2.top + ")");

    var valueline_1 = d3.line()
        .x(function(d) { return x(d.occurred_at); })
        .y(function(d) { return y(d.story_id); });

    var data = plotdata.data;
    var stories = data.stories;
    var transitions = data.transitions;
    var story_transitions = {};
    transitions.forEach(function (d) {
        d.occurred_at = parseDate(d.occurred_at);
        if(story_transitions[d.story_id] !== undefined) {
            story_transitions[d.story_id].push(d);
        } else {
            story_transitions[d.story_id] = [d];
        }
    });
    story_transitions = to_array(story_transitions);
    x.domain(d3.extent(transitions, function(d) { return d.occurred_at; })).nice();
    y.domain(stories.map(function(d) {return d.id}));
    x2.domain(x.domain()).nice();
    y2.domain(y.domain());

    // append scatter plot to main chart area
    var dots = focus.append("g");
    dots.attr("clip-path", "url(#clip)");
    dots.selectAll("dot")
        .data(transitions)
        .enter().append("circle")
        .attr('class', 'dot')
        .attr("r",5)
        .style("opacity", .5)
        .attr("cx", function(d) { return x(d.occurred_at); })
        .attr("cy", function(d) { return y(d.story_id); });

    focus.selectAll(".story")
        .data(story_transitions)
        .enter().append("g")
        .attr("class", 'story')
        .append("path")
        .attr("class", "valueline")
        .attr("d", valueline_1)
        .attr("clip-path", "url(#clip)")
        .style("stroke", function(d) { return colors[d[0].state]; });

    focus.append("g")
        .attr("class", "axis axis--x")
        .attr("transform", "translate(0," + height + ")")
        .call(xAxis);

    focus.append("g")
        .attr("class", "axis axis--y")
        .call(yAxis);

    focus.append("text")
        .attr("transform", "rotate(-90)")
        .attr("y", 0 - margin.left)
        .attr("x",0 - (height / 2))
        .attr("dy", "1em")
        .style("text-anchor", "middle")
        .text("Price");

    svg.append("text")
        .attr("transform",
            "translate(" + ((width + margin.right + margin.left)/2) + " ," +
            (height + margin.top + margin.bottom) + ")")
        .style("text-anchor", "middle")
        .text("Date");

    // append scatter plot to brush chart area
    var dots = context.append("g");
    dots.attr("clip-path", "url(#clip)");
    dots.selectAll("dot")
        .data(transitions)
        .enter().append("circle")
        .attr('class', 'dotContext')
        .attr("r",3)
        .style("opacity", .5)
        .attr("cx", function(d) { return x2(d.occurred_at); })
        .attr("cy", function(d) { return y2(d.story_id); });

    context.append("g")
        .attr("class", "axis axis--x")
        .attr("transform", "translate(0," + height2 + ")")
        .call(xAxis2);

    context.append("g")
        .attr("class", "brush")
        .call(brush)
        .call(brush.move, x.range());
}