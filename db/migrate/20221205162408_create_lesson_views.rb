class CreateLessonViews < ActiveRecord::Migration[7.0]
  def change
    create_table :lesson_views do |t|
      t.string :ip
      t.bigint :user_id
      t.references :lesson
      t.timestamps
    end
  end
end
