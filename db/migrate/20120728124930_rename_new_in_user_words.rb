class RenameNewInUserWords < ActiveRecord::Migration
  def up
    change_table :user_words do |t|
      t.rename :new, :new_card
    end
  end

  def down
    change_table :user_words do |t|
      t.rename :new_card, :new
    end
  end
end
