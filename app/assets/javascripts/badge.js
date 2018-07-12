function code_climate_badge(containerID, data) {
    d3.select('#' + containerID)
        .style('width', '100%')
        .html(data.data['maint_badge']);
}

function test_coverage_badge(containerID, data) {
    d3.select('#' + containerID)
        .style('width', '100%')
        .html(data.data['test_badge']);
}