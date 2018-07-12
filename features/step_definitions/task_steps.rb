require 'json'
Given(/^the following task graph configs:$/) do |table|
  table.hashes.each do |hash|
    new_iteration = Iteration.new()
    new_iteration.name = hash['name']
    new_iteration.project_id = Project.find_by_name(hash['project']).id
    new_iteration.save
  end
end

Given /the following Iteration exist:$/ do |table|
  table.hashes.each do |hash|
    Iteration.create hash
  end
  @iteration = Iteration.all
end

Given /the following Iteration template exist:$/ do |table|
  table.hashes.each do |hash|
    Iteration.create hash
  end
  Iteration.all.update_all(template: true)
  @iteration = Iteration.all
end

Given /the "([^\"]*)" iteration is map with the following tasks:$/ do |iter_name, table|
  @iteration = Iteration.find_by(name: iter_name)
  table.hashes.each do |hash|
    task = Task.new(hash)
    task.iteration_id = @iteration.id
    task.task_status = 'started'
    task.save.should be_truthy
  end
end

Given /^I receive a "([^\"]*)" with value "([^\"]*)" from event/ do |key, value|
  @tasks = Task.where(iteration_id: @iteration.id)
  Task.tasks_update_all @tasks, key, value
end

Then /^I will see the three parts of the tasks thread/ do
  %{Then I should see "Development Task"}
  %{Then I should see "Preliminary Task"}
  %{Then I should see "Post Task"}
end

Then /^I assign the "TempIteration" to every iteration/ do
  %{Given I am on the iterations page}
  %{Given I select "TempIteration" from "apply_all"}
  %{Then I press "Apply to all"}
end

Then /^all the preliminary tasks for "([^\"]*)" are in the preliminary section/ do |iteration|
  @iteration = Iteration.find_by(name: iteration)
  @tasks = Task.where(iteration_id: @iteration.id)
  @tasks.each do |task|
    %{I should see #{task.title}}
  end
end
Then /the "([^\"]*)" task have a finished status/ do |task_title|
  task = Task.find_by_title(task_title)
  task.task_status.should equal?('finished')
end

Given /^I will see drop down in "([^\"]*)"/ do |tasks|
  new_tasks = tasks.split(" and ")
end

Given /^"Github" default "started" task is mapped to "default branch"/ do
  @task = Task.new(title: "github branch task", task_status: "started", updater_type: "github",
              description: "this task is for testing the github call back")
  update_info = {}
  update_info[:branch_name] = "default branch"
  @task.updater_info = update_info.to_json
  @task.save.should be_truthy
end

When /^"Github" updater receives information of the "default branch" is merge back from Event/ do
  @task = Task.find_by(title: "github branch task")
  update_info = JSON.parse @task.updater_info
  update_info[:branch_name].should equal?"default branch"
  @task.task_status.should equal? "started"
  @task.update_status
end

Then /I will be able to see the status of the "([^\"]*)" become finished/ do |task_title|
  @task = Task.find_by(title: task_title)
  @task.task_status.should equal? "finished"
end

Given /"Pivotal" default "started" task is mapped to "default story"/ do
  @task = Task.new(title: "pivotal story task", task_status: "started", updater_type: "pivotal",
                   description: "this task is for testing the pivotal call back")
  update_info = {}
  update_info[:story_name] = "default story"
  @task.updater_info = update_info.to_json
  @task.save.should be_truthy
end

When /"Pivotal" updater receives information of the "default story" is labeled as finished/ do
  @task = Task.find_by(title: "pivotal story task")
  update_info = JSON.parse @task.updater_info
  update_info[:story_name].should equal?"default story"
  @task.task_status.should equal? "started"
  @task.update_status
end

Given /"Local" default "started" task is mapped to "google form"/ do
  @task = Task.new(title: "Local google form task", task_status: "started", updater_type: "github",
                   description: "this task is for testing the github call back")
  update_info = {}
  update_info[:google_doc_link] = "temp_google_doc_link"
  @task.updater_info = update_info.to_json
  @task.save.should be_truthy
end

When /"Local" updater receives information of a file is being submited/ do
  @task = Task.find_by(title: "Local google form task")
  update_info = JSON.parse @task.updater_info
  update_info[:google_doc_link].should equal?"temp_google_doc_link"
  @task.task_status.should equal? "started"
  @task.update_status
end

Then /All the projects should have status "assigned"/ do
  @projects = Project.all
  @projects.each do |proj|
    iter = Iteration.find_by{project_id:proj.id}
    iter.wont_be_nil
  end
end


