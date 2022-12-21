json.array! @categories do |category|
  json.extract! category, :id, :name, :description, :status, :image_url, :created_at
end
