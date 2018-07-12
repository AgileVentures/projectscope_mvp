class AddUpdaterInfoToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :updater_info, :string
  end
end
