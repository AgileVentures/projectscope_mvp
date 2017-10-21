// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Global variables
var days = 0;
var current_progress = 0;
var total_number = 0;
// var parent_metric = null;
var global_project_id = null;
var keep_log = false;

var update_date_label = function (days_from_now) {
    var today = new Date();
    today.setDate(today.getDate()-days_from_now);
    $("#date-label").html(today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate());
    d3.select('#day-before').classed('disabled', false);
    d3.select('#day-after').classed('disabled', false);
};

var outdate_all_metrics = function () {
    d3.selectAll('.chart_place').selectAll('*').remove();
    d3.select('#day-before').classed('disabled', true);
    d3.select('#day-after').classed('disabled', true);
};

// var update_parent_metric = function () {
//     if (parent_metric) {
//         $.ajax({url: "/projects/" + global_project_id.toString() + "/metrics/" + parent_metric.metric_name + '?days_from_now=' + days,
//             success: function(metric) {
//                 parent_metric['metric_name'] = metric.metric_name;
//                 parent_metric['id'] = metric.id;
//                 $.ajax({
//                     url: "/metric_samples/" + parent_metric.id + "/comments",
//                     success: function (comments) {
//                         d3.selectAll('.comments').remove();
//                         d3.select('#comment_column').selectAll('.comments')
//                             .data(comments).enter()
//                             .append('div')
//                             .style('top', function (d) {
//                                 return JSON.parse(d.params).offset_top + 'px';
//                             })
//                             .attr('class', 'comments well')
//                             .append('p')
//                             .attr('class', 'comment-contents')
//                             .html(function (d) {
//                                 return d.content;
//                             });
//                     },
//                     error: function (a, b, c) {
//                         if (a.status != 404) {
//                             console.log(a);
//                             console.log(b);
//                             console.log(c);
//                         } else {
//                         }
//                     }
//                 })
//             },
//             error: function(a, b, c) {
//                 if (a.status !== 404) {
//                     console.log(a);
//                     console.log(b);
//                     console.log(c);
//                 } else {
//                     //TODO: Add some place holder for data not found
//                 }
//             }
//         });
//     }
// };

var update_slider_indicator = function (is_successful) {
    var indicator = $("#slider-progress-indicator");
    if (indicator.css("display") === "none" || indicator.hasClass('slider-error-msg')) {
        indicator.html("Loading...");
        indicator.removeClass('slider-error-msg');
        indicator.css("display", "block");
    } else {
        if (is_successful) {
            indicator.css("display", "none");
        } else {
            indicator.html("Error: Failed to load new data");
            indicator.addClass('slider-error-msg');
        }
    }
};

var update_links = function () {
    $('.detail-link').each(function (index, elem) {
        var new_href = elem.href.split('=');
        if (new_href.length > 1) {
            new_href = new_href[0] + '=' + days.toString();
        } else {
            new_href = new_href[0] + '?days_from_now=' + days.toString();
        }
        elem.href = new_href;
    })
};

var request_for_metrics = function (days_from_now) {
    days = days_from_now;
    //TODO: Add some transition state indicators.
    outdate_all_metrics();
    update_links();
    render_charts();
    // update_date_label(days);
    // update_parent_metric();
};

var ready = function () {
    outdate_all_metrics();
    render_charts();

    $(".date-nav").unbind().click(function (event) {
        outdate_all_metrics();
        days += this.id === "day-before" ? 1 : -1;
        if (days < 0) {
            days = 0;
            return;
        }
        request_for_metrics(days);
    });
    // update_date_label(days);
};

var render_charts = function () {
    var get_charts_json = function (id) {
        var splited = id.split("-");
        var project_id = splited[1];
        var chart_type = splited[2];
        var metric = splited[3];
        if (chart_type === 'metric') {
            $.ajax({url: "/projects/" + project_id + "/metrics/" + metric + '?days_from_now=' + days,
                success: function(result) {
                    drawMetricCharts(id, result);
                    check_progress();
                },
                error: function(a, b, c) {
                    check_progress();
                    if (a.status !== 404) {
                        console.log(a);
                        console.log(b);
                        console.log(c);
                    } else {
                        drawDataNotFound(id);
                    }
                }
            });
        } else if (chart_type === 'series') {
            $.ajax({url: "/projects/" + project_id + "/metrics/" + metric + '/series?days_from_now=' + days,
                success: function(result) {
                    drawSeriesCharts(id, result);
                    check_progress();
                },
                error: function(a, b, c) {
                    check_progress();
                    if (a.status !== 404) {
                        console.log(a);
                        console.log(b);
                        console.log(c);
                    } else {
                        drawDataNotFound(id);
                    }
                }
            });
        } else if (chart_type === 'ondate') {
            $.ajax({url: "/projects/" + project_id + "/metrics/" + metric + '?days_from_now=' + splited[4],
                success: function(result) {
                    drawMetricCharts(id, result);
                    check_progress();
                },
                error: function(a, b, c) {
                    check_progress();
                    if (a.status !== 404) {
                        console.log(a);
                        console.log(b);
                        console.log(c);
                    } else {
                        drawDataNotFound(id);
                    }
                }
            });
        }
        if (keep_log) {
            $('#' + id).on('mouseenter', function () {
                write_log('Mouse over: ' + id);
            });
        }
    };
    total_number = $(".chart_place").length;
    current_progress = 0;
    $(".chart_place").each(function () {
        get_charts_json(this.id);
    });
};

function read_comment(comment_id) {
    $.ajax({
        url: "/comments/" + comment_id + "",
        type: 'PUT',
        data: { comment: { status: 'read' } },
        dataType: "json",
        success: function (result) {
            d3.select('#comment_' + comment_id).remove();
        },
        error: function (a, b, c) {
            console.log(a);
            console.log(b);
            console.log(c);
        }
    });
}

function write_log(msg) {
    $.ajax({
        url: "/log",
        type: 'POST',
        data: { message: msg },
        dataType: "json",
        success: function (r) {
            return;
        },
        error: function (a, b, c) {
            console.log(a);
            console.log(b);
            console.log(c);
        }
    })
}

function check_progress() {
    current_progress += 1;
    if (current_progress === total_number) {
        update_date_label(days);
    }
}

// $(document).ready(ready);
// $(window).on("load", ready);
$(document).on('turbolinks:load', ready);