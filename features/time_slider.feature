@omniauth @javascript @timetravel
Feature: Time Slider
	As a user, I want to see project with metrics of different
	dates when I slide the time slider

Background:
    Given I am logged in
    And the following projects exist:
      | name         |
      | LocalSupport |
      | WebsiteOne   |
    And they have the following metric samples:
      | project      | metric_name  | score  | created_at |
      | LocalSupport | code_climate | 5.05   | 2016-11-15 |
      | LocalSupport | code_climate | 3.03   | 2016-11-16 |
      | WebsiteOne   | code_climate | 4.04   | 2016-11-16 |
      | LocalSupport | code_climate | 1.01   | 2016-11-17 | 
      | WebsiteOne   | code_climate | 2.02   | 2016-11-17 |

Scenario: view metric from yesterday
	Given the date is "11/17/2016"
	When I go to the projects page
	Then I should see "1.01" within "#project_1_code_climate_metric"
	And I should see "2.02" within "#project_2_code_climate_metric"
	When I slide 1 day backward
	Then I should see "3.03" within "#project_1_code_climate_metric"
	And I should see "4.04" within "#project_2_code_climate_metric"

Scenario: view missing metric sample from a previous date
	Given the date is "11/17/2016"
	When I go to the projects page
	Then I should see "1.01" within "#project_1_code_climate_metric"
	And I should see "2.02" within "#project_2_code_climate_metric"
	When I slide 2 days backward
	Then I should see "5.05" within "#project_1_code_climate_metric"
	And I should see "2.02" within "#project_2_code_climate_metric"
	And "#project_2_code_climate_metric" should be outdated



