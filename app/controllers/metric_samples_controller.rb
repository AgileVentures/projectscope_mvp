class MetricSamplesController < ApplicationController
  load_and_authorize_resource

  def index
    @metrics = ProjectMetrics.hierarchies :metric
    @projects = Project.all
    @metric_samples = @projects.map do |project|
      @metrics.flat_map { |m| project.metric_on_date m, date }
    end
  end

  def raw_data
    @metric_sample = MetricSample.find(params[:id])
    new_rd = @metric_sample.raw_data.gsub(/[>:][ ]*(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} UTC)/) {|s| s[0] + '"' + $1 + '"'}
    render json: eval(new_rd)
  end

  private

  def date
    @days_from_now = params[:days_from_now] ? params[:days_from_now].to_i : 0
    Date.today - @days_from_now.days
  end
end
