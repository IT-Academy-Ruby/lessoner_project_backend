require './lib/middleware/jwt_auth'

class AuthorizationController < ApplicationController
  use JwtAuth

  before_action :initialize_user

  attr_reader :current_user

  def jwt_token
    request.headers['Authorization']&.split&.last
  end

  def initialize_user
    @current_user = request.env[:current_user]
  end
end
