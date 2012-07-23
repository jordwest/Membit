class DashboardController < ApplicationController
  def index
    authorize! :read, :dashboard
    @new_cards = current_user.user_words.where(:new => true).count
    @reviews_due = current_user.user_words.due.count
    @long_term = current_user.user_words.long_term.count
    @short_term = current_user.user_words.short_term.count
    #@info[:short_term] = UserWord.longterm
    #@info[:long_term] = UserWord.find_by_user_id_and_new(current_user, true)
  end
end
