class UsersController < AuthorizationController
  before_action :update_password, only: :update
  before_action :send_email, only: :update
  before_action :set_client, only: %i[update verify]

  def index
    @pagy, @users = pagy(User.all.order(sort_params))
  end

  def show
    if current_user
      render :show
    else
      render :not_found, status: :not_found
    end
  end

  def edit; end

  def update
    if current_user.update(user_params)
      if user_params[:phone].present?
        start_verification(current_user.phone, params[:channel])
        current_user.verified = false
        current_user.save
      end
      current_user.update!(avatar_url: current_user.avatar&.url&.split('?')&.first) if params[:avatar].present?
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
      render json: { verified: true }, status: :ok
    else
      render json: { error: 'the code is invalid' }, status: :unprocessable_entity
    end
  end

  def update_email
    @user = User.find_by(update_email_token: params[:token])
    if @user&.update_email_token_valid?
      @user.update_email!(@user.new_email)
      render json: { user: 'email has been changed' }, status: :ok
    else
      render :not_found, status: :not_found
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
      return render :error, status: :unprocessable_entity unless current_user.update(password: @password)

      render :show
    else
      render json: { error: 'current password does not match' }, status: :forbidden
    end
  end

  def send_email
    new_email = params[:email]
    return if new_email.blank?

    if User.where(email: new_email).any?
      return render json: { error: 'email already exists' },
                    status: :unprocessable_entity
    end

    if current_user.update(new_email:)
      current_user.generate_update_email_token!
      UserMailer.update_email_information(current_user, new_email).deliver_now
      UserMailer.update_email_confirmation(current_user, new_email).deliver_now
      render json: { deliver: 'sent' }, status: :ok
    else
      render :error, status: :unprocessable_entity
    end
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
