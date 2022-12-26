class AddColumnRatingToLesson < ActiveRecord::Migration[7.0]
  def change
    add_column :lessons, :rating, :float
  end
end
