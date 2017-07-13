class CreateDistributions < ActiveRecord::Migration
  def change
    create_table :distributions do |t|
      t.integer :height
      t.integer :width
      t.string :description
      t.text :inactive_seats
      t.text :active_seats
      t.integer :total_seats

      t.timestamps null: false
    end
  end
end
