Feature: Instructor will assign the iterations template in three step
  As an instructor
  I will be able to select template or create a new one
  I will select the projects
  and I will fill in the info of each task
  templates will be assign to each task

  Background: There exist some iteration template and
    Given I am logged in
    Then the following projects exist:
      | name         |
      | TestProject1 |
      | TestProject2 |
    And the following Iteration template exist:
      | name          |
      | TempIteration |
    And I am on the iterations page
