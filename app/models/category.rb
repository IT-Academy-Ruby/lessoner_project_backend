# frozen_string_literal: true

class Category < ApplicationRecord
  paginates_per MAX_ITEMS_PER_PAGE
  enum :status, %i[active archived]

  validates :name, presence: true
  validates :description, presence: true

  has_many :lessons
end
