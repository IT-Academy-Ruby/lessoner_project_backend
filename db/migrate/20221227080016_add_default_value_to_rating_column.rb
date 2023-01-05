class AddDefaultValueToRatingColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :lessons, :rating, :float, default: 0.0
  end
end
