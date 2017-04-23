var ready = function() {
	$('#check_all').on("click", function(){ 
		var project_checkboxes = $('.project_checkbox');
		var metric_checkboxes = $('.metric_checkbox');
		if (this.checked) {
			check_all(project_checkboxes);
			check_all(metric_checkboxes);
		}
	});
};

var check_all = function(checkboxes) {
	$.each(checkboxes, function(index, el) {
		if (el.checked !== true) {
			el.click();
		}
	});
}

$(document).on('turbolinks:load', ready);
$(document).ready(ready);