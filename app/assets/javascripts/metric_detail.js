/**
 * Created by Joe on 5/15/17.
 */

$(document).on('turbolinks:load', function () {
    $('#comment_form').submit(function () {
        var params = {
            'offset_top': $(this).offset().top,
            'offset_left': $(this).offset().left
        };
        d3.select('#comment_form').select('#params').attr('value', JSON.stringify(params));
        d3.select('#comment_form').select('#metric_sample_id').attr('value', parent_metric.id);
        var valuesToSubmit = $(this).serialize();
        $.ajax({
            type: $(this).attr('method'),
            url: $(this).attr('action'), //sumbits it to the given url of the form
            data: valuesToSubmit,
            dataType: "JSON" // you want a difference between normal and ajax-calls, and json is standard
        }).success(function (json) {
            $('#comment_form #content').val('');
            var params = JSON.parse(json['params']);
            d3.select('#comment_column')
                .append('div')
                .style('top', params['offset_top'] + 'px')
                .attr('class', 'comments well')
                .append('p')
                .attr('class', 'comment-contents')
                .html(json['content']);
        });
        return false; // prevents normal behaviour
    });

    $('#button_clear').click(function () {
        $('#content').val('');
        return false;
    });
});
