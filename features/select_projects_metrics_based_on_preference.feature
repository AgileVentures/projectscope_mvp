@omniauth
Feature: Select Projects and Metrics based on user preference
	As a user, I would like to see only projects and metrics
	that I'm interested in.

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

Scenario: select preferred projects
	When I am on the projects page
	Then I should see "LocalSupport"
	And I should see "WebsiteOne"
    When I follow "Preference"
    And I check "LocalSupport" within "#project-preference-list"
    And I uncheck "WebsiteOne" within "#project-preference-list"
    And I press "Save"
    Then I should see "Preference saved successfully"
    When I go to the projects page
    Then I should see "LocalSupport"
    And I should not see "WebsiteOne"


Scenario: select preferred metrics
	When I am on the projects page
	Then I should see "2.9" within "#project_1_code_climate_metric"
	And I should see "0.6" within "#project_2_github_metric"
	When I follow "Preference"
	And I check "CodeClimate" within "#metric-preference-list"
	And I uncheck "Github" within "#metric-preference-list"
	And I press "Save"
	Then I should see "Preference saved successfully"
	When I go to the projects page
	Then I should see "2.9" within "#project_1_code_climate_metric"
	And I should see "3.4" within "#project_2_code_climate_metric"
	And I should not see "0.7"
	And I should not see "0.6"


Scenario: select both projects and metrics
	When I am on the projects page
	Then I should see "2.9" within "#project_1_code_climate_metric"
	And I should see "0.6" within "#project_2_github_metric"
	When I follow "Preference"
	And I check "LocalSupport" within "#project-preference-list"
	And I uncheck "WebsiteOne" within "#project-preference-list"
	And I check "CodeClimate" within "#metric-preference-list"
	And I uncheck "Github" within "#metric-preference-list"
	And I press "Save"
	Then I should see "Preference saved successfully"
	When I go to the projects page
	Then I should see "2.9" within "#project_1_code_climate_metric"
	And I should not see "3.4"
	And I should not see "0.7"
	And I should not see "0.6"

Scenario: should see both newly created project and existing projects
	When I am on the projects page
	And I follow "New Project"
    And I fill in "Name" with "Test Project"
    And I press "Create Project"
    When I go to the home page
    Then I should see "2.9" within "#project_1_code_climate_metric"
	And I should see "0.6" within "#project_2_github_metric"
	And I should see "Test Project"