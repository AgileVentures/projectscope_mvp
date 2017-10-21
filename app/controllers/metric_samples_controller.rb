class MetricSamplesController < ApplicationController

  def index
    @metrics = ProjectMetrics.hierarchies :metric
    @projects = Project.all
    @metric_samples = @projects.map do |project|
      @metrics.flat_map { |m| project.metric_on_date m, date }
    end
  end

  private

  def date
    @days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    Date.today - @days_from_now.days
  end
end
