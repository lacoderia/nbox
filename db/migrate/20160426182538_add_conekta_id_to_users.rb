class AddConektaIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :conekta_id, :string
  end
end
