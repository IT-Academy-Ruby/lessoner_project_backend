class AddViewsCountFieldToLessons < ActiveRecord::Migration[7.0]
  def change
    add_column :lessons, :views_count, :integer
  end
end
