class Addreferenceslesson < ActiveRecord::Migration[7.0]
  def change
    add_reference :lessons, :author, foreign_key: { to_table: :users }
    add_reference :lessons, :category, foreign_key: { to_table: :categories }

  end
end
