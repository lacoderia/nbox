class AddExpirationToPacks < ActiveRecord::Migration
  def change
    add_column :packs, :expiration, :integer
  end
end
