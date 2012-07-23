class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :user_word
      t.references :word
      t.references :user

      # The follow fields should be pulled from the user_word record
      t.boolean :was_new
      t.integer :previous_interval
      t.datetime :was_due
      t.float :overdue_time
      t.integer :previous_incorrect_count
      t.integer :previous_correct_count
      t.float :previous_easiness_factor

      # The following fields should be set when creating an object
      t.integer :user_rated_answer
      t.float :time_to_answer

      # This field should be set based on the user_rated_answer
      t.boolean :correct

      t.timestamps
    end
    add_index :reviews, :user_word_id
  end
end
