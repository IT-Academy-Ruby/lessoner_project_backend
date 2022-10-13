class ChangeColumnStatusLessons < ActiveRecord::Migration[7.0]
  def change
    remove_column :lessons, :status, :string
  end
end
