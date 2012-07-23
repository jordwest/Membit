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

  after_create :create_user_words, :use_registration_code

  classy_enum_attr :role

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

  # Assign the user's role based on the registration code
  def registration_code=(value)
    reg_code = RegistrationCode.find_by_code(value)
    if reg_code
      self.role = reg_code.role.to_sym
      #self.role = "admin"
    end

    write_attribute(:registration_code, value)
  end

  def use_registration_code
    reg_code = RegistrationCode.find_by_code(self.registration_code)
    reg_code.used = true
    reg_code.save
  end

  # Check whether or not registrations are currently open
  def self.registrations_open?
    return Date.today > Date.new(2012, 07, 29)
    #false
  end
end
