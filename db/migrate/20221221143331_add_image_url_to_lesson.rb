class AddImageUrlToLesson < ActiveRecord::Migration[7.0]
  def change
    add_column :lessons, :image_link, :string
  end
end
