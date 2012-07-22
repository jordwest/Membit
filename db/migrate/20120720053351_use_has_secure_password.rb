class UseHasSecurePassword < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.remove :password_reset, :password_salt, :password_hash
      t.string :password_digest
    end
  end

  def down
    t.string :password_reset, :password_salt, :password_hash
    t.remove :password_digest
  end
end
