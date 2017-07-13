class CreateReferrals < ActiveRecord::Migration
  def change
    create_table :referrals do |t|
      t.integer :owner_id
      t.integer :referred_id
      t.float :credits
      t.boolean :used, default: false

      t.timestamps null: false
    end
  end
end
