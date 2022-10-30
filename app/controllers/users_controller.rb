# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_find, only: %i[show]
  before_action :authorize_request, only: %i[show]
  def show
    if @user
      render 'users/show'
    else
      render 'users/error', status: :not_found
    end
  end

  def check_username
    @user = User.find_by(name: params[:name])
  end

  def check_email
    @user = User.find_by(email: params[:email])
  end

  private

  def user_find
    @user = User.find_by(id: params[:id])
    p params
  end
end
