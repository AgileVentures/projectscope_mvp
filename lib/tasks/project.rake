namespace :project do
  desc "Resample all the metrics for all the projects"
  task :resample_all => :environment do
    Project.all.each &:resample_all_metrics
  end
end
