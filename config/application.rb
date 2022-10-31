# frozen_string_literal: true

require_relative 'boot'
require 'rails/all'
require 'octicons'
require './lib/middleware/jwt_auth'

Bundler.require(*Rails.groups)

module LessonerProject
  class Application < Rails::Application
    config.load_defaults 7.0
    I18n.available_locales = %i[en ru]
    I18n.default_locale = :en
    config.autoload_paths += %W[#{config.root}/lib]
    config.middleware.use JwtAuth
  end
end
