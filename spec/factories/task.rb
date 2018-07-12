FactoryGirl.define do
  factory :task do
    title 'Test Title'
    trait :github do
      task_status 'started'
      updater_type 'github'
    end

    trait :pivotal do
      task_status 'started'
      updater_type 'pivotal'
    end

    trait :local do
      task_status 'started'
      updater_type 'local'
    end

    trait :preliminary do
      task_status 'started'
      updater_type 'preliminary'
    end

    trait :development do
      task_status 'started'
      updater_type 'development'
    end

    trait :post do
      task_status 'started'
      updater_type 'post'
    end

    trait :started do
      task_status 'started'
    end

    trait :finished do
      task_status 'finished'
    end

    trait :danger do
      task_status 'danger'
    end

    trait :unstarted do
      task_status 'unstarted'
    end

  end
end