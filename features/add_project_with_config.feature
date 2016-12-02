@javascript @omniauth
Feature: add project and its config/credentials info

  As a project supervisor
  So that I can keep tabs on another project
  I want to add a project and specify credentials for scraping its metrics

  Scenario: add project with config info for CodeClimate gem
    Given I am logged in
    And I am on the projects page
    When I follow "New Project"
    And I fill in "Name" with "Test Project"
    And I enter new "Code Climate" config values:
      | key     | value |
      | url     | a.com |
      | channel | 12345 |
      | token   | 555   |
    And I enter new "Github" config values:
      | key     | value |
      | url     | b.com |
    And I enter new "Slack" config values:
      | key     | value |
      | channel | 1     |
      | token   | 5     |
    And I enter new "Pivotal Tracker" config values:
      | key     | value |
      | project | la    |
      | token   | 444   |
    And I enter new "Slack Trends" config values:
      | key     | value |
      | channel | 1     |
      | token   | 5     |
    And I press "Create Project"
    Then there should be a project "Test Project" with config values:
      | metric_name     | key      | value |
      | code_climate    | url      | a.com |
      | code_climate    | channel  | 12345 |
      | code_climate    | token    | 555   |
      | github          | url      | b.com |
      | slack           | channel  | 1     |
      | slack           | token    | 5     |
      | slack_trends    | channel  | 1     |
      | slack_trends    | token    | 5     |
      | pivotal_tracker | project  | la    |
      | pivotal_tracker | token    | 444   |




