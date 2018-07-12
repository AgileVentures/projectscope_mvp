Feature: Instructor will be able to assign iteration by assigning iteration graph
  As an instructor
  I should be able to select which template to assign to project
  so that they will have new project for the new iteration

  Background: There exists two projects and I login as instructor
    Given I am logged in
    Then the following projects exist:
      | name         |
      | TestProject1 |
      | TestProject2 |
    And the following Iteration exist:
      | name          |
      | TempIteration |
    And I am on the iterations page

  Scenario: I can assign project with existing tasks graph template
    #Given I select "TempIteration" from "apply_iter"
    #Then I press "apply to TestProject1"
    #Then "TestProject1" will have a current task graph same as "test task graph"

  Scenario: I can assign template to projects that have unassigned status
    #Given that a project is unassigned
    #Then I can assign new template
    #Then the status will become assgined
    #And I cannot assign template

  Scenario: I can assign the start and end time for the iteration
