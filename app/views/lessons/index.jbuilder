json.records do
  json.array! @lessons do |lesson|
    json.extract! lesson, :id, :title, :description, :video_link, :author_id, :category_id, :status
  end
end

json.pagy_metadata do
  json.page @pagy.page
  json.per_page @pagy.items
  json.count_pages @pagy.pages
end
