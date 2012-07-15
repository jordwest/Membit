class CreateUserInfos < ActiveRecord::Migration
  def change
    create_table :user_infos do |t|
      t.references :user_id
      t.integer :gender
      t.integer :english_first_language

      t.timestamps
    end
  end
end
