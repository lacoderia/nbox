class JoinPromotionsUsers < ActiveRecord::Migration
  def up
    create_table :promotions_users, :id => false do |t|
      t.references :promotion, :user
    end
    add_foreign_key :promotions_users, :users
    add_foreign_key :promotions_users, :promotions
  end

  def down
    drop_table :promotions_users
  end
end
