/**
 * Created by Joe on 4/29/17.
 */

function github_pr(containerID, plotdata) {
    var plot_data = plotdata.data.map(function (d) {
        return {
            x: d.comments.length-0.5+Math.random(),
            y: d.commits.length-0.5+Math.random(),
            num_comments: d.comments.length,
            num_commits: d.commits.length,
            title: d.title,
            state: d.state
        }
    });
    var closed_data = plot_data.filter(function (d) { return d.state === 'closed' });
    var open_data = plot_data.filter(function (d) { return d.state === 'open' });
    Highcharts.chart(containerID, {
        chart: {
            type: 'scatter',
            zoomType: 'xy'
        },
        title: {
            text: 'Pull Request comments and commits.'
        },
        xAxis: {
            title: {
                enabled: true,
                text: 'Number of comments'
            },
            startOnTick: true,
            endOnTick: true,
            allowDecimals: false
        },
        yAxis: {
            allowDecimals: false,
            title: {
                text: 'Number of commits'
            }
        },
        plotOptions: {
            scatter: {
                marker: {
                    radius: 5,
                    states: {
                        hover: {
                            enabled: true,
                            lineColor: 'rgb(100,100,100)'
                        }
                    }
                },
                states: {
                    hover: {
                        marker: {
                            enabled: false
                        }
                    }
                },
                tooltip: {
                    pointFormat: '{point.title}: {point.num_comments} comments, {point.num_commits} commits'
                }
            }
        },
        series: [{
            name: 'Closed',
            data: closed_data
        }, {
            name: 'Open',
            data: open_data
        }]
    });
}
