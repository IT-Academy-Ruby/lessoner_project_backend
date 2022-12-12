# frozen_string_literal: true

class UsersController < AuthorizationController
  before_action :user_find, only: %i[show]

  def show
    if @user
      render 'users/show'
    else
      render 'users/error', status: :not_found
    end
  end

  private

  def user_find
    @user = User.find_by(id: params[:id])
  end

  def user_params
    params.permit(:name, :description, :avatar, :avatar_url, :gender, :birthday, :phone, :created_at)
  end

end
