/**
 * Created by Joe on 5/24/17.
 */

function pull_requests(containerID, data) {
    if (data.total === 0) {
        d3.select('#' + containerID)
            .append('div')
            .style('width', '100%')
            .html('No Data');
    } else {
        var open = data.open === 0 ? 0.5 : data.open;
        var commented = data.commented === 0 ? 0.5 : data.commented;
        var container = d3.select('#' + containerID)
            .style('width', '100%');
        container.selectAll('div').remove();
        // container.append('div')
        //     .style('background-color', 'green')
        //     .style('width', (100.0 * open / data.total) + '%')
        //     .style('float', 'left')
        //     .attr('data-toggle', 'tooltip')
        //     .attr('title', 'open')
        //     .html(open);
        // container.append('div')
        //     .style('background-color', 'red')
        //     .style('width', (100.0 * (data.total - open) / data.total) + '%')
        //     .style('float', 'left')
        //     .attr('data-toggle', 'tooltip')
        //     .attr('title', 'closed')
        //     .html(data.closed);
        // container.append('br');
        container.append('div')
            .style('background-color', 'green')
            .style('width', (100.0 * commented / data.total) + '%')
            .style('float', 'left')
            .attr('data-toggle', 'tooltip')
            .attr('title', 'commented')
            .html(data.commented);
        container.append('div')
            .style('background-color', 'red')
            .style('width', (100.0 * (data.total - commented) / data.total) + '%')
            .style('float', 'left')
            .attr('data-toggle', 'tooltip')
            .attr('title', 'uncommented')
            .html(data.total - data.commented);
        $('[data-toggle="tooltip"]').tooltip();
    }
}