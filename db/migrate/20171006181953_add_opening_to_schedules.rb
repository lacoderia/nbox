class AddOpeningToSchedules < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :opening, :boolean, default: false
  end
end
