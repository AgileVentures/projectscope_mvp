class Task < ActiveRecord::Base
  belongs_to :iteration

  # many to many self join to realise the task graph join table
  has_many :childrentask, through: :childedge, source: :childtask
  has_many :childedge, foreign_key: :childedge_id, class_name: "Taskedge"

  has_many :parentstask, through: :parentedge, source: :parenttask
  has_many :parentedge, foreign_key: :parentedge_id, class_name: "Taskedge"

  has_many :updaters

  # scope :require_updating, -> { where("status = 'STARTED'") }
  include Updater

  Status = ['unstarted', 'started', 'finished','danger']
  StatusLink = {
    'unstarted' => 'started',
    'started' => 'finished',
    'danger' => 'finished'
  }
  validates :task_status, presence: true, inclusion: { in: Status }

  def self.abstract_graph start_task
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

  def self.no_update? task
    parents = Taskedge.find_parents task
    parents.each do |parent|
      if Task.find(parent).task_status != 'finished'
        return true
      end
    end
    false
  end

  def self.add_taskedge parent_id, child_id
    if ( Task.exists?(parent_id) and Task.exists?(child_id) )
      edge = Taskedge.new
      edge.parenttask_id = parent_id
      edge.childtask_id = child_id
      edge.save
    else
      nil
    end
  end

  def self.update_status task
    next_status = StatusLink[task.task_status]
    task.update_attributes(task_status: next_status)
  end

  def self.reset_status task
    task.update_attributes(task_status: 'unstarted')
  end
end
