class ChangeDateColumnsForCards < ActiveRecord::Migration
  def change
    change_column :cards, :exp_year, :string
    change_column :cards, :exp_month, :string
  end
end
