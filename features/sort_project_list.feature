@javascript @vcr
Feature: display list of project sorted by different criteria
 
  As an instructor or GSI
  So that I can quickly browse projects based on my preferences
  I want to see projects sorted by project name or matric_names

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

Scenario: sort project alphabetically
  When I am on the projects page
  When I follow "Project Name"
  # your steps here
  Then I should see "LocalSupport" before "WebsiteOne"



Scenario: sort movies in increasing order of code_climate score
  When I am on the projects page
  When I follow "code_climate"
  # your steps here
  Then I should see "LocalSupport" before "WebsiteOne"
