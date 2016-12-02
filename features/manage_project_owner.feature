@omniauth
Feature: Manage project owners
  As a user, I'd like to be the owner of the project I created
  And I should be able to add other user to be project owner

Background:
  Given I am logged in
  When I follow "New Project"
  And I fill in "Name" with "Test Project"
  And I press "Create Project"

Scenario: owner of created project
  When I am on the edit page for project "Test Project"
  Then I should see "test-coach" within ".owners-list"

Scenario: add other user as owner
  Given user with username "test-coach-2" exists
  When I am on the edit page for project "Test Project"
  And I fill in "Enter new owner's username" with "test-coach-2"
  And I press "Add"
  Then I should see "test-coach-2 has become an owner of this project!"
  And I should see "test-coach-2" within ".owners-list"

Scenario: cannot add a user who is already an owner
  Given user with username "test-coach-2" exists
  When I am on the edit page for project "Test Project"
  And I fill in "Enter new owner's username" with "test-coach"
  And I press "Add"
  Then I should see "Failed to add test-coach as owner"
  
