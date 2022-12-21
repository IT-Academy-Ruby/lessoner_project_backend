class SignUpController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user).deliver_now
      render :create, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :bad_request
    end
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      if @user.email_confirmed?
        token = JsonWebToken.encode(name: @user.name, email: @user.email,
                                    description: @user.description, phone: @user.phone,
                                    gender: @user.gender, birthday: @user.birthday.to_s,
                                    exp: 3.hours.from_now.to_i)
        render json: { jwt: token }, status: :ok
      else
        render json: { error: 'unconfirmed' }, status: :unauthorized
      end
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def confirm_email
    @user = User.find_by(confirm_token: params[:token])
    if @user
      @user.email_activate!
      render json: { user: 'confirmed' }, status: :ok
    else
      render json: { error: 'not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.permit(:email, :name, :password, :gender, :birthday, :phone)
  end
end
