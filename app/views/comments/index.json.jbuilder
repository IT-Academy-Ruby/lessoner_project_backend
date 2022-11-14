json.array! @comments do |comment|
  json.extract! comment, :id, :body, :lesson_id, :user_id, :created_at, :updated_at
end
