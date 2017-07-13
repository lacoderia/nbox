class AddPrimaryToCards < ActiveRecord::Migration
  def change
    add_column :cards, :primary, :boolean, default: false
  end
end
