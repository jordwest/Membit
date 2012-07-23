class CreateUserLogins < ActiveRecord::Migration
  def change
    create_table :user_logins do |t|
      t.references :user
      t.float :time_since_last_view
      t.integer :cards_due
      t.integer :new_cards

      t.timestamps
    end
    add_index :user_logins, :user_id
  end
end
