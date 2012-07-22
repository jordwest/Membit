class UserWord < ActiveRecord::Base
  belongs_to :user
  belongs_to :word
  #attr_accessible :correct_count, :easiness_factor, :incorrect_count, :interval, :last_review, :new, :next_due

  after_initialize :defaults

  def defaults
    self.correct_count ||= 0
    self.easiness_factor ||= 2.5
    self.incorrect_count ||= 0
    self.interval ||= 0
    self.new ||= 1
  end
end
