class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :register_pageview

  helper_method :current_user, :user_signed_in?
  helper_method :mobile_device?

  #rescue_from CanCan::AccessDenied, :with => :deny_access

  rescue_from Exception, :with => :exception_handler

  # Is the user using a mobile device?
  def mobile_device?
    (request.user_agent =~ /Mobile|webOS/) != nil
  end

  private

  def deny_access(exception)
    respond_to do |format|
      format.html do
        if(user_signed_in?)
          flash[:alert] = "Oops, you don't have access to that page."
        else
          flash[:alert] = "Oops, you don't have access to that page. Try logging in first."
        end
        AppLog.log("Security", "Access Denied to page "+request.original_url+".\nRemote IP: "+request.remote_ip, current_user, nil, nil)
        redirect_to "/"
      end
      format.xml { render :xml => {:forbidden => true}, :status => :forbidden }
      format.json { render :json => {:forbidden => true}, :status => :forbidden }
    end
  end

  def exception_handler(exception)
    case
      when exception.instance_of?(CanCan::AccessDenied)
        deny_access(exception)
      else
        if Rails.env.production?
          details = "Exception Occurred:\n\n"+exception.to_s+"\n\n==Backtrace==\n"
          exception.backtrace.each do |bt|
            details += bt.to_s+"\n"
          end
          AppLog.log("Exception", details, current_user, nil, nil)
          flash[:alert] = "Something went wrong... The error has been recorded and I'll try to fix it ASAP. In the meantime you can continue to use the software. If the issue isn't going away, please contact me at jordan.west@uqconnect.edu.au."
          redirect_to "/"
        else
          raise exception
        end
    end
  end

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
