source 'https://rubygems.org'

ruby '2.3.1'

# Gems for metrics to use
gem 'project_metrics', git: 'https://github.com/AgileVentures/ProjectMetrics/'
gem 'project_metric_code_climate', git: 'https://github.com/an-ju/project_metric_code_climate'
# gem 'project_metric_github', git: 'https://github.com/AgileVentures/project_metric_github'
gem 'project_metric_slack', git: 'https://github.com/an-ju/project_metric_slack'
# gem 'project_metric_pivotal_tracker', git: 'https://github.com/AgileVentures/project_metric_pivotal_tracker'
gem 'project_metric_slack_trends', git: 'https://github.com/an-ju/project_metric_slack_trends'
gem 'project_metric_github', git: 'https://github.com/an-ju/project_metric_github'
gem 'project_metric_pivotal_tracker', git: 'https://github.com/an-ju/project_metric_pivotal_tracker'
gem 'project_metric_story_transition', git: 'https://github.com/an-ju/project_metric_story_transitions'

gem 'highcharts-rails'

# use Rails 3-style protected attributes rather than strong params
gem 'protected_attributes'
# Securely store secrets, including symmetric encrypt key for attr_encrypted
gem 'attr_encrypted'
gem 'figaro'

gem 'rake'
gem 'rails', '4.2.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'haml'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'timecop'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'devise'
gem 'json'
gem 'omniauth-github', github: 'intridea/omniauth-github'

gem 'bootstrap-sass', '~> 3.3.6'
gem "font-awesome-rails"
gem 'jquery-ui-rails'
gem 'jquery-turbolinks'
gem 'sprockets-rails', '~> 3.1.1'

group :development, :test do
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'annotate'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem "jasmine"
  gem 'jasmine-jquery-rails'
end

group :test do
  gem 'rspec-rails'
  gem 'cucumber-rails'
  gem 'cucumber-rails-training-wheels'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'simplecov'
  gem 'launchy'
  gem 'poltergeist'
  gem 'phantomjs', :require => 'phantomjs/poltergeist'
  gem 'vcr'
  gem 'webmock'
  gem 'codeclimate-test-reporter', require: nil
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :production do
  gem 'rails_12factor'
  gem 'pg'
end
