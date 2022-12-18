# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  include Constants
  include Filterable
  primary_abstract_class
end
