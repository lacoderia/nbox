class AddIsBeingUpdatedToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :is_being_updated, :boolean, :default => false
  end
end
