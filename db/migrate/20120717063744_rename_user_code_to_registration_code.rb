class RenameUserCodeToRegistrationCode < ActiveRecord::Migration
  def change
    rename_column :users, :user_code, :registration_code
  end
end
