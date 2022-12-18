# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :lesson
  belongs_to :user
  validates :body, presence: true
  scope :filter_by_user_id, ->(user_id) { where user_id: }
  scope :filter_by_lesson_id, ->(lesson_id) { where lesson_id: }
end
