# frozen_string_literal: true

class Lesson < ApplicationRecord
  STATUSES = %i[active archived].freeze

  paginates_per MAX_ITEMS_PER_PAGE
  has_many :comments, dependent: :destroy
  belongs_to :author, class_name: 'User'
  enum :status, STATUSES

  validates :title, presence: true
  validates :description, presence: true
end
