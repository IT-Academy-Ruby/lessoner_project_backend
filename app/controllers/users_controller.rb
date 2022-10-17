# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :user_find, only: %i[show]


  def show; end

  def check_username
    @user = User.find_by(name: params[:name])
  end
  
  def check_email
    @user = User.find_by(email: params[:email])
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.valid_password?(params[:password])
      token = JsonWebToken.issue(user_name: @user.name,
                                 user_email: @user.email,
                                 user_description: @user.description,
                                 # user_phone: @user.phone,
                                 # user_gender: @user.gender,
                                 # user_birthday: (@user.birthday).to_s,
                                 exp: (1.hour.from_now).to_i)
      render json: { jwt: token}
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def user_find
    @user = User.find(params[:id])
  end

  def login_params
    params.permit(:name, :password, :email, :description, :phone, :gender, :birthday)
  end
end
