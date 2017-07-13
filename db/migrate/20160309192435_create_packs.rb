class CreatePacks < ActiveRecord::Migration
  def change
    create_table :packs do |t|
      t.string :description
      t.integer :classes
      t.float :amount

      t.timestamps null: false
    end
  end
end
