# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery unless: -> { request.format.json? }

  def jwt_token
    request.headers['Authorization']&.split&.last
  end

  def client_ip
    request.remote_ip
  end
end
