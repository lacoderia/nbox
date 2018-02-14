class AddOldConektaIdAndOldClassesLeftToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :old_conekta_id, :string
    add_column :users, :old_classes_left, :integer
  end
end
