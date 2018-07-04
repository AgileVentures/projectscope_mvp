function smart_story(containerID, metric_sample) {
    var color = {
        'DANGER': '#f45b5b',
        'SAFE': '#90ed7d'
    };

    var image_data = JSON.parse(metric_sample.image);
    var smart_stories = image_data.data.smart_stories;
    var non_smart_stories = image_data.data.non_smart_stories;
    var total_stories = smart_stories.length + non_smart_stories.length;

    if (total_stories > 0) {
        d3.select('#' + containerID)
            .style('width', '100%')
            .style('background-color', '')
            .html('')
            .append('font')
            .attr('face', 'Verdana')
            .attr('color', smart_stories.length === total_stories ? color['SAFE'] : color['DANGER'])
            .html('Score: ' + Math.round(100 * smart_stories.length / total_stories) + '%');
    } else {
        d3.select('#' + containerID)
            .append('div')
            .style('width', '100%')
            .html('No Data');
    }
}