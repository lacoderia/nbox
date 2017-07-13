class AddFieldsToPacks < ActiveRecord::Migration
  def change
    remove_column :packs, :amount
    add_column :packs, :special_price, :float
    add_column :packs, :price, :float
  end
end
