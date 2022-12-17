json.array! @categories do |category|
  json.extract! category, :id, :name, :description, :status, :created_at
end
