class ChangeUserTypeToRole < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.remove :user_type
      t.string :role
    end
  end

  def down
    change_table :users do |t|
      t.remove :role
      t.integer :user_type
    end
  end
end
