class AddActiveToIteration < ActiveRecord::Migration
  def change
    add_column :iterations, :active, :boolean
  end
end
