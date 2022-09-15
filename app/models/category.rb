# frozen_string_literal: true

class Category < ApplicationRecord
  paginates_per 10
  enum :status, %i[active archived]

  validates :name, presence: true
  validates :description, presence: true
end
