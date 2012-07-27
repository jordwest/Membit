class ReviewController < ApplicationController
  def review
    @current_card = get_card(false, 0.5)
    @next_card = get_card(true, 0.5)
  end

  private

  def get_card(second, chance_of_failed)
    if rand() <= chance_of_failed
      next_card = (second == true ? current_user.user_words.failed.next : current_user.user_words.failed.first)
      if next_card.nil?
        next_card = (second == true ? current_user.user_words.due.next : current_user.user_words.due.first)
      end
    else
      next_card = (second == true ? current_user.user_words.due.next : current_user.user_words.due.first)
      if next_card.nil?
        next_card = (second == true ? current_user.user_words.failed.next : current_user.user_words.failed.first)
      end
    end

    return next_card
  end
end
