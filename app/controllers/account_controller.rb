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
      if registration_code.role.participant? and !User.registrations_open?
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
        redirect_to '/log_in', :notice => 'Your account was created successfully. You can now log in using the details you registered with.'
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
      render 'withdraw'
  end

  # Do the actual withdrawal (destroy the account)
  def destroy
    case params['confirm'].to_i
      when 1
        # TODO: Do the actual withdrawal process here
        redirect_to '/'
      else
        render 'withdraw_confirm'
    end
  end

  private

  def check_registration_code
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
