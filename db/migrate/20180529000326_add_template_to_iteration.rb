class AddTemplateToIteration < ActiveRecord::Migration
  def change
    add_column :iterations, :template, :boolean
  end
end
