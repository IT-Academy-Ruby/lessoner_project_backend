// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false // this is required for proper html page updating

import "controllers"
//= require jquery3
//= require popper
//= require bootstrap
