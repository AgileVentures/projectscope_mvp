/**
 * Created by Joe on 7/3/17.
 */

function github_files(containerID, data) {
    var values = [];
    var color = {
        'test': '#2b908f',
        'model': '#8085e9',
        'view': '#8085e9',
        'controller': '#8085e9',
        'db': '#8085e9',
        'other': '#f7a35c'
    };
    ['test', 'model', 'view', 'controller', 'db', 'other'].forEach(function (item) {
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
                return color[d[1]];
            })
            .style('border-style', 'solid')
            .style('border-width', '1px')
            .style('border-color', 'black')
            .style('width', function (d) {
                return 95 * parseFloat(d[0]) / valsum + '%';
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