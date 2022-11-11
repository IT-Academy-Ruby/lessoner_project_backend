class UserMailer < ApplicationMailer
  
  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password Reset'
  end

  def registration_confirmation(user)
    @user = user
    mail to: user.email, subject: 'Registration Confirmation'
 end
end
