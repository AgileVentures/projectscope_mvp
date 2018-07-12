class CreateTaskedge < ActiveRecord::Migration
  def change
    create_table :taskedges do |t|
      t.integer :childtask_id
      t.integer :parenttask_id
    end
  end
end
