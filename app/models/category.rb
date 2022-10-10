# frozen_string_literal: true

class Category < ApplicationRecord
  STATUSES = %i[active archived].freeze

  paginates_per MAX_ITEMS_PER_PAGE
  enum :status, STATUSES

  validates :name, presence: true
  validates :description, presence: true

  has_many :lessons
end
