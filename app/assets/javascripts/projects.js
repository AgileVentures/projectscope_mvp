// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var update_metrics = function(data) {
	$.each(data, function(index, val) {
		$.each(val, function(index, val) {
			var metric_content = $("#project_" + val.project_id + "_" + val.metric_name + "_metric")
			metric_content.removeClass('outdated-metric')
			metric_content.find(".metric_score").html(val.score)
			metric_content.find(".metric_image").html(val.image)
		});
	});
};

var update_date_label = function(new_date) {
	$("#date-label").html(new_date.split("T")[0]);
}

var outdate_all_metrics = function() {
	$(".metric-content").addClass('outdated-metric')
}

var update_slider_indicator = function(is_successful) {
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
}

var request_for_metrics = function(days_from_now) {
	$.ajax({
		url: 'projects/metrics_on_date',
		type: 'POST',
		dataType: 'json',
		data: { days_from_now:  days_from_now }
	})
	.done(function(data) {
		outdate_all_metrics()
		update_metrics(data["data"]);
		update_date_label(data["date"]);
		$(".ui-slider").slider("enable");
		update_slider_indicator(true);
	})
	.fail(function() {
		outdate_all_metrics()
		$(".ui-slider").slider("enable");
		update_slider_indicator(false);
	})
}

var ready = function() {
	$("#date-slider").slider({
		value: 100,
		min: -$("#date-slider").attr("num_days_from_min"),
		max: 0,
		step: 1,
		slide: function(event, ui) {
			var days_from_now = -1 * ui.value
			request_for_metrics(days_from_now)
			update_slider_indicator();
			$(".ui-slider").slider("disable");
		}
    });

    $(".date-nav").unbind().click(function(event) {
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
}

$(document).ready(ready)
$(document).on('turbolinks:load', ready)