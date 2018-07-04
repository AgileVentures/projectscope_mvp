ProjectMetrics.configure do
  add_metric :project_metric_code_climate
  # add_metric :project_metric_github
  # add_metric :project_metric_slack
  # add_metric :project_metric_pivotal_tracker
  # add_metric :project_metric_slack_trends
  # add_metric :project_metric_story_transition
  add_metric :project_metric_point_estimation
  add_metric :project_metric_story_overall
  # add_metric :project_metric_collective_overview
  add_metric :project_metric_test_coverage
  add_metric :project_metric_pull_requests
  add_metric :project_metric_travis_ci
  add_metric :project_metric_github_files
  add_metric :project_metric_github_flow
  add_metric :project_metric_tracker_velocity
  add_metric :project_metric_point_distribution
  add_metric :project_metric_smart_story
  add_metric :project_metric_commit_message

  # add_hierarchy metric: [%I[code_climate test_coverage travis_ci point_estimation],
  #                        %I[pull_requests github_flow point_distribution smart_story],
  #                        %I[github_files commit_message story_overall]]
  add_hierarchy metric: [%I[pull_requests github_files commit_message test_coverage code_climate travis_ci],
                         %I[point_estimation github_flow point_distribution smart_story story_overall]]
end

METRIC_NAMES = {
  code_climate: 'Code Climate',
  test_coverage: 'Test Coverage',
  pull_requests: 'PR Status',
  github_files: 'Edited Lines',
  github_flow: 'Commit Counting',
  travis_ci: 'Build Status',
  smart_story: 'Story Relevance',
  point_estimation: 'Story Points',
  story_overall: 'Story Status',
  point_distribution: 'Finished Stories',
  commit_message: 'Commit Message'
}