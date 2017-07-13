class AddPackToCreditModifications < ActiveRecord::Migration
  def change
    add_column :credit_modifications, :pack_id, :integer
  end
end
