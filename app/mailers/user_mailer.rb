class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: user.email, subject: 'Password Reset'
  end

  def registration_confirmation(user)
    @user = user
    mail to: user.email, subject: 'Registration Confirmation'
  end

  def update_email_information(user, new_email)
    @user = user
    @new_email = new_email
    mail to: user.email, subject: 'Update email information'
  end

  def update_email_confirmation(user, new_email)
    @user = user
    @new_email = new_email
    mail to: new_email, subject: 'Update email confirmation'
  end
end
