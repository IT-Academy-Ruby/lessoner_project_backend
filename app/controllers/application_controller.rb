# frozen_string_literal: true

class ApplicationController < ActionController::Base
  
  before_action :set_locale
  helper_method :current_locale
  protect_from_forgery unless: -> { request.format.json? }
  
  def authorize_request
    header = request.headers['Authorization']
    jwt = header.split.last if header
    begin
      @decoded = JsonWebToken.decode(jwt)
      puts @decoded
      @current_user = User.find_by(email: @decoded[:email])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  private

  def default_url_options
    { locale: I18n.locale }
  end

  def current_locale
    I18n.locale
  end

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    parsed_locale = params[:locale]
    parsed_locale.to_sym if I18n.available_locales.map(&:to_s).include?(parsed_locale)
  end
end
