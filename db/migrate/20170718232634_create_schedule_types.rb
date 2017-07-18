class CreateScheduleTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :schedule_types do |t|
      t.string :description
      t.boolean :active, :default => true
    end
  end
end
