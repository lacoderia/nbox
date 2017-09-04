class AddTestToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :test, :boolean, default: false
  end
end
