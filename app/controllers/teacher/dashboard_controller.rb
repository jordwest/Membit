class Teacher::DashboardController < ApplicationController
  def index
    authorize! :read, :statistics
    @metrics = Array.new
    
    # Users registered
    @metrics << {:metric => "Total students registered", :value => User.where({:role => :participant}).count}

    # Users logged in today
    @metrics << {:metric => "Students logged in today", :value => User.where({:role => :participant}).where("last_pageview > ?", Time.now.beginning_of_day).count}

    # Total reviews today
    @metrics << {:metric => "Total reviews completed today", :value => Review.where({:user_role => :participant}).where("created_at > ?", Time.now.beginning_of_day).count}

    @metrics << {:metric => "Last review", :value => Review.where({:user_role => :participant}).order("created_at DESC").first.created_at, :time => true}

    @metrics << {:metric => "Last participant access", :value => User.where({:role => :participant}).order("last_pageview DESC").first.last_pageview, :time => true}
  end

  def words
    authorize! :read, :statistics
    @words = Word.order("id ASC")
    @total_users = User.where(:role => :participant).count

    @word_list = Array.new
    @words.each do |word|
      @word_info = Hash.new
      @word_info["order"] = word.order
      @word_info["expression"] = word.expression
      @word_info["total_reviews"] = word.reviews.where({:user_role => :participant}).count
      @word_info["reviews_this_week"] = word.reviews
                                  .where({:user_role => "participant"})
                                  .where("created_at > ?", Time.now.beginning_of_week)
                                  .count
      @word_info["number_studied"] = word.user_words.participant_only.where({:new_card => false}).count
      @word_info["pct_studied"] = ((@word_info["number_studied"]/@total_users.to_f)*100).to_i
      @word_info["easiness"] = (word.average_easiness_factor - 1.3)/1.2
      @word_info["interval"] = word.average_interval
      @word_list << @word_info
    end

    # Sort the word list
    @word_list.sort_by! do |word|
      case params[:sort_by]
        when "difficulty"
          word["easiness"]
        when "reviews_this_week"
          -word["reviews_this_week"]
        when "order"
          word["order"]
        else
          word["order"]
      end

    end
  end
end
