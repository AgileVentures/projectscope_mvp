// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var update_metrics = function (data) {
    $.each(data, function (index, val) {
        $.each(val, function (index, val) {
            var metric_content = $("#project_" + val.project_id + "_" + val.metric_name + "_metric")
            metric_content.removeClass('outdated-metric')
            metric_content.find(".metric_score").html(val.score)
            metric_content.find(".metric_image").html(val.image)
        });
    });
};

var update_date_label = function (new_date) {
    $("#date-label").html(new_date.split("T")[0]);
};

var outdate_all_metrics = function () {
    $(".metric-content").addClass('outdated-metric')
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
// Global variable for days
var days;
var request_for_metrics = function (days_from_now) {
    days = days_from_now;
    $.ajax({
        url: 'projects/metrics_on_date',
        type: 'POST',
        dataType: 'json',
        data: {days_from_now: days_from_now}
    })
        .done(function (data) {
            outdate_all_metrics()
            update_metrics(data["data"]);
            update_date_label(data["date"]);
            $(".ui-slider").slider("enable");
            update_slider_indicator(true);
        })
        .fail(function () {
            outdate_all_metrics()
            $(".ui-slider").slider("enable");
            update_slider_indicator(false);
        })
};

var ready = function () {
    render_charts();
    $("#date-slider").slider({
        value: 100,
        min: -$("#date-slider").attr("num_days_from_min"),
        max: 0,
        step: 1,
        slide: function (event, ui) {
            var days_from_now = -1 * ui.value
            request_for_metrics(days_from_now)
            update_slider_indicator();
            $(".ui-slider").slider("disable");
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
        update_slider_indicator();
        date_slider.slider("value", -1 * days_from_now);
    });
    $(".expand_button").click(function (event) {
        var $targetRow = $("[id = 'expanded_row-project:{0}']".format($(this).attr('pid')))
        debugger
        if (toggle($targetRow)) {
            containerID = $targetRow.find('.expanded_container').attr('id');
            $.getJSON('https://www.highcharts.com/samples/data/jsonp.php?filename=usdeur.json&callback=?', function (data) {
                createTimeSeriesGraph(containerID, data);
            });
        }
        //createTimeSeriesGraph($targetRow.select('expanded_container'), );
    })
};

var render_charts = function () {
    var get_charts_json = function (id) {
        // split
        var splited = id.split("-");
        var project_id = splited[1];
        var metric = splited[3];

        // $.getJSON('https://www.highcharts.com/samples/data/jsonp.php?filename=usdeur.json&callback=?', function (data) {
        //     createTimeSeriesGraph(id, data);
        // });
        $.ajax({url: "projects/" + project_id + "/metrics/" + metric,

          // result is the json string from the gem.
          // TODO: parse to javascript
          // 'chartType'
          // 'titleText'
          // 'subTitleText'
          // 'xAxisTitleText'
          // "xAxisUnit"
          // 'yAxisTitleText'
          // 'yAxisUnit'
          // 'data'
        	success: function(result) {
        		//Highcharts.chart(id, result);

            drawHighCharts(id, result);
        	},
          error: function(a, b, c){
            debugger
          }
          }

        );
    };
    $(".chart_place").each(function () {
        get_charts_json(this.id);
    });
};

// $(document).ready(ready);
$(document).on('turbolinks:load', ready);
// var metric_content = $("#project_" + val.project_id + "_" + val.metric_name + "_metric")
// metric_content.removeClass('outdated-metric')
// metric_content.find(".metric_score").html(val.score)
// metric_content.find(".metric_image").html(val.image)
var MetricPopup = {
    setup: function () {
        // add hidden 'div' to end of page to display popup:
        var popupDiv = $('<div id="metricInfo"><a id="closeLink" href="#" style="position: static">close</a><div class = "metric_score"></div><div class = "metric_image"></div></div>');
        popupDiv.hide().appendTo($('body'));
        $('.expand_link').each(function () {
            var expand = $(this);
            expand.on('click', MetricPopup.getMetricInfo);
        })
    }

    , getMetricInfo: function () {
        // debugger
        $.ajax({
            type: 'POST',
            url: 'projects/metrics_on_date',
            data: {
                id: $(this).attr('proj_id'),
                metric: $(this).attr('metric'),
                days_from_now: days
            },
            timeout: 5000,
            success: MetricPopup.showMetricInfo,
            error: function (xhrObj, textStatus, exception) {
                alert('Error!');
            }
            // 'success' and 'error' functions will be passed 3 args
        });
        return (false);
    }

    , showMetricInfo: function (data, requestStatus, xhrObject) {
        // center a floater 1/2 as wide and 1/4 as tall as screen
        var oneFourth = Math.ceil($(window).width() / 4);
        // debugger;
        $('#metricInfo').find(".metric_score").html(data['score']);
        $('#metricInfo').find(".metric_image").html(data['image']);
        $('#metricInfo').css({'left': oneFourth, 'width': 2 * oneFourth, 'top': 300, 'position': 'fixed'}).show();


        // debugger;
        // make the Close link in the hidden element work
        $('#closeLink').click(MetricPopup.hideMetricInfo);
        // debugger;
        return (false);  // prevent default link action
    }

    , hideMetricInfo: function () {
        $('#metricInfo').hide();
        return (false);
    }
};
$(MetricPopup.setup);
