@javascript
Feature: edit existing project and its config/credentials info

  As a project supervisor
  So that I can keep update an existing project
  I want to edit a project and specify different credentials for scraping its metrics

  Scenario: Cannot see credentials
    Given I am logged in
    And the following projects exist:
      | name         |
      | LocalSupport |
    And they have the following metric configs:
      | project      | metric_name  | key     | value                                       |
      | LocalSupport | code_climate | token   | 1234                                        |
    And I am on the edit page for project "LocalSupport"
    Then the config value "1234" should not appear in the page

  #TODO: Some more scenarios are needed.