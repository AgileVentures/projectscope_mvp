/**
 * Created by stevenwuyinze on 3/22/17.
 */


function parseChartParams(JSONStr) {
    var paramMap = JSONStr;
    if (JSONStr['chartType'] == "spline"){
      var chartParams = {
          chart: {
              type: paramMap['chartType'],
              spacingBottom: 0,
              spacingTop: 0,
              spacingLeft: 0,
              spacingRight: 0,
              height: 250
          },
          title: {
              text: paramMap['titleText']
          },
          subtitle: {
              text: paramMap['subtitleText']
          },
          xAxis: {
              title: {
                  margin: 0,
                  text: paramMap['xAxisTitleText']
              },
              maxPadding: 0.01,
              // showLastLabel: true
          },
          yAxis: {
              title: {
                  margin: 0,
                  text: paramMap['yAxisTitleText']
              },
              maxPadding: 0.01
          },
          series: [{
              data: paramMap['data']
          }]
      };
    }else if(JSONStr['chartType'] == "pie") {
        var chartParams = {
            chart: {
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                type: paramMap["chartType"]
            },
            title: {
                text: paramMap["titleText"]
            },
            tooltip: {
                pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: false,
                        format: '<b>{point.name}</b>: {point.percentage:.1f} %',
                        style: {
                            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                        }
                    }
                }
            },
            series: paramMap['data']
        };
    }else if(JSONStr['chartType'] == 'bar') {
        var chartParams = {
            chart: {
                type: 'bar'
            },
            title: {
                text: paramMap['titleText']
            },
            series: paramMap['data']
        }
    }else{
        var chartParams = {
            chart: {
                type: paramMap['chartType']
            },
            title: {
                text: paramMap['titleText']
            },
            series: paramMap['data']

        }
    }

    return chartParams
}

function draw_d3(containerID, plotdata) {
    //create brush function redraw scatterplot with selection
    function brushed() {
        var selection = d3.event.selection;
        x.domain(selection.map(x2.invert, x2));
        focus.selectAll(".dot")
            .attr("cx", function(d) { return x(d.occurred_at); })
            .attr("cy", function(d) { return y(d.story_id); });
        focus.select(".axis--x").call(xAxis);
    }

    var margin = {top: 20, right: 20, bottom: 110, left: 50},
        margin2 = {top: 430, right: 20, bottom: 30, left: 40},
        width = 960 - margin.left - margin.right,
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

    var svg = container.append("svg")
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

    var data = plotdata.data;
    console.log(data);
    var stories = data.stories;
    var transitions = data.transitions;
    transitions.forEach(function (d) {
        d.occurred_at = parseDate(d.occurred_at);
    });
    x.domain(d3.extent(transitions, function(d) { return d.occurred_at; })).nice();
    y.domain(stories.map(function(d) {return d.id}));
    x2.domain(x.domain()).nice();
    y2.domain(y.domain());

    console.log(x.domain());
    console.log(y.domain());

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

function drawHighCharts(containerID, JSONStr) {
    if(JSONStr['chartType'] !== 'd3') {
        Highcharts.chart(containerID, parseChartParams(JSONStr));
    } else if (JSONStr['chartType'] === 'd3') {
        draw_d3(containerID, JSONStr);
    }
    else {
        console.log(JSONStr);
    }
}
