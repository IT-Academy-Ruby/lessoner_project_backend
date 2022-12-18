# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  protect_from_forgery unless: -> { request.format.json? }
  
  def sort_params
    sort_field = params[:sort] || 'created_at'
    sort_type = params[:sort_type] || 'DESC'
    "#{sort_field} #{sort_type}"
  end

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
      render json: { error: "You don't have permission to access" }, status: :forbidden unless current_user.admin_type?
    else
      render json: { error: "You don't have permission to access" }, status: :forbidden
    end
  end
end
