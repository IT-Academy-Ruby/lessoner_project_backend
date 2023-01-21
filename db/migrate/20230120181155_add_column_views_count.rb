class AddColumnViewsCount < ActiveRecord::Migration[7.0]
  def change
    add_column :lessons, :views_count, :integer, default: 0
  end
end
