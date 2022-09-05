# frozen_string_literal: true

class Lesson < ApplicationRecord
  has_many :comments, dependent: :destroy
end
