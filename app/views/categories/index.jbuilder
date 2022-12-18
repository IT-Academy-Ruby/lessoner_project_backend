json.records do
  json.array! @categories do |category|
    json.extract! category, :id, :name, :description, :status, :created_at
  end
end

json.pagy_metadata do
  json.page @pagy.page
  json.per_page @pagy.items
  json.count_pages @pagy.pages
end
