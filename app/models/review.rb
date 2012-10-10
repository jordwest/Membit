class Review < ActiveRecord::Base
  belongs_to :user_word
  belongs_to :user, :counter_cache => :reviews_count
  belongs_to :word
  attr_accessible :was_failed, :actual_interval, :correct, :overdue_time, :previous_attempts, :previous_correct_count, :previous_easiness_factor, :previous_incorrect_count, :previous_interval, :previous_repetition_number, :time_to_answer, :user_rated_answer, :was_due, :was_new, :user_role, :previous_time_to_answer, :previous_answer

  def export_attributes
    return [:word_average_easiness_factor]
  end

  scope :new_studied_today, lambda {
    subtract_3hrs = Time.now - 10800
    where(:was_new => true).where("created_at > ?", subtract_3hrs.beginning_of_day+10800)
  }

  scope :not_new, lambda {
    where(:was_new => false)
  }

  scope :active_users, joins(:user).where('users.reviews_count > ?', User::ACTIVE_THRESHOLD)

  scope :completed_today, lambda {
    subtract_3hrs = Time.now - 10800
    where(:correct => true).where("created_at > ?", subtract_3hrs.beginning_of_day+10800)
  }

  scope :participants_only, where({:user_role => :participant})

  def word_average_easiness_factor
    return self.word.average_easiness_factor
  end
end
