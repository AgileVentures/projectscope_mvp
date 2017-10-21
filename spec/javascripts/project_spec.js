describe("sliding timeslider", function() {

  beforeEach(function() {
    loadFixtures("timeslider_fixture.html");
  });

  it("should make an AJAX request to the correct URL", function() {
    var doneCallback = {
      done: function() {}
    };
    var failCallback = {
      fail: function() {}
    };
    spyOn($, "ajax").and.returnValue(doneCallback);
    spyOn(doneCallback, 'done').and.returnValue(failCallback);
    request_for_metrics(-1);
    expect($.ajax.calls.mostRecent().args[0]["url"]).toEqual("projects/metrics_on_date");
  });

  it("should update slider indicator to loading if none", function() {
    update_slider_indicator();
    expect($("#slider-progress-indicator")).toContainText("Loading...");
  });

  it("should update slider indicator to none if successful", function() {
    $("#slider-progress-indicator").css("display", "block");
    update_slider_indicator(true);
    expect($("#slider-progress-indicator")).toBeHidden();
  });

  it("should show error message if failed to update", function() {
    $("#slider-progress-indicator").css("display", "block");
    update_slider_indicator(false);
    expect($("#slider-progress-indicator")).toContainText("Error: Failed to load new data");
    expect($("#slider-progress-indicator")).toHaveClass("slider-error-msg");
  });

  it("should outdate all metric contents", function() {
    outdate_all_metrics();
    expect($(".metric-content")).toHaveClass("outdated-metric");
  });

  it("should update date label to be new date", function() {
    update_date_label("2016-12-2T000000");
    expect($("#date-label")).toContainText("2016-12-2");
  });

  it("should update metric to new data", function() {
    var fake_data = [[{project_id: 4, metric_name: "github", score: 0.2, image: "fake_image"}]];
    update_metrics(fake_data);
    expect($(".metric_score")).toContainText("0.2");
    expect($(".metric_image")).toContainText("fake_image");
  });
});