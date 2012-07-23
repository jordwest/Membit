class UserWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  #attr_accessible :correct_count, :easiness_factor, :incorrect_count, :interval, :last_review, :new, :next_due

  after_initialize :defaults

  scope :due, lambda {
    where("next_due < ?", Time.now.end_of_day)
  }

  scope :short_term, where("interval between ? and ?", 1, 14).where(:new => false)
  scope :long_term, where("interval > ?", 14).where(:new => false)

  def defaults
    self.correct_count ||= 0
    self.easiness_factor ||= 2.5
    self.incorrect_count ||= 0
    self.interval ||= 0
    self.new ||= 1
  end
end
