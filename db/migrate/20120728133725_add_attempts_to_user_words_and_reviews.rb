class AddAttemptsToUserWordsAndReviews < ActiveRecord::Migration
  def change
    add_column :user_words, :attempts, :integer
    add_column :reviews, :previous_attempts, :integer
  end
end
