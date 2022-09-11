# frozen_string_literal: true

class CreateLessons < ActiveRecord::Migration[7.0]
  def change
    create_table :lessons do |t|
      t.string :description
      t.string :title
      t.string :video_link
      t.string :status

      t.timestamps
    end
  end
end
