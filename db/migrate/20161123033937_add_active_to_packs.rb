class AddActiveToPacks < ActiveRecord::Migration
  def change
    add_column :packs, :active, :boolean, default: true
  end
end
