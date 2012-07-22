class User < ActiveRecord::Base
  has_secure_password

  has_one :user_info, :inverse_of => :user, :dependent => :destroy
  accepts_nested_attributes_for :user_info

  has_many :user_words, :dependent => :destroy

  attr_accessible :email, :registration_code,
                  :password, :password_confirmation,
                  :user_info_attributes


  validates_presence_of :email
  validates_presence_of :registration_code
  validate :registration_code_available, :on => :create
  validates_presence_of :password, :on => :create
  validates_uniqueness_of :email
  validates_uniqueness_of :registration_code

  after_create :create_user_words

  def registration_code_available
    if !registration_code.blank? and RegistrationCode.find_by_code_and_used(registration_code, false).nil?
      errors.add(:registration_code, "is not a valid code")
    end
  end

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.authenticate(password)
      user
    else
      nil
    end
  end

  def create_user_words
    Word.all.each do |word|
      new_uw = UserWord.new
      new_uw.user = self
      new_uw.word = word
      new_uw.save
    end
  end
end
