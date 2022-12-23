json.records do
  json.array! @categories do |category|
    json.extract! category, :id, :name, :description, :status, :image_url, :created_at
    json.amount_lessons category.lessons.count
  end
end

json.pagy_metadata do
  json.page @pagy.page
  json.per_page @pagy.items
  json.count_pages @pagy.pages
end
