class AddActualIntervalToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :actual_interval, :float
  end
end
