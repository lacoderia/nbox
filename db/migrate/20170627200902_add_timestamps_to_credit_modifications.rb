class AddTimestampsToCreditModifications < ActiveRecord::Migration
  def change
    add_column(:credit_modifications, :created_at, :datetime)
    add_column(:credit_modifications, :updated_at, :datetime)
  end
end
