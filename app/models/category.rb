# frozen_string_literal: true

class Category < ApplicationRecord
  enum :status, %i[active archived]

  validates :name, presence: true
  validates :description, presence: true
end
