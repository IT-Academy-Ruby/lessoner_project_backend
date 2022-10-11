json.post do
  json.id @lesson.id
  json.title @lesson.title
  json.description @lesson.description
  json.video_link @lesson.video_link
end
