# frozen_string_literal: true

class Category < ApplicationRecord
  STATUSES = %i[active archived].freeze

  enum :status, STATUSES

  validates :name, presence: true
  validates :description, presence: true

  has_many :lessons
end
