# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  def jwt_token
    request.headers['Authorization']&.split&.last
  end

  def current_user
    @decoded = JsonWebToken.decode(jwt_token)
    @current_user = User.find_by(email: @decoded['email'])
  rescue
    nil
  end
end
