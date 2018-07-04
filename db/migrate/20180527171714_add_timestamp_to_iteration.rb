class AddTimestampToIteration < ActiveRecord::Migration
  def change
    add_column :iterations, :start_time, :datetime
    add_column :iterations, :end_time, :datetime
  end
end
