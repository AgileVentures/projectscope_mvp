/**
 * Created by Joe on 5/25/17.
 */

function stacked_bar(containerID, data, stacked_items) {
    var color = d3.scaleOrdinal()
        .range([
            '#90ed7d',
            '#f7a35c',
            '#8085e9',
            '#f15c80',
            '#e4d354',
            '#2b908f',
            '#f45b5b',
            '#91e8e1'])
        .domain(stacked_items);
    var values = [];
    stacked_items.forEach(function (item) {
        values.push(data.data[item] ? [data.data[item], item] : [0, item]);
    });
    var add = function (sum, elem) {
        return sum + parseFloat(elem[0]);
    };
    var valsum = values.reduce(add, 0);
    if (valsum > 0) {
        d3.select('#' + containerID)
            .style('width', '100%')
            .style('background-color', '')
            .html('')
            .selectAll('div')
            .data(values)
            .enter()
            .append('div')
            .style('background-color', function (d) {
                return color(d[1]);
            })
            .style('width', function (d) {
                return 100 * parseFloat(d[0]) / valsum + '%';
            })
            .style('float', 'left')
            .attr('data-toggle', 'tooltip')
            .attr('title', function (d) {
                return d[1];
            })
            .html(function (d) {
                return d[0] > 0 ? d[0] : '';
            });
        $('[data-toggle="tooltip"]').tooltip();
    } else {
        d3.select('#' + containerID)
            .append('div')
            .style('width', '100%')
            .html('No Data');
    }
}