Before('@rake') do |scenario|
  unless $rake
    require 'rake'
    Rake.application.rake_require "tasks/project"
    Rake::Task.define_task(:environment)
    $rake = Rake::Task
  end
end