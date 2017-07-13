class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.integer :pack_id
      t.integer :user_id
      t.string :uid
      t.string :object
      t.boolean :livemode
      t.string :status
      t.string :description
      t.integer :amount
      t.string :currency
      t.text :payment_method
      t.text :details

      t.timestamps null: false
    end
  end
end
