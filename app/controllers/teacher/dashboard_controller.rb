class Teacher::DashboardController < ApplicationController
  def index
    authorize! :read, :statistics
    @metrics = Array.new
    
    # Users registered
    @metrics << {:metric => "Total students registered", :value => User.where({:role => :participant}).count}

    # Users logged in today
    @metrics << {:metric => "Users logged in today", :value => User.where({:role => :participant}).where("last_pageview > ?", Time.now.beginning_of_day).count}

    # Total reviews today
    @metrics << {:metric => "Total reviews completed today", :value => Review.where({:user_role => :participant}).where("created_at > ?", Time.now.beginning_of_day).count}

  end

  def words
    authorize! :read, :statistics
    @words = Word.order("id ASC")
    @total_users = User.where(:role => :participant).count
  end
end
