# frozen_string_literal: true

class UsersController < AuthorizationController
  before_action :user_find, only: %i[show edit update]

  def show
    if @user
      render 'users/show'
    else
      render :not_found, status: :not_found
    end
  end

  def edit; end

  def update
    if params[:avatar].present? && @user.present?
      @user.avatar.attach(params[:avatar])
      @user.avatar_url = rails_blob_path(@user.avatar)
      @user.save!
    end
    if @user.update(user_params)
      render 'users/show'
    else
      render :error, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :description, :avatar, :avatar_url, :gender, :birthday)
  end

  def user_find
    @user = User.find_by(id: params[:id])
  end
end
