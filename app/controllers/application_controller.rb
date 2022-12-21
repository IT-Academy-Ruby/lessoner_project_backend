class ApplicationController < ActionController::API
  include ActiveStorage::SetCurrent

  def jwt_token
    request.headers['Authorization']&.split&.last
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
end
