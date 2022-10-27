# frozen_string_literal: true

class ApplicationController < ActionController::Base
  
  before_action :set_locale
  helper_method :current_locale

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
