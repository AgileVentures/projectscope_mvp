@javascript @vcr
Feature: View A Projects Metrics with Secrets

  As a project supervisor
  So that I can keep tabs on another project
  I want to view that projects metrics

  Background:
    Given the following projects exist:
      | name         |
      | LocalSupport |
      | WebsiteOne   |
    And they have the following metric configs:
      | project      | metric_name  | key     | value                                         |
      | LocalSupport | code_climate | url     | https://github.com/AgileVentures/LocalSupport |
      | WebsiteOne   | code_climate | url     | https://github.com/AgileVentures/WebsiteOne   |
      | LocalSupport | github       | url     | https://github.com/AgileVentures/LocalSupport |
      | WebsiteOne   | github       | url     | https://github.com/AgileVentures/WebsiteOne   |
      | LocalSupport | slack        | channel | localsupport                                  |
      | WebsiteOne   | slack        | channel | websiteone                                    |
      | LocalSupport | slack        | token   | 12345678                                      |
      | WebsiteOne   | slack        | token   | 12345678                                      |
    And they have the following metric samples:
      | project      | metric_name  | score |
      | LocalSupport | code_climate | 3.1   |
      | WebsiteOne   | code_climate | 3.4   |
      | LocalSupport | github       | 0.7   |
      | WebsiteOne   | github       | 0.6   |
      | LocalSupport | slack        | 0.2   |
      | WebsiteOne   | slack        | 0.3   |

  Scenario: view metric for projects
    When I am on the projects page
    Then I should see "0.2" within "#LocalSupport_slack_metric"
    And I should see "0.3" within "#WebsiteOne_slack_metric"

  @rake
  Scenario: update metrics for projects
    Given A project update job has been run
    When I am on the projects page
    Then I should see "0.14" within "#LocalSupport_slack_metric"
    And I should see "0.19" within "#WebsiteOne_slack_metric"
