class AddPhoneToCards < ActiveRecord::Migration
  def change
    add_column :cards, :phone, :string
  end
end
