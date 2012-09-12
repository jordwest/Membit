class AccountMessager < ActionMailer::Base
  default from: "noreply@membit.herokuapp.com"

  def reset_password(user, new_password)
    @user = user
    @new_password = new_password
    mail(:to => user.email, :subject => "Membit Password Reset")
  end
end
