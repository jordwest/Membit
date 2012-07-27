class AddFailedToReviewsAndUserWords < ActiveRecord::Migration
  def change
    add_column :reviews, :was_failed, :boolean
    add_column :user_words, :failed, :boolean
  end
end
