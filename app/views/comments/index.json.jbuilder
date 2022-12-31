json.records do
  json.array! @comments do |comment|
    json.extract! comment, :id, :body, :lesson_id, :user_id, :created_at, :updated_at
  end
end

json.pagy_metadata do
  json.page @pagy.page
  json.per_page @pagy.items
  json.count_pages @pagy.pages
end
