class UserWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  #attr_accessible :correct_count, :easiness_factor, :incorrect_count, :interval, :last_review, :new_card, :next_due

  has_many :reviews, :dependent => :destroy

  after_initialize :defaults

  scope :due, lambda {
    # Subtract 3 hours so that a day 'ends' at 3am
    minus_3hrs = Time.now - 10800
    where("next_due < ?", minus_3hrs.end_of_day+10800).where(:failed => false).order("next_due ASC")
  }

  scope :failed, lambda {
    where(:failed => true).order("last_review ASC")
  }

  scope :next, lambda {
    offset(1).limit(1)
  }

  scope :not_studied, where(:new_card => true).order("id ASC")
  scope :short_term, where("interval between ? and ?", 1, 14).where(:new_card => false)
  scope :long_term, where("interval > ?", 14).where(:new_card => false)

  def defaults
    self.correct_count ||= 0
    self.easiness_factor ||= 2.5
    self.incorrect_count ||= 0
    self.interval ||= 0
    self.new_card = true if self.new_card.nil?
    self.repetition_number ||= 0
    self.failed ||= false if self.failed.nil?
    self.attempts ||= 0
  end

  # Records a review for this user's word
  def review(answer, time_to_answer_in_seconds)
    new_review = self.reviews.new
    new_review.user = self.user
    new_review.word = self.word
    if self.next_due.nil? || self.failed?
      overdue_time = 0
    else
      overdue_time = (Time.now - self.next_due) / 86400 # seconds -> days
    end
    new_review.update_attributes({:was_new => self.new_card,
                                 :previous_interval => self.interval,
                                 :was_due => self.next_due,
                                 :overdue_time => overdue_time,
                                 :previous_incorrect_count => self.incorrect_count,
                                 :previous_correct_count => self.correct_count,
                                 :previous_easiness_factor => self.easiness_factor,
                                 :previous_repetition_number => self.repetition_number,
                                 :user_rated_answer => answer,
                                 :time_to_answer => time_to_answer_in_seconds,
                                 :correct => (answer > 2),
                                 :user_role => self.user.role.to_s,
                                 :actual_interval => self.interval + overdue_time,
                                 :was_failed => self.failed,
                                 :previous_attempts => self.attempts})
    new_review.save

    self.last_review = Time.now

    if answer < 3
      self.incorrect_count += 1
    else
      self.correct_count += 1
    end

    # Now reschedule the card
    reschedule(answer, time_to_answer_in_seconds)
  end

  # Reschedules a card based on the user's answer
  def reschedule(answer, time_to_answer_in_seconds)
    # Supermemo 2 algorithm, see http://www.supermemo.com/english/ol/sm2.htm
    ef_new = self.easiness_factor + (0.1 - (5-answer)*(0.08+(5-answer)*0.02))
    ef_new = 1.3 if ef_new < 1.3

    self.easiness_factor = ef_new

    self.new_card = false

    self.attempts += 1

    self.repetition_number ||= 0
    if answer < 3
      self.failed = true
      self.repetition_number = 0
    else
      self.failed = false
      self.repetition_number += 1
    end

    case
      when self.failed?
        self.interval = 0
      when self.repetition_number == 1
        self.interval = 1
      when self.repetition_number == 2
        self.interval = 3
      else
        self.interval = self.interval*self.easiness_factor
    end

    self.next_due = Time.now + self.interval*(60*60*24)

    self.save
  end
end
