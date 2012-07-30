class Word < ActiveRecord::Base
  has_many :user_words, :dependent => :destroy
  has_many :reviews

  attr_accessible :order, :average_easiness_factor, :expression, :meaning, :reading, :reviewed_count, :honorific, :type1, :type2

  after_create :create_user_words

  after_initialize :defaults

  def defaults
    self.type1 ||= ""
    self.type2 ||= ""
    self.honorific ||= false
    self.reviewed_count ||= 0
  end

  def create_user_words
    User.all.each do |user|
      new_uw = UserWord.new
      new_uw.user = user
      new_uw.word = self
      new_uw.save
    end
  end

  def average_easiness_factor
    self.user_words.participant_only.average(:easiness_factor)
  end

  def average_interval
    self.user_words.participant_only.where(:new_card => false).average(:interval)
  end

  def number_failed
    self.user_words.participant_only.where(:failed => true).count
  end
end
