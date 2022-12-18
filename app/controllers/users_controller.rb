# frozen_string_literal: true

class UsersController < AuthorizationController
  def show
    if current_user
      render :show
    else
      render :not_found, status: :not_found
    end
  end

  def edit; end

  def update
    if params[:avatar].present?
      current_user.avatar.attach(params[:avatar])
      current_user.avatar_url = current_user.avatar&.url&.split('?')&.first
      current_user.save!
    end
    if params[:email].present?
      current_user.generate_update_email_token!
      new_email = params[:email]
      UserMailer.update_email_information(current_user, new_email).deliver_now
      UserMailer.update_email_confirmation(current_user, new_email).deliver_now
      render json: { user: 'sent' }, status: :ok
    elsif current_user.update(user_params)
      render :show
    else
      render :error, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :description, :avatar, :avatar_url, :gender, :birthday)
  end
end
