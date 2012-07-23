class AddMobileTypeToUserLogins < ActiveRecord::Migration
  def change
    add_column :user_logins, :mobile, :boolean
  end
end
