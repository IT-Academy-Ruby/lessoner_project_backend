class CreateLessonRatings < ActiveRecord::Migration[7.0]
  def change
    create_table :lesson_ratings do |t|
      t.float :rating
      t.timestamps
    end
  end
end
