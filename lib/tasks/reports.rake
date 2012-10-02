class Timer
  @@t = 0
  @@timers = Hash.new

  def self.start(timer_name = nil)
    if(timer_name.nil?)
      @@t = Time.now
    else
      @@timers[timer_name] = Time.now
    end
  end

  def self.print(timer_name = nil)
    if(timer_name.nil?)
      ms_elapsed = Time.now - @@t
      puts "Time to prepare: #{ms_elapsed}ms"
    else
      ms_elapsed = Time.now - @@timers[timer_name]
      puts "Time to prepare [#{timer_name}]: #{ms_elapsed}ms"
    end
  end
end

namespace :reports do
  task :prepare => [
            :start_timer,
            :prepare_word_list,
            :prepare_device_usage,
            :prepare_user_review_count,
            :prepare_reviews_over_semester,
            :prepare_reviews_since_registering] do
    puts "All reports prepared"
    Timer.print "total"
  end

  task :start_timer => :environment do
    Timer.start "total"
  end

  task :prepare_genders => :environment do
    puts "Preparing genders"
    Timer.start

    users = User.participants.joins(:user_info)

    genders = Hash.new
    genders["Male"] = {"total" => 0, "active" => 0, "inactive" => 0}
    genders["Female"] = {"total" => 0, "active" => 0, "inactive" => 0}
    genders["Unspecified"] = {"total" => 0, "active" => 0, "inactive" => 0}

    users.each do |u|
      if(u.user_info.gender.male?)
        ref = genders["Male"]
      elsif(u.user_info.gender.female?)
        ref = genders["Female"]
      else
        ref = genders["Unspecified"]
      end

      if(u.active?)
        ref["active"] += 1
      else
        ref["inactive"] += 1
      end

      ref["total"] += 1
    end

    ReportCache.store_data_with_key("genders", genders)

    Timer.print
  end

  task :prepare_word_list => :environment do
    # ==== WORD LIST ====
    puts "Preparing Word List"
    Timer.start
    words = Word.order("id ASC")
    total_users = User.where(:role => :participant).count

    word_list = Array.new
    words.each do |word|
      word_info = Hash.new
      word_info["order"] = word.order
      word_info["expression"] = word.expression
      word_info["meaning"] = word.meaning
      word_info["total_reviews"] = word.reviews.where({:user_role => :participant}).count
      word_info["reviews_this_week"] = word.reviews
      .where({:user_role => "participant"})
      .where("created_at > ?", Time.now.beginning_of_week)
      .count
      word_info["number_studied"] = word.user_words.participant_only.where({:new_card => false}).count
      word_info["pct_studied"] = ((word_info["number_studied"]/total_users.to_f)*100).to_i
      word_info["easiness"] = (word.average_easiness_factor - 1.3)/1.2
      word_info["interval"] = word.average_interval
      word_info["failed"] = word.number_failed
      word_list << word_info
    end

    ReportCache.store_data_with_key("word_list", word_list)

    Timer.print
  end

  task :prepare_device_usage => :environment do
    puts "Preparing Device Usage"
    Timer.start
    # ==== DEVICE USAGE PER USER ====
    users = User.where(:role => :participant)
    devices = Hash.new

    devices["mobile_and_desktop"] = 0
    devices["mobile"] = 0
    devices["desktop"] = 0
    devices["none"] = 0

    users.each do |user|
      used_desktop = user.user_logins.where({:mobile => false}).count > 0
      used_mobile = user.user_logins.where({:mobile => true}).count > 0
      if(used_desktop and used_mobile)
        devices["mobile_and_desktop"] += 1
      elsif(used_desktop)
        devices["desktop"] += 1
      elsif(used_mobile)
        devices["mobile"] += 1
      else
        devices["none"] += 1
      end
    end

    ReportCache.store_data_with_key("device_usage", devices)
    Timer.print
  end

  task :prepare_user_review_count => :environment do
    puts "Preparing user review count"
    Timer.start
    users = User.where(:role => :participant)

    review_bags = Hash.new
    review_bags["0"] = 0
    review_bags["1 - 20"] = 0
    review_bags["20 - 100"] = 0
    review_bags["101 - 200"] = 0
    review_bags["201 - 500"] = 0
    review_bags["501 - 1000"] = 0
    review_bags["1001+"] = 0

    users.each do |user|
      reviews = user.reviews.count
      if(reviews > 1000)
        review_bags["1001+"] += 1
      elsif(reviews > 500)
        review_bags["501 - 1000"] += 1
      elsif(reviews > 200)
        review_bags["201 - 500"] += 1
      elsif(reviews > 100)
        review_bags["101 - 200"] += 1
      elsif(reviews >= 20)
        review_bags["20 - 100"] += 1
      elsif(reviews > 0)
        review_bags["1 - 20"] += 1
      else
        review_bags["0"] += 1
      end
    end

    ReportCache.store_data_with_key("user_review_count", review_bags)

    Timer.print
  end

  task :prepare_reviews_over_semester => :environment do
    puts "Preparing reviews over semester"
    Timer.start

    # Add each week of semester
    weeks = (1..13).to_a

    # Add holiday
    weeks.insert(9, 'Break')

    first_day = Time.new(2012, 07, 23)
    current_week_start = first_day

    week_data = Array.new

    weeks.each do |week|
      this_week = {"week" => week.to_s, "inactive" => 0, "active" => 0, "total" => 0}

      beginning_of_week = current_week_start.beginning_of_week
      end_of_week = current_week_start.end_of_week

      # Don't show weeks beyond today
      break if beginning_of_week > Time.now

      reviews_this_week = Review.where("created_at > ? and created_at < ?", beginning_of_week, end_of_week).count
      inactive_reviews_this_week = 0
      active_reviews_this_week = 0

      User.participants.each do |user|
        if(user.active?)
          active_reviews_this_week += user.reviews.where("created_at > ? and created_at < ?", beginning_of_week, end_of_week).count
        else
          inactive_reviews_this_week += user.reviews.where("created_at > ? and created_at < ?", beginning_of_week, end_of_week).count
        end
      end

      this_week["total"] = reviews_this_week / User.participants.count
      this_week["active"] = active_reviews_this_week / User.participants.active.count
      this_week["inactive"] = inactive_reviews_this_week / User.participants.inactive.count
      week_data.append(this_week)

      current_week_start += 604800 # 7 days
    end

    ReportCache.store_data_with_key("reviews_over_semester", week_data)
    Timer.print
  end

  task :prepare_reviews_since_registering => :environment do
    puts "Preparing reviews since registering"
    Timer.start

    days = Hash.new
    users = Hash.new

    split_days = 3
    split_sec = split_days * 86400

    # Create days hash
    max_days = ((Time.now - User.participants.first.created_at) / split_sec).to_i
    (0..max_days).each do |day|
      days[day] = {"total" => 0, "total_active" => 0, "total_inactive" => 0, "average" => 0}
    end

    # Store all users in a hash for later use
    User.participants.each do |u|
      users[u.id] = u
    end

    Rails.logger.debug "Scanning reviews..."

    Review.where({:user_role => :participant}).find_each do |review|
      user = users[review.user_id]

      day = ((review.created_at - user.created_at) / split_sec).to_i

      if(user.active?)
        days[day]["total_active"] += 1
      else
        days[day]["total_inactive"] += 1
      end
      days[day]["total"] += 1
    end

    days.each do |day, data|
      users_on_this_day = 0
      active_users_on_this_day = 0
      inactive_users_on_this_day = 0

      users.each do |uid, u|
        days_registered = (Time.now - u.created_at) / split_sec
        if days_registered > day
          users_on_this_day += 1
          if u.active?
            active_users_on_this_day += 1
          else
            inactive_users_on_this_day += 1
          end
        end
      end
      days[day]["average"] = days[day]["total"] / users_on_this_day
      days[day]["average_active"] = days[day]["total_active"] / active_users_on_this_day
      days[day]["average_inactive"] = days[day]["total_inactive"] / inactive_users_on_this_day

      days[day]["total_users"] = users_on_this_day
      days[day]["total_active_users"] = active_users_on_this_day
      days[day]["total_inactive_users"] = inactive_users_on_this_day

      days[day]["label"] = day*split_days
    end

    ReportCache.store_data_with_key("reviews_since_registering", days)
    Timer.print
  end
end
