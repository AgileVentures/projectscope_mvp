ProjectMetrics.configure do
  add_metric :project_metric_code_climate
  add_metric :project_metric_github
  add_metric :project_metric_slack
  add_metric :project_metric_pivotal_tracker
  # add_metric :project_metric_slack_trends
  add_metric :project_metric_story_transition
  add_metric :project_metric_point_estimation
  add_metric :project_metric_story_overall
  add_metric :project_metric_collective_overview
  add_metric :project_metric_test_coverage
  add_metric :project_metric_pull_requests
  add_metric :project_metric_travis_ci
  add_metric :project_metric_github_files
  add_metric :project_metric_github_flow
  add_metric :project_metric_tracker_velocity

  add_hierarchy report: [{ title: :github,
                            contents: [] },
                          { title: :pivotal_tracker,
                            contents: [:pivotal_tracker, :story_transition] }]
  add_hierarchy metric: [[
                             :code_climate,
                             :test_coverage,
                             :pull_requests,
                             :github_files,
                             :github_flow,
                         ], [
                             :travis_ci,
                             :tracker_velocity,
                             :point_estimation,
                             :story_overall,
                             :slack
                         ]]
end
