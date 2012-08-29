class Admin::DataoutputController < ApplicationController
  def reviews
    authorize! :manage, :all

    @reviews = Review.participants_only
    respond_to do |format|
      format.csv { render :layout => false }
    end
  end
end
