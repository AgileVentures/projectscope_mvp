require 'json'
class Taskedge < ActiveRecord::Base
  belongs_to :childtask, foreign_key: :childtask_id, class_name: "Task"
  belongs_to :parenttask, foreign_key: :parenttask_id, class_name: "Task"

  # use Taskedge to find all parents
  def self.find_parents child_id
    edges = Taskedge.where(childtask_id: child_id)
    if edges
      edges.map{|edge| edge.parenttask_id}
    else
      return nil
    end
  end

  # use Taskedge to find all children
  def self.find_children parent_id
    edges = Taskedge.where(parenttask_id: parent_id)
    if edges
      edges.map{ |edge| edge.childtask_id }
    else
      return nil
    end
  end

  # find the start node of a graph under the assumption that there is only one starter node
  def self.find_root nodes
    nodes.each { |node|
      if (Taskedge.find_parents node).empty?
        return node
      end
    }
  end
end
