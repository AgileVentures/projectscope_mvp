require 'json'
class Task < ActiveRecord::Base
  belongs_to :iteration

  # many to many self join to realise the task graph join table
  has_many :childrentask, through: :childedge, source: :childtask
  has_many :childedge, foreign_key: :childedge_id, class_name: "Taskedge"

  has_many :parentstask, through: :parentedge, source: :parenttask
  has_many :parentedge, foreign_key: :parentedge_id, class_name: "Taskedge"

  scope :require_updating, -> { where("status = 'started'") }
  include Updater

  Status = %w[unstarted started finished danger].freeze
  StatusLink = {
    unstarted: :started,
    started: :finished,
    danger: :finished
  }.stringify_keys.freeze
  Updaters = %w[github pivotal local preliminary development post].freeze
  UPDATER = {
    github: GithubUpdater,
    pivotal: PivotalUpdater,
    local: LocalUpdater,
    preliminary: PreliminaryUpdater,
    development: DevelopmentUpdater,
    post: PostUpdater
  }.stringify_keys.freeze
  DevTaskTitles = ['Lo-fi Mockup', 'Pair programming', 'Code Review',
                   'Finish Story', 'TDD and BDD', 'Points Estimation',
                   'Pull Request'].freeze
  PreTaskTitles = ['Customer Meeting', 'Iteration Planning', 'GSI Meeting',
                   'Scrum meeting', 'Configuration Setup', 'Test Title'].freeze
  PostTaskTitles = ['Deploy', 'Cross Group Review', 'Customer Feedback'].freeze
  validates :task_status, presence: true, inclusion: { in: Status }
  validates :updater_type, presence: true, inclusion: { in: Updaters }
  validates :title, inclusion: { in: PreTaskTitles | DevTaskTitles | PostTaskTitles }

  def self.abstract_graph(start_task)
    children = Taskedge.find_children(start_task)
    graph = Hash.new
    visited = Array.new(children)
    visited.append(start_task)
    graph[start_task] = Array.new(children)
    until children.empty?
      newnode = children.shift
      newchildren = Taskedge.find_children newnode
      graph[newnode] = Array.new(newchildren)
      newchildren.delete_if{|child| visited.include? child}
      visited.concat(newchildren)
      children.concat(newchildren)
    end
    JSON.generate(graph)
  end

  def updatable?
    (task_status == 'started') or (task_status == 'danger')
  end

  def startable?
    task_status == 'unstarted'
  end

  def self.no_started? task
    parents = Taskedge.find_parents task
    parents.each do |parent|
      if Task.find(parent).task_status != 'finished'
        return true
      end
    end
    false
  end

  def self.add_taskedge(parent_id, child_id)
    if Task.exists?(parent_id) and Task.exists?(child_id)
      edge = Taskedge.new
      edge.parenttask_id = parent_id
      edge.childtask_id = child_id
      edge.save
    else
      nil
    end
  end

  def update_status(event_name, event_function)
    # we will use the event name to find out the updater in upcoming week
    return self unless updatable?
    UPDATER[updater_type].update self, event_name, event_function
    self
    #next_status = StatusLink[self.task_status]
    #self.update_attributes(task_status: next_status)
  end

  # iterate through
  def self.tasks_update_all(tasks, event_name, event_value)
    tasks.each do |task|
      task.update_status event_name, event_value
    end
  end

  def callback_updater(key, value)
    if UPDATER[updater_type].analysis_call_back ({key => value})
      update_attributes(task_status: next_status)
    end
  end

  def start_task
    false
    if startable?
      next_status = StatusLink[task_status]
      update_attributes(task_status: next_status)
    end
  end

  def reset_status
    update_attributes(task_status: 'unstarted')
  end
end
