class PasswordsController < ApplicationController
  def forgot
    return render json: { error: 'Email not present' } if params[:email].blank?

    user = User.find_by(email: params[:email])

    if user.present?
      user.generate_password_token!
      UserMailer.password_reset(user).deliver_now
      render json: { alert: "We've sent a link to restore access to your account to the address #{user.email}" }
    else
      render json: { error: 'User is not found. Please enter a valid email address' }, status: :not_found
    end
  end

  def reset
    token = params[:token].to_s
    return render json: { error: 'Token not present' } if params[:email].blank?

    user = User.find_by(password_reset_token: token)
    if user.present? && user.password_token_valid?
      if user.reset_password!(params[:password])
        render json: { status: 'ok' }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Link not valid or expired. Try generating a new link.' }, status: :not_found
    end
  end
end
