class SignUpController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      render :create, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :bad_request
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(name: @user.name, email: @user.email,
                                  description: @user.description, phone: @user.phone,
                                  gender: @user.gender, birthday: @user.birthday.to_s,
                                  exp: 1.hour.from_now.to_i)
      render json: { jwt: token }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:email, :name, :password, :gender, :birthday, :phone)
  end
end
