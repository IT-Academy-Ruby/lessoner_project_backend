require_relative 'boot'
require 'rails/all'

Bundler.require(*Rails.groups)

module LessonerProject
  class Application < Rails::Application
    config.api_only = true
    config.load_defaults 7.0
    config.autoload_paths += %W[#{config.root}/lib]
  end
end
