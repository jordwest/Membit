class FixUserInfoUserIdColumnName < ActiveRecord::Migration
  def up
    change_table :user_infos do |t|
      t.rename :user_id_id, :user_id
    end
  end

  def down
    change_table :user_infos do |t|
      t.rename :user_id, :user_id_id
    end
  end
end
