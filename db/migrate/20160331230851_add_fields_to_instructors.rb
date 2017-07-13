class AddFieldsToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :bio, :text
    add_column :instructors, :quote, :string
  end
end
