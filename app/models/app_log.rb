class AppLog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user, :details, :type, :var1, :var2

  def self.inheritance_column
    "none"
  end

  def self.log(type, detail, user, var1, var2)
    log = self.new
    log.type = type
    log.details = detail
    log.user = user if !user.nil?
    log.var1 = var1 if !var1.nil?
    log.var2 = var2 if !var2.nil?
    log.save
  end
end
