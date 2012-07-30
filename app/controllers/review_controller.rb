class ReviewController < ApplicationController
  def review
    authorize! :review, UserWord
    if !params[:reviews].nil?
      reviews = JSON.parse params[:reviews]
      puts reviews.to_s
      reviews.each do |review|
        user_word = current_user.user_words.find(review['user_word_id'])

        if review['last_review'].nil? && user_word.last_review.nil?
          valid = true
        else
          # Make sure the review exists!
          remote_last_review = user_word.last_review.to_s
          local_last_review = Time.parse(review['last_review']).to_s
          valid = (local_last_review == remote_last_review)
        end

        if valid
          user_word.review(review['answer'].to_i, review['time_to_answer_in_seconds'].to_f)
        else
          log = AppLog.new({:type => "Security"})
          log.details = "Invalid last_review check when attempting to review. "+remote_last_review+" != "+local_last_review
          log.var1 = review['user_word_id']
          log.user = current_user
          log.save
        end
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
