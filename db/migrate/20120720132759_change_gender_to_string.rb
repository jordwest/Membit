class ChangeGenderToString < ActiveRecord::Migration
  def up
    change_table :user_infos do |t|
      t.remove :gender
      t.string :gender
    end
  end

  def down
    t.remove :gender
    t.integer :gender
  end
end
