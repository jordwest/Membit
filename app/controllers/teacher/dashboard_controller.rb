class Teacher::DashboardController < ApplicationController
  def index
    authorize! :read, :statistics

    @total_users = User.where({:role => :participant}).count

    @metrics = Array.new
    
    # Users registered
    @metrics << {:metric => "Total students registered", :value => @total_users}

    # Users logged in this week
    logged_in_this_week = User.where({:role => :participant}).where("last_pageview > ?", Time.now.beginning_of_week).count.to_s + " of " + @total_users.to_s
    @metrics << {:metric => "Students logged in this week", :value => logged_in_this_week}

    # Users logged in today
    logged_in_today = User.where({:role => :participant}).where("last_pageview > ?", Time.now.beginning_of_day).count.to_s + " of " + @total_users.to_s
    @metrics << {:metric => "Students logged in today", :value => logged_in_today}

    # Total reviews
    @metrics << {:metric => "Total reviews", :value => Review.where({:user_role => :participant}).count}

    # Total reviews this week
    @metrics << {:metric => "Total reviews completed this week", :value => Review.where({:user_role => :participant}).where("created_at > ?", Time.now.beginning_of_week).count}

    # Total reviews today
    @metrics << {:metric => "Total reviews completed today", :value => Review.where({:user_role => :participant}).where("created_at > ?", Time.now.beginning_of_day).count}

    @metrics << {:metric => "Last review", :value => Review.where({:user_role => :participant}).order("created_at DESC").first.created_at, :time => true}

    @metrics << {:metric => "Last participant access", :value => User.where({:role => :participant}).order("last_pageview DESC").first.last_pageview, :time => true}
  end

  def words
    authorize! :read, :statistics
    @word_list = ReportCache.get_data_with_key("word_list")
    @total_users = User.where(:role => :participant).count

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

  def usage
    authorize! :read, :statistics
    @genders = ReportCache.get_data_with_key("genders")
    @device_usage = ReportCache.get_data_with_key("device_usage")
    @user_review_count = ReportCache.get_data_with_key("user_review_count")
    @reviews_over_semester = ReportCache.get_data_with_key("reviews_over_semester")
    @reviews_since_registering = ReportCache.get_data_with_key("reviews_since_registering")
  end
end
