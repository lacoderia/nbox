class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :user_id
      t.string :status
      t.integer :schedule_id
      t.integer :bicycle_number
      t.datetime :start
      t.string :description
      t.text :anomaly

      t.timestamps null: false
    end
  end
end
