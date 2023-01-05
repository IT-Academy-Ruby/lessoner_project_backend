json.extract! @lesson, :id, :title, :description, :video_link, :author_id, :category_id, :status, :created_at,
              :image_link, :rating, :votes_count
json.views_count @views_count
json.image_size @image_size
json.image_name @image_name
