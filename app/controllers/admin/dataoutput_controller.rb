class Admin::DataoutputController < ApplicationController

  def index
    authorize! :manage, :all
  end

  def reviews
    authorize! :manage, :all

    @reviews = Review.participants_only

    # Remove new reviews
    if(!params[:new].nil?)
      @reviews = @reviews.not_new if params[:new] == "false"
    end

    # Keep only reviews by 'active' users
    if(!params[:active].nil?)
      @reviews = @reviews.active_users if params[:active] == "true"
    end

    # Keep only reviews where the word has been attempted a min # of times
    if(!params[:min_attempts].nil?)
      @reviews = @reviews.where('previous_attempts >= ?', params[:min_attempts])
    end

    # Keep only reviews where the word has been correctly reviewed a min # of times
    if(!params[:min_rep_num].nil?)
      @reviews = @reviews.where('previous_repetition_number >= ?', params[:min_rep_num])
    end

    # Keep only reviews by a particular user
    if(!params[:user_id].nil?)
      @reviews = @reviews.where('user_id = ?', params[:user_id])
    end

    # Keep only reviews for a particular word
    if(!params[:word_id].nil?)
      @reviews = @reviews.where('word_id = ?', params[:word_id])
    end

    respond_to do |format|
      format.csv { render :layout => false }
    end
  end
end
