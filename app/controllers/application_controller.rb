class ApplicationController < ActionController::API
  include ActiveStorage::SetCurrent
  include Pagy::Backend

  def jwt_token
    request.headers['Authorization']&.split&.last
  end

  def encode_jwt_token(user)
    JsonWebToken.encode(name: user.name, email: user.email,
                        description: user.description, phone: user.phone,
                        gender: user.gender, birthday: user.birthday.to_s,
                        admin: user.admin_type, exp: 3.hours.from_now.to_i)
  end

  def client_ip
    request.remote_ip
  end

  def current_user
    @decoded = JsonWebToken.decode(jwt_token)
    @current_user = User.find_by(email: @decoded['email'])
  rescue
    nil
  end

  def for_admin
    if jwt_token.present?
      render json: { error: "You don't have permission to access" }, status: :forbidden unless current_user&.admin_type?
    else
      render json: { error: "You don't have permission to access" }, status: :forbidden
    end
  end

  private

  def sort_params(random: false)
    sort_field = params[:sort_field]
    sort_type = params[:sort_type]
    if random && [sort_field, sort_type].all?(&:blank?)
      'RANDOM()'
    else
      sort_field ||= 'created_at'
      sort_type ||= 'DESC'
      "#{sort_field} #{sort_type}"
    end
  end

  def for_registered_user
    render json: { error: "You don't have permission to access" }, status: :forbidden if current_user.blank?
  end
end
