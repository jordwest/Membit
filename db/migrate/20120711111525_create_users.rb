class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_code
      t.string :password_hash
      t.string :password_salt
      t.string :password_reset
      t.integer :user_type
      t.datetime :last_login

      t.timestamps
    end
  end
end
