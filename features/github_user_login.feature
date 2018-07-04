@omniauth
Feature: GitHub User Login
	As a user of projectscope, I should be able to login
	if I have an valid github account

Scenario: github user login with email
	Given I am on the login page
	And "test-coach" is in the whitelist
	And I have a valid github account with email "test-coach@test.com" username "test-coach"
	When I follow "Sign in with GitHub"
	Then I should be on team selection page for student "test-coach"
	And I should see "Signed in successfully."

Scenario: github user login without email
	Given I am on the login page
	And "test-coach" is in the whitelist
	And I have a valid github account with email "" username "test-coach"
	When I follow "Sign in with GitHub"
	Then I should be on team selection page for student "test-coach"
	And I should see "Signed in successfully."

Scenario: unauthrozied user login
	Given I am on the login page
	And I do not have a valid github account
	When I follow "Sign in with GitHub"
	Then I should be on the login page
	And I should see "Could not authenticate you from GitHub"
