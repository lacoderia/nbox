class AddPicture2ToInstructors < ActiveRecord::Migration
  def change
    add_column :instructors, :picture_2, :string
  end
end
