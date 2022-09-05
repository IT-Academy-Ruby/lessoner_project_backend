# frozen_string_literal: true

class ChangeCategoryStatusColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column :categories, :status, :integer, using: 'status::integer', default: 0
  end
end
