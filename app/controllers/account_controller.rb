class AccountController < ApplicationController
  before_filter :check_registration_code, :only => [:new, :create]

  # Render the registration form
  def new

    if params[:user].nil?
      return
    end

    @user.registration_code = params[:user][:registration_code]

    registration_code = RegistrationCode.find_by_code(params[:user][:registration_code])

    if @code_valid then
      if @registration_code.role.participant? && !User.registrations_open?
        redirect_to "/register", :alert => "Sorry, registration is not yet open. Check back from Week 2 of semester."
      else
        render "new_"+@code_valid
      end
    else
        render "new"
    end
  end

  # Attempt to register a new user
  def create
    if @code_valid
      @user.update_attributes(params[:user])
      if @user.save
        User.authenticate(@user.email, @user.password)
        redirect_to '/log_in', :notice => 'Thanks for registering! You can now log in using the details you registered with and start reviewing vocabulary.'
      else
        flash.now.alert = "Please check that you have filled in the form completely"
        render "new_"+@code_valid
      end
    else
      render "new"
    end
  end

  # Withdraw
  def withdraw
      authorize! :withdraw, :self
      render 'withdraw'
  end

  # Do the actual withdrawal (destroy the account)
  def destroy
    authorize! :withdraw, :self
    case params['confirm'].to_i
      when 1
        user = current_user

        # Record the withdrawal
        AppLog.create({:user => user, :type => 'Withdrawal', :details => "User withdrew participation, all associated data deleted"})

        # Destroy the session
        session[:user_id] = nil

        # Destroy the user
        user.destroy

        redirect_to '/'
      else
        render 'withdraw_confirm'
    end
  end

  def change_password
    authorize! :edit, :self

    if !params[:original_password].nil?
      if current_user.authenticate(params[:original_password])
        current_user.password_digest = nil
        current_user.password = params[:password]
        current_user.password_confirmation = params[:password_confirmation]
        if current_user.save
          flash.now.notice = "Password successfully changed."
        else
          flash.now.alert = "Couldn't change password. Check that your new password is at least 6 characters and that the new passwords match."
        end
      else
        flash.now.alert = "Couldn't change password. Check that your current password was entered correctly."
      end
    end
  end

  def reset_password
    redirect_to '/' if !current_user.nil?

    if !params[:registration_code].nil?
      user = User.find_by_registration_code(params[:registration_code])

      if(user.nil?)
        flash.now.alert = "Couldn't find a user with the registration code "+params[:registration_code]
        return
      end

      new_password = ""
      # Generate a new password
      allowedChars = "abcdefghkmnpqrstuvwxyzABCDEFGHJKMNPQRTUVWXYZ234789"

      10.times do
        new_password << allowedChars[rand(allowedChars.size)]
      end

      AppLog.log("Security", "Password reset", user, nil, nil)
      AccountMessager.reset_password(user, new_password).deliver

      # TODO: Actually save the new password
      user.password_digest = nil
      user.password = new_password
      user.password_confirmation = new_password
      user.save

      flash.now.notice = "A password reset email was sent to "+user.email
    end
  end

  private

  def check_registration_code
    # Convert registration code to uppercase TODO: really ugly... gotta be a better way
    params[:user][:registration_code] = params[:user][:registration_code].upcase if !params[:user].nil? && !params[:user][:registration_code].nil?

    @user = User.new(params[:user])
    @registration_code = RegistrationCode.find_by_code(@user.registration_code)

    @code_valid = false

    if @registration_code
      if @registration_code.used?
        flash.now.alert = "This code has already been used. If you are having trouble registering, please contact Jordan at jordan.west@uqconnect.edu.au"
      elsif @registration_code.role.participant? or @registration_code.role.tester?
        @code_valid = 'participant'
        @user.build_user_info
      else
        @code_valid = 'other'
      end
    elsif !params[:user].nil?
      flash.now.alert = "We couldn't find this registration code. Please enter the code as it appears on the card you received. If you are having trouble registering, please contact Jordan at jordan.west@uqconnect.edu.au"
    end
  end
end
