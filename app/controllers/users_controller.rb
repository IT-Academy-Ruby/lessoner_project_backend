class UsersController < AuthorizationController
  before_action :update_password, only: :update
  before_action :send_email, only: :update

  def show
    if current_user
      render :show
    else
      render :not_found, status: :not_found
    end
  end

  def edit; end

  def update
    if params[:avatar].present?
      current_user.avatar.attach(params[:avatar])
      current_user.avatar_url = current_user.avatar&.url&.split('?')&.first
      current_user.save!
    end
    if current_user.update(user_params)
      render :show
    else
      render :error, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :description, :avatar, :avatar_url, :gender, :birthday)
  end

  def update_password
    @password = params[:password]
    return if @password.blank?

    if current_user.authenticate(params[:current_password])
      return render :error unless current_user.update(password: @password)

      render :show
    else
      render json: { error: 'current password does not match' }, status: :forbidden
    end
  end

  def send_email
    return if params[:email].blank?

    current_user.generate_update_email_token!
    new_email = params[:email]
    UserMailer.update_email_information(current_user, new_email).deliver_now
    UserMailer.update_email_confirmation(current_user, new_email).deliver_now
    render json: { user: 'sent' }, status: :ok
  end
end
