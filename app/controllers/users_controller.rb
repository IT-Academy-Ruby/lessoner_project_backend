class UsersController < AuthorizationController
  before_action :update_password, only: :update
  before_action :send_email, only: :update
  before_action :set_client, only: %i[update verify]
  before_action :update_phone, only: :update

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

  def verify
    is_verified = check_verification(current_user.phone, params[:verification_code])
    if is_verified
      current_user.verified = true
      current_user.save
      render json: { user: 'phone number was successfully verified' }, status: :ok
    else
      render json: { error: 'the code was invalid' }, status: :unprocessable_entity
    end
  end

  def update_email
    @user = User.find_by(update_email_token: params[:token])
    if @user&.update_email_token_valid?
      @user.update_email!(params[:email])
      render json: { user: 'email has been changed' }, status: :ok
    else
      render json: { error: 'not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.permit(:name, :description, :avatar, :avatar_url, :gender, :birthday, :phone)
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

  def update_phone
    if user_params[:phone].present?
      start_verification(current_user.phone, params[:channel])
      current_user.verified = false
      current_user.save
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

  def set_client
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def start_verification(to, channel = 'sms')
    channel = 'sms' unless %w[sms voice].include? channel
    verification = @client.verify.services(ENV['VERIFICATION_SID'])
                          .verifications
                          .create(to:, channel:)
    verification.sid
  end

  def check_verification(phone, code)
    verification_check = @client.verify.services(ENV['VERIFICATION_SID'])
                                .verification_checks
                                .create(to: phone, code:)
    verification_check.status == 'approved'
  end
end
