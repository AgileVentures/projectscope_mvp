class AddUpdaterToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :updater_type, :string
    add_column :tasks, :update_time, :datetime
  end
end
