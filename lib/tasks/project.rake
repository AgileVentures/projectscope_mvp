namespace :project do
  desc "Resample all the metrics for all the projects"
  task :resample_all => :environment do
    Project.all.shuffle.each &:resample_all_metrics
  end

  desc 'Resample all metrics for a given project'
  task :resample, [:pid] => :environment do |_, args|
    Project.find(args[:pid]).resample_all_metrics
  end

  desc 'Resample a given metric for a given project'
  task :resample_metric, [:pid, :metric] => :environment do |_, args|
    Project.find(args[:pid]).resample_metric(args[:metric])
  end
end
