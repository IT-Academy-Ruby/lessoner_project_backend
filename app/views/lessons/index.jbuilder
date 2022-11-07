json.array! @lessons do |lesson|
  json.id lesson.id
  json.title lesson.title
  json.description lesson.description
  json.status lesson.status
end
