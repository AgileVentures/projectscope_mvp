Feature: Started tasks will be send and receive update info in iteration package with event

  As a student
  So that I will have each task map to a list of event
  Task will be automatically updated by event

  Background: The task graph is correctly map to project and iteration keep the correct token to access to event
    Given I am logged in
    And the following Iteration exist:
      | name           |
      | IterationEvent |
    And the "IterationEvent" iteration is map with the following tasks:
      | title       | updater_type |
      | Test Title  | github       |
      | Test Title  | pivotal      |
      | Test Title  | local        |

  Scenario: Iteration send request and receive callback from event of all new events
    Given I am on the iteration page for "IterationEvent"
    # And I press "update all"
    Then Tasks will be updated if they reach the requirement to update

  Scenario: I cannot delete or create task
    Given I am on the iteration page for "IterationEvent"
    Then I cannot create task
    And I cannot edit task
    And I cannot delete task