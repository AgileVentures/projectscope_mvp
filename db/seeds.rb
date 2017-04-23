# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# require 'project_metric_code_climate'
# require 'project_metric_slack_trends'
# require 'project_metric_pivotal_tracker'

User.delete_all
Whitelist.delete_all
Project.delete_all
MetricSample.delete_all

# dummy1_code_climate = ProjectMetrics.class_for('code_climate').new url: 'http://github.com/AgileVentures/WebsiteOne'
# dummy2_code_climate = ProjectMetrics.class_for('code_climate').new url: 'http://github.com/AgileVentures/project_metric_slack'





slack1 = '{
							"chartType":"pie",
							"titleText":"Activity",
							"data":[{
												"name": "Activity",
												 "colorByPoint": true,
										     "data": [{
													 "name": "Calvin Yu",
													 "y": 56.33
												 }, {
													 "name": "Harry",
													 "y": 24.03,
													 "sliced": true,
													 "selected": true
												 }, {
													 "name": "Steven",
													 "y": 10.38
												 }, {
													 "name": "Joseph",
													 "y": 4.77
										     }, {
													 "name": "Levin",
													 "y": 0.91
										     }, {
													 "name": "Clark",
													 "y": 0.2
										     }]
										 }]
					}'
slack2 = '{
							"chartType":"pie",
							"titleText":"Activity",
							"data":[{
												"name": "Activity",
												 "colorByPoint": true,
										     "data": [{
													 "name": "Calvin Yu",
													 "y": 35.27
												 }, {
													 "name": "Harry",
													 "y": 33.10,
													 "sliced": true,
													 "selected": true
												 }, {
													 "name": "Steven",
													 "y": 24.72
												 }, {
													 "name": "Joseph",
													 "y": 19.60
										     }, {
													 "name": "Levin",
													 "y": 6.42
										     }, {
													 "name": "Clark",
													 "y": 9.91
										     }]
										 }]
					}'
slack3 = '{
							"chartType":"pie",
							"titleText":"Activity",
							"data":[{
												"name": "Activity",
												 "colorByPoint": "true",
										     "data": [{
													 "name": "Calvin Yu",
													 "y": 10.13
												 }, {
													 "name": "Harry",
													 "y": 24.57,
													 "sliced": true,
													 "selected": true
												 }, {
													 "name": "Steven",
													 "y": 18.12
												 }, {
													 "name": "Joseph",
													 "y": 2.47
										     }, {
													 "name": "Levin",
													 "y": 21.60
										     }, {
													 "name": "Clark",
													 "y": 1.91
										     }]
										 }]
					}'
dummy1_code_climate = slack1
dummy2_code_climate = slack3
slack_trends1 = '{
										"chartType" : "spline",
										"titleText" : "Foo",
										"subtitleText" : "",
										"xAxisTitleText" : "",
										"yAxisTitleText" : "",
										"data" : [[0, 9], [1, 7], [2, 0], [3, 1], [4, 5],
												[5, 3], [6, 2], [7, 9], [8, 0]]
								}'
slack_trends2 = '{
										"chartType" : "spline",
										"titleText" : "Bar",
										"subtitleText" : "",
										"xAxisTitleText" : "",
										"yAxisTitleText" : "",
										"data" : [[0, 8], [1, 1], [2, 5], [3, 1], [4, 0],
												[5, 7], [6, 3], [7, 6], [8, 7]]
								}'
slack_trends3 = '{
										"chartType" : "spline",
										"titleText" : "Fubar",
										"subtitleText" : "",
										"xAxisTitleText" : "",
										"yAxisTitleText" : "",
										"data" : [[0, 7], [1, 3], [2, 7], [3, 3], [4, 0],
												[5, 9], [6, 5], [7, 8], [8, 5]]
								}'
# slack_trends2 = File.read './db/images/slack_trends2.svg'
# slack_trends3 = File.read './db/images/slack_trends3.svg'
pivot1 = slack1
pivot2 = slack2
github1 = slack_trends1
github2 = slack_trends2
github3 = slack_trends3


dummies = Hash.new
dummies["code_climate"] = [dummy1_code_climate,
													 dummy2_code_climate,
													 dummy1_code_climate]
dummies["github"] = [github1,
	                   github2,
										 github3]
dummies["slack"] = [slack1,
	                  slack2,
										slack3]
dummies["pivotal_tracker"] = [pivot1,
	                            pivot2,
															pivot2]
dummies["slack_trends"] = [slack_trends1,
	                         slack_trends2,
													 slack_trends3]

projects_list = []
0.upto(10).each do |num|
	projects_list << Project.create!(:name => "Project #{num}")
end

end_date = Date.today
start_date = end_date - 7.days


projects_list.each do |project|
    ProjectMetrics.metric_names.each do |metric|
        if rand(100) % 3 != 0
            start_date.upto(end_date) do |date|
                MetricSample.create!(:metric_name => metric,
                                 :project_id => project.id,
                                 :score => rand(0.0..4.0).round(2),
                                 :image => dummies[metric][rand(3)],
                                 :created_at => date)
            end
        end
    end
end

@user01 = User.create!(provider_username: "Clarkkkk", uid: "Clark",
    provider: "developer", role: "admin", password: Devise.friendly_token[0,20])
Whitelist.create!(username: @user01.provider_username)
