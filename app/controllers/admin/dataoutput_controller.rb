class Admin::DataoutputController < ApplicationController

  def index
    authorize! :manage, :all
  end

  def reviews
    authorize! :manage, :all

    @reviews = Review.participants_only
    if(!params[:new].nil?)
      @reviews = @reviews.not_new if params[:new] == "false"
    end
    respond_to do |format|
      format.csv { render :layout => false }
    end
  end
end
