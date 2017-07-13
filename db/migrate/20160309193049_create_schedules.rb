class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.integer :instructor_id
      t.integer :room_id
      t.datetime :datetime

      t.timestamps null: false
    end
  end
end
