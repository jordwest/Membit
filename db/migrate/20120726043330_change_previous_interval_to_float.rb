class ChangePreviousIntervalToFloat < ActiveRecord::Migration
  def up
    change_table :reviews do |t|
      t.remove :previous_interval
      t.float :previous_interval
    end
  end

  def down
    change_table :reviews do |t|
      t.remove :previous_interval
      t.integer :previous_interval
    end
  end
end
