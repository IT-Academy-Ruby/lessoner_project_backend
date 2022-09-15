# frozen_string_literal: true

class Lesson < ApplicationRecord
  paginates_per 10
  has_many :comments, dependent: :destroy
end
