class AccountController < ApplicationController
  # Render the registration form
  def new
    @user = User.new
  end

  # Attempt to register a new user
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to root_url, :notice => 'Your account was created successfully.'
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
end
