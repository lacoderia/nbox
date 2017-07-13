class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.integer :venue_id
      t.integer :distribution_id
      t.string :description

      t.timestamps null: false
    end
  end
end
