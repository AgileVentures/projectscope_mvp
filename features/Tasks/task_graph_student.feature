Feature:  Task graph will help user to finish the task step by step

  As a students user under a certain project in a certain iteration
  So that I can go through the routes of task graph
  I will be able to finish evert task finally


  Background: The default task is generated
    Given I am logged in
    And that I am on the iteration page for DefaultTaskGraph

  Scenario: Task graph is correctly present
    #When I press the start button of a unstarted task
    #Then I will be able to started the task
    #And the status of the task will be unfinished

  Scenario: Student will be only be able start their work when parent task are finished
    #When I press the button of a task whose parent task is not finished
    #Then I will not be able to started the task

  Scenario: Student will be able to see the task update when it has status unfinished
    #Given that the task A is updated by updater
    #Then I will be able to see it's status become finished when I press fresh
    #And I will be able to start the next task

  Scenario: Student will have danger status when a task is in danger to be finished
    #Given that I have a default danger task that has one more day before it's due
    #Then The status of the task should be danger
    #And I won't be able to start its child task