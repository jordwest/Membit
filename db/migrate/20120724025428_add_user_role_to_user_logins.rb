class AddUserRoleToUserLogins < ActiveRecord::Migration
  def change
    add_column :user_logins, :user_role, :string
  end
end
