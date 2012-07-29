class AppLog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user, :details, :type, :var1, :var2
end
