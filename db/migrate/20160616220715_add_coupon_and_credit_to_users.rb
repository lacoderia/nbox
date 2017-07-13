class AddCouponAndCreditToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coupon, :string
    add_column :users, :credits, :float, default: 0.0
  end
end
