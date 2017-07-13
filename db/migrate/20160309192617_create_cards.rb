class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.integer :user_id
      t.string :uid
      t.string :object
      t.boolean :active
      t.string :last4
      t.datetime :exp_month
      t.datetime :exp_year
      t.string :name
      t.text :address

      t.timestamps null: false
    end
  end
end
