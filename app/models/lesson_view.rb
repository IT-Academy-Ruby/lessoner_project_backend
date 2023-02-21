class LessonView < ApplicationRecord
  belongs_to :lesson, counter_cache: :views_count
end
