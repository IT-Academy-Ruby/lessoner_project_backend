class Lesson < ApplicationRecord
  has_many :comments, dependent: :destroy
end
