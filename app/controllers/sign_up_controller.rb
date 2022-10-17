class SignUpController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render :create, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :bad_request
    end
  end

  private

  def user_params
    params.require(:sign_up).permit(:email, :name, :password, :gender, :birthday, :phone)
  end
end
