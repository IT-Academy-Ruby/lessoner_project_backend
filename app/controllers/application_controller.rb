class ApplicationController < ActionController::API
  include Pagy::Backend

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

  private

  def sort_params
    sort_field = params[:sort] || 'created_at'
    sort_type = params[:sort_type] || 'DESC'
    "#{sort_field} #{sort_type}"
  end

  def for_registered_user
    render json: { error: "You don't have permission to access" }, status: :forbidden if current_user.blank?
  end
end
