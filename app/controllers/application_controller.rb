class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :register_pageview

  helper_method :current_user, :user_signed_in?
  helper_method :mobile_device?

  # Is the user using a mobile device?
  def mobile_device?
    (request.user_agent =~ /Mobile|webOS/) != nil
  end

  private

  def user_signed_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def register_pageview
    if user_signed_in?
      current_user.pageview(mobile_device?)
    end
  end
end
