class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :metric_sample, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :ctype
      t.text :content
      t.text :params
      t.timestamp :created_at

      t.timestamps null: false
    end
  end
end
