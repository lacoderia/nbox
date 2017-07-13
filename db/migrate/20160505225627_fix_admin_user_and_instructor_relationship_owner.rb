class FixAdminUserAndInstructorRelationshipOwner < ActiveRecord::Migration
  def change
    remove_column :instructors, :admin_user_id
    add_column :admin_users, :instructor_id, :integer
  end
end
