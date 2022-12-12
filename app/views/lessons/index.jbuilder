json.array! @lessons do |lesson|
  json.extract! lesson, :id, :title, :description, :video_link, :author_id, :category_id, :status, :created_at
end
