/**
 * Created by An Ju on 5/2/17.
 */

function pivotal_tracker(containerID, data) {
    var container = d3.select('#' + containerID);
    var colors = {'unscheduled': '#7cb5ec', 'unstarted': '#90ed7d', 'started': '#f7a35c', 'finished': '#8085e9',
        'delivered': '#f15c80', 'accepted': '#e4d354', 'default': '#2b908f'};
    if (!container.select('.table').empty()) {
        return;
    }
    var tbl = container
        .append('table')
        .attr('class', 'table table-hover');
    var headers = tbl.append('thead').append('tr');
    headers.append('th').html('ID');
    headers.append('th').html('Story Name');
    headers.append('th').html('Current State');
    var rows = tbl.append('tbody').selectAll('tr')
        .data(data.data)
      .enter()
        .append('tr')
        .attr('bgcolor', function (d) {
            return colors[d.current_state];
        });
    rows.append('th').html(function (d) {
        return d.id;
    });
    rows.append('td').html(function (d) {
        return d.name;
    });
    rows.append('td').html(function (d) {
        return d.current_state;
    });
}