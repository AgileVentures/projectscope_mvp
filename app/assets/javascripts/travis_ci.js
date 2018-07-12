/**
 * Created by Joe on 5/25/17.
 */

function travis_ci(containerID, data) {
    if (data.current_state) {
        var status_color = data.current_state === 'passed' ? 'green' : 'red';
        var color = d3.scaleLinear().domain([0, 0.5, 1.0]).range(['red', 'yellow', 'green']);
        var success_rate = parseFloat(data.success_builds) / parseFloat(data.total_builds);
        d3.select('#' + containerID)
            .append('div')
            .style('background-color', color(success_rate))
            .style('width', (90.0 * success_rate) + '%')
            .style('float', 'left')
            .attr('data-toggle', 'tooltip')
            .attr('title', function (d) {
                return  'Total builds: ' + data.total_builds;
            })
            .html(success_rate.toPrecision(2));
        d3.select('#' + containerID)
            .append('div')
            .style('background-color', status_color)
            .style('width', '10%')
            .style('float', 'right')
            .attr('data-toggle', 'tooltip')
            .attr('title', function (d) {
                return 'Latest Build Status: ' + data.current_state;
            })
            .html(data.current_state[0]);
        $('[data-toggle="tooltip"]').tooltip();
    } else {
        d3.select('#' + containerID)
            .append('div')
            .style('width', 100.0 + '%')
            .html('No Data');
    }
}