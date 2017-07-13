class ModifyFieldsForInstructors < ActiveRecord::Migration
  def change
    remove_column :instructors, :email
    add_column :instructors, :admin_user_id, :integer
  end
end
