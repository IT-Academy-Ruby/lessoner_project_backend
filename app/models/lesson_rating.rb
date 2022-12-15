class LessonRating < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  validates :rating, numericality: { less_than_or_equal_to: 5, only_integer: true }
end
