
function velocity(containerID, data) {
    var velocities = JSON.parse(data.image).data;
    var bar_data = {'data': [], 'series': []};
    for (var iter = 1; iter < 5; iter++) {
        if (velocities[iter] !== undefined) {
            bar_data['data'].push(velocities[iter]);
            bar_data['series'].push('Iteration ' + iter);
        }
    }
    bar_chart(containerID, bar_data);
}