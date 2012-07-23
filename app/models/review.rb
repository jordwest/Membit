class Review < ActiveRecord::Base
  belongs_to :user_word
  attr_accessible :correct, :overdue_time, :previous_correct_count, :previous_easiness_factor, :previous_incorrect_count, :previous_interval, :time_to_answer, :user_rated_answer, :was_due, :was_new, :user_role
end
