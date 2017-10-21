@javascript @omniauth
Feature: add project and its config/credentials info

  As a project supervisor
  So that I can keep tabs on another project
  I want to add a project and specify credentials for scraping its metrics

  Scenario: add project with config info for CodeClimate gem
    Given I am logged in
    And I am on the new project page
    Then I fill in "project_name" with "Test Project"
    And I enter new "Github" config values:
      | key          | value  |
      | project      | a.com  |
      | access_token | 12345  |
      | main_branch  | master |
    And I enter new "Slack" config values:
      | key     | value |
      | channel | 1     |
      | token   | 5     |
    And I enter new "Tracker" config values:
      | key     | value |
      | project | b.com |
      | token   | 5     |
    And I press "Create"
    Then there should be a project "Test Project" with config values:
      | metric_name      | key             | value |
      | pull_requests    | github_project  | a.com |
      | github_files     | github_project  | a.com |
      | slack            | slack_channel   | 1     |
      | tracker_velocity | tracker_project | b.com |
