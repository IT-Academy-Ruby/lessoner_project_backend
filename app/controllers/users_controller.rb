# frozen_string_literal: true

class UsersController < AuthorizationController
  def show
    if current_user
      render 'users/show'
    else
      render :not_found, status: :not_found
    end
  end

  def edit; end

  def update
    current_user.update!(avatar_url: current_user.avatar&.url&.split('?')&.first) if params[:avatar].present?
    if current_user.update(user_params)
      render 'users/show'
    else
      render :error, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :description, :avatar, :avatar_url, :gender, :birthday)
  end
end
