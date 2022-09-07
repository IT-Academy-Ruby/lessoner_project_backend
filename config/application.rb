# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module LessonerProject
  class Application < Rails::Application
    config.load_defaults 7.0
    I18n.available_locales = %i[en ru]
    I18n.default_locale = :en
  end
end
