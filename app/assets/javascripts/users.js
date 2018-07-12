// var ready = function () {
//     $('#check_all').on("click", function () {
//         var project_checkboxes = $('.project_checkbox');
//         var metric_checkboxes = $('.metric_checkbox');
//         if (this.checked) {
//             check_all(project_checkboxes);
//             check_all(metric_checkboxes);
//         }
//     });
// };
//
// var check_all = function (checkboxes) {
//     $.each(checkboxes, function (index, el) {
//         if (el.checked !== true) {
//             el.click();
//         }
//     });
// }
var ready = function () {
    var metricsCheckboxHandler = {
        init: function () {
            $('.metrics_checkbox').click(metricsCheckboxHandler.parentClicked);
            $('.sub_metrics_checkbox').click(metricsCheckboxHandler.childClicked);
        },

        parentClicked: function () {
            var isChecked = this.checked;
            subMetrics = $(this).parent().parent().find(".sub_metrics_checkbox");
            subMetrics.each(function () {
                this.checked = isChecked;
            });
        },

        childClicked: function () {
            subMetrics = $(this).parent().find(".sub_metrics_checkbox");
            var checkedCnt = 0;
            subMetrics.each(function() {
               if (this.checked == true) {
                   checkedCnt += 1;
               }
            });
            parentCheckbox = $(this).parent().parent().find(".metrics_checkbox");
            parentCheckbox[0].checked = checkedCnt != 0;
        }
    }
    metricsCheckboxHandler.init();
}
$(document).on('turbolinks:load', ready);
// $(document).ready(ready);