Feature: The progress of current iteration will be represented
  As an instructor
  So that I will be able to view the current iteration progress
  Each part of the progress will be correctly presented

  Given I am logged in
  Then the following projects exist:
  | name         |
  | TestProject1 |
  | TestProject2 |
  | TestProject3 |

  And the following Iteration exist:
  | name          |
  | TempIteration |

  And I assign the "TempIteration" to every iteration

  Scenario: Select all from the the tasks graph
    Given I am on the aggregation progress page
    And I should see the progress of "TestProject1"