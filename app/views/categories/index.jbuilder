json.array! @categories do |category|
  json.extract! category, :id, :name, :description, :status
end
