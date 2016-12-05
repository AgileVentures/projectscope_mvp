@omniauth
Feature: Whitelist
	As a whitelist user, I will be able to login to the projectscope and see the whitelist.
	If I am not a whitelist user, I will not be able to login and manipulate the whitelist.

Background:
	Given "test-admin" is in the whitelist
	And "ysiad" is in the whitelist

Scenario: Users in the whitelist should be able to login
	Given I am on the login page
	And I have a valid github account with email "test-coach@test.com" username "test-admin"
	When I follow "Sign in with GitHub"
	Then I should be on the home page
	And I should see "Signed in successfully."
	
Scenario: Users that are not in the whitelist will not be able to login
	Given I am on the login page
	And I have a valid github account with email "test-coach@test.com" username "test-coach"
	When I follow "Sign in with GitHub"
	Then I should be on the login page
	And I should see "You are not authorized."
	
Scenario: Not whitelist user cannot see the whitelist
   Given I am on the login page
   When I go to the whitelist page
   Then I should see "You are not authorized to manipulate whitelist."
   
Scenario: Whitelist users can see the whitelist
  Given I am logged in
  Then I should be on the home page
  And I should see "Whitelist"
  When I follow "Whitelist"
  Then I should be on the whitelist page
  Then I should see "ysiad"
  Then I should see "test-admin"
   
Scenario: Whitelist users add a user to the whitelist
  Given I am logged in 
  And I enter the whitelist page
  Then I should see "Add user to whitelist"
  When I follow "Add user to whitelist"
  Then I should be on the whitelist management page
  When I fill in "username" with "daisy"
  And I press "Add"
  Then I should be on the whitelist page
  And I should see "daisy"
  
 Scenario: Whitelist users delete a user from the whitelist
   Given I am logged in
   And I enter the whitelist page
   Then I should see "test-admin"
   When I follow the first "Delete"
   Then I should see "User is deleted successfully."
   And I should not see "test-admin"
   
 Scenario: Whitelist users are unable to delete themselves from the whitelist
   Given I am logged in
   And I enter the whitelist page
   Then I should see "test-admin"
   Then I should see "ysiad"
   Then I should see "test-coach"
   When I follow the first "Delete"
   Then I should not see "test-admin"
   When I follow the first "Delete"
   Then I should not see "ysiad"
   Then I should not see "Delete"
  
	

