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
Task.delete_all
Taskedge.delete_all
Iteration.delete_all

# dummy1_code_climate = ProjectMetrics.class_for('code_climate').new url: 'http://github.com/AgileVentures/WebsiteOne'
# dummy2_code_climate = ProjectMetrics.class_for('code_climate').new url: 'http://github.com/AgileVentures/project_metric_slack'


# slack_trends1 = File.read './db/fake_data/spline1.json'
# slack_trends2 = File.read './db/fake_data/spline2.json'
# slack_trends3 = File.read './db/fake_data/spline3.json'

#TODO: code climate fake data is not consistent with real format.
code_climate1 = File.read './db/fake_data/codeclimate1.json'
code_climate2 = File.read './db/fake_data/codeclimate2.json'
code_climate3 = File.read './db/fake_data/codeclimate3.json'

collective_gauge1 = '{"chartType" : "gauge", "titleText" : "Collective Ownership GPA", "data" : {"score" : 3.5}}'
collective_gauge2 = '{"chartType" : "gauge", "titleText" : "Collective Ownership GPA", "data" : {"score" : 2.3}}'
collective_gauge3 = '{"chartType" : "gauge", "titleText" : "Collective Onwership GPA", "data" : {"score" : 1.6}}'

story_1 = open('./db/fake_data/p1.json', 'r') { |f| f.read }
story_2 = open('./db/fake_data/p2.json', 'r') { |f| f.read }
story_3 = open('./db/fake_data/p3.json', 'r') { |f| f.read }

point_est1 = open('./db/fake_data/point_est1.json', 'r') { |f| f.read }
point_est2 = open('./db/fake_data/point_est2.json', 'r') { |f| f.read }
point_est3 = open('./db/fake_data/point_est3.json', 'r') { |f| f.read }

pivot1 = File.read './db/fake_data/stories1.json'
pivot2 = File.read './db/fake_data/stories2.json'
pivot3 = File.read './db/fake_data/stories3.json'

github1 = File.read './db/fake_data/spline1.json'
github2 = File.read './db/fake_data/spline2.json'
github3 = File.read './db/fake_data/spline3.json'

#TODO: test coverage fake data is not consistent with real format.
test_coverage1 = File.read './db/fake_data/test_coverage1.json'
test_coverage2 = File.read './db/fake_data/test_coverage2.json'
test_coverage3 = File.read './db/fake_data/test_coverage3.json'

pull_requests1 = File.read './db/fake_data/pull_requests1.json'
pull_requests2 = File.read './db/fake_data/pull_requests2.json'
pull_requests3 = File.read './db/fake_data/pull_requests3.json'

travis_ci1 = File.read './db/fake_data/travis_ci1.json'
travis_ci2 = File.read './db/fake_data/travis_ci2.json'
travis_ci3 = File.read './db/fake_data/travis_ci3.json'

github_files1 = File.read './db/fake_data/github_files1.json'
github_files2 = File.read './db/fake_data/github_files2.json'
github_files3 = File.read './db/fake_data/github_files3.json'

github_flow1 = File.read './db/fake_data/github_flow1.json'
github_flow2 = File.read './db/fake_data/github_flow2.json'
github_flow3 = File.read './db/fake_data/github_flow3.json'

tracker_velocity1 = File.read './db/fake_data/tracker_velocity1.json'
tracker_velocity2 = File.read './db/fake_data/tracker_velocity2.json'
tracker_velocity3 = File.read './db/fake_data/tracker_velocity3.json'

# point_distribution1 = File.read './db/fake_data/tracker_distribution1.json'
# point_distribution2 = File.read './db/fake_data/tracker_distribution2.json'
# point_distribution3 = File.read './db/fake_data/tracker_distribution3.json'

story_overall1 = File.read './db/fake_data/story_overall1.json'
story_overall2 = File.read './db/fake_data/story_overall2.json'
story_overall3 = File.read './db/fake_data/story_overall3.json'

slack1 = File.read './db/fake_data/slack1.json'
slack2 = File.read './db/fake_data/slack2.json'
slack3 = File.read './db/fake_data/slack3.json'

point_distribution1 = File.read './db/fake_data/point_distribution1.json'
point_distribution2 = File.read './db/fake_data/point_distribution2.json'
point_distribution3 = File.read './db/fake_data/point_distribution3.json'

smart_story1 = File.read './db/fake_data/smart_story1.json'
smart_story2 = File.read './db/fake_data/smart_story2.json'
smart_story3 = File.read './db/fake_data/smart_story3.json'

commit_message1 = File.read './db/fake_data/commit_message1.json'
commit_message2 = File.read './db/fake_data/commit_message2.json'
commit_message3 = File.read './db/fake_data/commit_message3.json'

dummies = Hash.new
dummies["code_climate"] = [code_climate1, code_climate2, code_climate3]
dummies["github"] = [github1, github2, github3]
dummies["slack"] = [slack1, slack2,	slack3]
dummies["pivotal_tracker"] = [pivot1, pivot2, pivot3]
# dummies["slack_trends"] = [slack_trends1, slack_trends2, slack_trends3]
dummies["story_transition"] = [story_1, story_2, story_3]
dummies["point_estimation"] = [point_est1, point_est2, point_est3]
dummies["story_overall"] = [story_overall1, story_overall2, story_overall3]
dummies["collective_overview"] = [collective_gauge1, collective_gauge2, collective_gauge3]
dummies["test_coverage"] = [test_coverage1, test_coverage2, test_coverage3]
dummies["pull_requests"] = [pull_requests1, pull_requests2, pull_requests3]
dummies["travis_ci"] = [travis_ci1, travis_ci2, travis_ci3]
dummies["github_files"] = [github_files1, github_files2, github_files3]
dummies["github_flow"] = [github_flow1, github_flow2, github_flow3]
dummies["tracker_velocity"] = [tracker_velocity1, tracker_velocity2, tracker_velocity3]
dummies["point_distribution"] = [point_distribution1, point_distribution2, point_distribution3]
dummies["smart_story"] = [smart_story1, smart_story2, smart_story3]
dummies["commit_message"] = [commit_message1, commit_message2, commit_message3]

projects_list = []
0.upto(10).each do |num|
  projects_list << Project.create!(name: "Project #{num}")
end

# create iteration
iteration = Iteration.create(name: "Iteration 0", template: true)
# create the seed for task graph
t1 = Task.create(title: 'Customer Meeting',
                 iteration: iteration,
                 description: 'Some contents about Task 1',
                 task_status: 'finished',
                 updater_type: 'preliminary',
                 task_callbacks: 'hello_world')
t2 = Task.create(title: 'Iteration Planning',
                 iteration: iteration,
                 description: 'Some contents about Task 2',
                 task_status: 'finished',
                 updater_type: 'preliminary',
                 task_callbacks: 'hello_world')
t4 = Task.create(title: 'Test Title',
                 iteration: iteration,
                 description: 'Some contents about Task 4',
                 task_status: 'danger',
                 updater_type: 'preliminary',
                 task_callbacks: 'hello_world')
t5 = Task.create(title: 'GSI Meeting',
                 iteration: iteration,
                 description: 'Some contents about Task 5',
                 task_status: 'finished',
                 updater_type: 'preliminary',
                 task_callbacks: 'hello_world')
t6 = Task.create(title: 'Scrum meeting',
                 iteration: iteration,
                 description: 'Some contents about Task 6',
                 task_status: 'unstarted',
                 updater_type: 'preliminary',
                 task_callbacks: 'hello_world')
t7 = Task.create(title: 'Configuration Setup',
                 iteration: iteration,
                 description: 'Some contents about Task 7',
                 task_status: 'unstarted',
                 updater_type: 'preliminary',
                 task_callbacks: 'hello_world')
t8 = Task.create(title: 'Lo-fi Mockup',
                 iteration: iteration,
                 description: 'Some contents about Task 8',
                 task_status: 'started',
                 updater_type: 'development',
                 task_callbacks: 'hello_world')
t10 = Task.create(title: 'Pair programming',
                 iteration: iteration,
                 description: 'Some contents about Task 8',
                 task_status: 'started',
                 updater_type: 'development',
                 task_callbacks: 'hello_world')
t9 = Task.create(title: 'Scrum Meeting',
                 iteration: iteration,
                 description: 'Pass only get accepted by customers',
                 task_status: 'unstarted',
                 updater_type: 'development',
                 task_callbacks: 'hello_world')
t11 = Task.create(title: 'Code Review',
                 iteration: iteration,
                 description: 'Pass only get accepted by customers',
                 task_status: 'unstarted',
                 updater_type: 'development',
                 task_callbacks: 'hello_world')
t12 = Task.create(title: 'Finish Story',
                 iteration: iteration,
                 description: 'Pass only get accepted by customers',
                 task_status: 'unstarted',
                 updater_type: 'development',
                 task_callbacks: 'hello_world')
t13 = Task.create(title: 'TDD and BDD',
                  iteration: iteration,
                  description: 'Pass only get accepted by customers',
                  task_status: 'unstarted',
                  updater_type: 'development',
                  task_callbacks: 'hello_world')
t14 = Task.create(title: 'Points Estimation',
                  iteration: iteration,
                  description: 'Pass only get accepted by customers',
                  task_status: 'unstarted',
                  updater_type: 'development',
                  task_callbacks: 'hello_world')
t15 = Task.create(title: 'Pull Request',
                  iteration: iteration,
                  description: 'Pass only get accepted by customers',
                  task_status: 'unstarted',
                  updater_type: 'development',
                  task_callbacks: 'hello_world')
t16 = Task.create(title: 'Deploy',
                  iteration: iteration,
                  description: 'Pass only get accepted by customers',
                  task_status: 'unstarted',
                  updater_type: 'post',
                  task_callbacks: 'hello_world')
t17 = Task.create(title: 'Cross Group Review',
                  iteration: iteration,
                  description: 'Pass only get accepted by customers',
                  task_status: 'unstarted',
                  updater_type: 'post',
                  task_callbacks: 'hello_world')
t18 = Task.create(title: 'Customer Feedback',
                  iteration: iteration,
                  description: 'Pass only get accepted by customers',
                  task_status: 'unstarted',
                  updater_type: 'post',
                  task_callbacks: 'hello_world')

Taskedge.create(childtask_id: t2.id, parenttask_id: t1.id)
Taskedge.create(childtask_id: t4.id, parenttask_id: t2.id)
Taskedge.create(childtask_id: t5.id, parenttask_id: t2.id)
Taskedge.create(childtask_id: t7.id, parenttask_id: t4.id)
Taskedge.create(childtask_id: t8.id, parenttask_id: t5.id)
Taskedge.create(childtask_id: t9.id, parenttask_id: t4.id)
Taskedge.create(childtask_id: t10.id, parenttask_id: t5.id)
Taskedge.create(childtask_id: t11.id, parenttask_id: t7.id)
Taskedge.create(childtask_id: t12.id, parenttask_id: t11.id)

end_date = Date.today
start_date = end_date - 7.days

Config.delete_all

projects_list.each do |project|
  ProjectMetrics.metric_names.each do |metric|
    if TRUE
      start_date.upto(end_date) do |date|
        3.times do
          m = MetricSample.create!(:metric_name => metric,
                                   :project_id => project.id,
                                   :score => rand(0.0..4.0).round(2),
                                   :image => dummies[metric].sample,
                                   :created_at => date)
          rand(3).times do
            m.comments << Comment.new(content: "Comment on #{date} for #{metric}",
                                      ctype: 'general_comment',
                                      params: '{}',
                                      created_at: date.beginning_of_day)
          end
        end
      end
      ProjectMetrics.class_for(metric).credentials.each do |param|
        next unless rand > 0.5
        Config.create(metric_name: metric,
                      project_id: project.id,
                      token: (0...50).map { ('a'..'z').to_a[rand(26)] }.join,
                      metrics_params: param)
      end
    end
  end
end

# preferred_metrics = [{
#                          'code_climate' => [],
#                          'test_coverage' => [],
#                          'pull_requests' => [],
#                          'github_files' => [],
#                          'github_flow' => [],
#                      }, {
#                          'travis_ci' => [],
#                          'tracker_velocity' => [],
#                          'point_estimation' => [],
#                          'story_overall' => [],
#                          'slack' => []
#                      }]

@user01 = User.create!(provider_username: "Admin", uid: "uadmin", email: 'uadmin@example.com',
                       provider: "developer", role: User::ADMIN, password: Devise.friendly_token[0,20],
                       preferred_metrics: [], preferred_projects: projects_list)
@user02 = User.create!(provider_username: "Instructor", uid: "uinstructor", email: 'uinstructor@example.com',
											 provider: "developer", role: User::INSTRUCTOR, password: Devise.friendly_token[0,20],
											 preferred_metrics: [], preferred_projects: projects_list)
@user03 = User.create!(provider_username: "Student", uid: "ustudent", email: 'ustudent@example.com',
											 provider: "developer", role: User::STUDENT, password: Devise.friendly_token[0,20],
											 preferred_metrics: [], preferred_projects: projects_list)
Whitelist.create!(username: @user01.provider_username)
