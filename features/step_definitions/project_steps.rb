Then /debug/ do
  1 if debugger
  1
end

When /^I enter new "(.*)" config values/ do |metric, table|
  fieldset_id = metric.downcase.gsub(' ', '_') # "Code Climate" => "code_climate"
  table.hashes.each do |h|
    credential = h['key']
    fill_in("#{fieldset_id}_#{credential}", :with => h['value'])
  end
end

Then /^there should be a project "(.*)" with config values/ do |name, table|
  proj = Project.includes(:configs).find_by_name!(name)
  table.hashes.each do |h|
    expect(proj.config_for(h['metric_name']).options[h['key']]).to eq(h['value'])
  end
end

Given(/^the following projects exist:$/) do |table|
  table.hashes.each do |hash|
    Project.create hash
  end
  @projects = Project.all
end

Given(/^they have the following metric configs:$/) do |table|
  table.hashes.each do |hash|
    project = Project.find_by(name: hash.delete('project'))
    existing_config = project.config_for(hash['metric_name'])
    new_options = existing_config.options
    new_options[hash['key'].to_sym] = hash['value']
    existing_config.options = new_options
    existing_config.save!
  end
end

Given(/^they have the following metric samples:$/) do |table|
  table.hashes.each do |hash|
    project = Project.find_by(name: hash.delete('project'))
    project.metric_samples << MetricSample.create(hash)
  end
end

Given(/^A project update job has been run$/) do
  $rake['project:resample_all'].execute
end

And(/^I am logged in$/) do
  steps %Q{
    Given admin with email "test-admin@test.com" and password "testadminofprojectscope" exists
    Given I am on the login page
    When I sign in as admin with email "test-admin@test.com" and password "testadminofprojectscope"
  }
end

Then(/^the config value "([^"]*)" should not appear in the page$/) do |value|
  expect(page.body).not_to match value
end

Given(/^the date is "([^"]*)"$/) do |date|
  date =~ /(\d{2})\/(\d{2})\/(\d{4})/
  month = Integer($1,10)
  day = Integer($2,10)
  year = Integer($3,10)
  new_time = Time.utc(year, month,day, 12, 0, 0)
  Timecop.travel(new_time)
end
# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  !(/#{e1}.*#{e2}/m =~ page.body).nil?
end