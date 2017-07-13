class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.integer :classes_left
      t.datetime :last_class_purchased
      t.string :picture
      #t.string :uid

      t.timestamps null: false
    end
  end
end
