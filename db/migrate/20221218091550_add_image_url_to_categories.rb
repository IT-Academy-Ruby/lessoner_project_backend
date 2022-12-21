class AddImageUrlToCategories < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :image_url, :string
  end
end
