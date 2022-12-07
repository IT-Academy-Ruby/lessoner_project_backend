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
end
