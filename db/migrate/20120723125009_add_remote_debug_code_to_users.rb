class AddRemoteDebugCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remote_debug_code, :string
  end
end
