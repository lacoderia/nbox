class AddFreeToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :free, :boolean, default: false
  end
end
