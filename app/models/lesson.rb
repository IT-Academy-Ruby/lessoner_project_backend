# frozen_string_literal: true

class Lesson < ApplicationRecord
  paginates_per PAGE10
  has_many :comments, dependent: :destroy
end
