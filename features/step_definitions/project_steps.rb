Then /debug/ do
  1 if debugger
  1
end

When /^I enter new "(.*)" config values/ do |metric, table|
  fieldset_id = metric.downcase.gsub(' ', '_') # "Code Climate" => "code_climate"
  (table.hashes.length - 1).times do
    within "##{fieldset_id}" do
      click_link 'Add new'
    end
  end
  idx = 0
  all_inputs = page.all("fieldset##{fieldset_id} .newf")
  table.hashes.each do |h|
    all_inputs[idx].set h['key']
    all_inputs[idx+1].set h['value']
    idx += 2
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
  Project.all.each &:resample_all_metrics
end

And(/^I am logged in$/) do
  page.driver.basic_authorize('cs169', ENV['PROJECTSCOPE_PASSWORD'])
end