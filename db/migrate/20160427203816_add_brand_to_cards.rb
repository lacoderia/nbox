class AddBrandToCards < ActiveRecord::Migration
  def change
    add_column :cards, :brand, :string
  end
end
