Feature: All iteration properly present the development tasks
  As a student
  So that I will have preliminary tasks
  Tasks will be updated properly

  Background: I'm having some existing preliminary graph task
    Given I am logged in
    And the following Iteration exist:
      | name                 |
      | IterationDevelopment |
    And the "IterationDevelopment" iteration is map with the following tasks:
      | title              | updater_type    | task_status |
      | Lo-fi Mockup       | development     | started     |
      | Pair programming   | development     | started     |
      | Code Review        | development     | started     |
      | Finish Story       | development     | started     |
      | TDD and BDD        | development     | started     |
      | Points Estimation  | development     | started     |
      | Pull Request       | development     | started     |

  Scenario: I should see all the preliminary tasks in my task graph page
    Given I am on the iteration page for "IterationDevelopment"
    Then I should see "Development Task"
    And all the preliminary tasks for "IterationDevelopment" are in the preliminary section

  Scenario: the task will be update when the title name is matched and result is true
    Given I receive a "Pair programming" with value "true" from event
    Then the "Pair programming" task have a finished status

    Given I receive a "Finish Story" with value "true" from event
    Then the "Finish Story" task have a finished status

    Given I receive a "TDD and BDD" with value "true" from event
    Then the "TDD and BDD" task have a finished status

    Given I receive a "Points Estimation" with value "true" from event
    Then the "Points Estimation" task have a finished status

    Given I receive a "Pull Request" with value "true" from event
    Then the "Pull Request" task have a finished status
