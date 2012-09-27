class AddReviewsCountToUsers < ActiveRecord::Migration
  def up
    add_column :users, :reviews_count, :integer

    User.reset_column_information
    User.all.each do |u|
      User.reset_counters(u.id, :reviews)
    end
  end

  def down
    remove_column :users, :reviews_count
  end
end
