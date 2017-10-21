/**
 * Created by Joe on 5/24/17.
 */

function index_score(containerID, score, min, max) {
    var color = d3.scaleLinear().domain([min, (max+min)/2.0, max]).range(['red', 'yellow', 'green']);
    d3.select('#' + containerID)
        .append('div')
        .style('background-color', color(score))
        .style('width', (100.0 * score / (max - min)) + '%')
        .style('float', 'left')
        .html(score);
}