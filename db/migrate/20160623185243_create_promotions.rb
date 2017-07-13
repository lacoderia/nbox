class CreatePromotions < ActiveRecord::Migration
  def change
    create_table :promotions do |t|
      t.string :coupon
      t.string :description
      t.float :amount
      t.boolean :active

      t.timestamps null: false
    end

    add_index :promotions, :coupon, :unique => true
  end
end
