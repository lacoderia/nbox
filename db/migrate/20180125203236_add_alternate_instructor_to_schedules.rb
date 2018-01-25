class AddAlternateInstructorToSchedules < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :alternate_instructor_id, :integer
  end
end
