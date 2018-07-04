
function story_overall(containerID, data) {
    var values = [
        [data.data[0], data.series[0]], //unscheduled
        [data.data[1], data.series[1]], //unstarted
        [data.data[2], data.series[2]], //started
        [data.data[3], data.series[3]], //finished
        [data.data[4], data.series[4]]  //delivered
    ];
    var color = {
        'started': '#2b908f',
        'finished': '#2b908f',
        'delivered': '#2b908f',
        'unstarted': '#8085e9',
        'unscheduled': '#8085e9'
    };
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