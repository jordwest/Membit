class Review < ActiveRecord::Base
  belongs_to :user_word
  belongs_to :user
  belongs_to :word
  attr_accessible :was_failed, :actual_interval, :correct, :overdue_time, :previous_correct_count, :previous_easiness_factor, :previous_incorrect_count, :previous_interval, :previous_repetition_number, :time_to_answer, :user_rated_answer, :was_due, :was_new, :user_role
end
