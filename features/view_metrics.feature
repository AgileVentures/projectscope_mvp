@javascript @vcr @omniauth
Feature: View A Projects Metrics

  As a project supervisor
  So that I can keep tabs on another project
  I want to view that projects metrics

  Background:
    Given I am logged in
    And the following projects exist:
      | name         |
      | LocalSupport |
      | WebsiteOne   |
    And they have the following metric configs:
      | project      | metric_name  | key | value                                         |
      | LocalSupport | code_climate | url | https://github.com/AgileVentures/LocalSupport |
      | WebsiteOne   | code_climate | url | https://github.com/AgileVentures/WebsiteOne   |
      | LocalSupport | github       | url | https://github.com/AgileVentures/LocalSupport |
      | WebsiteOne   | github       | url | https://github.com/AgileVentures/WebsiteOne   |
    And they have the following metric samples:
      | project      | metric_name  | score |
      | LocalSupport | code_climate | 2.9   |
      | WebsiteOne   | code_climate | 3.4   |
      | LocalSupport | github       | 0.7   |
      | WebsiteOne   | github       | 0.6   |

  Scenario: view metric for projects
    When I am on the projects page
    Then I should see "2.9" within "#project_1_code_climate_metric"
    And I should see "3.4" within "#project_2_code_climate_metric"
    And I should see "0.7" within "#project_1_github_metric"
    And I should see "0.6" within "#project_2_github_metric"

  @rake
  Scenario: update metrics for projects
    Given A project update job has been run
    When I am on the projects page
    Then I should see "3.2" within "#project_1_code_climate_metric"
    And I should see "3.5" within "#project_2_code_climate_metric"
    And I should see "0.64" within "#project_1_github_metric"
    And I should see "0.28" within "#project_2_github_metric"
