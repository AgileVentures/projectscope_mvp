@javascript
Feature: add project and its config/credentials info

  As a project supervisor
  So that I can keep tabs on another project
  I want to add a project and specify credentials for scraping its metrics

  Scenario: add project with config info for CodeClimate gem

    Given I am on the projects page
    And I am logged in
    When I follow "New Project"
    And I fill in "Name" with "Test Project"
    And I enter new "Code Climate" config values:
      | key   | value |
      | token | 12345 |
      | login | fox   |
    And I press "Create Project"
    Then there should be a project "Test Project" with config values:
      | metric_name  | key   | value |
      | code_climate | token | 12345 |
      | code_climate | login | fox   |



