json.array! @categories do |category|
  json.extract! category, :id, :name, :description, :status, :image_url, :created_at
  json.amount_lessons category.lessons.count
  json.image_size category.image.byte_size
  json.image_name category.image.filename
end
