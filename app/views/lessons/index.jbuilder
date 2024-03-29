json.records do
  json.array! @lessons do |lesson|
    json.extract! lesson, :id, :title, :description, :video_link, :author_id, :category_id, :status, :created_at,
                  :image_link, :votes_count, :rating, :views_count
    json.image_size lesson.lesson_image.byte_size
    json.image_name lesson.lesson_image.filename
    json.author_name lesson.author.name
    json.author_avatar_url lesson.author.avatar_url
  end
end

json.pagy_metadata do
  json.page @pagy.page
  json.per_page @pagy.items
  json.count_pages @pagy.pages
end
