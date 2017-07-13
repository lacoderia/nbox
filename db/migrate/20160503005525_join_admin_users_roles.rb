class JoinAdminUsersRoles < ActiveRecord::Migration
  def up
    create_table :admin_users_roles, :id => false do |t|
      t.references :admin_user, :role
    end
  end

  def down
    drop_table :admin_users_roles
  end
end
