/**
 * Created by Joe on 5/25/17.
 */

function travis_ci(containerID, data) {
    if (data.current_state) {
        var color = data.current_state === 'passed' ? 'green' : 'red';
        var success_rate = parseFloat(data.success_builds) / parseFloat(data.total_builds);
        d3.select('#' + containerID)
            .append('div')
            .style('background-color', color)
            .style('width', (100.0 * success_rate) + '%')
            .style('float', 'left')
            .attr('data-toggle', 'tooltip')
            .attr('title', function (d) {
                return 'State: ' + data.current_state + '.' + ' Total builds: ' + data.total_builds;
            })
            .html(success_rate.toPrecision(2));
        $('[data-toggle="tooltip"]').tooltip();
    } else {
        d3.select('#' + containerID)
            .append('div')
            .style('width', 100.0 + '%')
            .html('No Data');
    }
}