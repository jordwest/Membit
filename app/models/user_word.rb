class UserWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  #attr_accessible :correct_count, :easiness_factor, :incorrect_count, :interval, :last_review, :new, :next_due

  has_many :reviews

  after_initialize :defaults

  scope :due, lambda {
    where("next_due < ?", Time.now.end_of_day)
  }

  scope :not_studied, where(:new => true)
  scope :short_term, where("interval between ? and ?", 1, 14).where(:new => false)
  scope :long_term, where("interval > ?", 14).where(:new => false)

  def defaults
    self.correct_count ||= 0
    self.easiness_factor ||= 2.5
    self.incorrect_count ||= 0
    self.interval ||= 0
    self.new ||= 1
  end

  # Records a review for this user's word
  def do_review(answer, time_to_answer_in_seconds)
    new_review = self.reviews.new
    new_review.user = self.user
    new_review.word = self.word
    if self.next_due.nil?
      overdue_time = 0
    else
      overdue_time = (self.next_due - Time.now) / 86400 # seconds -> days
    end
    new_review.update_attributes({:was_new => self.new,
                                 :previous_interval => self.interval,
                                 :was_due => self.next_due,
                                 :overdue_time => overdue_time,
                                 :previous_incorrect_count => self.incorrect_count,
                                 :previous_correct_count => self.correct_count,
                                 :previous_easiness_factor => self.easiness_factor,
                                 :user_rated_answer => answer,
                                 :time_to_answer => time_to_answer_in_seconds,
                                 :correct => (answer > 2),
                                 :user_role => self.user.role})
    new_review.save

    # Now reschedule the card
    reschedule(answer, time_to_answer_in_seconds)
  end

  def reschedule(answer, time_to_answer_in_seconds)
  end
end
