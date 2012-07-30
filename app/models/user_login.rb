class UserLogin < ActiveRecord::Base
  belongs_to :user
  attr_accessible :cards_due, :new_cards, :time_since_last_view, :mobile, :user_role
end
