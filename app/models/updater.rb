require 'json'
module Updater

  class Updater
  end

  # github updater to update the github task
  class GithubUpdater < Updater
    def self.update task,key,value
      # Here we are going to call event api in the future and receive call back
      task.update_attributes(task_status: 'finished')
    end

    def self.analysis_call_back githubdata
      nil
    end
  end

  # pivotal updater to update the github task
  class PivotalUpdater < Updater
    def self.update task,key,value
      task.update_attributes(task_status: 'finished')
    end

    def self.analysis_call_back pivotaldata
      nil
    end
  end

  # local updater to update the github task
  class LocalUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end

  # task that handle over the preliminary task
  class PreliminaryUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end

  class DevelopmentUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end

  class PostUpdater < Updater
    def self.update task, key, value
      if (value == 'true' and task.title == key)
        task.update_attributes(task_status: 'finished')
      end
    end

    def self.analysis_call_back localdata
      nil
    end
  end
end
