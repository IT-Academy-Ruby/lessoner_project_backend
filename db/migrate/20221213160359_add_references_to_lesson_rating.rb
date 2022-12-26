class AddReferencesToLessonRating < ActiveRecord::Migration[7.0]
  def change
    add_reference :lesson_ratings, :user, foreign_key: true
    add_reference :lesson_ratings, :lesson, foreign_key: true
  end
end
