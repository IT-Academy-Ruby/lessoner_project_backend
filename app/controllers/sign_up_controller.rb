class SignUpController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render :create
    else
      render json: { errors: @user.errors.full_messages }
    end
  end

  private

  def user_params
    params.permit(:email, :name, :password, :gender, :birthday, :phone)
  end
end
