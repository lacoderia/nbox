class AddHeadersToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :headers, :text
  end
end
