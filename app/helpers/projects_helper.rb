module ProjectsHelper
  def setup_metric_configs(project)
    ProjectMetrics.metric_names.each do |metric|
      if project.configs.where(:metric_name => metric).empty?
        project.configs.build(:metric_name => metric)
      end
    end
    project
  end

  def is_selected_metric? sample
    sample.try(:metric_name) != nil && (current_user.preferred_metrics.include? sample.metric_name)
  end

  def metric_content_class_label sample
    "metric-content " + (sample.created_at >= Date.today ? "" : "outdated-metric")
  end
end
