/**
 * Created by stevenwuyinze on 3/22/17.
 */

function parseChartParams(JSONStr) {
    var paramMap = JSONStr;
    if (JSONStr['chartType'] == "spline"){
      var chartParams = {
          chart: {
              type: paramMap['chartType']
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

    }else if(JSONStr['chartType'] == "pie"){
      var chartParams = {
          chart: {
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

function drawMetricCharts(containerID, metric_sample) {
    var JSONStr = JSON.parse(metric_sample.image);
    $('#'+containerID).attr('metric_sample', metric_sample.id);
    if(JSONStr['chartType'] === 'd3') {
        story_transition(containerID, JSONStr);
    } else if (JSONStr['chartType'] === 'point_estimation') {
        var new_data = {data: concat_arrays(JSONStr.data.data, JSONStr.data.series)};
        stacked_bar(containerID, new_data, JSONStr.data.series);
    } else if (JSONStr['chartType'] === 'github_pr') {
        github_pr(containerID, JSONStr);
    } else if (JSONStr['chartType'] === 'gauge') {
        gauge(containerID, JSONStr);
    } else if (JSONStr['chartType'] === 'pivotal_tracker') {
        pivotal_tracker(containerID, JSONStr);
    } else if (JSONStr['chartType'] === 'code_climate') {
        index_score(containerID, JSONStr.data.GPA, 0.0, 4.0);
    } else if (JSONStr['chartType'] === 'test_coverage') {
        index_score(containerID, JSONStr.data.coverage, 0.0, 100.0)
    } else if (JSONStr['chartType'] === 'pull_requests') {
        pull_requests(containerID, JSONStr.data);
    } else if (JSONStr['chartType'] === 'travis_ci') {
        travis_ci(containerID, JSONStr.data);
    } else if (JSONStr['chartType'] === 'github_files') {
        stacked_bar(containerID, JSONStr, ['model', 'view', 'controller', 'test', 'db', 'other']);
    } else if (JSONStr['chartType'] === 'github_flow') {
        bar_chart(containerID, JSONStr.data);
    } else if (JSONStr['chartType'] === 'tracker_velocity') {
        stacked_bar(containerID, JSONStr, ['unscheduled', 'unstarted', 'started', 'finished', 'delivered', 'accepted', 'rejected'])
    } else if (JSONStr['chartType'] === 'point_distribution') {
        var new_data = {data: concat_arrays(JSONStr.data.data, JSONStr.data.series)};
        stacked_bar(containerID, new_data, JSONStr.data.series);
    } else if (JSONStr['chartType'] === 'slack') {
        var new_data = {data: concat_arrays(JSONStr.data.data, JSONStr.data.series)};
        stacked_bar(containerID, new_data, JSONStr.data.series);
    }
    else {
        Highcharts.chart(containerID, parseChartParams(JSONStr));
    }
}

function drawSeriesCharts(containerID, metric_samples) {
    var JSONStr = JSON.parse(metric_samples[0].image);
    score_series(containerID, metric_samples);
}

function drawDataNotFound(containerID) {
    d3.select('#' + containerID)
        .append('div')
        .style('width', '100%')
        .html('Not Found');
}

function concat_arrays(data, series) {
    if (series.length !== data.length) {
        return data
    } else {
        var new_data = {};
        data.forEach(function (d, i) {
            new_data[series[i]] = d;
        });
        return new_data;
    }
}

function to_array(input_dict) {
    var prev = undefined;
    var result = [];
    for (var key in input_dict) {
        input_dict[key].sort(function(a, b) {
            if (a.occurred_at < b.occurred_at) return -1;
            if (a.occurred_at > b.occurred_at) return 1;
            return 0;
        }).forEach(function(d, i) {
            if (prev !== undefined) {
                result.push([prev, d]);
            }
            prev = d;
        });
        prev = undefined;
    }
    return result;
}
