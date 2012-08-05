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

    new_remaining_today = current_user.new_remaining_today

    @cards = Array.new

    show_failed_first = (current_user.user_words.failed.count >= UserWord.max_failed)

    if show_failed_first
      @cards += current_user.user_words.failed.order("last_review ASC").includes(:word)
    end

    @cards += current_user.user_words.due.includes(:word)
    @cards += current_user.user_words.not_studied.limit(new_remaining_today).includes(:word)

    if !show_failed_first
      @cards += current_user.user_words.failed.order("last_review ASC").includes(:word)
    end

    @stats = Hash.new

    @stats["total_new"] = UserWord.new_per_day
    @stats["remaining_new"] = current_user.new_remaining_today
    @stats["remaining_due"] = current_user.user_words.due.count
    @stats["remaining_failed"] = current_user.user_words.failed.count
    @stats["total_remaining"] = @stats["remaining_new"] + @stats["remaining_due"] + @stats["remaining_failed"]
    @stats["total_reviews_today"] = @stats["total_remaining"] + current_user.reviews.completed_today.count

    # Artificial delay for slow response testing
    sleep(1) if !params[:reviews].nil? && !Rails.env.production?

    # Artificial error
    #raise Exception if !params[:reviews].nil?
  end
end
