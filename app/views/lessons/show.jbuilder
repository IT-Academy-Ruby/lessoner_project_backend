json.post do
  json.id @lesson.id
  json.title @lesson.title
  json.description @lesson.description
  json.video_link @lesson.video_link
  json.author_id @lesson.author_id
  json.category_id @lesson.category_id
end
