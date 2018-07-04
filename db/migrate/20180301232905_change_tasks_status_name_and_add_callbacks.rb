class ChangeTasksStatusNameAndAddCallbacks < ActiveRecord::Migration
  def change
    remove_column :tasks, :status
    add_column :tasks, :task_status, :string
    add_column :tasks, :task_callbacks, :string
  end
end
