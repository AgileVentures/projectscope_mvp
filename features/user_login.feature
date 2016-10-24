Feature: User Login
	As a user of projectscope, I should be able to login if I am
	on the whitelist or I am an admin. Otherwise I should be blocked.

Background:
	Given admin with email "test-admin@test.com" and password "testadminofprojectscope" exists
	And coach with email "test-coach@test.com" is in the whitelist

Scenario: authrozied admin login
	Given I am on the login page
	When I sign in as admin with email "test-admin@test.com" and password "testadminofprojectscope"
	Then I should be on the home page
	And I should see "Signed in successfully."

@omniauth_test
Scenario: authrozied coach login
	Given I am on the login page
	When I sign in as coach with github email "test-coach@test.com"
	Then I should be on the home page
	And I should see "Signed in successfully."

@omniauth_test
Scenario: unauthrozied user login
	Given I am on the login page
	When I sign in as coach with github email "test-coach-not-exist@test.com"
	Then I should be on the login page
	And I should see "You are not authorized."
