class AddRepetitionNumberToUserWordsAndReviews < ActiveRecord::Migration
  def change
    add_column :user_words, :repetition_number, :integer
    add_column :reviews, :previous_repetition_number, :integer
  end
end
