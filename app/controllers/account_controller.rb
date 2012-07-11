class AccountController < ApplicationController
  def withdraw
    case params['confirm'].to_i
      when 1
        render 'withdraw_confirm'
      when 2
        # TODO: Do the actual withdrawal process here
        redirect_to '/'
      else
        render 'withdraw'
    end
  end
end
