json.extract! @lesson, :id, :title, :description, :video_link, :author_id, :category_id, :status, :created_at,
              :image_link, :rating, :votes_count
json.views_count @lesson.views_count
json.author_name @lesson.author.name
json.author_avatar_url @lesson.author.avatar_url
json.image_size @image_size
json.image_name @image_name
json.user_rating @user_rating
