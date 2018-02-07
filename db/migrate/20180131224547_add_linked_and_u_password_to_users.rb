class AddLinkedAndUPasswordToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :linked, :boolean, default: false
    add_column :users, :u_password, :string
  end
end
