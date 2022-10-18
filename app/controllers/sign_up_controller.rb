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
    if @user&.valid_password?(params[:password])
      token = JsonWebToken.issue(name: @user.name, email: @user.email,
                                 description: @user.description, phone: @user.phone,
                                 gender: @user.gender, birthday: @user.birthday.to_s,
                                 exp: 1.hour.from_now.to_i)
      render json: { jwt: token }
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:sign_up).permit(:email, :name, :password, :gender, :birthday, :phone)
  end
end