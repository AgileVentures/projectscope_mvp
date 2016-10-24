# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Project.create!(:name => "THE ARCTIC INSTITUTE", :metric_samples =>[
    MetricSample.create!(:metric_name => 'code_climate', :project_id => 1, :score => 7), 
    MetricSample.create!(:metric_name => 'github', :project_id => 1, :score => 2), 
    MetricSample.create!(:metric_name => 'slack', :project_id => 1, :score => 5),
    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 1, :score => 4),
    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 1, :score => 6)])
Project.create!(:name => "ALZHEIMER'S GREATER LOS ANGELES", :metric_samples =>[
    MetricSample.create!(:metric_name => 'code_climate', :project_id => 2, :score => 9), 
    MetricSample.create!(:metric_name => 'github', :project_id => 2, :score => 7), 
    MetricSample.create!(:metric_name => 'slack', :project_id => 2, :score => 15),
    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 2, :score => 14),
    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 2, :score => 4)])
Project.create!(:name => "VISIONARIA NETWORK", :metric_samples =>[
    MetricSample.create!(:metric_name => 'code_climate', :project_id => 3, :score => 9), 
    MetricSample.create!(:metric_name => 'github', :project_id => 3, :score => 4), 
    MetricSample.create!(:metric_name => 'slack', :project_id => 3, :score => 3),
    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 3, :score => 12),
    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 3, :score => 14)])
Project.create!(:name => "ACCCOS", :metric_samples =>[
    MetricSample.create!(:metric_name => 'code_climate', :project_id => 4, :score => 13), 
    MetricSample.create!(:metric_name => 'github', :project_id => 4, :score => 6), 
    MetricSample.create!(:metric_name => 'slack', :project_id => 4, :score => 9),
    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 4, :score => 3),
    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 4, :score => 7)])
Project.create!(:name => "ORINDA POLICE DEPARTMENT", :metric_samples =>[
    MetricSample.create!(:metric_name => 'code_climate', :project_id => 5, :score => 3), 
    MetricSample.create!(:metric_name => 'github', :project_id => 5, :score => 2), 
    MetricSample.create!(:metric_name => 'slack', :project_id => 5, :score => 5),
    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 5, :score => 4),
    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 5, :score => 6)])
Project.create!(:name => "ESENTIAL", :metric_samples =>[
    MetricSample.create!(:metric_name => 'code_climate', :project_id => 6, :score => 3), 
    MetricSample.create!(:metric_name => 'github', :project_id => 6, :score => 1), 
    MetricSample.create!(:metric_name => 'slack', :project_id => 6, :score => 7),
    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 6, :score => 5),
    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 6, :score => 9)])
Project.create!(:name => "ProjectScope", :metric_samples =>[
    MetricSample.create!(:metric_name => 'code_climate', :project_id => 7, :score => 23), 
    MetricSample.create!(:metric_name => 'github', :project_id => 7, :score => 22), 
    MetricSample.create!(:metric_name => 'slack', :project_id => 7, :score => 15),
    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 7, :score => 14),
    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 7, :score => 16)])
Project.create!(:name => "CALIFORNIA POETS IN THE SCHOOLS", :metric_samples =>[
    MetricSample.create!(:metric_name => 'code_climate', :project_id => 8, :score => 4), 
    MetricSample.create!(:metric_name => 'github', :project_id => 8, :score => 3), 
    MetricSample.create!(:metric_name => 'slack', :project_id => 8, :score => 7),
    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 8, :score => 3),
    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 8, :score => 5)])
Project.create!(:name => "QuestionBank",
                :configs => [
                    Config.create!(:metric_name => 'code_climate', :options => {'token' => 'xyz', 'user' => 'fox'}),
                    Config.create!(:metric_name => 'github', :options => {'token' =>'123', 'user'=>"fox"})], 
                :metric_samples =>[
                    MetricSample.create!(:metric_name => 'code_climate', :project_id => 9, :score => 5), 
                    MetricSample.create!(:metric_name => 'github', :project_id => 9, :score => 4), 
                    MetricSample.create!(:metric_name => 'slack', :project_id => 9, :score => 6),
                    MetricSample.create!(:metric_name => 'pivotal_tracker', :project_id => 9, :score => 2),
                    MetricSample.create!(:metric_name => 'slack_trends', :project_id => 9, :score => 6)])

    
