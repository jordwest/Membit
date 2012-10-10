class AddExtraVarsToReviews < ActiveRecord::Migration
  def up
    add_column :reviews, :previous_answer, :integer
    add_column :reviews, :previous_time_to_answer, :float

    # Copy over the data for each user_word
    UserWord.all.each do |user_word|
      previous_answer = nil
      previous_time_to_answer = nil
      user_word.reviews.find_each do |review|
        review.previous_answer = previous_answer
        review.previous_time_to_answer = previous_time_to_answer

        previous_answer = review.user_rated_answer
        previous_time_to_answer = review.time_to_answer

        review.save
      end
    end
  end

  def down
    remove_column :reviews, :previous_answer
    remove_column :reviews, :previous_time_to_answer
  end
end
