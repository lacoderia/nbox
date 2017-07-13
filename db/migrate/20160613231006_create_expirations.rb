class CreateExpirations < ActiveRecord::Migration
  def change
    create_table :expirations do |t|
      t.integer :user_id
      t.integer :classes_left
      t.datetime :last_class_purchased

      t.timestamps null: false
    end
  end
end
