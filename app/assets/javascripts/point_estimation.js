function point_estimation(containerID, metric_sample) {
    var color = {
        'UNESTIMATED': '#f45b5b',
        'ESTIMATED': '#90ed7d'
    };
    var image = JSON.parse(metric_sample.image);

    var valsum = 0;
    for (var i = 0; i !== image.data.data.length; i++) {
        valsum += image.data.data[i];
    }

    if (image.data.series[0] === '-1') {
        d3.select('#' + containerID)
            .style('width', '100%')
            .append('font')
            .attr('face', 'Verdana')
            .attr('color', color['ESTIMATED'])
            .html('Estimated: 100%')
    } else {
        d3.select('#' + containerID)
            .style('width', '100%')
            .append('font')
            .attr('face', 'Verdana')
            .attr('color', color['UNESTIMATED'])
            .html('Estimated: ' + Math.round((valsum - image.data.data[0]) * 100 / valsum) + '%')
    }

}