class CreateWhitelists < ActiveRecord::Migration
  def change
    create_table :whitelists, :force => true  do |t|
      t.string :email                  # default: "",      null: false
    end
    add_index :whitelists, :email
  end
end

