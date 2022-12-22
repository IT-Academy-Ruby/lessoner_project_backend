json.extract! @lesson, :id, :title, :description, :video_link, :author_id, :category_id, :status, :created_at,
              :image_link
json.views_count @views_count
