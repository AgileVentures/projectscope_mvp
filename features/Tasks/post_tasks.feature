Feature: All iteration properly present the priliminary tasks
  As a student
  So that I will have post iteration tasks
  Tasks will be updated properly

  Background: I'm having some existing preliminary graph task
    Given I am logged in
    And the following Iteration exist:
      | name          |
      | IterationPost |

    And the "IterationPost" iteration is map with the following tasks:
      | title               | updater_type      | task_status |
      | Deploy              | post              | started     |
      | Cross Group Review  | post              | started     |
      | Customer Feedback   | post              | started     |

  Scenario: I should see all the preliminary tasks in my task graph page
    Given I am on the iteration page for "IterationPost"
    Then I should see "Post Task"
    And all the preliminary tasks for "IterationPost" are in the preliminary section

  Scenario: the task will be update when the title name is matched and result is true
    Given I receive a "Deploy" with value "true" from event
    Then the "Deploy" task have a finished status

    Given I receive a "Cross Group Review" with value "true" from event
    Then the "Cross Group Review" task have a finished status

    Given I receive a "Customer Feedback" with value "true" from event
    Then the "Customer Feedback" task have a finished status
