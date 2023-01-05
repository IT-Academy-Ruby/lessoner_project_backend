class ChangeTypeOfLessonRating < ActiveRecord::Migration[7.0]
  def change
    change_column :lesson_ratings, :rating, :integer
  end
end
