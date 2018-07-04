/**
 * Created by stevenwuyinze on 3/22/17.
 */

function parseChartParams(JSONStr) {
    var paramMap = JSONStr;
    var chartParams = {
        chart: {
            type: paramMap['chartType']
        },
        title: {
            text: paramMap['titleText']
        },
        series: paramMap['data']
    };
    return chartParams;
}

function drawMetricCharts(containerID, metric_sample) {
    if (metric_sample == null) {
        return;
    }
    var JSONStr = JSON.parse(metric_sample.image);
    $('#'+containerID).attr('metric_sample', metric_sample.id);
    if(JSONStr['chartType'] === 'd3') {
        story_transition(containerID, JSONStr);
    } else if (JSONStr['chartType'] === 'point_estimation') {
        point_estimation(containerID, metric_sample);
        // var new_data = {data: concat_arrays(JSONStr.data.data, JSONStr.data.series)};
        // stacked_bar(containerID, new_data, JSONStr.data.series);
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
        github_files(containerID, JSONStr);
        // stacked_bar(containerID, JSONStr, ['model', 'view', 'controller', 'test', 'db', 'other']);
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
    } else if (JSONStr['chartType'] === 'tracker_velocity_v2') {
        velocity(containerID, metric_sample);
    } else if (JSONStr['chartType'] === 'point_distribution_v2') {
        bar_chart(containerID, JSONStr.data);
    } else if (JSONStr['chartType'] === 'story_overall_v2') {
        story_overall(containerID, JSONStr.data);
    } else if (JSONStr['chartType'] === 'smart_story') {
        smart_story(containerID, metric_sample);
    } else if (JSONStr['chartType'] === 'commit_message') {
        commit_message(containerID, JSONStr.data);
    } else if (JSONStr['chartType'] === 'code_climate_v2') {
        if (JSONStr['data']['gpa'] > 0) {
            index_score(containerID, metric_sample.score.toPrecision(3), 0.0, 4.0);
        } else {
            code_climate_badge(containerID, JSONStr);
        }
    } else if (JSONStr['chartType'] === 'test_coverage_v2') {
        if (JSONStr['data']['test_badge'].length > 0) {
            test_coverage_badge(containerID, JSONStr);
        } else {
            index_score(containerID, metric_sample.score.toPrecision(3), 0.0, 100.0);
        }
    }
    else {
        error_message(containerID, metric_sample);
    }
}

function drawSeriesCharts(containerID, metric_samples) {
    var scores = metric_samples.map(function (x) {
        return x.score;
    });
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

function error_message(containerID, metric_sample) {
    d3.select('#' + containerID)
        .html('metric not supported: ' + JSON.parse(metric_sample.image)['chartType']);
    console.log('metric not supported:');
    console.log(metric_sample);
}