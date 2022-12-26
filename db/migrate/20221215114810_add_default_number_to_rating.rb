class AddDefaultNumberToRating < ActiveRecord::Migration[7.0]
  def change
    change_column :lesson_ratings, :rating, :float, default: 0
  end
end
