class AddColumnStatusLessonsEnum < ActiveRecord::Migration[7.0]
  def change
    add_column  :lessons,:status, :integer, default: 0
  end
end
