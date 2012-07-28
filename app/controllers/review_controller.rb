class ReviewController < ApplicationController
  def review
    if !params[:reviews].nil?
      reviews = JSON.parse params[:reviews]
      puts reviews.to_s
      reviews.each do |review|
        user_word = UserWord.find(review['user_word_id'])
        user_word.review(review['answer'].to_i, review['time_to_answer_in_seconds'].to_f)
      end
    end

    new_remaining_today = 20 - current_user.reviews.new_studied_today.count
    new_remaining_today = 0 if new_remaining_today < 0

    @cards = current_user.user_words.due.includes(:word)
    @cards += current_user.user_words.not_studied.limit(new_remaining_today).includes(:word)
    @cards += current_user.user_words.failed.order("last_review ASC").includes(:word)

    # Artificial delay for slow response testing
    sleep(1) if !params[:reviews].nil? && !Rails.env.production?

    # Artificial error
    #raise Exception if !params[:reviews].nil?
  end
end
