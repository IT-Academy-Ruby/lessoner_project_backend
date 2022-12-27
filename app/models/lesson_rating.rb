class LessonRating < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  validates :rating, numericality: { in: 0..5, only_integer: true, message: 'The rating should be from 0 to 5' }
end
