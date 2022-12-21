class ApplicationRecord < ActiveRecord::Base
  include Constants
  primary_abstract_class
end
