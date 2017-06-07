// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

// Global variables
var days = 0;
var parent_metric = null;
var global_project_id = null;

var update_date_label = function (days_from_now) {
    var today = new Date();
    today.setDate(today.getDate()-days_from_now);
    $("#date-label").html(today.getFullYear()+'-'+(today.getMonth()+1)+'-'+today.getDate());
};

var outdate_all_metrics = function () {
    d3.selectAll('.chart_place').selectAll('*').remove();
};

var update_parent_metric = function () {
    if (parent_metric) {
        $.ajax({url: "/projects/" + global_project_id.toString() + "/metrics/" + parent_metric.metric_name + '?days_from_now=' + days,
            success: function(metric) {
                parent_metric['metric_name'] = metric.metric_name;
                parent_metric['id'] = metric.id;
                $.ajax({
                    url: "/metric_samples/" + parent_metric.id + "/comments",
                    success: function (comments) {
                        d3.selectAll('.comments').remove();
                        d3.select('#comment_column').selectAll('.comments')
                            .data(comments).enter()
                            .append('div')
                            .style('top', function (d) {
                                return JSON.parse(d.params).offset_top + 'px';
                            })
                            .attr('class', 'comments well')
                            .append('p')
                            .attr('class', 'comment-contents')
                            .html(function (d) {
                                return d.content;
                            });
                    },
                    error: function (a, b, c) {
                        if (a.status != 404) {
                            console.log(a);
                            console.log(b);
                            console.log(c);
                        } else {
                        }
                    }
                })
            },
            error: function(a, b, c) {
                if (a.status !== 404) {
                    console.log(a);
                    console.log(b);
                    console.log(c);
                } else {
                    //TODO: Add some place holder for data not found
                }
            }
        });
    }
};

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
    update_date_label(days);
    update_links();
    render_charts();
    update_parent_metric();
};

var ready = function () {
    outdate_all_metrics();
    render_charts();
    $("#date-slider").slider({
        value: 100,
        min: -$("#date-slider").attr("num_days_from_min"),
        max: 0,
        step: 1,
        slide: function (event, ui) {
            var days_from_now = -1 * ui.value;
            request_for_metrics(days_from_now);
        }
    });

    $(".date-nav").unbind().click(function (event) {
        var date_slider = $("#date-slider");
        var days_from_now = -1 * date_slider.slider("value");
        days_from_now += this.id === "day-before" ? 1 : -1;
        if (days_from_now < 0) {
            days_from_now = 0;
            return;
        }
        request_for_metrics(days_from_now);
        date_slider.slider("value", -1 * days_from_now);
    });
    update_date_label(days);
    $("#date-slider").slider("value", -1 * days);
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
                },
                error: function(a, b, c) {
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
                },
                error: function(a, b, c) {
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
                },
                error: function(a, b, c) {
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
    };
    $(".chart_place").each(function () {
        get_charts_json(this.id);
    });
};

// $(document).ready(ready);
// $(window).on("load", ready);
$(document).on('turbolinks:load', ready);