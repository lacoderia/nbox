class CreateCreditModifications < ActiveRecord::Migration
  def change
    create_table :credit_modifications do |t|
      t.integer :user_id
      t.integer :credits
      t.text :reason
    end
  end
end
