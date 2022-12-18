# frozen_string_literal: true

class Category < ApplicationRecord
  STATUSES = %i[active archived].freeze

  enum :status, STATUSES

  validates :name, presence: true
  validates :description, presence: true

  has_many :lessons
  scope :filter_by_name, ->(name) { where name: }
  scope :filter_by_status, ->(status) { where status: }
end
