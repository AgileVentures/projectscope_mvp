class AddProjectIndexToUser < ActiveRecord::Migration
  def change
    add_reference :users, :project, index: true, foreign_key: true
  end
end
