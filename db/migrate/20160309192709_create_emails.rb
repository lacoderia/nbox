class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.integer :user_id
      t.string :email_status
      t.string :email_type

      t.timestamps null: false
    end
  end
end
