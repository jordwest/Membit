class UserInfo < ActiveRecord::Base
  attr_accessible :english_first_language, :gender

  belongs_to :user, :inverse_of => :user_info

  validates_presence_of :gender, :english_first_language, :user
  validates_associated :user

  classy_enum_attr :gender
end
